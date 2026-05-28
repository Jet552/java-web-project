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

    <link href="${pageContext.request.contextPath}/css/index1.css" rel="stylesheet"/>
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
