<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="${pageContext.request.contextPath}/css/index1.css" rel="stylesheet"/>
    <style>
        .sidebar { min-height: 100vh; background-color: #2c3e50; }
        .sidebar a { color: #ecf0f1; transition: all 0.3s; }
        .sidebar a:hover { background-color: #34495e; color: #fff; }
        .sidebar .active { background-color: #3498db; }
        .main-content { min-height: 100vh; }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/index2.jsp");
            return;
        }
        String username = user.getUsername();
    %>

    <div class="container-fluid p-0">
        <div class="row">
            <nav class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="text-white text-center mb-4"><i class="bi bi-calendar-alt"></i> 管理控制台</h4>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link p-3 active" href="#" data-page="stats"><i class="bi bi-bar-chart"></i> 系统统计</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="#" data-page="conferences"><i class="bi bi-calendar"></i> 会议管理</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link p-3" href="#" data-page="users"><i class="bi bi-users"></i> 用户管理</a>
                    </li>
                    <li class="nav-item mt-auto">
                        <a class="nav-link p-3 text-danger" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a>
                    </li>
                </ul>
            </nav>

            <main class="col-md-10 main-content bg-light p-6">
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <h1 class="text-2xl font-bold text-gray-800">管理员控制台</h1>
                        <div class="dropdown">
                            <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-user-circle me-2"></i><%= username %>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile.jsp"><i class="bi bi-user-circle me-2"></i>个人中心</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right me-2"></i>退出登录</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div id="content-wrapper">
                    <div class="text-center py-10">
                        <i class="bi bi-hourglass fa-4x text-muted"></i>
                        <p class="mt-3 text-muted">加载中...</p>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        var contextPath = '<%= request.getContextPath() %>';
        
        $(document).ready(function() {
            loadPage('stats');
            
            $('.nav-link').click(function(e) {
                e.preventDefault();
                var page = $(this).data('page');
                $('.nav-link').removeClass('active');
                $(this).addClass('active');
                loadPage(page);
            });
        });
        
        function loadPage(page) {
            var urls = {
                'conferences': 'fragments/conferences.jsp',
                'users': 'fragments/users.jsp',
                'stats': 'fragments/stats.jsp'
            };
            
            $('#content-wrapper').html('<div class="text-center py-10"><i class="bi bi-spinner fa-spin fa-3x text-primary"></i><p class="mt-3">加载中...</p></div>');
            
            $.get(urls[page], function(data) {
                $('#content-wrapper').html(data);
            }).fail(function() {
                $('#content-wrapper').html('<div class="alert alert-danger">加载失败，请刷新页面重试</div>');
            });
        }
        
        function showDeveloping(featureName) {
            Swal.fire({
                icon: 'info',
                title: '功能开发中',
                text: '"' + featureName + '" 功能正在开发中，敬请期待！',
                confirmButtonText: '知道了',
                confirmButtonColor: '#667eea'
            });
        }
    </script>
</body>
</html>