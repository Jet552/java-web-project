<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 会务管理系统</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f5f7fa;
        }

        /* 顶部导航栏 */
        .navbar-brand {
            font-weight: 600;
            font-size: 1.35rem;
        }

        .navbar-brand i {
            margin-right: 8px;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            background-color: #0d6efd;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            margin-right: 8px;
        }

        .dropdown-menu {
            border-radius: 12px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            border: none;
            margin-top: 8px;
        }

        .dropdown-item {
            padding: 8px 20px;
        }

        .dropdown-item i {
            margin-right: 10px;
            width: 20px;
        }

        /* 主内容区 */
        .main-container {
            padding: 24px 32px;
            min-height: calc(100vh - 56px);
        }

        /* 卡片样式 */
        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #edf2f7;
            padding: 20px 28px;
        }

        .card-header h4 {
            font-size: 18px;
            font-weight: 600;
            color: #1a202c;
            margin: 0;
        }

        .card-header i {
            margin-right: 10px;
            color: #0d6efd;
        }

        /* 头像区域 */
        .avatar-section {
            text-align: center;
            padding: 30px 0 20px 0;
            border-bottom: 1px solid #edf2f7;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .profile-avatar span {
            font-size: 40px;
            font-weight: 600;
            color: white;
        }

        .profile-name {
            font-size: 22px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }

        .profile-role {
            font-size: 14px;
            color: #718096;
        }

        /* 表单样式 */
        .form-section {
            padding: 24px 28px;
        }

        .form-label {
            font-weight: 500;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .required:after {
            content: " *";
            color: #dc3545;
        }

        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 10px 16px;
            font-size: 14px;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
            outline: none;
        }

        .form-control[readonly] {
            background-color: #f8fafc;
            cursor: not-allowed;
        }

        /* 信息行样式 */
        .info-row {
            display: flex;
            padding: 14px 0;
            border-bottom: 1px solid #edf2f7;
        }

        .info-label {
            width: 120px;
            font-weight: 500;
            color: #4a5568;
        }

        .info-value {
            flex: 1;
            color: #1a202c;
        }

        /* 按钮样式 */
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 28px;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-outline-custom {
            border: 1px solid #e2e8f0;
            background: white;
            padding: 10px 28px;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-outline-custom:hover {
            border-color: #0d6efd;
            color: #0d6efd;
        }

        /* 返回按钮 */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4a5568;
            text-decoration: none;
            margin-bottom: 20px;
            transition: all 0.2s;
        }

        .back-btn:hover {
            color: #0d6efd;
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .main-container {
                padding: 16px;
            }
            .info-row {
                flex-direction: column;
            }
            .info-label {
                width: 100%;
                margin-bottom: 8px;
            }
        }
    </style>
</head>
<body>

<c:set var="user" value="${sessionScope.user}" scope="page" />
<c:set var="username" value="${pageScope.user.username}" scope="page" />
<c:set var="role" value="${pageScope.user.role}" scope="page" />
<c:set var="isAdmin" value="${role == 1}" scope="page" />

<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top shadow-sm">
    <div class="container-fluid px-3">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-calendar-event"></i>
            会务管理系统
        </a>

        <div class="dropdown">
            <button class="btn btn-link text-white dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown" style="text-decoration: none;">
                <div class="user-avatar">${fn:substring(username, 0, 1)}</div>
                <span>${username}</span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/index.jsp"><i class="bi bi-house"></i> 返回首页</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- 主内容区 -->
<div class="main-container" style="margin-top: 76px;">

    <!-- 返回按钮 -->
    <a href="${pageContext.request.contextPath}/index.jsp" class="back-btn">
        <i class="bi bi-arrow-left"></i> 返回首页
    </a>

    <div class="row g-4">
        <!-- 左侧：个人信息卡片 -->
        <div class="col-md-4">
            <div class="card">
                <div class="avatar-section">
                    <div class="profile-avatar">
                        <span>${fn:substring(username, 0, 1)}</span>
                    </div>
                    <div class="profile-name" id="displayUsername">${username}</div>
                    <div class="profile-role">
                        <c:choose>
                            <c:when test="${isAdmin}">
                                <span class="badge bg-danger">管理员</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary">普通用户</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="form-section">
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-person me-2"></i>用户名</div>
                        <div class="info-value" id="infoUsername">${username}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-envelope me-2"></i>电子邮箱</div>
                        <div class="info-value" id="infoEmail">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-telephone me-2"></i>手机号码</div>
                        <div class="info-value" id="infoPhone">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-calendar me-2"></i>注册时间</div>
                        <div class="info-value" id="infoCreatedAt">-</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 右侧：编辑信息卡片 -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h4><i class="bi bi-pencil-square"></i> 编辑个人信息</h4>
                </div>
                <div class="form-section">
                    <form id="profileForm">
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label required">用户名</label>
                                <input type="text" class="form-control" id="username" readonly
                                       value="${username}" style="background-color: #f8fafc;">
                                <div class="form-text text-muted">用户名不可修改</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">电子邮箱</label>
                                <input type="email" class="form-control" id="email"
                                       placeholder="请输入电子邮箱">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">手机号码</label>
                                <input type="tel" class="form-control" id="phone"
                                       placeholder="请输入手机号码">
                            </div>

                            <div class="col-12">
                                <label class="form-label">角色</label>
                                <input type="text" class="form-control" id="roleDisplay" readonly
                                       value="<c:choose><c:when test='${isAdmin}'>管理员</c:when><c:otherwise>普通用户</c:otherwise></c:choose>"
                                       style="background-color: #f8fafc;">
                            </div>

                            <div class="col-12">
                                <hr>
                                <div class="d-flex gap-3 justify-content-end">
                                    <button type="button" class="btn btn-outline-custom" onclick="resetForm()">
                                        <i class="bi bi-arrow-repeat"></i> 重置
                                    </button>
                                    <button type="button" class="btn btn-primary-custom" onclick="updateProfile()">
                                        <i class="bi bi-save"></i> 保存修改
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 修改密码卡片 -->
            <div class="card mt-4">
                <div class="card-header">
                    <h4><i class="bi bi-shield-lock"></i> 修改密码</h4>
                </div>
                <div class="form-section">
                    <form id="passwordForm">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <label class="form-label required">新密码</label>
                                <input type="password" class="form-control" id="newPassword"
                                       placeholder="请输入新密码">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label required">确认密码</label>
                                <input type="password" class="form-control" id="confirmPassword"
                                       placeholder="请再次输入新密码">
                            </div>
                            <div class="col-12">
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-primary-custom" onclick="changePassword()">
                                        <i class="bi bi-key"></i> 修改密码
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var contextPath = '${pageContext.request.contextPath}';
    var isAdmin = ${isAdmin};

    // 页面加载时获取个人信息
    document.addEventListener('DOMContentLoaded', function() {
        loadUserProfile();
    });

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
                    // 显示个人信息
                    displayUserInfo(data.data);
                } else if (data.code === 401) {
                    Swal.fire({
                        icon: 'error',
                        title: '未登录',
                        text: '请先登录',
                        confirmButtonColor: '#f56565'
                    }).then(function() {
                        window.location.href = contextPath + '/login.jsp';
                    });
                } else {
                    showErrorMessage(data.msg || '获取个人信息失败');
                }
            })
            .catch(function(error) {
                console.error('请求失败:', error);
                showErrorMessage('网络错误，请稍后重试');
            });
    }

    /**
     * 显示用户信息
     */
    function displayUserInfo(userData) {
        // 更新左侧信息
        if (userData.email) {
            document.getElementById('infoEmail').innerText = userData.email;
            document.getElementById('email').value = userData.email;
        }
        if (userData.phone) {
            document.getElementById('infoPhone').innerText = userData.phone;
            document.getElementById('phone').value = userData.phone;
        }
        if (userData.createdAt) {
            document.getElementById('infoCreatedAt').innerText = formatDateTime(userData.createdAt);
        }
        if (userData.username) {
            document.getElementById('infoUsername').innerText = userData.username;
        }
    }

    /**
     * 更新个人信息
     */
    function updateProfile() {
        var email = document.getElementById('email').value.trim();
        var phone = document.getElementById('phone').value.trim();

        // 构建请求参数
        var bodyData = '';
        if (email) bodyData += 'email=' + encodeURIComponent(email);
        if (phone) {
            if (bodyData) bodyData += '&';
            bodyData += 'phone=' + encodeURIComponent(phone);
        }

        if (!bodyData) {
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
                        // 重新加载个人信息
                        loadUserProfile();
                    });
                } else {
                    showErrorMessage(data.msg || '修改失败');
                }
            })
            .catch(function(error) {
                console.error('请求失败:', error);
                showErrorMessage('网络错误，请稍后重试');
            });
    }

    /**
     * 修改密码
     */
    function changePassword() {
        var newPassword = document.getElementById('newPassword').value;
        var confirmPassword = document.getElementById('confirmPassword').value;

        // 验证
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
                        // 退出登录
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
        if (!dateTimeStr) return '-';
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
</script>
</body>
</html>