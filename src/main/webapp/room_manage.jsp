<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<style>
    :root {
        --m5-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --m5-radius: 8px;
    }
    .m5-header {
        background: var(--m5-gradient);
        color: #fff;
        padding: 14px 20px;
        border-radius: var(--m5-radius);
        margin-bottom: 20px;
    }
    .m5-header h5 { color: #fff; margin: 0; }
    .m5-card { background: #fff; border-radius: var(--m5-radius); box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    .m5-card-header { padding: 12px 18px; border-bottom: 1px solid #f3f4f6; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
    .m5-card-body { padding: 0; }
    .m5-table { width: 100%; border-collapse: collapse; }
    .m5-table th { background: #f9fafb; padding: 10px 14px; text-align: left; font-size: 13px; color: #6b7280; font-weight: 500; }
    .m5-table td { padding: 10px 14px; border-top: 1px solid #f3f4f6; font-size: 14px; }
    .m5-table tr:hover td { background: #f9fafb; }
    .m5-select { border-radius: var(--m5-radius); border: 1px solid #e5e7eb; padding: 8px 12px; width: 100%; }
    .m5-btn { border-radius: 20px; padding: 6px 16px; font-size: 13px; font-weight: 500; border: none; cursor: pointer; transition: all 0.15s; }
    .m5-btn-primary { background: var(--m5-gradient); color: #fff; }
    .m5-btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
    .m5-btn-outline { background: #fff; color: #c81e1e; border: 1px solid #fecaca; }
    .m5-btn-outline:hover { background: #fef2f2; }
    .m5-badge { padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
    .m5-badge-success { background: #ecfdf5; color: #057a55; }
    .m5-badge-secondary { background: #f3f4f6; color: #6b7280; }
    .m5-text-muted { color: #9ca3af; text-align: center; padding: 40px 0; }
</style>

<div class="content-wrapper">
    <div class="m5-header">
        <h5><i class="fas fa-hotel me-2"></i>入住管理</h5>
    </div>

    <div class="m5-card" style="margin-bottom:20px;">
        <div class="m5-card-header">
            <span><i class="fas fa-calendar-alt me-2" style="color:#667eea;"></i>选择会议</span>
        </div>
        <div style="padding:14px 18px;">
            <select id="conferenceSelect" class="m5-select" onchange="loadData()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <div class="m5-card" style="margin-bottom:20px;">
        <div class="m5-card-header">
            <span><i class="fas fa-user-check me-2" style="color:#057a55;"></i>已签到人员</span>
            <span style="font-size:12px;color:#9ca3af;">仅已签到可分配房间</span>
        </div>
        <div class="m5-card-body">
            <div id="loadingHint" class="m5-text-muted">
                <i class="fas fa-arrow-up" style="font-size:32px;margin-bottom:8px;display:block;"></i>请先选择一个会议
            </div>
            <table class="m5-table d-none" id="checkedInTable">
                <thead><tr><th>姓名</th><th>手机号</th><th>签到时间</th><th>操作</th></tr></thead>
                <tbody id="checkedInBody"></tbody>
            </table>
        </div>
    </div>

    <div class="m5-card">
        <div class="m5-card-header">
            <span><i class="fas fa-hotel me-2" style="color:#667eea;"></i>已分配房间</span>
            <span id="roomCount" class="m5-badge m5-badge-secondary">0 间</span>
        </div>
        <div class="m5-card-body">
            <table class="m5-table d-none" id="roomTable">
                <thead><tr><th>房号</th><th>入住人</th><th>入住日期</th><th>退房日期</th><th>状态</th><th>操作</th></tr></thead>
                <tbody id="roomBody"></tbody>
            </table>
            <div id="noRoom" class="m5-text-muted d-none">
                <i class="fas fa-bed" style="font-size:32px;margin-bottom:8px;display:block;opacity:0.2;"></i>暂无房间分配记录
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    var ctx = window.contextPath || '';
    var currentConferenceId = null;

    loadConferences();

    function loadConferences() {
        fetch(ctx + '/conference/myList?_=' + Date.now(), { cache: 'no-store' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var select = document.getElementById('conferenceSelect');
                if (data.code === 200 && data.data) {
                    data.data.forEach(function(conf) {
                        var opt = document.createElement('option');
                        opt.value = conf.id;
                        opt.textContent = conf.title + (conf.status === 'approved' ? '' : ' [待审核]');
                        if (conf.status !== 'approved') opt.disabled = true;
                        select.appendChild(opt);
                    });
                }
            });
    }

    window.loadData = function() {
        currentConferenceId = document.getElementById('conferenceSelect').value;
        if (!currentConferenceId) return;
        document.getElementById('loadingHint').style.display = 'none';
        loadCheckedInList();
        loadRoomList();
    };

    function loadCheckedInList() {
        fetch(ctx + '/checkin/list?conferenceId=' + currentConferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                if (resp.code !== 200) return;
                var checkedIn = resp.data.filter(function(r) { return r.checkedIn; });
                document.getElementById('checkedInTable').classList.remove('d-none');
                var tbody = document.getElementById('checkedInBody');
                tbody.innerHTML = checkedIn.length === 0
                    ? '<tr><td colspan="4" style="text-align:center;padding:24px 0;color:#9ca3af;">暂无已签到人员</td></tr>'
                    : checkedIn.map(function(row) {
                        return '<tr>' +
                            '<td><strong>' + (row.username || '-') + '</strong></td>' +
                            '<td style="color:#6b7280;">' + (row.phone || '-') + '</td>' +
                            '<td>' + (row.checkinTime ? row.checkinTime.replace('T',' ').substring(0,16) : '-') + '</td>' +
                            '<td><button class="m5-btn m5-btn-primary" onclick="window.showAssignRoom(' + row.attendeeId + ',\'' + (row.username||'') + '\')"><i class="fas fa-plus me-1"></i>分配房间</button></td>' +
                            '</tr>';
                    }).join('');
            });
    }

    function loadRoomList() {
        fetch(ctx + '/checkin/roomList?conferenceId=' + currentConferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                var table = document.getElementById('roomTable');
                var noRoom = document.getElementById('noRoom');
                var data = resp.data || [];
                document.getElementById('roomCount').textContent = data.length + ' 间';
                if (data.length === 0) { table.classList.add('d-none'); noRoom.classList.remove('d-none'); return; }
                table.classList.remove('d-none'); noRoom.classList.add('d-none');
                document.getElementById('roomBody').innerHTML = data.map(function(row) {
                    var badge = row.status === 1
                        ? '<span class="m5-badge m5-badge-success">入住中</span>'
                        : '<span class="m5-badge m5-badge-secondary">已退房</span>';
                    var action = row.status === 1
                        ? '<button class="m5-btn m5-btn-outline" onclick="window.doCheckout(' + row.id + ',\'' + (row.roomNumber||'') + '\')"><i class="fas fa-sign-out-alt me-1"></i>退房</button>'
                        : '<span style="color:#9ca3af;font-size:12px;">-</span>';
                    return '<tr>' +
                        '<td><strong>' + (row.roomNumber || '-') + '</strong></td>' +
                        '<td>' + (row.username || '-') + '</td>' +
                        '<td>' + (row.checkinDate || '-') + '</td>' +
                        '<td>' + (row.checkoutDate || '-') + '</td>' +
                        '<td>' + badge + '</td>' +
                        '<td>' + action + '</td>' +
                        '</tr>';
                }).join('');
            });
    }

    window.showAssignRoom = function(attendeeId, username) {
        Swal.fire({
            title: '分配房间 - ' + username,
            html:
                '<div class="alert alert-info py-2 mb-3 text-start small" style="font-size:12px;">' +
                  '<i class="fas fa-info-circle me-1"></i>日期范围约束：<br>' +
                  '入住和退房日期必须 ≥ 签到日期，≤ 会议结束后3天' +
                '</div>' +
                '<div style="margin-bottom:12px;"><label style="display:block;text-align:left;margin-bottom:4px;font-weight:500;">房间号</label><input id="swalRoomNumber" class="swal2-input" placeholder="如 908"></div>' +
                '<div style="margin-bottom:12px;"><label style="display:block;text-align:left;margin-bottom:4px;font-weight:500;">入住日期</label><input id="swalCheckinDate" class="swal2-input" type="date"></div>' +
                '<div style="margin-bottom:12px;"><label style="display:block;text-align:left;margin-bottom:4px;font-weight:500;">退房日期</label><input id="swalCheckoutDate" class="swal2-input" type="date"></div>',
            confirmButtonText: '<i class="fas fa-check me-1"></i>确认分配',
            confirmButtonColor: '#667eea',
            showCancelButton: true,
            cancelButtonText: '取消',
            preConfirm: function() {
                var rn = document.getElementById('swalRoomNumber').value.trim();
                var ci = document.getElementById('swalCheckinDate').value;
                var co = document.getElementById('swalCheckoutDate').value;
                if (!rn) { Swal.showValidationMessage('请输入房间号'); return false; }
                if (!ci || !co) { Swal.showValidationMessage('请选择日期'); return false; }
                if (ci >= co) { Swal.showValidationMessage('入住日期必须早于退房日期'); return false; }
                return { roomNumber: rn, checkinDate: ci, checkoutDate: co };
            }
        }).then(function(result) {
            if (result.isConfirmed) assignRoom(attendeeId, result.value.roomNumber, result.value.checkinDate, result.value.checkoutDate);
        });
    };

    function assignRoom(attendeeId, roomNumber, checkinDate, checkoutDate) {
        var fd = new URLSearchParams();
        fd.append('attendeeId', attendeeId); fd.append('roomNumber', roomNumber);
        fd.append('checkinDate', checkinDate); fd.append('checkoutDate', checkoutDate);
        fetch(ctx + '/checkin/assignRoom', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.code === 200) { Swal.fire({ icon: 'success', title: '房间分配成功', timer: 1200, showConfirmButton: false }); window.loadData(); }
                else if (data.code === 401) { location.href = ctx + '/login.jsp'; }
                else { Swal.fire({ icon: 'error', title: '分配失败', text: data.msg }); }
            });
    }

    window.doCheckout = function(roomId, roomNumber) {
        Swal.fire({
            title: '确认退房', html: '确定将房间 <strong>' + roomNumber + '</strong> 办理退房吗？', icon: 'question',
            showCancelButton: true, confirmButtonText: '<i class="fas fa-sign-out-alt me-1"></i>确认退房', confirmButtonColor: '#c81e1e', cancelButtonText: '取消'
        }).then(function(result) {
            if (result.isConfirmed) {
                var fd = new URLSearchParams(); fd.append('roomId', roomId);
                fetch(ctx + '/checkin/checkout', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: fd })
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (data.code === 200) { Swal.fire({ icon: 'success', title: '退房成功', timer: 1200, showConfirmButton: false }); window.loadData(); }
                        else if (data.code === 401) { location.href = ctx + '/login.jsp'; }
                        else { Swal.fire({ icon: 'error', title: '操作失败', text: data.msg }); }
                    });
            }
        });
    };
})();
</script>
