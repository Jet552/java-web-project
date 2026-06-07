<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    long currentUserId = currentUser != null ? currentUser.getId() : 0;
%>
<div class="card">
    <div class="card-header">
        <h5><i class="bi bi-users me-2 text-primary"></i>用户管理</h5>
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
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="userTableBody">
                    <tr><td colspan="7" class="text-center py-5 text-muted"><i class="bi bi-hourglass"></i> 加载中...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    var contextPath = '<%= request.getContextPath() %>';
    var currentUserId = <%= currentUserId %>;
    
    $(document).ready(function() {
        loadUsers();
    });
    
    function loadUsers() {
        $.get(contextPath + '/admin/users', function(data) {
            renderUsers(data);
        });
    }
    
    function renderUsers(data) {
        var tbody = $('#userTableBody');
        if (!data || data.length === 0) {
            tbody.html('<tr><td colspan="7" class="text-center py-5 text-muted">暂无用户</td></tr>');
            return;
        }
        
        var html = '';
        $.each(data, function(i, user) {
            var role = user.role === 1 ? '<span class="badge bg-danger">管理员</span>' : '<span class="badge bg-secondary">普通用户</span>';
            var status = user.status === 1 ? '<span class="badge bg-success">正常</span>' : '<span class="badge bg-warning">已封禁</span>';
            var action = '';
            
            if (user.id === currentUserId) {
                action = '<span class="text-muted text-sm">当前用户</span>';
            } else if (user.role === 1) {
                action = '<span class="text-muted text-sm">管理员</span>';
            } else if (user.status === 1) {
                action = '<button class="btn btn-sm btn-warning" onclick="banUser(' + user.id + ')">封禁</button>';
            } else {
                action = '<button class="btn btn-sm btn-success" onclick="unbanUser(' + user.id + ')">解封</button>';
            }
            
            html += '<tr>';
            html += '<td>' + user.id + '</td>';
            html += '<td>' + user.username + '</td>';
            html += '<td>' + (user.email || '-') + '</td>';
            html += '<td>' + (user.phone || '-') + '</td>';
            html += '<td>' + role + '</td>';
            html += '<td>' + status + '</td>';
            html += '<td>' + action + '</td>';
            html += '</tr>';
        });
        tbody.html(html);
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
                $.post(contextPath + '/admin/ban', {userId: userId}, function(data) {
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
                $.post(contextPath + '/admin/unban', {userId: userId}, function(data) {
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
</script>