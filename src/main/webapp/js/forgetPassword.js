//忘记密码页面
document.addEventListener('DOMContentLoaded', function() {
    // 切换联系方式时更新输入框提示
    document.getElementById('contactMethod').addEventListener('change', function() {
        var method = this.value;
        var contactInput = document.getElementById('contactValue');
        var contactIcon = document.getElementById('contactIcon');

        if (method === 'phone') {
            contactInput.placeholder = '请输入注册时的手机号码';
            contactIcon.className = 'bi bi-phone';
        } else if (method === 'email') {
            contactInput.placeholder = '请输入注册时的邮箱地址';
            contactIcon.className = 'bi bi-envelope';
        } else {
            contactInput.placeholder = '请先选择联系方式类型';
            contactIcon.className = 'bi bi-phone';
        }

        // 隐藏错误提示
        document.getElementById('contactValueError').style.display = 'none';
        document.getElementById('contactMethodError').style.display = 'none';
    });
});

//验证身份
function handleVerify() {
    var username = document.getElementById('username').value.trim();
    var contactMethod = document.getElementById('contactMethod').value;
    var contactValue = document.getElementById('contactValue').value.trim();
    var hasError = false;

    if (!username) {
        showFieldError('usernameError', '请输入用户名');
        document.getElementById('username').classList.add('is-invalid');
        hasError = true;
    } else {
        hideFieldError('usernameError');
        document.getElementById('username').classList.remove('is-invalid');
    }
    if (!contactMethod) {
        showFieldError('contactMethodError', '请选择联系方式类型');
        hasError = true;
    } else {
        hideFieldError('contactMethodError');
    }
    if (!contactValue) {
        showFieldError('contactValueError', '请输入联系方式');
        document.getElementById('contactValue').classList.add('is-invalid');
        hasError = true;
    } else {
        hideFieldError('contactValueError');
        document.getElementById('contactValue').classList.remove('is-invalid');
    }
    if (hasError) return;
    // 发送验证请求
    var verifyBtn = document.getElementById('verifyBtn');
    var originalHtml = verifyBtn.innerHTML;
    verifyBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>验证中...';
    verifyBtn.disabled = true;
    fetch(contextPath + '/user/resetPassword', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'username=' + encodeURIComponent(username) +
              '&contactMethod=' + encodeURIComponent(contactMethod) +
              '&contactValue=' + encodeURIComponent(contactValue) +
              '&action=verify'
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        verifyBtn.innerHTML = originalHtml;
        verifyBtn.disabled = false;

        if (data.code === 200) {
            Swal.fire({
                icon: 'sucess',
                title: '验证成功',
                text: data.msg ||'验证成功',
                confirmButtonColor: '#f56565'
            });
            goToStep2();
        } else {
            Swal.fire({
                icon: 'error',
                title: '验证失败',
                text: data.msg || '身份验证未通过，请检查信息',
                confirmButtonColor: '#f56565'
            });
        }
    })
    .catch(function() {
        verifyBtn.innerHTML = originalHtml;
        verifyBtn.disabled = false;
        Swal.fire({
            icon: 'error',
            title: '网络错误',
            text: '请求失败，请稍后重试',
            confirmButtonColor: '#f56565'
        });
    });
}

//进入步骤2
function goToStep2() {
    document.getElementById('step1').style.display = 'none';
    document.getElementById('step2').style.display = 'block';
    document.getElementById('step1Indicator').classList.remove('active');
    document.getElementById('step2Indicator').classList.add('active');
}

//重置密码
function handleReset() {
    var newPassword = document.getElementById('newPassword').value;
    var confirmPassword = document.getElementById('confirmPassword').value;
    var hasError = false;

    if (!newPassword) {
        showFieldError('newPasswordError', '请输入新密码');
        hasError = true;
    } else {
        hideFieldError('newPasswordError');
    }

    if (!confirmPassword) {
        showFieldError('confirmPasswordError', '请确认新密码');
        hasError = true;
    } else if (confirmPassword !== newPassword) {
        showFieldError('confirmPasswordError', '两次输入的密码不一致');
        hasError = true;
    } else {
        hideFieldError('confirmPasswordError');
    }
    if (hasError) return;
    // 发送重置请求
    var resetBtn = document.getElementById('resetBtn');
    var originalHtml = resetBtn.innerHTML;
    resetBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>重置中...';
    resetBtn.disabled = true;

    var username = document.getElementById('username').value.trim();
    var contactMethod = document.getElementById('contactMethod').value;
    var contactValue = document.getElementById('contactValue').value.trim();

    fetch(contextPath + '/user/resetPassword', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'username=' + encodeURIComponent(username) +
              '&contactMethod=' + encodeURIComponent(contactMethod) +
              '&contactValue=' + encodeURIComponent(contactValue) +
              '&password=' + encodeURIComponent(newPassword) +
              '&action=reset'
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        resetBtn.innerHTML = originalHtml;
        resetBtn.disabled = false;

        if (data.code === 200) {
            Swal.fire({
                icon: 'success',
                title: '密码重置成功',
                text: '请使用新密码登录',
                confirmButtonColor: '#52c41a',
                confirmButtonText: '去登录'
            }).then(function() {
                window.location.href = contextPath + '/login.jsp';
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: '重置失败',
                text: data.msg || '密码重置失败，请重试',
                confirmButtonColor: '#f56565'
            });
        }
    })
    .catch(function() {
        resetBtn.innerHTML = originalHtml;
        resetBtn.disabled = false;
        Swal.fire({
            icon: 'error',
            title: '网络错误',
            text: '请求失败，请稍后重试',
            confirmButtonColor: '#f56565'
        });
    });
}

function showFieldError(elementId, message) {
    var el = document.getElementById(elementId);
    if (el) {
        el.textContent = message;
        el.style.display = 'block';
    }
}

function hideFieldError(elementId) {
    var el = document.getElementById(elementId);
    if (el) {
        el.style.display = 'none';
    }
}
