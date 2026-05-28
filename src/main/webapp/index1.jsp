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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --sidebar-width: 260px;
            --sidebar-bg: #2c3e50;
            --sidebar-active: #3498db;
            --primary-color: #0d6efd;
        }

        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f5f6fa;
            min-height: 100vh;
        }

        /* 侧边栏样式 */
        .sidebar {
            width: var(--sidebar-width);
            background: #ffffff;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: 2px 0 12px rgba(0,0,0,0.08);
        }

        .sidebar-brand {
            padding: 28px 20px;
            border-bottom: 1px solid #e8ecef;
            margin-bottom: 8px;
        }

        .sidebar-brand h4 {
            color: #2c3e50;
            margin: 0;
            font-weight: 700;
            font-size: 1.6rem;
        }

        .sidebar-brand i {
            color: #3498db;
            margin-right: 12px;
            font-size: 1.4rem;
        }

        .sidebar-menu {
            padding: 16px 0;
        }

        .sidebar-menu .nav-link {
            color: #5a6e7e;
            padding: 16px 28px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
            font-size: 1.05rem;
            font-weight: 500;
            margin: 4px 0;
        }

        .sidebar-menu .nav-link:hover {
            color: #3498db;
            background: #f0f7ff;
            border-left-color: #3498db;
        }

        .sidebar-menu .nav-link.active {
            color: #3498db;
            background: linear-gradient(90deg, #e8f4ff 0%, #f0f7ff 100%);
            border-left-color: #3498db;
            font-weight: 600;
        }

        .sidebar-menu .nav-link i {
            width: 28px;
            margin-right: 14px;
            font-size: 1.25rem;
        }

        /* 主内容区 */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 顶部导航栏 */
        .top-navbar {
            background: #ADD8E6 ;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .top-navbar .breadcrumb {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 500;
            color: #2c3e50;
        }

        .user-dropdown .dropdown-toggle {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px;
            border-radius: 25px;
            border: 1px solid #e0e0e0;
            background: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-dropdown .dropdown-toggle:hover {
            background: #f8f9fa;
            border-color: #3498db;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 600;
        }

        /* 内容区域 */
        .content-wrapper {
            flex: 1;
            padding: 30px;
        }

        /* 欢迎区域 */
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 30px;
            color: #fff;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        .welcome-section h2 {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .welcome-section p {
            opacity: 0.9;
            margin: 0;
        }

        /* 统计卡片 */
        .stat-card {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .stat-card .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 15px;
        }

        .stat-card .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .stat-card .stat-label {
            color: #7f8c8d;
            font-size: 0.95rem;
        }

        .stat-card.primary .stat-icon {
            background: rgba(13, 110, 253, 0.1);
            color: #0d6efd;
        }

        .stat-card.success .stat-icon {
            background: rgba(25, 135, 84, 0.1);
            color: #198754;
        }

        .stat-card.warning .stat-icon {
            background: rgba(255, 193, 7, 0.1);
            color: #ffc107;
        }

        .stat-card.danger .stat-icon {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }

        /* 图表区域 */
        .chart-card {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            height: 100%;
        }

        .chart-card h5 {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        /* 底部版权 */
        .footer {
            background: #fff;
            padding: 20px 30px;
            text-align: center;
            color: #7f8c8d;
            border-top: 1px solid #e0e0e0;
            font-size: 0.9rem;
        }

        /* 响应式 */
        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // 如果不是管理员，重定向到普通用户页面
        if (user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/index2.jsp");
            return;
        }
        String username = user.getUsername();
    %>

    <!-- 侧边栏 -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <h4><i class="fas fa-calendar-alt"></i>会务管理系统</h4>
        </div>
        <nav class="sidebar-menu">
            <a href="#" class="nav-link active">
                <i class="fas fa-home"></i>
                <span>系统概览</span>
            </a>
            <a href="#" class="nav-link" onclick="showDeveloping('会议审核')">
                <i class="fas fa-clipboard-check"></i>
                <span>会议审核</span>
            </a>
            <a href="#" class="nav-link" onclick="showDeveloping('所有会议')">
                <i class="fas fa-list-alt"></i>
                <span>所有会议</span>
            </a>
            <a href="#" class="nav-link" onclick="showDeveloping('用户管理')">
                <i class="fas fa-users"></i>
                <span>用户管理</span>
            </a>
            <a href="#" class="nav-link" onclick="showDeveloping('系统统计')">
                <i class="fas fa-chart-line"></i>
                <span>系统统计</span>
            </a>
        </nav>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
        <!-- 顶部导航栏 -->
        <div class="top-navbar">
            <div class="breadcrumb">
                <i class="fas fa-tachometer-alt me-2 text-primary"></i>管理员控制台
            </div>
            <div class="user-dropdown dropdown">
                <div class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <span class="d-none d-md-inline"><strong><%= username %></strong></span>
                    <i class="fas fa-chevron-down text-muted small"></i>
                </div>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="#" onclick="showDeveloping('个人中心')">
                            <i class="fas fa-user-circle me-2"></i>个人中心
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>退出登录
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 欢迎区域 -->
            <div class="welcome-section">
                <h2><i class="fas fa-hand-sparkles me-2"></i>欢迎回来，管理员 <%= username %></h2>
                <p>这里是会务管理系统管理员控制台，您可以审核会议、管理用户和查看系统统计信息。</p>
            </div>

            <!-- 统计卡片 -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card primary">
                        <div class="stat-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="stat-value">128</div>
                        <div class="stat-label">总会议数</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card success">
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stat-value">2,456</div>
                        <div class="stat-label">总用户数</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card warning">
                        <div class="stat-icon">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stat-value">8,932</div>
                        <div class="stat-label">总参会人次</div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card danger">
                        <div class="stat-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div class="stat-value">12</div>
                        <div class="stat-label">待审核会议</div>
                    </div>
                </div>
            </div>

            <!-- 图表和列表区域 -->
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="chart-card">
                        <h5><i class="fas fa-chart-bar me-2 text-primary"></i>近期会议趋势</h5>
                        <div class="text-center py-5 text-muted">
                            <i class="fas fa-chart-area fa-4x mb-3 opacity-25"></i>
                            <p>数据可视化图表区域<br><small>（功能开发中）</small></p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="chart-card">
                        <h5><i class="fas fa-bell me-2 text-warning"></i>系统通知</h5>
                        <div class="list-group list-group-flush">
                            <div class="list-group-item px-0 py-3">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">新会议待审核</h6>
                                    <small class="text-muted">10分钟前</small>
                                </div>
                                <p class="mb-1 text-muted small">"2024年人工智能峰会"等待审核</p>
                            </div>
                            <div class="list-group-item px-0 py-3">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">用户注册</h6>
                                    <small class="text-muted">1小时前</small>
                                </div>
                                <p class="mb-1 text-muted small">5位新用户注册系统</p>
                            </div>
                            <div class="list-group-item px-0 py-3">
                                <div class="d-flex w-100 justify-content-between">
                                    <h6 class="mb-1">系统维护通知</h6>
                                    <small class="text-muted">昨天</small>
                                </div>
                                <p class="mb-1 text-muted small">系统将于本周日凌晨进行例行维护</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 底部版权 -->
        <div class="footer">
            <p class="mb-0">
                <i class="fas fa-copyright me-1"></i>2024 会务管理系统. All rights reserved.
                <span class="mx-2">|</span>
                <span class="text-muted">技术支持：开发团队</span>
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 显示功能开发中提示
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
