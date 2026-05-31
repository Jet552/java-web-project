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
        <div class="input-group-custom">
            <i class="bi bi-lock"></i>
            <input type="password" class="form-control-custom" id="password" name="password" placeholder="密码" required>
        </div>
        <div class="input-group-custom">
            <i class="bi bi-shield-check"></i>
            <input type="password" class="form-control-custom" id="confirmPassword" name="confirmPassword" placeholder="确认密码" required>
        </div>
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle custom-register-btn" type="button" id="registerMethodBtn" data-bs-toggle="dropdown">
                <span id="selectedMethodText">选择注册方式</span>
                <i class="bi bi-chevron-down"></i>
            </button>
            <div class="dropdown-menu p-3" style="width: 250px;" data-bs-auto-close="true"> <!-- 改了这里  -->
                <!-- 注意：data-bs-auto-close 必须放在 .dropdown-menu 上 -->
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="registerMethod" value="email" id="radioEmail" onclick=toggleContactInput()>
                    <label class="form-check-label" for="radioEmail">邮箱地址</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="registerMethod" value="phone" id="radioPhone" onclick=toggleContactInput()>
                    <label class="form-check-label" for="radioPhone">手机号码</label>
                </div>
            </div>
        </div>
        <!-- 动态显示的联系方式输入框容器 -->
        <div id="contactInputContainer">
            <!-- 邮箱输入框（初始隐藏） -->
            <div class="input-group-custom" id="emailGroup" style="display: none;">
                <i class="bi bi-envelope"></i>
                <input type="email" class="form-control-custom" id="email" name="email" placeholder="邮箱地址">
            </div>
            <!-- 手机输入框（初始隐藏） -->
            <div class="input-group-custom" id="phoneGroup" style="display: none;" >
                <i class="bi bi-phone"></i>
                <input type="tel" class="form-control-custom" id="phone" name="phone" placeholder="手机号码">
            </div>
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