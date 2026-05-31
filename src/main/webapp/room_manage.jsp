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
    <h4 class="mb-4"><i class="fas fa-hotel text-primary me-2"></i>入住管理</h4>

    <!-- 选择会议 -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <label class="form-label fw-bold">选择会议</label>
            <select id="conferenceSelect" class="form-select" onchange="loadData()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <!-- 签到人员列表（只有已签到才能分配房间） -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white fw-bold">
            <i class="fas fa-user-check text-success me-2"></i>已签到人员（可分配房间）
        </div>
        <div class="card-body p-0">
            <div id="loadingHint" class="text-center py-5 text-muted">
                <i class="fas fa-arrow-up fa-2x mb-2"></i>
                <p>请先选择一个会议</p>
            </div>
            <table class="table table-striped table-hover mb-0 d-none" id="checkedInTable">
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
    <div class="card shadow-sm">
        <div class="card-header bg-white fw-bold">
            <i class="fas fa-hotel text-primary me-2"></i>已分配房间
        </div>
        <div class="card-body p-0">
            <table class="table table-striped table-hover mb-0 d-none" id="roomTable">
                <thead class="table-light">
                    <tr>
                        <th>房号</th>
                        <th>入住日期</th>
                        <th>退房日期</th>
                        <th>状态</th>
                    </tr>
                </thead>
                <tbody id="roomBody"></tbody>
            </table>
            <div id="noRoom" class="text-center py-4 text-muted d-none">暂无房间分配记录</div>
        </div>
    </div>
</div>

<script>
(function() {
    var ctx = window.contextPath || '';

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
                        opt.textContent = conf.title + (conf.status === 'approved' ? ' [已审核]' : '');
                        if (conf.status !== 'approved') opt.disabled = true;
                        select.appendChild(opt);
                    });
                }
            })
            .catch(function(err) { console.error('加载会议列表失败', err); });
    }

    window.loadData = function() {
        var conferenceId = document.getElementById('conferenceSelect').value;
        if (!conferenceId) return;
        document.getElementById('loadingHint').classList.add('d-none');
        loadCheckedInList(conferenceId);
        loadRoomList(conferenceId);
    };

    function loadCheckedInList(conferenceId) {
        fetch(ctx + '/checkin/list?conferenceId=' + conferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                if (resp.code !== 200) return;
                var checkedIn = resp.data.filter(function(r) { return r.checkedIn; });
                document.getElementById('checkedInTable').classList.remove('d-none');

                var tbody = document.getElementById('checkedInBody');
                tbody.innerHTML = '';
                if (checkedIn.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">暂无已签到人员</td></tr>';
                    return;
                }
                checkedIn.forEach(function(row) {
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td>' + row.username + '</td>' +
                        '<td>' + (row.phone || '-') + '</td>' +
                        '<td>' + (row.checkinTime || '-') + '</td>' +
                        '<td><button class="btn btn-sm btn-primary" onclick="window.showAssignRoom(' + row.attendeeId + ', \'' + row.username + '\')">分配房间</button></td>';
                    tbody.appendChild(tr);
                });
            });
    }

    function loadRoomList(conferenceId) {
        fetch(ctx + '/checkin/roomList?conferenceId=' + conferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                var table = document.getElementById('roomTable');
                var tbody = document.getElementById('roomBody');
                var noRoom = document.getElementById('noRoom');

                if (!resp.data || resp.data.length === 0) {
                    table.classList.add('d-none');
                    noRoom.classList.remove('d-none');
                    return;
                }
                table.classList.remove('d-none');
                noRoom.classList.add('d-none');

                tbody.innerHTML = '';
                resp.data.forEach(function(row) {
                    var tr = document.createElement('tr');
                    var statusBadge = row.status === 1
                        ? '<span class="badge bg-success">入住中</span>'
                        : '<span class="badge bg-secondary">已退房</span>';
                    tr.innerHTML =
                        '<td><strong>' + row.roomNumber + '</strong></td>' +
                        '<td>' + (row.checkinDate || '-') + '</td>' +
                        '<td>' + (row.checkoutDate || '-') + '</td>' +
                        '<td>' + statusBadge + '</td>';
                    tbody.appendChild(tr);
                });
            });
    }

    window.showAssignRoom = function(attendeeId, username) {
        Swal.fire({
            title: '分配房间 - ' + username,
            html:
                '<input id="swalRoomNumber" class="swal2-input" placeholder="房间号（如 908）">' +
                '<input id="swalCheckinDate" class="swal2-input" type="date" placeholder="入住日期">' +
                '<input id="swalCheckoutDate" class="swal2-input" type="date" placeholder="退房日期">',
            confirmButtonText: '确认分配',
            showCancelButton: true,
            preConfirm: function() {
                var roomNumber = document.getElementById('swalRoomNumber').value;
                var checkinDate = document.getElementById('swalCheckinDate').value;
                var checkoutDate = document.getElementById('swalCheckoutDate').value;
                if (!roomNumber || !checkinDate || !checkoutDate) {
                    Swal.showValidationMessage('请填写完整信息');
                    return false;
                }
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
                Swal.fire({ icon: 'success', title: '房间分配成功', timer: 1500, showConfirmButton: false });
                window.loadData();
            } else if (data.code === 401) {
                location.href = ctx + '/login.jsp';
            } else {
                Swal.fire({ icon: 'error', title: '分配失败', text: data.msg });
            }
        });
    }
})();
</script>
