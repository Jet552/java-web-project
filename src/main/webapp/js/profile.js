// var contextPath = '${pageContext.request.contextPath}';
// var isAdmin = ${isAdmin};

// 页面加载时获取个人信息
document.addEventListener('DOMContentLoaded', function() {
    loadUserProfile();

    // 密码强度实时检测
    var newPassword = document.getElementById('newPassword');
    if (newPassword) {
        newPassword.addEventListener('input', checkPasswordStrength);
    }
});

/**
 * 密码显示/隐藏切换
 */
function togglePassword(inputId) {
    var input = document.getElementById(inputId);
    var icon = document.getElementById(inputId + 'Icon');

    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bi-eye-slash');
        icon.classList.add('bi-eye');
    } else {
        input.type = 'password';
        icon.classList.remove('bi-eye');
        icon.classList.add('bi-eye-slash');
    }
}

/**
 * 检测密码强度
 */
function checkPasswordStrength() {
    var password = document.getElementById('newPassword').value;
    var strengthDiv = document.getElementById('passwordStrength');
    var strengthBar = document.getElementById('strengthBar');
    var strengthText = document.getElementById('strengthText');

    if (password.length === 0) {
        strengthDiv.style.display = 'none';
        return;
    }

    strengthDiv.style.display = 'block';

    var strength = 0;
    var tips = '';
    var color = '';

    // 长度检测
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // 包含数字
    if (/\d/.test(password)) strength++;

    // 包含小写字母
    if (/[a-z]/.test(password)) strength++;

    // 包含大写字母
    if (/[A-Z]/.test(password)) strength++;

    // 包含特殊字符
    if (/[^a-zA-Z0-9]/.test(password)) strength++;

    if (strength <= 2) {
        tips = '弱';
        color = '#dc3545';
        strengthBar.style.width = '25%';
    } else if (strength <= 4) {
        tips = '中';
        color = '#ffc107';
        strengthBar.style.width = '60%';
    } else {
        tips = '强';
        color = '#28a745';
        strengthBar.style.width = '100%';
    }

    strengthBar.style.backgroundColor = color;
    strengthText.innerHTML = '密码强度：' + tips;
    strengthText.style.color = color;
}

/**
 * 加载用户个人信息
 */
function loadUserProfile() {
    var url = contextPath + '/user/profile';

    fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.code === 200) {
                displayUserInfo(data.data);
            } else if (data.code === 401) {
                Swal.fire({
                    icon: 'error',
                    title: '未登录',
                    text: '请先登录',
                    confirmButtonColor: '#f56565',
                    background: '#fff',
                    backdrop: true
                }).then(function() {
                    window.location.href = contextPath + '/login.jsp';
                });
            } else {
                showErrorMessage(data.msg || '获取个人信息失败');
            }
        })
        .catch(function(error) {
            showErrorMessage('网络错误，请稍后重试2');
        });
}

/**
 * 显示用户信息
 */
function displayUserInfo(userData) {
    if (userData.id) {
        document.getElementById('infoId').innerText = userData.id;
    }
    if (userData.username) {
        document.getElementById('infoUsername').innerText = userData.username;
    }
    if (userData.email) {
        document.getElementById('infoEmail').innerText = userData.email;
        document.getElementById('email').value = userData.email;
    }
    if (userData.phone) {
        document.getElementById('infoPhone').innerText = userData.phone;
        document.getElementById('phone').value = userData.phone;
    }
    if (userData.createdDate) {
        document.getElementById('infoCreatedDate').innerText = formatDateTime(userData.createdDate);
    }
}

/**
 * 更新个人信息
 */
function updateProfile() {
    var email = document.getElementById('email').value.trim();
    var phone = document.getElementById('phone').value.trim();

    var bodyData = '';
    if (phone) {
        bodyData += 'phone=' + encodeURIComponent(phone);
    }
    else {
        Swal.fire({
            icon: 'warning',
            title: '提示',
            text: '请填写要修改的信息',
            confirmButtonColor: '#f56565'
        });
        return;
    }
    if (email) {
        if (bodyData) bodyData += '&';
        bodyData += 'email=' + encodeURIComponent(email);
    }
    else{
        Swal.fire({
            icon: 'warning',
            title: '提示',
            text: '请填写要修改的信息',
            confirmButtonColor: '#f56565'
        });
        return;
    }

    var url = contextPath + '/user/update';

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
            if (data.code === 200) {
                Swal.fire({
                    icon: 'success',
                    title: '修改成功',
                    text: '个人信息已更新',
                    confirmButtonColor: '#0d6efd',
                    timer: 1500,
                    showConfirmButton: false
                }).then(function() {
                    loadUserProfile();
                });
            } else {
                showErrorMessage(data.msg || '修改失败');
            }
        })
        .catch(function(error) {
            showErrorMessage('网络错误，请稍后重试');
        });
}

/**
 * 修改密码
 */
function changePassword() {
    var newPassword = document.getElementById('newPassword').value;
    var confirmPassword = document.getElementById('confirmPassword').value;

    if (!newPassword) {
        showErrorMessage('请输入新密码');
        return;
    }

    if (newPassword.length < 6) {
        showErrorMessage('密码长度不能少于6位');
        return;
    }

    if (newPassword !== confirmPassword) {
        showErrorMessage('两次输入的密码不一致');
        return;
    }

    var url = contextPath + '/user/changePassword';
    var bodyData = 'password=' + encodeURIComponent(newPassword);

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
            if (data.code === 200) {
                Swal.fire({
                    icon: 'success',
                    title: '修改成功',
                    text: '密码已更新，请重新登录',
                    confirmButtonColor: '#0d6efd'
                }).then(function() {
                    window.location.href = contextPath + '/user/logout';
                });
            } else {
                showErrorMessage(data.msg || '修改密码失败');
            }
        })
        .catch(function(error) {
            console.error('请求失败:', error);
            showErrorMessage('网络错误，请稍后重试');
        });
}

/**
 * 重置表单
 */
function resetForm() {
    loadUserProfile();
    document.getElementById('newPassword').value = '';
    document.getElementById('confirmPassword').value = '';
    document.getElementById('passwordStrength').style.display = 'none';

    Swal.fire({
        icon: 'info',
        title: '已重置',
        text: '表单已恢复为最新数据',
        confirmButtonColor: '#0d6efd',
        timer: 1000,
        showConfirmButton: false
    });
}

/**
 * 显示错误消息
 */
function showErrorMessage(message) {
    Swal.fire({
        icon: 'error',
        title: '操作失败',
        text: message,
        confirmButtonColor: '#f56565'
    });
}

/**
 * 格式化日期时间
 */
function formatDateTime(dateTimeStr) {
    if (!dateTimeStr) return '--';
    try {
        var date = new Date(dateTimeStr);
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    } catch(e) {
        return dateTimeStr;
    }
}