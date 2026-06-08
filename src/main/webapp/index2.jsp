<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户工作台-会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="${pageContext.request.contextPath}/css/index2.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/conferencePayment.css" rel="stylesheet"/>
</head>
<body>
<%-- 检查是否登录，未登录则重定向 --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp" />
</c:if>
<%-- 检查是否是管理员（role == 1），是则重定向到管理员页面 --%>
<c:if test="${sessionScope.user.role == 1}">
    <c:redirect url="/index1.jsp" />
</c:if>
<%-- 获取用户名（后面的页面可以直接用） --%>
<c:set var="username" value="${sessionScope.user.username}" scope="page" />

<%--<%--%>
<%--    User user = (User) session.getAttribute("user");--%>
<%--    if (user == null) {--%>
<%--        response.sendRedirect(request.getContextPath() + "/login.jsp");--%>
<%--        return;--%>
<%--    }--%>
<%--    // 如果是管理员，重定向到管理员页面--%>
<%--    if (user.getRole() == 1) {--%>
<%--        response.sendRedirect(request.getContextPath() + "/index1.jsp");--%>
<%--        return;--%>
<%--    }--%>
<%--    String username = user.getUsername();--%>
<%--%>--%>

<!-- 侧边栏 -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <h4><i class="fas fa-calendar-alt"></i>会务管理系统</h4>
    </div>

    <!-- 注意：这里需要 sidebar-menu 容器 -->
    <div class="sidebar-menu">
        <!-- 首页 - 无子菜单，直接点击 -->
        <div class="nav-group">
            <a href="#" class="nav-link nav-direct" data-page="default">
                <i class="fas fa-home"></i>
                <span>首页</span>
            </a>
        </div>
        <!-- 会议管理 - 下拉菜单 -->
        <div class="nav-group">
            <a href="#" class="nav-link nav-toggle" data-group="meeting">
                <i class="fas fa-calendar-alt"></i>
                <span>会议管理</span>
                <i class="fas fa-chevron-down toggle-icon"></i>
            </a>
            <div class="nav-submenu" data-parent="meeting">
                <a href="#" class="nav-sub-link" data-page="conferenceHall">
                    <i class="fas fa-th-large"></i>
                    <span>会议大厅</span>
                </a>
                <a href="#" class="nav-sub-link" data-page="myConferences">
                    <i class="fas fa-calendar-check"></i>
                    <span>我的会议</span>
                </a>
                <a href="#" class="nav-sub-link" data-page="myAttendee">
                    <i class="fas fa-clipboard-list"></i>
                    <span>我的参会</span>
                </a>
                <a href="#" class="nav-sub-link" data-page="conferencePayment">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>会议缴费记录</span>
                </a>
            </div>
        </div>


        <!-- 会务服务 -->
        <div class="nav-group">
            <a href="#" class="nav-link nav-toggle" data-group="service">
                <i class="fas fa-concierge-bell"></i>
                <span>会务服务</span>
                <i class="fas fa-chevron-down toggle-icon"></i>
            </a>
            <div class="nav-submenu" data-parent="service">
                <a href="#" class="nav-sub-link" data-page="checkin">
                    <i class="fas fa-check-circle"></i>
                    <span>签到管理</span>
                </a>
                <a href="#" class="nav-sub-link" data-page="room">
                    <i class="fas fa-hotel"></i>
                    <span>入住管理</span>
                </a>
            </div>
        </div>
    </div>
</div>


<!-- 右侧主内容区 -->
<div class="main-content">
    <!-- 顶部用户栏 -->
    <div class="top-bar">
        <div class="user-dropdown dropdown">
            <div class="dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="user-avatar">
                    <span>${fn:substring(username, 0, 1)}</span>
                </div>
                <span class="d-none d-md-inline">${username}</span>
<%--                <i class="fas fa-chevron-down small"></i>--%>
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

    <!-- 动态内容区域（页面内容将异步加载到这里） -->
    <div id="pageContent">

    </div>
</div>

<!-- 加载动画遮罩 -->
<div id="loadingOverlay" class="loading-overlay" style="display: none;">
    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
        <span class="visually-hidden">加载中...</span>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 动态获取 contextPath（必须留在 JSP 中）
    var contextPath = '<%= request.getContextPath() %>';
    // 检测 URL 参数，用于从外部页面跳回时自动加载指定页面
    var pageParam = new URLSearchParams(window.location.search).get('page');
    if (pageParam) {
        // 延迟执行，等 index2.js 加载完成后再调用 loadPage
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                if (typeof loadPage === 'function') {
                    loadPage(pageParam);
                }
            }, 100);
        });
    }
</script>
<!-- 引入纯静态 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/index2.js"></script>
<!-- 引入纯静态 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/conferencePayment.js"></script>
<script src="${pageContext.request.contextPath}/js/meetingSearch.js"></script>
<script src="${pageContext.request.contextPath}/js/myAttendances.js"></script>
<script src="${pageContext.request.contextPath}/js/default.js"></script>
<script>
    //设置当前激活菜单(公共script)
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