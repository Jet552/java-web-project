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
    <title>管理员控制台 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
        .stat-card {
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
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
                        <a class="nav-link active p-3" href="${pageContext.request.contextPath}/admin_index.jsp">
                            <i class="bi bi-speedometer"></i> 仪表盘
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/admin_users.jsp">
                            <i class="bi bi-users"></i> 用户管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="${pageContext.request.contextPath}/admin_conferences.jsp">
                            <i class="bi bi-calendar"></i> 会议审核
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
                    <h1 class="text-2xl font-bold text-gray-800">欢迎, <%= user.getUsername() %></h1>
                    <p class="text-gray-600 mt-2">管理系统概览</p>
                </div>

                <!-- 统计卡片 -->
                <div class="row mb-6">
                    <div class="col-md-3">
                        <div class="stat-card card bg-primary text-white p-4 rounded-lg shadow">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p class="text-sm opacity-80">待审核会议</p>
                                    <p id="pendingCount" class="text-3xl font-bold">--</p>
                                </div>
                                <i class="bi bi-clock text-4xl opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card card bg-success text-white p-4 rounded-lg shadow">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p class="text-sm opacity-80">总会议数</p>
                                    <p id="totalCount" class="text-3xl font-bold">--</p>
                                </div>
                                <i class="bi bi-calendar-check text-4xl opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card card bg-info text-white p-4 rounded-lg shadow">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p class="text-sm opacity-80">总用户数</p>
                                    <p id="userCount" class="text-3xl font-bold">--</p>
                                </div>
                                <i class="bi bi-users text-4xl opacity-50"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card card bg-warning text-white p-4 rounded-lg shadow">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p class="text-sm opacity-80">总参会数</p>
                                    <p id="attendeeCount" class="text-3xl font-bold">--</p>
                                </div>
                                <i class="bi bi-people text-4xl opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 快捷操作 -->
                <div class="card shadow rounded-lg">
                    <div class="card-header bg-white border-0">
                        <h3 class="font-semibold">快捷操作</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <a href="${pageContext.request.contextPath}/admin_conferences.jsp" class="btn btn-primary w-full py-3">
                                    <i class="bi bi-check-circle"></i> 审核会议
                                </a>
                            </div>
                            <div class="col-md-4 mb-4">
                                <a href="${pageContext.request.contextPath}/admin_users.jsp" class="btn btn-info w-full py-3">
                                    <i class="bi bi-user-check"></i> 管理用户
                                </a>
                            </div>
                            <div class="col-md-4 mb-4">
                                <a href="${pageContext.request.contextPath}/admin_stats.jsp" class="btn btn-success w-full py-3">
                                    <i class="bi bi-bar-chart"></i> 查看统计
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var contextPath = '<%= request.getContextPath() %>';
        
        function loadStats() {
            fetch(contextPath + '/admin/stats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('pendingCount').textContent = data.pendingConferences || 0;
                    document.getElementById('totalCount').textContent = data.totalConferences || 0;
                    document.getElementById('userCount').textContent = data.totalUsers || 0;
                    document.getElementById('attendeeCount').textContent = data.totalAttendees || 0;
                })
                .catch(error => console.error('加载统计数据失败:', error));
        }

        document.addEventListener('DOMContentLoaded', loadStats);
    </script>
</body>
</html>