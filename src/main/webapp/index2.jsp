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

    <link href="${pageContext.request.contextPath}/css/index2.css" rel="stylesheet"/>
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
                    <a class="dropdown-item" href="#" onclick="showProfile()">
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
    // 动态获取 contextPath（必须留在 JSP 中）
    var contextPath = '<%= request.getContextPath() %>';
</script>
<!-- 引入纯静态 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/index2.js"></script>
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