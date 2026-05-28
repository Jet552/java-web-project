<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户工作台 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --success-color: #198754;
            --info-color: #0dcaf0;
            --light-bg: #f8f9fa;
            --sidebar-width: 280px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
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
            text-decoration: none;
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

        /* 右侧主内容区 */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        /* 顶部用户栏 */
        .top-bar {
            background: #ffffff;
            padding: 12px 30px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            border-bottom: 1px solid #e8ecef;
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .user-dropdown {
            cursor: pointer;
        }

        .user-dropdown .dropdown-toggle {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            border-radius: 40px;
            background: #f8f9fa;
            border: 1px solid #e8ecef;
            color: #2c3e50;
            transition: all 0.3s ease;
        }

        .user-dropdown .dropdown-toggle:hover {
            background: #f0f2f5;
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
            font-size: 0.9rem;
        }

        /* 欢迎区域 */
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 0;
            margin-bottom: 30px;
            color: #fff;
        }

        .welcome-banner h2 {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .welcome-banner p {
            opacity: 0.9;
            margin: 0;
        }

        /* 快速入口卡片 */
        .quick-card {
            background: #fff;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            border: 2px solid transparent;
        }

        .quick-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            border-color: var(--primary-color);
        }

        .quick-card .quick-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 20px;
            transition: all 0.3s ease;
        }

        .quick-card:hover .quick-icon {
            transform: scale(1.1);
        }

        .quick-card.primary .quick-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
        }

        .quick-card.success .quick-icon {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: #fff;
        }

        .quick-card.info .quick-icon {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: #fff;
        }

        .quick-card h5 {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .quick-card p {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin: 0;
        }

        /* 内容卡片 */
        .content-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .content-card .card-header {
            background: transparent;
            border-bottom: 1px solid #f0f0f0;
            padding: 20px 25px;
        }

        .content-card .card-header h5 {
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }

        .content-card .card-body {
            padding: 0;
        }

        /* 表格样式 */
        .table-custom {
            margin: 0;
        }

        .table-custom thead th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #2c3e50;
            padding: 15px 25px;
        }

        .table-custom tbody td {
            border: none;
            border-bottom: 1px solid #f0f0f0;
            padding: 15px 25px;
            vertical-align: middle;
        }

        .table-custom tbody tr:hover {
            background: #f8f9fa;
        }

        .table-custom tbody tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-badge.upcoming {
            background: #e3f2fd;
            color: #1976d2;
        }

        .status-badge.ongoing {
            background: #e8f5e9;
            color: #388e3c;
        }

        .status-badge.ended {
            background: #f5f5f5;
            color: #616161;
        }

        /* 容器 */
        .content-wrapper {
            padding: 0 30px 30px 30px;
        }

        /* 底部版权 */
        .footer {
            background: #fff;
            padding: 20px;
            text-align: center;
            color: #7f8c8d;
            border-top: 1px solid #e0e0e0;
            margin-top: 40px;
            font-size: 0.9rem;
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .sidebar {
                left: -280px;
            }
            .main-content {
                margin-left: 0;
            }
            .welcome-banner {
                padding: 30px 0;
            }
            .quick-card {
                margin-bottom: 20px;
            }
            .content-wrapper {
                padding: 0 15px 15px 15px;
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
    // 如果是管理员，重定向到管理员页面
    if (user.getRole() == 1) {
        response.sendRedirect(request.getContextPath() + "/index1.jsp");
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
            <span>首页</span>
        </a>
        <a href="#" class="nav-link" onclick="showDeveloping('会议大厅')">
            <i class="fas fa-th-large"></i>
            <span>会议大厅</span>
        </a>
        <a href="#" class="nav-link" onclick="showDeveloping('我的参会')">
            <i class="fas fa-calendar-check"></i>
            <span>我的参会</span>
        </a>
        <a href="#" class="nav-link" onclick="showDeveloping('缴费记录')">
            <i class="fas fa-credit-card"></i>
            <span>缴费记录</span>
        </a>
    </nav>
</div>

<!-- 右侧主内容区 -->
<div class="main-content">
    <!-- 顶部用户栏 -->
    <div class="top-bar">
        <div class="user-dropdown dropdown">
            <div class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="user-avatar">
                    <span><%= username.substring(0, 1) %></span>
                </div>
                <span class="d-none d-md-inline"><%= username %></span>
                <i class="fas fa-chevron-down small"></i>
            </div>
            <ul class="dropdown-menu dropdown-menu-end">
                <li>
                    <a class="dropdown-item" href="#" onclick="showDeveloping('个人中心')">
                        <i class="fas fa-user-circle me-2 text-primary"></i>个人中心
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

    <!-- 欢迎区域 -->
    <div class="welcome-banner">
        <div class="container-fluid">
            <h2><i class="fas fa-hand-sparkles me-2"></i>欢迎，<%= username %>，发现精彩会议</h2>
            <p>浏览最新会议活动，一键报名参加，享受便捷的会务服务体验。</p>
        </div>
    </div>

    <!-- 主内容区 -->
    <div class="content-wrapper">

        <!-- 近期推荐会议 -->
        <div class="content-card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5><i class="fas fa-star me-2 text-warning"></i>近期推荐会议</h5>
                <a href="#" class="btn btn-outline-primary btn-sm" onclick="showDeveloping('查看更多')">
                    查看更多 <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-custom">
                        <thead>
                        <tr>
                            <th>会议名称</th>
                            <th>时间</th>
                            <th>地点</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded p-2 me-3">
                                        <i class="fas fa-microchip"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">2024年人工智能峰会</h6>
                                        <small class="text-muted">主办方：科技协会</small>
                                    </div>
                                </div>
                            </td>
                            <td>2024-06-15 至 2024-06-17</td>
                            <td><i class="fas fa-map-marker-alt text-muted me-1"></i>北京国际会议中心</td>
                            <td><span class="status-badge upcoming">即将开始</span></td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                    <i class="fas fa-eye me-1"></i>查看
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 text-success rounded p-2 me-3">
                                        <i class="fas fa-leaf"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">绿色能源发展论坛</h6>
                                        <small class="text-muted">主办方：环保组织</small>
                                    </div>
                                </div>
                            </td>
                            <td>2024-06-20 至 2024-06-21</td>
                            <td><i class="fas fa-map-marker-alt text-muted me-1"></i>上海国际会议中心</td>
                            <td><span class="status-badge upcoming">即将开始</span></td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                    <i class="fas fa-eye me-1"></i>查看
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-info bg-opacity-10 text-info rounded p-2 me-3">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">高校教学研讨会</h6>
                                        <small class="text-muted">主办方：教育部</small>
                                    </div>
                                </div>
                            </td>
                            <td>2024-05-28 至 2024-05-30</td>
                            <td><i class="fas fa-map-marker-alt text-muted me-1"></i>武汉大学</td>
                            <td><span class="status-badge ongoing">进行中</span></td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                    <i class="fas fa-eye me-1"></i>查看
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-warning bg-opacity-10 text-warning rounded p-2 me-3">
                                        <i class="fas fa-chart-line"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">数字经济创新大会</h6>
                                        <small class="text-muted">主办方：商会</small>
                                    </div>
                                </div>
                            </td>
                            <td>2024-05-15 至 2024-05-16</td>
                            <td><i class="fas fa-map-marker-alt text-muted me-1"></i>深圳会展中心</td>
                            <td><span class="status-badge ended">已结束</span></td>
                            <td>
                                <button class="btn btn-outline-secondary btn-sm" onclick="showDeveloping('查看详情')">
                                    <i class="fas fa-eye me-1"></i>查看
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-danger bg-opacity-10 text-danger rounded p-2 me-3">
                                        <i class="fas fa-heartbeat"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-0">医疗健康创新论坛</h6>
                                        <small class="text-muted">主办方：医疗协会</small>
                                    </div>
                                </div>
                            </td>
                            <td>2024-07-05 至 2024-07-07</td>
                            <td><i class="fas fa-map-marker-alt text-muted me-1"></i>广州琶洲展馆</td>
                            <td><span class="status-badge upcoming">即将开始</span></td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                    <i class="fas fa-eye me-1"></i>查看
                                </button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 底部版权 -->
        <div class="footer">
            <div class="container-fluid">
                <p class="mb-0">
                    <i class="fas fa-copyright me-1"></i>2024 会务管理系统. All rights reserved.
                    <span class="mx-2">|</span>
                    <span class="text-muted">让会议管理更简单</span>
                </p>
            </div>
        </div>
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

    // 设置当前激活菜单
    document.querySelectorAll('.sidebar-menu .nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            if (!this.getAttribute('onclick') || this.getAttribute('onclick') === '') {
                e.preventDefault();
                document.querySelectorAll('.sidebar-menu .nav-link').forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });
</script>
</body>
</html>