// 注册页面 JavaScript 逻辑

// 处理注册功能
function handleRegister() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const department = document.getElementById('department').value;
    const realName = document.getElementById('realName').value;
    const role = document.querySelector('input[name="role"]:checked').value;

    // 表单验证
    if (!username || !password || !confirmPassword || !email || !phone || !department || !realName) {
        Swal.fire({
            icon: 'error',
            title: '错误',
            text: '请填写所有必填字段！',
            confirmButtonColor: '#667eea'
        });
        return;
    }

    if (password !== confirmPassword) {
        Swal.fire({
            icon: 'error',
            title: '错误',
            text: '两次输入的密码不一致！',
            confirmButtonColor: '#667eea'
        });
        return;
    }

    if (password.length < 6) {
        Swal.fire({
            icon: 'error',
            title: '错误',
            text: '密码长度至少需要6位！',
            confirmButtonColor: '#667eea'
        });
        return;
    }

    // 邮箱格式验证
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        Swal.fire({
            icon: 'error',
            title: '错误',
            text: '请输入有效的邮箱地址！',
            confirmButtonColor: '#667eea'
        });
        return;
    }

    // 手机号格式验证（简单的11位数字验证）
    const phoneRegex = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
        Swal.fire({
            icon: 'error',
            title: '错误',
            text: '请输入有效的手机号码！',
            confirmButtonColor: '#667eea'
        });
        return;
    }

    // 显示加载状态
    const registerBtn = document.getElementById('registerBtn');
    const originalBtnText = registerBtn.innerHTML;
    registerBtn.disabled = true;
    registerBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> 注册中...';

    // 模拟注册请求（实际项目中需要替换为真实的API调用）
    setTimeout(() => {
        // 这里应该发送 AJAX 请求到服务器
        // const registerData = {
        //     username: username,
        //     password: password,
        //     email: email,
        //     phone: phone,
        //     department: department,
        //     realName: realName,
        //     role: role
        // };

        // 模拟成功注册
        Swal.fire({
            icon: 'success',
            title: '注册成功！',
            text: '您的账户已成功创建，正在跳转到登录页面...',
            confirmButtonColor: '#667eea',
            timer: 2000,
            timerProgressBar: true,
            didClose: () => {
                window.location.href = 'login.jsp';
            }
        });

        // 恢复按钮状态
        registerBtn.disabled = false;
        registerBtn.innerHTML = originalBtnText;

    }, 1500);
}

// 表单输入验证
document.addEventListener('DOMContentLoaded', function() {
    const formInputs = document.querySelectorAll('.form-control-custom');

    // 为每个输入框添加实时验证
    formInputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateInput(this);
        });

        input.addEventListener('input', function() {
            // 清除错误状态
            this.style.borderColor = '#e2e8f0';
            this.style.boxShadow = 'none';
        });
    });

    // 密码强度提示
    const passwordInput = document.getElementById('password');
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        if (password.length > 0) {
            const strength = calculatePasswordStrength(password);
            showPasswordStrength(strength);
        }
    });
});

// 验证单个输入框
function validateInput(input) {
    const value = input.value.trim();
    const inputId = input.id;
    // 清除之前的错误提示
    const existingError = input.parentNode.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    // 验证逻辑
    if (value === '' && input.hasAttribute('required')) {
        showError(input, '此字段为必填项');
        return false;
    }
    if (inputId === 'email' && value !== '') {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) {
            showError(input, '请输入有效的邮箱地址');
            return false;
        }
    }
    if (inputId === 'phone' && value !== '') {
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (!phoneRegex.test(value)) {
            showError(input, '请输入有效的手机号码');
            return false;
        }
    }
    if (inputId === 'confirmPassword' && value !== '') {
        const password = document.getElementById('password').value;
        if (value !== password) {
            showError(input, '两次输入的密码不一致');
            return false;
        }
    }

    return true;
}

// 显示错误信息
function showError(input, message) {
    input.style.borderColor = '#e53e3e';
    input.style.boxShadow = '0 0 0 3px rgba(229, 62, 62, 0.1)';

    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.style.cssText = 'color: #e53e3e; font-size: 12px; margin-top: 5px;';
    errorDiv.textContent = message;

    input.parentNode.appendChild(errorDiv);
}

// 计算密码强度
function calculatePasswordStrength(password) {
    let strength = 0;

    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/\d/.test(password)) strength++;
    if (/[^a-zA-Z0-9]/.test(password)) strength++;

    return strength;
}

// 显示密码强度提示
function showPasswordStrength(strength) {
    const passwordInput = document.getElementById('password');
    const existingStrength = passwordInput.parentNode.querySelector('.strength-indicator');

    if (existingStrength) {
        existingStrength.remove();
    }

    const strengthDiv = document.createElement('div');
    strengthDiv.className = 'strength-indicator';
    strengthDiv.style.cssText = 'margin-top: 5px; font-size: 12px;';

    let strengthText = '';
    let strengthColor = '';

    switch(strength) {
        case 0:
        case 1:
            strengthText = '密码强度：弱';
            strengthColor = '#e53e3e';
            break;
        case 2:
        case 3:
            strengthText = '密码强度：中';
            strengthColor = '#dd6b20';
            break;
        case 4:
        case 5:
            strengthText = '密码强度：强';
            strengthColor = '#38a169';
            break;
    }

    strengthDiv.innerHTML = `<span style="color: ${strengthColor};">${strengthText}</span>`;
    passwordInput.parentNode.appendChild(strengthDiv);
}
function toggleContactInput() {
    const selectedMethodText=document.getElementById('selectedMethodText');
    const radioEmail = document.getElementById('radioEmail');
    const radioPhone = document.getElementById('radioPhone');
    const emailGroup = document.getElementById('emailGroup');
    const phoneGroup = document.getElementById('phoneGroup');
    emailGroup.style.display = 'none';
    phoneGroup.style.display = 'none';
    if (radioEmail.checked) {
        emailGroup.style.display = 'flex';
        document.getElementById('email').required = true;
        document.getElementById('phone').required = false;
        selectedMethodText.textContent="邮箱地址";
    } else if (radioPhone.checked) {
        phoneGroup.style.display = 'flex';
        document.getElementById('phone').required = true;
        document.getElementById('email').required = false;
        selectedMethodText.textContent="手机号码";
    }
}
// 键盘快捷键支持
document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && e.target.classList.contains('form-control-custom')) {
        // 在表单输入框中按 Enter 键时提交表单
        handleRegister();
    }
});
//处理登录请求
function handleRegister() {
    // 获取表单数据
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value;
    var phone=document.getElementById('phone').value;
    var email=document.getElementById('email').value;
    var role = '0';
    // 前端表单验证
    if (!validateForm(username, password)) {
        return;
    }
    // 显示加载状态
    var loginBtn = document.getElementById('loginBtn');
    var originalHtml = loginBtn.innerHTML;
    setButtonLoading(loginBtn, true, originalHtml);
    // 构建请求参数
    var url = contextPath + '/user/register';
    var bodyData = buildRequestBody(username, password, phone,email);
    // 发送登录请求
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: bodyData
    })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            handleLoginResponse(data, username, password, loginBtn, originalHtml);
        })
        .catch(function(error) {
            handleLoginError(error, loginBtn, originalHtml);
        });
}