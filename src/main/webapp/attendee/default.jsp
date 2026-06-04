<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>首页 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css">
</head>
<body style="padding: 28px;">
    <div class="page-wrapper">
    <!-- 欢迎区域 -->
    <div class="welcome-banner">
        <h2><i class="fas fa-hand-sparkles me-2"></i>欢迎，${username}，发现精彩会议</h2>
        <p>浏览最新会议活动，一键报名参加，享受便捷的会务服务体验。</p>
    </div>

    <!-- 近期推荐会议 -->
    <div class="content-card">
        <div class="card-header">
            <h5><i class="fas fa-star me-2 text-warning"></i>近期推荐会议</h5>
        </div>
        <div class="card-body">
            <div id="conferenceTableWrapper">
                <div class="loading-placeholder">
                    <span class="spinner-border spinner-border-sm text-primary me-2" role="status"></span>加载中...
                </div>
            </div>
        </div>
    </div>

    <!-- 底部版权 -->
    <div class="footer">
        <i class="fas fa-copyright me-1"></i> 会务管理系统 &nbsp;|&nbsp; 让会议管理更简单
    </div>
    </div>

</body>
</html>
