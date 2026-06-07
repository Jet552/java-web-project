<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    String username = user != null ? user.getUsername() : "";
%>
<div class="welcome-section">
    <h2><i class="fas fa-hand-sparkles me-2"></i>欢迎回来，管理员 <%= username %></h2>
    <p>这里是会务管理系统管理员控制台，您可以审核会议、管理用户和查看系统统计信息。</p>
</div>

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