/**
 * 会务管理系统 - 登录页面 JavaScript
 * 功能：表单验证、登录请求、记住密码、忘记密码
 */


//页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 加载保存的账号密码
    loadRememberedAccount();

    // 绑定回车键登录事件
    bindEnterKeyEvent();
});

//绑定回车键登录事件
function bindEnterKeyEvent() {
    var usernameInput = document.getElementById('username');
    var passwordInput = document.getElementById('password');

    if (usernameInput) {
        usernameInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                handleLogin();
            }
        });
    }

    if (passwordInput) {
        passwordInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                handleLogin();
            }
        });
    }
}

//处理登录请求
function handleLogin() {
    // 获取表单数据
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value;
    var role = 'attendee';
    // 前端表单验证
    if (!validateForm(username, password)) {
        return;
    }
    // 显示加载状态
    var loginBtn = document.getElementById('loginBtn');
    var originalHtml = loginBtn.innerHTML;
    setButtonLoading(loginBtn, true, originalHtml);
    // 构建请求参数
    var url = contextPath + '/user/login';
    var bodyData = buildRequestBody(username, password, role);

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


/**
 * 表单验证
 * @param {string} username 用户名
 * @param {string} password 密码
 * @returns {boolean} 验证是否通过
 */
function validateForm(username, password) {
    if (!username) {
        showError('请输入用户名');
        highlightInput('username');
        return false;
    }

    if (!password) {
        showError('请输入密码');
        highlightInput('password');
        return false;
    }

    return true;
}

/**
 * 构建请求体
 * @param {string} username 用户名
 * @param {string} password 密码
 * @param {string} role 角色
 * @returns {string} URL编码的请求体
 */
function buildRequestBody(username, password, role) {
    return 'username=' + encodeURIComponent(username) +
        '&password=' + encodeURIComponent(password) +
        '&role=' + encodeURIComponent(role);//用于后端request接收,"username=??&password=??&role=??"
}

/**
 * 设置按钮加载状态
 * @param {HTMLElement} button 按钮元素
 * @param {boolean} isLoading 是否加载中
 * @param {string} originalHtml 原始HTML内容
 */
function setButtonLoading(button, isLoading, originalHtml) {
    if (isLoading) {
        button.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>登录中...';
        button.disabled = true;
    } else {
        button.innerHTML = originalHtml;
        button.disabled = false;
    }
}

/**
 * 处理登录响应
 * @param {Object} data 服务器响应数据
 * @param {string} username 用户名
 * @param {string} password 密码
 * @param {HTMLElement} loginBtn 登录按钮元素
 * @param {string} originalHtml 按钮原始HTML
 */
function handleLoginResponse(data, username, password, loginBtn, originalHtml) {
    // 恢复按钮状态
    setButtonLoading(loginBtn, false, originalHtml);
    if (data.code === 200) {
        // 处理记住密码
        handleRememberPassword(username, password);
        // 显示成功提示并跳转
        showSuccessAndRedirect(data);
    } else {
        // 登录失败处理
        showError(data.msg || '登录失败，请检查用户名和密码');
        document.getElementById('password').value = '';
    }
}

/**
 * 处理登录错误
 * @param {Error} error 错误对象
 * @param {HTMLElement} loginBtn 登录按钮元素
 * @param {string} originalHtml 按钮原始HTML
 */
function handleLoginError(error, loginBtn, originalHtml) {
    setButtonLoading(loginBtn, false, originalHtml);
    console.error('登录请求失败:', error);
    showError('网络错误，请稍后重试');
}


/**
 * 处理记住密码
 * @param {string} username 用户名
 * @param {string} password 密码
 */
function handleRememberPassword(username, password) {
    var rememberCheckbox = document.getElementById('rememberMe');

    if (rememberCheckbox && rememberCheckbox.checked) {
        saveAccount(username, password);
    } else {
        clearSavedAccount();
    }
}

/**
 * 保存账号到本地存储
 * @param {string} username 用户名
 * @param {string} password 密码
 */
function saveAccount(username, password) {
    localStorage.setItem('saved_username', username);
    localStorage.setItem('saved_password', password);
    localStorage.setItem('remember_me', 'true');
}

/**
 * 加载保存的账号
 */
function loadRememberedAccount() {
    var rememberMe = localStorage.getItem('remember_me') === 'true';

    if (rememberMe) {
        var savedUsername = localStorage.getItem('saved_username');
        var savedPassword = localStorage.getItem('saved_password');

        if (savedUsername) {
            document.getElementById('username').value = savedUsername;
        }

        if (savedPassword) {
            document.getElementById('password').value = savedPassword;
        }

        var rememberCheckbox = document.getElementById('rememberMe');
        if (rememberCheckbox) {
            rememberCheckbox.checked = true;
        }
    }
}

/**
 * 清除保存的账号
 */
function clearSavedAccount() {
    localStorage.removeItem('saved_username');
    localStorage.removeItem('saved_password');
    localStorage.removeItem('remember_me');
}


/**
 * 显示成功提示并跳转
 * @param {Object} data - 服务器响应数据
 */
function showSuccessAndRedirect(data) {
    Swal.fire({
        icon: 'success',
        title: '登录成功',
        text: data.msg || '正在跳转...',
        timer: 1500,
        showConfirmButton: false
    }).then(function() {
        redirectByRole(data);
    });
}

/**
 * 根据角色跳转页面
 * @param {Object} data - 服务器响应数据
 */
function redirectByRole(data) {
    if (data.data && data.data.role === 'admin') {
        window.location.href = contextPath + '/admin/dashboard.jsp';
    } else {
        window.location.href = contextPath + '/index.jsp';
    }
}

/**
 * 显示错误提示
 * @param {string} message - 错误消息
 */
function showError(message) {
    Swal.fire({
        icon: 'error',
        title: '登录失败',
        text: message,
        confirmButtonColor: '#f56565'
    });
}

/**
 * 高亮错误输入框
 * @param {string} inputId - 输入框ID
 */
function highlightInput(inputId) {
    var input = document.getElementById(inputId);

    if (!input) {
        return;
    }
    input.classList.add('is-invalid');
    setTimeout(function() {
        input.classList.remove('is-invalid');
    }, 2000);
}

/**
 * 显示忘记密码弹窗
 */
function showForgotPassword() {
    Swal.fire({
        icon: 'info',
        title: '找回密码',
        html: '<div style="text-align:left;">' +
            '<p>请联系系统管理员重置密码：</p>' +
            '<p class="mt-2 mb-0"><i class="bi bi-envelope"></i> <strong>admin@meeting.com</strong></p>' +
            '<p><i class="bi bi-telephone"></i> <strong>400-123-4567</strong></p>' +
            '</div>',
        confirmButtonText: '知道了',
        confirmButtonColor: '#667eea'
    });
}