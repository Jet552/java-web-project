<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>签到管理 - 会务管理系统</title>
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

    <!-- 侧边栏 -->
    <div class="d-flex">
        <div class="bg-dark text-white p-3" style="width: 250px; min-height: 100vh;">
            <h5 class="mb-4"><i class="fas fa-calendar-alt me-2"></i>会务管理</h5>
            <nav class="nav flex-column">
                <a href="index2.jsp" class="nav-link text-white"><i class="fas fa-home me-2"></i>首页</a>
                <a href="checkin_manage.jsp" class="nav-link text-white bg-primary rounded"><i class="fas fa-check-circle me-2"></i>签到管理</a>
                <a href="room_manage.jsp" class="nav-link text-white"><i class="fas fa-hotel me-2"></i>入住管理</a>
            </nav>
            <hr class="text-secondary">
            <div class="text-secondary small">
                <i class="fas fa-user me-2"></i><%= user.getUsername() %>
            </div>
            <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-outline-light btn-sm mt-2 w-100">退出登录</a>
        </div>

        <!-- 主内容区 -->
        <div class="flex-grow-1 p-4 bg-light" style="min-height: 100vh;">
            <h4 class="mb-4"><i class="fas fa-check-circle text-primary me-2"></i>签到管理</h4>

            <!-- 选择会议 -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <label class="form-label fw-bold">选择会议</label>
                    <select id="conferenceSelect" class="form-select" onchange="loadCheckinList()">
                        <option value="">-- 请选择会议 --</option>
                    </select>
                </div>
            </div>

            <!-- 签到统计 -->
            <div id="statsBar" class="row g-3 mb-4 d-none">
                <div class="col-md-4">
                    <div class="card shadow-sm border-primary">
                        <div class="card-body text-center">
                            <h2 class="text-primary" id="statTotal">0</h2>
                            <small class="text-muted">参会总人数</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm border-success">
                        <div class="card-body text-center">
                            <h2 class="text-success" id="statCheckedIn">0</h2>
                            <small class="text-muted">已签到</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card shadow-sm border-warning">
                        <div class="card-body text-center">
                            <h2 class="text-warning" id="statUnchecked">0</h2>
                            <small class="text-muted">未签到</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 签到列表 -->
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <span class="fw-bold"><i class="fas fa-list me-2"></i>参会人员</span>
                    <span id="listCount" class="badge bg-secondary">0 人</span>
                </div>
                <div class="card-body p-0">
                    <div id="loadingHint" class="text-center py-5 text-muted">
                        <i class="fas fa-hand-pointer fa-2x mb-2"></i>
                        <p>请先选择一个会议</p>
                    </div>
                    <table class="table table-striped table-hover mb-0 d-none" id="checkinTable">
                        <thead class="table-light">
                            <tr>
                                <th>姓名</th>
                                <th>手机号</th>
                                <th>签到时间</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="checkinBody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面加载时获取组织者的会议列表
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

        function loadCheckinList() {
            const conferenceId = document.getElementById('conferenceSelect').value;
            if (!conferenceId) return;

            document.getElementById('loadingHint').classList.add('d-none');
            fetch('${pageContext.request.contextPath}/checkin/list?conferenceId=' + conferenceId)
                .then(res => res.json())
                .then(resp => {
                    if (resp.code !== 200) return;
                    const list = resp.data;
                    document.getElementById('listCount').textContent = list.length + ' 人';
                    document.getElementById('checkinTable').classList.remove('d-none');

                    // 统计
                    const checkedIn = list.filter(r => r.checkedIn).length;
                    document.getElementById('statTotal').textContent = list.length;
                    document.getElementById('statCheckedIn').textContent = checkedIn;
                    document.getElementById('statUnchecked').textContent = list.length - checkedIn;
                    document.getElementById('statsBar').classList.remove('d-none');

                    // 表格
                    const tbody = document.getElementById('checkinBody');
                    tbody.innerHTML = '';
                    list.forEach(row => {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td>' + row.username + '</td>' +
                            '<td>' + (row.phone || '-') + '</td>' +
                            '<td>' + (row.checkinTime || '-') + '</td>' +
                            '<td>' + (row.checkedIn
                                ? '<span class="badge bg-success">已签到</span>'
                                : '<span class="badge bg-warning text-dark">未签到</span>') + '</td>' +
                            '<td>' + (row.checkedIn
                                ? '<button class="btn btn-sm btn-secondary" disabled>已签到</button>'
                                : '<button class="btn btn-sm btn-primary" onclick="doCheckin(' + row.attendeeId + ')">签到</button>') + '</td>';
                        tbody.appendChild(tr);
                    });
                });
        }

        function doCheckin(attendeeId) {
            const formData = new URLSearchParams();
            formData.append('attendeeId', attendeeId);

            fetch('${pageContext.request.contextPath}/checkin/doCheckin', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    Swal.fire({ icon: 'success', title: '签到成功', timer: 1500, showConfirmButton: false });
                    loadCheckinList();
                } else if (data.code === 401) {
                    location.href = '${pageContext.request.contextPath}/login.jsp';
                } else {
                    Swal.fire({ icon: 'error', title: '签到失败', text: data.msg });
                }
            });
        }
    </script>
</body>
</html>
