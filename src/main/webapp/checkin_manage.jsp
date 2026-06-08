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
        --m5-purple-light: #f3f0ff;
        --m5-blue-light: #e8f0fe;
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
    .m5-stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 20px; }
    .m5-stat-item {
        background: #fff;
        border-radius: var(--m5-radius);
        padding: 18px 16px;
        text-align: center;
        box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    }
    .m5-stat-item .stat-icon { font-size: 28px; margin-bottom: 6px; line-height: 1; }
    .m5-stat-item .stat-num { font-size: 28px; font-weight: 700; line-height: 1.2; }
    .m5-stat-item .stat-label { font-size: 12px; color: #6b7280; margin-top: 4px; }
    .m5-stat-item:nth-child(1) { background: var(--m5-blue-light); }
    .m5-stat-item:nth-child(2) { background: #ecfdf5; }
    .m5-stat-item:nth-child(3) { background: #fffbeb; }
    .m5-stat-item:nth-child(4) { background: var(--m5-purple-light); }
    .m5-card { background: #fff; border-radius: var(--m5-radius); box-shadow: 0 1px 3px rgba(0,0,0,0.06); }
    .m5-card-header { padding: 12px 18px; border-bottom: 1px solid #f3f4f6; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
    .m5-card-body { padding: 0; }
    .m5-table { width: 100%; border-collapse: collapse; }
    .m5-table th { background: #f9fafb; padding: 10px 14px; text-align: left; font-size: 13px; color: #6b7280; font-weight: 500; }
    .m5-table td { padding: 10px 14px; border-top: 1px solid #f3f4f6; font-size: 14px; }
    .m5-table tr:hover td { background: #f9fafb; }
    .m5-input { border-radius: var(--m5-radius); border: 1px solid #e5e7eb; padding: 6px 12px; font-size: 13px; }
    .m5-input:focus { border-color: #667eea; box-shadow: 0 0 0 2px rgba(102,126,234,0.15); outline: none; }
    .m5-select { border-radius: var(--m5-radius); border: 1px solid #e5e7eb; padding: 8px 12px; width: 100%; }
    .m5-btn { border-radius: 20px; padding: 6px 16px; font-size: 13px; font-weight: 500; border: none; cursor: pointer; transition: all 0.15s; }
    .m5-btn-primary { background: var(--m5-gradient); color: #fff; }
    .m5-btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
    .m5-badge { padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 500; }
    .m5-badge-success { background: #ecfdf5; color: #057a55; }
    .m5-badge-warning { background: #fffbeb; color: #b45309; }
</style>

<div class="content-wrapper">
    <div class="m5-header">
        <h5><i class="fas fa-check-circle me-2"></i>签到管理</h5>
    </div>

    <div class="m5-card" style="margin-bottom:20px;">
        <div class="m5-card-header">
            <span><i class="fas fa-calendar-alt me-2" style="color:#667eea;"></i>选择会议</span>
        </div>
        <div style="padding:14px 18px;">
            <select id="conferenceSelect" class="m5-select" onchange="loadCheckinList()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <div id="statsBar" class="m5-stat-grid" style="display:none;">
        <div class="m5-stat-item">
            <div class="stat-icon"><i class="fas fa-users" style="color:#667eea;"></i></div>
            <div class="stat-num" id="statTotal">0</div>
            <div class="stat-label">参会总人数</div>
        </div>
        <div class="m5-stat-item">
            <div class="stat-icon"><i class="fas fa-user-check" style="color:#057a55;"></i></div>
            <div class="stat-num text-success" id="statCheckedIn">0</div>
            <div class="stat-label">已签到</div>
        </div>
        <div class="m5-stat-item">
            <div class="stat-icon"><i class="fas fa-hourglass-half" style="color:#b45309;"></i></div>
            <div class="stat-num text-warning" id="statUnchecked">0</div>
            <div class="stat-label">未签到</div>
        </div>
        <div class="m5-stat-item">
            <div class="stat-icon"><i class="fas fa-chart-line" style="color:#667eea;"></i></div>
            <div class="stat-num" id="statRate" style="color:#667eea;">0%</div>
            <div class="stat-label">签到率</div>
        </div>
    </div>

    <div class="m5-card">
        <div class="m5-card-header">
            <span><i class="fas fa-list me-2" style="color:#667eea;"></i>参会人员</span>
            <div style="display:flex;gap:8px;align-items:center;">
                <input type="text" id="nameSearch" class="m5-input" style="width:170px;" placeholder="搜索姓名..." oninput="filterByName()">
                <span id="listCount" class="m5-badge" style="background:#f3f4f6;color:#6b7280;">0 人</span>
            </div>
        </div>
        <div class="m5-card-body">
            <div id="loadingHint" style="text-align:center;padding:50px 0;color:#9ca3af;">
                <i class="fas fa-hand-pointer" style="font-size:32px;margin-bottom:8px;display:block;"></i>请先选择一个会议
            </div>
            <table class="m5-table d-none" id="checkinTable">
                <thead>
                    <tr><th>姓名</th><th>手机号</th><th>签到时间</th><th>状态</th><th>操作</th></tr>
                </thead>
                <tbody id="checkinBody"></tbody>
            </table>
        </div>
    </div>
</div>

<script>
(function() {
    var ctx = window.contextPath || '';
    var allCheckinData = [];

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

    window.loadCheckinList = function() {
        var conferenceId = document.getElementById('conferenceSelect').value;
        if (!conferenceId) return;
        document.getElementById('loadingHint').style.display = 'none';
        document.getElementById('nameSearch').value = '';
        fetch(ctx + '/checkin/list?conferenceId=' + conferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                if (resp.code !== 200) return;
                allCheckinData = resp.data;
                renderTable(allCheckinData);
                updateStats(allCheckinData);
            });
    };

    function renderTable(list) {
        document.getElementById('listCount').textContent = list.length + ' 人';
        document.getElementById('checkinTable').classList.remove('d-none');
        document.getElementById('statsBar').style.display = 'grid';
        var tbody = document.getElementById('checkinBody');
        tbody.innerHTML = '';
        if (list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:40px 0;color:#9ca3af;">暂无参会人员</td></tr>';
            return;
        }
        list.forEach(function(row) {
            var tr = document.createElement('tr');
            var nameHtml = '<strong>' + (row.username || '-') + '</strong>';
            if (row.joinSource === 'invite') {
                nameHtml += ' <span class="m5-badge" style="background:#fef3c7;color:#92400e;font-size:10px;">特邀</span>';
            }
            tr.innerHTML =
                '<td>' + nameHtml + '</td>' +
                '<td style="color:#6b7280;">' + (row.phone || '-') + '</td>' +
                '<td>' + (row.checkinTime ? row.checkinTime.replace('T',' ').substring(0,16) : '<span style="color:#9ca3af;">-</span>') + '</td>' +
                '<td>' + (row.checkedIn
                    ? '<span class="m5-badge m5-badge-success">已签到</span>'
                    : '<span class="m5-badge m5-badge-warning">未签到</span>') + '</td>' +
                '<td>' + (row.checkedIn
                    ? '<span style="color:#9ca3af;font-size:12px;">' + (row.checkinTime ? row.checkinTime.replace('T',' ').substring(0,16) : '') + '</span>'
                    : '<button class="m5-btn m5-btn-primary" onclick="window.doCheckin(' + row.attendeeId + ')"><i class="fas fa-check me-1"></i>签到</button>') + '</td>';
            tbody.appendChild(tr);
        });
    }

    function updateStats(list) {
        var total = list.length;
        var checkedIn = list.filter(function(r) { return r.checkedIn; }).length;
        var unchecked = total - checkedIn;
        var rate = total > 0 ? Math.round(checkedIn / total * 100) : 0;
        document.getElementById('statTotal').textContent = total;
        document.getElementById('statCheckedIn').textContent = checkedIn;
        document.getElementById('statUnchecked').textContent = unchecked;
        document.getElementById('statRate').textContent = rate + '%';
    }

    window.filterByName = function() {
        var keyword = document.getElementById('nameSearch').value.trim().toLowerCase();
        renderTable(keyword ? allCheckinData.filter(function(r) { return (r.username||'').toLowerCase().includes(keyword); }) : allCheckinData);
    };

    window.doCheckin = function(attendeeId) {
        var formData = new URLSearchParams();
        formData.append('attendeeId', attendeeId);
        fetch(ctx + '/checkin/doCheckin', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.code === 200) {
                Swal.fire({ icon: 'success', title: '签到成功', timer: 1200, showConfirmButton: false });
                window.loadCheckinList();
            } else if (data.code === 401) {
                location.href = ctx + '/login.jsp';
            } else {
                Swal.fire({ icon: 'info', title: '提示', text: data.msg });
            }
        });
    };
})();
</script>
