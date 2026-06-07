<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    String username = user != null ? user.getUsername() : "";
%>
<div class="card">
    <div class="card-body">
        <h2 class="card-title"><i class="bi bi-hand-sparkles me-2"></i>欢迎回来，管理员 <%= username %></h2>
        <p class="card-text text-muted">这里是会务管理系统管理员控制台，您可以审核会议、管理用户和查看系统统计信息。</p>
    </div>
</div>

<div class="row g-4 mt-4">
    <div class="col-md-6 col-lg-3">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="text-sm opacity-80">总会议数</p>
                        <p class="text-3xl font-bold" id="totalConferences">--</p>
                    </div>
                    <i class="bi bi-calendar text-4xl opacity-50"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card bg-success text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="text-sm opacity-80">总用户数</p>
                        <p class="text-3xl font-bold" id="totalUsers">--</p>
                    </div>
                    <i class="bi bi-users text-4xl opacity-50"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card bg-warning text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="text-sm opacity-80">总参会人次</p>
                        <p class="text-3xl font-bold" id="totalAttendees">--</p>
                    </div>
                    <i class="bi bi-people text-4xl opacity-50"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="card bg-danger text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <p class="text-sm opacity-80">待审核会议</p>
                        <p class="text-3xl font-bold" id="pendingConferences">--</p>
                    </div>
                    <i class="bi bi-clock text-4xl opacity-50"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row g-4 mt-4">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5><i class="bi bi-chart-bar me-2 text-primary"></i>近期会议趋势</h5>
            </div>
            <div class="card-body text-center py-5 text-muted">
                <i class="bi bi-chart-area fa-4x mb-3 opacity-25"></i>
                <p>数据可视化图表区域<br><small>（功能开发中）</small></p>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header">
                <h5><i class="bi bi-bell me-2 text-warning"></i>系统通知</h5>
            </div>
            <div class="card-body p-0">
                <div class="list-group list-group-flush">
                    <div class="list-group-item px-4 py-3">
                        <div class="d-flex w-100 justify-content-between">
                            <h6 class="mb-1">新会议待审核</h6>
                            <small class="text-muted">10分钟前</small>
                        </div>
                        <p class="mb-1 text-muted small">"2024年人工智能峰会"等待审核</p>
                    </div>
                    <div class="list-group-item px-4 py-3">
                        <div class="d-flex w-100 justify-content-between">
                            <h6 class="mb-1">用户注册</h6>
                            <small class="text-muted">1小时前</small>
                        </div>
                        <p class="mb-1 text-muted small">5位新用户注册系统</p>
                    </div>
                    <div class="list-group-item px-4 py-3">
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

<script>
    $(document).ready(function() {
        loadOverviewStats();
    });
    
    function loadOverviewStats() {
        $.get('<%= request.getContextPath() %>/admin/stats', function(data) {
            $('#totalConferences').text(data.totalConferences || 0);
            $('#totalUsers').text(data.totalUsers || 0);
            $('#totalAttendees').text(data.totalAttendees || 0);
            $('#pendingConferences').text(data.pendingConferences || 0);
        });
    }
</script>