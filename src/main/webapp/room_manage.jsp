<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>入住管理 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
    %>

    <div class="d-flex">
        <!-- 侧边栏 -->
        <div class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh;">
            <h5 class="mb-4"><i class="fas fa-calendar-alt me-2"></i>会务管理</h5>
            <nav class="nav flex-column">
                <a href="index2.jsp" class="nav-link text-white"><i class="fas fa-home me-2"></i>首页</a>
                <a href="checkin_manage.jsp" class="nav-link text-white"><i class="fas fa-check-circle me-2"></i>签到管理</a>
                <a href="room_manage.jsp" class="nav-link text-white bg-primary rounded"><i class="fas fa-hotel me-2"></i>入住管理</a>
            </nav>
            <hr class="text-secondary">
            <div class="text-secondary small">
                <i class="fas fa-user me-2"></i><%= user.getUsername() %>
            </div>
            <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-outline-light btn-sm mt-2 w-100">退出登录</a>
        </div>

        <!-- 主内容区 -->
        <div class="flex-grow-1 p-4 bg-light" style="min-height: 100vh;">
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.addEventListener('DOMContentLoaded', loadConferences);

        function loadConferences() {
            fetch('${pageContext.request.contextPath}/conference/myList')
                .then(res => res.json())
                .then(data => {
                    const select = document.getElementById('conferenceSelect');
                    if (data.code === 200 && data.data) {
                        data.data.forEach(conf => {
                            const opt = document.createElement('option');
                            opt.value = conf.id;
                            opt.textContent = conf.title + (conf.status === 'approved' ? ' [已审核]' : '');
                            if (conf.status !== 'approved') opt.disabled = true;
                            select.appendChild(opt);
                        });
                    }
                })
                .catch(err => console.error('加载会议列表失败', err));
        }

        function loadData() {
            const conferenceId = document.getElementById('conferenceSelect').value;
            if (!conferenceId) return;
            document.getElementById('loadingHint').classList.add('d-none');
            loadCheckedInList(conferenceId);
            loadRoomList(conferenceId);
        }

        function loadCheckedInList(conferenceId) {
            fetch('${pageContext.request.contextPath}/checkin/list?conferenceId=' + conferenceId)
                .then(res => res.json())
                .then(resp => {
                    if (resp.code !== 200) return;
                    const checkedIn = resp.data.filter(r => r.checkedIn);
                    document.getElementById('checkedInTable').classList.remove('d-none');

                    const tbody = document.getElementById('checkedInBody');
                    tbody.innerHTML = '';
                    if (checkedIn.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">暂无已签到人员</td></tr>';
                        return;
                    }
                    checkedIn.forEach(row => {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td>' + row.username + '</td>' +
                            '<td>' + (row.phone || '-') + '</td>' +
                            '<td>' + (row.checkinTime || '-') + '</td>' +
                            '<td><button class="btn btn-sm btn-primary" onclick="showAssignRoom(' + row.attendeeId + ', \'' + row.username + '\')">分配房间</button></td>';
                        tbody.appendChild(tr);
                    });
                });
        }

        function loadRoomList(conferenceId) {
            fetch('${pageContext.request.contextPath}/checkin/roomList?conferenceId=' + conferenceId)
                .then(res => res.json())
                .then(resp => {
                    const table = document.getElementById('roomTable');
                    const tbody = document.getElementById('roomBody');
                    const noRoom = document.getElementById('noRoom');

                    if (!resp.data || resp.data.length === 0) {
                        table.classList.add('d-none');
                        noRoom.classList.remove('d-none');
                        return;
                    }
                    table.classList.remove('d-none');
                    noRoom.classList.add('d-none');

                    tbody.innerHTML = '';
                    resp.data.forEach(row => {
                        const tr = document.createElement('tr');
                        const statusBadge = row.status === 1
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

        function showAssignRoom(attendeeId, username) {
            Swal.fire({
                title: '分配房间 - ' + username,
                html:
                    '<input id="swalRoomNumber" class="swal2-input" placeholder="房间号（如 908）">' +
                    '<input id="swalCheckinDate" class="swal2-input" type="date" placeholder="入住日期">' +
                    '<input id="swalCheckoutDate" class="swal2-input" type="date" placeholder="退房日期">',
                confirmButtonText: '确认分配',
                showCancelButton: true,
                preConfirm: () => {
                    const roomNumber = document.getElementById('swalRoomNumber').value;
                    const checkinDate = document.getElementById('swalCheckinDate').value;
                    const checkoutDate = document.getElementById('swalCheckoutDate').value;
                    if (!roomNumber || !checkinDate || !checkoutDate) {
                        Swal.showValidationMessage('请填写完整信息');
                        return false;
                    }
                    return { roomNumber, checkinDate, checkoutDate };
                }
            }).then(result => {
                if (result.isConfirmed) {
                    assignRoom(attendeeId, result.value.roomNumber, result.value.checkinDate, result.value.checkoutDate);
                }
            });
        }

        function assignRoom(attendeeId, roomNumber, checkinDate, checkoutDate) {
            const formData = new URLSearchParams();
            formData.append('attendeeId', attendeeId);
            formData.append('roomNumber', roomNumber);
            formData.append('checkinDate', checkinDate);
            formData.append('checkoutDate', checkoutDate);

            fetch('${pageContext.request.contextPath}/checkin/assignRoom', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    Swal.fire({ icon: 'success', title: '房间分配成功', timer: 1500, showConfirmButton: false });
                    loadData();
                } else if (data.code === 401) {
                    location.href = '${pageContext.request.contextPath}/login.jsp';
                } else {
                    Swal.fire({ icon: 'error', title: '分配失败', text: data.msg });
                }
            });
        }
    </script>
</body>
</html>
