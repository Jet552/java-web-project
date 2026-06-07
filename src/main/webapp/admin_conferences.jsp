<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() != 1) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会议审核 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #2c3e50;
        }
        .sidebar a {
            color: #ecf0f1;
            transition: all 0.3s;
        }
        .sidebar a:hover {
            background-color: #34495e;
            color: #fff;
        }
        .sidebar .active {
            background-color: #3498db;
        }
        .main-content {
            min-height: 100vh;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <nav class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="text-white text-center mb-4"><i class="bi bi-building"></i> 管理控制台</h4>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/index1.jsp">
                            <i class="bi bi-speedometer"></i> 系统概览
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/admin_users.jsp">
                            <i class="bi bi-users"></i> 用户管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active p-3" href="${pageContext.request.contextPath}/admin_conferences.jsp">
                            <i class="bi bi-calendar"></i> 会议审核
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/admin_conferences.jsp?status=all">
                            <i class="bi bi-list-alt"></i> 所有会议
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/admin_stats.jsp">
                            <i class="bi bi-bar-chart"></i> 系统统计
                        </a>
                    </li>
                    <li class="nav-item mt-auto">
                        <a class="nav-link p-3 text-danger" href="${pageContext.request.contextPath}/user/logout">
                            <i class="bi bi-box-arrow-right"></i> 退出登录
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- 主内容区 -->
            <main class="col-md-10 main-content bg-light p-6">
                <div class="mb-6">
                    <h1 class="text-2xl font-bold text-gray-800">会议审核</h1>
                    <p class="text-gray-600 mt-2">审核用户创建的会议</p>
                </div>

                <!-- 标签切换 -->
                <div class="mb-4">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <button class="nav-link active" id="pendingTab" onclick="loadPending()">待审核</button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" id="allTab" onclick="loadAll()">全部会议</button>
                        </li>
                    </ul>
                </div>

                <!-- 会议列表 -->
                <div class="card shadow rounded-lg">
                    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                        <h3 class="font-semibold" id="listTitle">待审核会议</h3>
                        <div class="text-sm text-gray-500">
                            共 <span id="conferenceCount" class="text-primary font-bold">0</span> 个会议
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>会议名称</th>
                                        <th>主办方ID</th>
                                        <th>地点</th>
                                        <th>开始时间</th>
                                        <th>结束时间</th>
                                        <th>状态</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody id="conferenceTableBody">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-hourglass"></i> 加载中...
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 审核弹窗 -->
    <div class="modal fade" id="reviewModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">审核会议</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="conferenceId">
                    <div class="mb-3">
                        <label class="form-label">会议名称</label>
                        <p class="form-control-plaintext" id="modalTitleText"></p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">审核意见</label>
                        <textarea class="form-control" id="reviewReason" rows="3" placeholder="请输入审核意见..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-success" id="approveBtn">通过</button>
                    <button type="button" class="btn btn-danger" id="rejectBtn">拒绝</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var contextPath = '<%= request.getContextPath() %>';
        var currentMode = 'pending';

        function loadPending() {
            currentMode = 'pending';
            document.getElementById('pendingTab').classList.add('active');
            document.getElementById('allTab').classList.remove('active');
            document.getElementById('listTitle').textContent = '待审核会议';
            fetch(contextPath + '/admin/pending')
                .then(response => response.json())
                .then(data => {
                    renderConferences(data);
                    document.getElementById('conferenceCount').textContent = data.length;
                })
                .catch(error => console.error('加载待审核会议失败:', error));
        }

        function loadAll() {
            currentMode = 'all';
            document.getElementById('allTab').classList.add('active');
            document.getElementById('pendingTab').classList.remove('active');
            document.getElementById('listTitle').textContent = '全部会议';
            fetch(contextPath + '/admin/conferences')
                .then(response => response.json())
                .then(data => {
                    renderConferences(data);
                    document.getElementById('conferenceCount').textContent = data.length;
                })
                .catch(error => console.error('加载会议列表失败:', error));
        }

        function renderConferences(conferences) {
            var tbody = document.getElementById('conferenceTableBody');
            if (!conferences || conferences.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted">暂无会议</td></tr>';
                return;
            }

            var html = '';
            conferences.forEach(function(conf) {
                var status = '';
                switch(conf.status) {
                    case 'pending':
                        status = '<span class="badge bg-warning">待审核</span>';
                        break;
                    case 'approved':
                        status = '<span class="badge bg-success">已通过</span>';
                        break;
                    case 'rejected':
                        status = '<span class="badge bg-danger">已拒绝</span>';
                        break;
                    default:
                        status = '<span class="badge bg-secondary">' + conf.status + '</span>';
                }

                var action = '';
                if (conf.status === 'pending') {
                    action = '<button class="btn btn-sm btn-primary" onclick="showReviewModal(' + conf.id + ', \'' + escapeHtml(conf.title) + '\')">审核</button>';
                } else {
                    action = '<span class="text-muted text-sm">-</span>';
                }

                html += '<tr>';
                html += '<td>' + conf.id + '</td>';
                html += '<td>' + escapeHtml(conf.title) + '</td>';
                html += '<td>' + conf.organizer_id + '</td>';
                html += '<td>' + escapeHtml(conf.venue || '-') + '</td>';
                html += '<td>' + formatDateTime(conf.start_date) + '</td>';
                html += '<td>' + formatDateTime(conf.end_date) + '</td>';
                html += '<td>' + status + '</td>';
                html += '<td>' + action + '</td>';
                html += '</tr>';
            });
            tbody.innerHTML = html;
        }

        function showReviewModal(id, title) {
            document.getElementById('conferenceId').value = id;
            document.getElementById('modalTitleText').textContent = title;
            document.getElementById('reviewReason').value = '';
            var modal = new bootstrap.Modal(document.getElementById('reviewModal'));
            modal.show();
        }

        document.getElementById('approveBtn').addEventListener('click', function() {
            var id = document.getElementById('conferenceId').value;
            var reason = document.getElementById('reviewReason').value;
            submitReview(id, reason, 'approve');
        });

        document.getElementById('rejectBtn').addEventListener('click', function() {
            var id = document.getElementById('conferenceId').value;
            var reason = document.getElementById('reviewReason').value;
            submitReview(id, reason, 'reject');
        });

        function submitReview(id, reason, action) {
            fetch(contextPath + '/admin/' + action, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'conferenceId=' + id + '&reason=' + encodeURIComponent(reason)
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    Swal.fire('成功', data.msg, 'success');
                    var modal = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
                    modal.hide();
                    if (currentMode === 'pending') {
                        loadPending();
                    } else {
                        loadAll();
                    }
                } else {
                    Swal.fire('失败', data.msg, 'error');
                }
            });
        }

        function formatDateTime(dateStr) {
            if (!dateStr) return '-';
            var date = new Date(dateStr);
            return date.toLocaleString('zh-CN');
        }

        function escapeHtml(str) {
            if (!str) return '';
            var div = document.createElement('div');
            div.textContent = str;
            return div.innerHTML;
        }

        document.addEventListener('DOMContentLoaded', loadPending);
    </script>
</body>
</html>