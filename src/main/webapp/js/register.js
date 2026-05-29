// 注册页面 JavaScript 逻辑
function buildRequestBody(username, password, phone,email) {
    return 'username=' + encodeURIComponent(username) +
        '&password=' + encodeURIComponent(password) +
        '&phone=' + encodeURIComponent(phone)+'&email=' + encodeURIComponent(email);//用于后端request接收,"username=??&password=??&role=??"
}
// 处理注册功能
function handleRegister() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const radioEmail=document.getElementById('radioEmail').value;
    const radioPhone=document.getElementById('radioPhone').value;
    // 表单验证
    if (!username || !password || !confirmPassword || (!email && !phone )) {
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
    if (radioEmail.checked&&!emailRegex.test(email)) {
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
    if (radioPhone.checked&&!phoneRegex.test(phone)) {
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
    // 构建请求参数
    var url = contextPath + '/user/register';
    var bodyData = buildRequestBody(username, password, phone,email);
    // 发送登录请求
    fetch(url,{
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
            handleRegisterResponse(data, username, password, registerBtn, originalBtnText);
        })
        .catch(function(error) {
            handleLoginError(error, registerBtn, originalBtnText);
        });
    // 恢复按钮状态
    registerBtn.disabled = false;
    registerBtn.innerHTML = originalBtnText;
}
function handleRegisterResponse(data, username, password, loginBtn, originalHtml) {
    // 恢复按钮状态
    setButtonLoading(loginBtn, false, originalHtml);
    if (data.code ==200) {
        // 显示成功提示并跳转
        showSuccessAndRedirect(data.msg);
    } else{
        // 注册失败处理
        showError(data.msg);
        document.getElementById("username").value='';
        document.getElementById("password").value='';
        document.getElementById("phone").value='';
        document.getElementById("email").value='';
        document.getElementById("confirmPassword").value='';
    }
}
function showSuccessAndRedirect(message) {
    Swal.fire({
        icon: 'success',
        title: '注册成功！',
        text: message || '正在跳转...',
        confirmButtonColor: '#667eea',
        timer: 1500,
        timerProgressBar: true,
        didClose: () => {
            window.location.href = 'login.jsp';
        }
    });
}
function setButtonLoading(button, isLoading, originalHtml) {
    if (isLoading) {
        button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>注册中...';
        button.disabled = true;
    } else {
        button.innerHTML = originalHtml;
        button.disabled = false;
    }
}
function handleLoginError(error, registerBtn, originalHtml) {
    setButtonLoading(registerBtn, false, originalHtml);
    console.error('注册请求失败:', error);
    showError('网络错误，请稍后重试');
}
function showError(message) {
    Swal.fire({
        icon: 'error',
        title: '注册失败',
        text: message,
        confirmButtonColor: '#f56565'
    });
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
        showInputError(input, '此字段为必填项');
        return false;
    }
    if (inputId === 'email' && value !== '') {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) {
            showInputError(input, '请输入有效的邮箱地址');
            return false;
        }
    }
    if (inputId === 'phone' && value !== '') {
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (!phoneRegex.test(value)) {
            showInputError(input, '请输入有效的手机号码');
            return false;
        }
    }
    if (inputId === 'confirmPassword' && value !== '') {
        const password = document.getElementById('password').value;
        if (value !== password) {
            showInputError(input, '两次输入的密码不一致');
            return false;
        }
    }

    return true;
}
// 显示错误信息
function showInputError(input, message) {
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

