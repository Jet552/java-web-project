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

    <link href="${pageContext.request.contextPath}/css/profile.css" rel="stylesheet"/>
</head>
<body>

<c:set var="user" value="${sessionScope.user}" scope="page" />
<c:set var="username" value="${pageScope.user.username}" scope="page" />
<c:set var="role" value="${pageScope.user.role}" scope="page" />
<c:set var="isAdmin" value="${role == 1}" scope="page" />

<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="${isAdmin ? 'index1.jsp' : 'index2.jsp'}">
            <i class="bi bi-calendar-event"></i>
            会务管理系统
        </a>

        <div class="dropdown">
            <button class="btn btn-link text-white dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                <div class="user-avatar">${fn:substring(username, 0, 1)}</div>
                <span>${username}</span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="${isAdmin ? 'index1.jsp' : 'index2.jsp'}"><i class="bi bi-house"></i> 返回首页</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- 主内容区 -->
<div class="main-container">
    <div class="row-flex">

        <div class="left-fixed">
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
                        <div class="info-label"><i class="bi bi-hash me-2"></i>用户ID</div>
                        <div class="info-value" id="infoId">-</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-person me-2"></i>用户名</div>
                        <div class="info-value" id="infoUsername">${username}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label"><i class="bi bi-lock me-2"></i>密码</div>
                        <div class="info-value" id="infoPassword">******</div>
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
                        <div class="info-value" id="infoCreatedDate">-</div>
                    </div>

                    <div class="mt-4 pt-2"></div>
                </div>
            </div>
        </div>

        <div class="right-scrollable">

            <!-- 第二个卡片：编辑个人信息 -->
            <div class="card slide-card">
                <div class="card-header">
                    <h4><i class="bi bi-pencil-square"></i> 编辑个人信息</h4>
                </div>
                <div class="form-section">
                    <form id="profileForm">
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label required">用户名</label>
                                <input type="text" class="form-control" id="username" readonly
                                       value="${username}">
                                <div class="form-text text-muted">用户名不可修改</div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">电子邮箱</label>
                                <input type="email" class="form-control" id="email"
                                       placeholder="请输入电子邮箱">
                            </div>

                            <div class="col-12">
                                <label class="form-label">手机号码</label>
                                <input type="tel" class="form-control" id="phone"
                                       placeholder="请输入手机号码">
                            </div>

                            <div class="col-12">
                                <label class="form-label">角色</label>
                                <input type="text" class="form-control" id="roleDisplay" readonly
                                       value="<c:choose><c:when test='${isAdmin}'>管理员</c:when><c:otherwise>普通用户</c:otherwise></c:choose>">
                            </div>

                            <div class="col-12">
                                <hr>
                                <div class="d-flex gap-3 justify-content-end">
                                    <button type="button" class="btn btn-primary-custom" onclick="updateProfile()">
                                        <i class="bi bi-save"></i> 保存修改
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 第三个卡片：修改密码 -->
            <div class="card mt-4 slide-card">
                <div class="card-header">
                    <h4><i class="bi bi-shield-lock"></i> 修改密码</h4>
                </div>
                <div class="form-section">
                    <form id="passwordForm">
                        <div class="row g-4">
                            <div class="col-12">
                                <label class="form-label required">新密码</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="newPassword"
                                           placeholder="请输入新密码（至少6位）">
                                    <span class="password-toggle" onclick="togglePassword('newPassword')">
                                        <i class="bi bi-eye-slash" id="newPasswordIcon"></i>
                                    </span>
                                </div>
                                <div class="form-text text-muted">
                                    <i class="bi bi-info-circle"></i> 密码长度至少6位，建议包含字母和数字
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label required">确认密码</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="confirmPassword"
                                           placeholder="请再次输入新密码">
                                    <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="bi bi-eye-slash" id="confirmPasswordIcon"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="col-12" id="passwordStrength">
                                <div class="progress">
                                    <div class="progress-bar" id="strengthBar" role="progressbar"></div>
                                </div>
                                <small class="text-muted" id="strengthText">密码强度：弱</small>
                            </div>

                            <div class="col-12">
                                <hr>
                                <div class="d-flex justify-content-end">
                                    <button type="button" class="btn btn-outline-custom" onclick="resetForm()">
                                        <i class="bi bi-arrow-repeat"></i> 重置
                                    </button>
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
    // 动态获取 contextPath（必须留在JSP中）
    var contextPath = '<%= request.getContextPath() %>';
</script>
<!-- 引入纯静态 JS 文件 -->
<script src="${pageContext.request.contextPath}/js/profile.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>