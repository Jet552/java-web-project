<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册-会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="${pageContext.request.contextPath}/css/login-style.css" rel="stylesheet"/>
    <style>
        .form-select-custom {
            width: 50% !important;
            margin: 0 0 20px 0 !important;
            display: block !important;
            padding: 12px 16px !important;
            font-size: 15px !important;
            border: 2px solid #c3b5f0 !important;
            border-radius: 12px !important;
            background: #f5f3ff !important;
            color: #4a3bb5 !important;
            transition: all 0.2s;
        }
        .form-select-custom:focus {
            outline: none !important;
            border-color: #6c5ce7 !important;
            box-shadow: 0 0 0 3px rgba(108,92,231,0.15) !important;
        }
        .field-error {
            font-size: 12px;
            color: #e53e3e;
            margin: -14px 0 16px 0;
            padding-left: 4px;
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="logo-icon">
        <i class="bi bi-person-plus"></i>
    </div>
    <h2>用户注册</h2>
    <div class="subtitle">创建您的会务管理账户</div>

    <form id="registerForm">
        <div class="input-group-custom">
            <i class="bi bi-person"></i>
            <input type="text" class="form-control-custom" id="username" name="username" placeholder="用户名" autocomplete="off" required>
        </div>
        <div class="field-error" id="usernameError" style="display:none;"></div>

        <div class="input-group-custom">
            <i class="bi bi-lock"></i>
            <input type="password" class="form-control-custom" id="password" name="password" placeholder="密码" required>
        </div>
        <div class="field-error" id="passwordError" style="display:none;"></div>

        <div class="input-group-custom">
            <i class="bi bi-shield-check"></i>
            <input type="password" class="form-control-custom" id="confirmPassword" name="confirmPassword" placeholder="确认密码" required>
        </div>
        <div class="field-error" id="confirmPasswordError" style="display:none;"></div>

        <select class="form-select-custom" id="registerMethod" name="registerMethod" onchange="toggleContactInput()">
            <option value="">请选择联系方式...</option>
            <option value="email">邮箱地址</option>
            <option value="phone">手机号码</option>
        </select>
        <div class="field-error" id="registerMethodError" style="display:none;"></div>

        <div id="contactInputContainer">
            <div class="input-group-custom" id="emailGroup" style="display: none;">
                <i class="bi bi-envelope"></i>
                <input type="email" class="form-control-custom" id="email" name="email" placeholder="邮箱地址">
            </div>
            <div class="field-error" id="emailError" style="display:none;"></div>

            <div class="input-group-custom" id="phoneGroup" style="display: none;">
                <i class="bi bi-phone"></i>
                <input type="tel" class="form-control-custom" id="phone" name="phone" placeholder="手机号码">
            </div>
            <div class="field-error" id="phoneError" style="display:none;"></div>
        </div>
        <button type="button" class="btn-login" id="registerBtn" onclick="handleRegister()">
            <i class="bi bi-person-plus me-2"></i> 注册账户
        </button>

        <div class="divider"><span>已有账户？</span></div>
        <div class="extra-links">
            <a href="login.jsp"><i class="bi bi-box-arrow-in-right"></i> 立即登录</a>
        </div>
    </form>

    <div class="footer">
        <i class="bi bi-shield-check"></i> 安全注册 · 信息保密
    </div>
</div>

<script>
    // 动态获取 contextPath（必须留在 JSP 中）
    var contextPath = '<%= request.getContextPath() %>';
</script>
<!-- 引入注册页面的 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>