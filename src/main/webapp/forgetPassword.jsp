<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>忘记密码 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link href="${pageContext.request.contextPath}/css/login-style.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/forgetPassword.css" rel="stylesheet"/>
</head>
<body>
<div class="login-card">
    <div class="logo-icon">
        <i class="bi bi-key"></i>
    </div>
    <h2>忘记密码</h2>
    <div class="subtitle">验证身份后重置您的登录密码</div>

    <div class="step-indicator">
        <div class="step-item active" id="step1Indicator">
            <div class="step-circle">1</div>
            <span class="step-label">验证身份</span>
        </div>
        <div class="step-line"></div>
        <div class="step-item" id="step2Indicator">
            <div class="step-circle">2</div>
            <span class="step-label">重置密码</span>
        </div>
    </div>

    <!--验证身份 -->
    <div id="step1" class="step-content">
        <form id="verifyForm">
            <div class="input-group-custom">
                <i class="bi bi-person"></i>
                <input type="text" class="form-control-custom" id="username" name="username" placeholder="用户名" autocomplete="off" required>
            </div>
            <div class="field-error" id="usernameError" style="display:none;"></div>

            <select class="form-select-custom" id="contactMethod" name="contactMethod">
                <option value="">选择注册时的方式...</option>
                <option value="phone">手机号码</option>
                <option value="email">邮箱地址</option>
            </select>
            <div class="field-error" id="contactMethodError" style="display:none;"></div>

            <div class="input-group-custom" id="contactInputContainer">
                <i class="bi bi-phone" id="contactIcon"></i>
                <input type="text" class="form-control-custom" id="contactValue" name="contactValue" placeholder="请输入手机号码或邮箱" autocomplete="off">
            </div>
            <div class="field-error" id="contactValueError" style="display:none;"></div>

            <button type="button" class="btn-login" id="verifyBtn" onclick="handleVerify()">
                <i class="bi bi-shield-check me-2"></i> 验证身份
            </button>
        </form>
    </div>

    <!--重置密码（默认隐藏） -->
    <div id="step2" class="step-content" style="display:none;">
        <form id="resetForm">
            <div class="input-group-custom">
                <i class="bi bi-lock"></i>
                <input type="password" class="form-control-custom" id="newPassword" name="newPassword" placeholder="新密码" required>
            </div>
            <div class="field-error" id="newPasswordError" style="display:none;"></div>

            <div class="input-group-custom">
                <i class="bi bi-shield-check"></i>
                <input type="password" class="form-control-custom" id="confirmPassword" name="confirmPassword" placeholder="确认新密码" required>
            </div>
            <div class="field-error" id="confirmPasswordError" style="display:none;"></div>

            <button type="button" class="btn-login" id="resetBtn" onclick="handleReset()">
                <i class="bi bi-check-circle me-2"></i> 重置密码
            </button>
        </form>
    </div>

    <div class="divider"><span>想起密码了？</span></div>
    <div class="extra-links">
        <a href="login.jsp"><i class="bi bi-box-arrow-in-right"></i> 返回登录</a>
    </div>

    <div class="footer">
        <i class="bi bi-shield-check"></i> 安全验证 · 保护账户
    </div>
</div>

<script>
    // 动态获取 contextPath
    var contextPath = '<%= request.getContextPath() %>';
</script>
<script src="${pageContext.request.contextPath}/js/forgetPassword.js"></script>
</body>
</html>
