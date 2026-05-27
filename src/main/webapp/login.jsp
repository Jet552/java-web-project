<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录-会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link href="${pageContext.request.contextPath}/css/login-style.css" rel="stylesheet"/>
</head>
<body>

<div class="login-card">
    <div class="logo-icon">
        <i class="bi bi-calendar-event"></i>
    </div>
    <h2>会务管理系统</h2>
    <div class="subtitle">会议一站式管理平台</div>

    <form id="loginForm">
        <div class="input-group-custom">
            <i class="bi bi-person"></i>
            <input type="text" class="form-control-custom" id="username" name="username" placeholder="用户名" autocomplete="off" required>
        </div>
        <div class="input-group-custom">
            <i class="bi bi-lock"></i>
            <input type="password" class="form-control-custom" id="password" name="password" placeholder="密码" required>
        </div>

        <div class="role-selector">
            <div class="text-muted small mt-2"><i class="bi bi-info-circle"></i> 管理员请使用专用账号登录</div>
        </div>

        <div class="remember-check">
            <div class="form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe">
                <label class="form-check-label" for="rememberMe">记住密码</label>
            </div>
            <a href="#" class="text-decoration-none small" onclick="showForgotPassword(); return false;">忘记密码？</a>
        </div>

        <button type="button" class="btn-login" id="loginBtn" onclick="handleLogin()">
            <i class="bi bi-box-arrow-in-right me-2"></i> 登录系统
        </button>

        <div class="divider"><span>还没有账号？</span></div>
        <div class="extra-links">
            <a href="register.jsp"><i class="bi bi-person-plus"></i> 立即注册</a>
        </div>
    </form>

    <div class="footer">
        <i class="bi bi-shield-check"></i> 安全登录 · 数据加密
    </div>
</div>

<script>
    // 动态获取 contextPath（必须留在 JSP 中）
    var contextPath = '<%= request.getContextPath() %>';
</script>
<!-- 引入纯静态 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/login.js"></script>

</body>
</html>