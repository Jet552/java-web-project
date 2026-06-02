<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<div class="content-wrapper">
    <h5 class="mb-4 fw-bold"><i class="fas fa-hotel text-primary me-2"></i>入住管理</h5>

    <!-- 选择会议 -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <label class="form-label fw-bold"><i class="fas fa-calendar-alt me-2"></i>选择会议</label>
            <select id="conferenceSelect" class="form-select" onchange="loadData()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <!-- 已签到人员（可分配房间） -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="fw-bold"><i class="fas fa-user-check text-success me-2"></i>已签到人员</span>
            <span class="text-muted small">仅已签到可分配房间</span>
        </div>
        <div class="card-body p-0">
            <div id="loadingHint" class="text-center py-5 text-muted">
                <i class="fas fa-arrow-up fa-2x mb-2"></i>
                <p>请先选择一个会议</p>
            </div>
            <table class="table table-hover align-middle mb-0 d-none" id="checkedInTable">
                <thead class="table-light">
                    <tr>
                        <th>姓名</th>
                        <th>手机号</th>
                        <th>签到时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="checkedInBody"></tbody>
            </table>
        </div>
    </div>

    <!-- 已分配房间列表 -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="fw-bold"><i class="fas fa-hotel text-primary me-2"></i>已分配房间</span>
            <span id="roomCount" class="badge bg-secondary rounded-pill">0 间</span>
        </div>
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0 d-none" id="roomTable">
                <thead class="table-light">
                    <tr>
                        <th>房号</th>
                        <th>入住人</th>
                        <th>入住日期</th>
                        <th>退房日期</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="roomBody"></tbody>
            </table>
            <div id="noRoom" class="text-center py-4 text-muted d-none">
                <i class="fas fa-bed fa-2x mb-2 opacity-25"></i>
                <p>暂无房间分配记录</p>
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
            })
            .catch(function(err) { console.error('加载会议列表失败', err); });
    }

    window.loadData = function() {
        currentConferenceId = document.getElementById('conferenceSelect').value;
        if (!currentConferenceId) return;
        document.getElementById('loadingHint').classList.add('d-none');
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
                tbody.innerHTML = '';
                if (checkedIn.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center py-3 text-muted">暂无已签到人员</td></tr>';
                    return;
                }
                checkedIn.forEach(function(row) {
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td><strong>' + (row.username || '-') + '</strong></td>' +
                        '<td class="text-muted">' + (row.phone || '-') + '</td>' +
                        '<td>' + (row.checkinTime ? row.checkinTime.replace('T',' ').substring(0,16) : '-') + '</td>' +
                        '<td><button class="btn btn-primary btn-sm rounded-pill" onclick="window.showAssignRoom(' + row.attendeeId + ', \'' + (row.username || '') + '\')"><i class="fas fa-plus me-1"></i>分配房间</button></td>';
                    tbody.appendChild(tr);
                });
            });
    }

    function loadRoomList() {
        fetch(ctx + '/checkin/roomList?conferenceId=' + currentConferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                var table = document.getElementById('roomTable');
                var tbody = document.getElementById('roomBody');
                var noRoom = document.getElementById('noRoom');
                var data = resp.data || [];

                document.getElementById('roomCount').textContent = data.length + ' 间';

                if (data.length === 0) {
                    table.classList.add('d-none');
                    noRoom.classList.remove('d-none');
                    return;
                }
                table.classList.remove('d-none');
                noRoom.classList.add('d-none');

                tbody.innerHTML = '';
                data.forEach(function(row) {
                    var tr = document.createElement('tr');
                    var statusBadge = row.status === 1
                        ? '<span class="badge bg-success rounded-pill">入住中</span>'
                        : '<span class="badge bg-secondary rounded-pill">已退房</span>';
                    var actionHtml = row.status === 1
                        ? '<button class="btn btn-outline-danger btn-sm rounded-pill" onclick="window.doCheckout(' + row.id + ', \'' + (row.roomNumber || '') + '\')"><i class="fas fa-sign-out-alt me-1"></i>退房</button>'
                        : '<span class="text-muted small">-</span>';
                    tr.innerHTML =
                        '<td><strong>' + (row.roomNumber || '-') + '</strong></td>' +
                        '<td>' + (row.username || '-') + '</td>' +
                        '<td>' + (row.checkinDate || '-') + '</td>' +
                        '<td>' + (row.checkoutDate || '-') + '</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '<td>' + actionHtml + '</td>';
                    tbody.appendChild(tr);
                });
            });
    }

    window.showAssignRoom = function(attendeeId, username) {
        Swal.fire({
            title: '分配房间 - ' + username,
            html:
                '<div class="mb-3"><label class="form-label">房间号</label><input id="swalRoomNumber" class="swal2-input" placeholder="如 908"></div>' +
                '<div class="mb-3"><label class="form-label">入住日期</label><input id="swalCheckinDate" class="swal2-input" type="date"></div>' +
                '<div class="mb-3"><label class="form-label">退房日期</label><input id="swalCheckoutDate" class="swal2-input" type="date"></div>',
            confirmButtonText: '<i class="fas fa-check me-1"></i>确认分配',
            confirmButtonColor: '#1a56db',
            showCancelButton: true,
            cancelButtonText: '取消',
            preConfirm: function() {
                var roomNumber = document.getElementById('swalRoomNumber').value.trim();
                var checkinDate = document.getElementById('swalCheckinDate').value;
                var checkoutDate = document.getElementById('swalCheckoutDate').value;
                if (!roomNumber) { Swal.showValidationMessage('请输入房间号'); return false; }
                if (!checkinDate || !checkoutDate) { Swal.showValidationMessage('请选择日期'); return false; }
                if (checkinDate >= checkoutDate) { Swal.showValidationMessage('入住日期必须早于退房日期'); return false; }
                return { roomNumber: roomNumber, checkinDate: checkinDate, checkoutDate: checkoutDate };
            }
        }).then(function(result) {
            if (result.isConfirmed) {
                assignRoom(attendeeId, result.value.roomNumber, result.value.checkinDate, result.value.checkoutDate);
            }
        });
    };

    function assignRoom(attendeeId, roomNumber, checkinDate, checkoutDate) {
        var formData = new URLSearchParams();
        formData.append('attendeeId', attendeeId);
        formData.append('roomNumber', roomNumber);
        formData.append('checkinDate', checkinDate);
        formData.append('checkoutDate', checkoutDate);

        fetch(ctx + '/checkin/assignRoom', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.code === 200) {
                Swal.fire({ icon: 'success', title: '房间分配成功', timer: 1200, showConfirmButton: false });
                window.loadData();
            } else if (data.code === 401) {
                location.href = ctx + '/login.jsp';
            } else {
                Swal.fire({ icon: 'error', title: '分配失败', text: data.msg });
            }
        });
    }

    // 退房操作
    window.doCheckout = function(roomId, roomNumber) {
        Swal.fire({
            title: '确认退房',
            html: '确定要将房间 <strong>' + roomNumber + '</strong> 办理退房吗？',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-sign-out-alt me-1"></i>确认退房',
            confirmButtonColor: '#c81e1e',
            cancelButtonText: '取消'
        }).then(function(result) {
            if (result.isConfirmed) {
                var formData = new URLSearchParams();
                formData.append('roomId', roomId);
                fetch(ctx + '/checkin/checkout', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                })
                .then(function(res) { return res.json(); })
                .then(function(data) {
                    if (data.code === 200) {
                        Swal.fire({ icon: 'success', title: '退房成功', timer: 1200, showConfirmButton: false });
                        window.loadData();
                    } else {
                        Swal.fire({ icon: 'error', title: '操作失败', text: data.msg });
                    }
                });
            }
        });
    };
})();
</script>
