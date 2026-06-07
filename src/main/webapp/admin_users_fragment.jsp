<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    long currentUserId = currentUser != null ? currentUser.getId() : 0;
%>
<div class="mb-6">
    <h1 class="text-2xl font-bold text-gray-800">用户管理</h1>
    <p class="text-gray-600 mt-2">管理系统所有用户</p>
</div>

<div class="card shadow rounded-lg">
    <div class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
        <h3 class="font-semibold">用户列表</h3>
        <div class="text-sm text-gray-500">
            共 <span id="userCount" class="text-primary font-bold">0</span> 个用户
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>邮箱</th>
                        <th>手机号</th>
                        <th>角色</th>
                        <th>状态</th>
                        <th>注册时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="userTableBody">
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="bi bi-hourglass"></i> 加载中...
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    var contextPath = '<%= request.getContextPath() %>';
    var currentUserId = <%= currentUserId %>;

    function loadUsers() {
        fetch(contextPath + '/admin/users')
            .then(response => response.json())
            .then(data => {
                renderUsers(data);
                document.getElementById('userCount').textContent = data.length;
            })
            .catch(error => console.error('加载用户列表失败:', error));
    }

    function renderUsers(users) {
        var tbody = document.getElementById('userTableBody');
        if (!users || users.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted">暂无用户</td></tr>';
            return;
        }

        var html = '';
        users.forEach(function(user) {
            var role = user.role === 1 ? '<span class="badge bg-danger">管理员</span>' : '<span class="badge bg-secondary">普通用户</span>';
            var status = user.status === 1 ? '<span class="badge bg-success">正常</span>' : '<span class="badge bg-warning">已封禁</span>';
            var action = user.status === 1 
                ? '<button class="btn btn-sm btn-warning" onclick="banUser(' + user.id + ')">封禁</button>'
                : '<button class="btn btn-sm btn-success" onclick="unbanUser(' + user.id + ')">解封</button>';
            
            if (user.id === currentUserId) {
                action = '<span class="text-muted text-sm">当前用户</span>';
            }

            html += '<tr>';
            html += '<td>' + user.id + '</td>';
            html += '<td>' + user.username + '</td>';
            html += '<td>' + (user.email || '-') + '</td>';
            html += '<td>' + (user.phone || '-') + '</td>';
            html += '<td>' + role + '</td>';
            html += '<td>' + status + '</td>';
            html += '<td>' + formatDateTime(user.createdDate) + '</td>';
            html += '<td>' + action + '</td>';
            html += '</tr>';
        });
        tbody.innerHTML = html;
    }

    function formatDateTime(dateStr) {
        if (!dateStr) return '-';
        var date = new Date(dateStr);
        return date.toLocaleString('zh-CN');
    }

    function banUser(userId) {
        Swal.fire({
            title: '确认封禁',
            text: '封禁后该用户将无法登录系统',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '确认封禁',
            cancelButtonText: '取消'
        }).then(function(result) {
            if (result.isConfirmed) {
                fetch(contextPath + '/admin/ban', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'userId=' + userId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        Swal.fire('成功', data.msg, 'success');
                        loadUsers();
                    } else {
                        Swal.fire('失败', data.msg, 'error');
                    }
                });
            }
        });
    }

    function unbanUser(userId) {
        Swal.fire({
            title: '确认解封',
            text: '解封后该用户可以正常登录系统',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: '确认解封',
            cancelButtonText: '取消'
        }).then(function(result) {
            if (result.isConfirmed) {
                fetch(contextPath + '/admin/unban', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'userId=' + userId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 200) {
                        Swal.fire('成功', data.msg, 'success');
                        loadUsers();
                    } else {
                        Swal.fire('失败', data.msg, 'error');
                    }
                });
            }
        });
    }

    document.addEventListener('DOMContentLoaded', loadUsers);
</script>