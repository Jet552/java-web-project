<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .stat-card {
        transition: transform 0.2s, box-shadow 0.2s;
        cursor: pointer;
    }
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.15);
    }
    .bg-purple { background-color: #9b59b6 !important; }
    .bg-teal { background-color: #1abc9c !important; }
    .bg-orange { background-color: #e67e22 !important; }
    .bg-indigo { background-color: #6610f2 !important; }
    .bg-cyan { background-color: #17a2b8 !important; }
    .bg-lime { background-color: #28a745 !important; }
    .bg-pink { background-color: #e83e8c !important; }
    .bg-gray { background-color: #6c757d !important; }
</style>

<div class="card">
    <div class="card-header">
        <h5><i class="bi bi-bar-chart me-2 text-primary"></i>系统统计</h5>
    </div>
    <div class="card-body">
        <div class="row g-4 mb-6">
            <div class="col-md-3">
                <div class="stat-card card bg-primary text-white p-4 rounded-lg" onclick="showDetail('conference', 'all')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">总会议数</p>
                            <p id="totalConferences" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-calendar text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-success text-white p-4 rounded-lg" onclick="showDetail('conference', 'pending')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">待审核</p>
                            <p id="pendingConferences" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-clock text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-info text-white p-4 rounded-lg" onclick="showDetail('conference', 'approved')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">已通过</p>
                            <p id="approvedConferences" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-check-circle text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-warning text-white p-4 rounded-lg" onclick="showDetail('conference', 'rejected')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">已拒绝</p>
                            <p id="rejectedConferences" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-x-circle text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-6">
            <div class="col-md-3">
                <div class="stat-card card bg-purple text-white p-4 rounded-lg" onclick="showDetail('user', 'all')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">总用户数</p>
                            <p id="totalUsers" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-users text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-teal text-white p-4 rounded-lg" onclick="showDetail('user', 'active')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">活跃用户</p>
                            <p id="activeUsers" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-user-check text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-orange text-white p-4 rounded-lg" onclick="showDetail('user', 'admin')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">管理员</p>
                            <p id="adminUsers" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-shield text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-danger text-white p-4 rounded-lg" onclick="showDetail('user', 'banned')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">被封禁</p>
                            <p id="bannedUsers" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-user-x text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-6">
            <div class="col-md-3">
                <div class="stat-card card bg-indigo text-white p-4 rounded-lg" onclick="showDetail('attendee')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">总参会人数</p>
                            <p id="totalAttendees" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-people text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-cyan text-white p-4 rounded-lg" onclick="showDetail('payment', 'paid')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">已缴费人数</p>
                            <p id="paidAttendees" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-credit-card text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-lime text-white p-4 rounded-lg" onclick="showDetail('payment', 'all')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">缴费笔数</p>
                            <p id="totalPayments" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-receipt text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card card bg-pink text-white p-4 rounded-lg" onclick="showDetail('payment', 'all')">
                    <div class="d-flex justify-content-between">
                        <div>
                            <p class="text-sm opacity-80">缴费总额</p>
                            <p id="totalAmount" class="text-3xl font-bold">--</p>
                        </div>
                        <i class="bi bi-wallet text-4xl opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h5 class="mb-3">会议状态统计</h5>
                <table class="table table-sm">
                    <tr><td class="text-muted">待审核</td><td class="text-right font-bold text-warning" id="pendingPercent">--%</td></tr>
                    <tr><td class="text-muted">已通过</td><td class="text-right font-bold text-success" id="approvedPercent">--%</td></tr>
                    <tr><td class="text-muted">已拒绝</td><td class="text-right font-bold text-danger" id="rejectedPercent">--%</td></tr>
                </table>
            </div>
            <div class="col-md-6">
                <h5 class="mb-3">用户状态统计</h5>
                <table class="table table-sm">
                    <tr><td class="text-muted">活跃用户</td><td class="text-right font-bold text-success" id="activePercent">--%</td></tr>
                    <tr><td class="text-muted">被封禁</td><td class="text-right font-bold text-danger" id="bannedPercent">--%</td></tr>
                    <tr><td class="text-muted">管理员</td><td class="text-right font-bold text-primary" id="adminPercent">--%</td></tr>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">详情列表</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="modalContent">加载中...</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script>
    var contextPath = '<%= request.getContextPath() %>';
    
    $(document).ready(function() {
        loadStats();
    });
    
    function loadStats() {
        $.get(contextPath + '/admin/stats', function(data) {
            $('#totalConferences').text(data.totalConferences || 0);
            $('#pendingConferences').text(data.pendingConferences || 0);
            $('#approvedConferences').text(data.approvedConferences || 0);
            $('#rejectedConferences').text(data.rejectedConferences || 0);
            $('#totalUsers').text(data.totalUsers || 0);
            $('#activeUsers').text(data.activeUsers || 0);
            $('#adminUsers').text(data.adminUsers || 0);
            $('#bannedUsers').text(data.bannedUsers || 0);
            $('#totalAttendees').text(data.totalAttendees || 0);
            $('#paidAttendees').text(data.paidAttendees || 0);
            $('#totalPayments').text(data.totalPayments || 0);
            $('#totalAmount').text('¥' + (data.totalAmount || 0).toFixed(2));
            
            var totalConf = data.totalConferences || 1;
            $('#pendingPercent').text(((data.pendingConferences || 0) / totalConf * 100).toFixed(1) + '%');
            $('#approvedPercent').text(((data.approvedConferences || 0) / totalConf * 100).toFixed(1) + '%');
            $('#rejectedPercent').text(((data.rejectedConferences || 0) / totalConf * 100).toFixed(1) + '%');
            
            var totalUsers = data.totalUsers || 1;
            $('#activePercent').text(((data.activeUsers || 0) / totalUsers * 100).toFixed(1) + '%');
            $('#bannedPercent').text(((data.bannedUsers || 0) / totalUsers * 100).toFixed(1) + '%');
            $('#adminPercent').text(((data.adminUsers || 0) / totalUsers * 100).toFixed(1) + '%');
        });
    }
    
    function showDetail(type, subType) {
        var title = '';
        var url = '';
        
        switch(type) {
            case 'conference':
                switch(subType) {
                    case 'all': title = '全部会议'; url = '/admin/conferences?status=all'; break;
                    case 'pending': title = '待审核会议'; url = '/admin/conferences?status=pending'; break;
                    case 'approved': title = '已通过会议'; url = '/admin/conferences?status=approved'; break;
                    case 'rejected': title = '已拒绝会议'; url = '/admin/conferences?status=rejected'; break;
                }
                break;
            case 'user':
                switch(subType) {
                    case 'all': title = '全部用户'; url = '/admin/users'; break;
                    case 'active': title = '活跃用户'; url = '/admin/users?status=1'; break;
                    case 'admin': title = '管理员'; url = '/admin/users?role=1'; break;
                    case 'banned': title = '被封禁用户'; url = '/admin/users?status=0'; break;
                }
                break;
            case 'attendee':
                title = '参会人员'; url = '/admin/attendees'; break;
            case 'payment':
                title = subType === 'paid' ? '已缴费记录' : '全部缴费记录';
                url = '/admin/payments' + (subType === 'paid' ? '?status=paid' : '');
                break;
        }
        
        $('#modalTitle').text(title);
        $('#modalContent').html('<div class="text-center py-5">加载中...</div>');
        
        $.get(contextPath + url, function(data) {
            renderDetail(type, data);
        });
        
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();
    }
    
    function renderDetail(type, data) {
        if (!data || data.length === 0) {
            $('#modalContent').html('<p class="text-center text-muted py-5">暂无数据</p>');
            return;
        }
        
        var html = '';
        if (type === 'conference') {
            html = '<table class="table table-striped"><thead><tr><th>ID</th><th>会议名称</th><th>地点</th><th>状态</th></tr></thead><tbody>';
            $.each(data, function(i, item) {
                var status = '';
                switch(item.status) {
                    case 'pending': status = '<span class="badge bg-warning">待审核</span>'; break;
                    case 'approved': status = '<span class="badge bg-success">已通过</span>'; break;
                    case 'rejected': status = '<span class="badge bg-danger">已拒绝</span>'; break;
                    default: status = item.status;
                }
                html += '<tr><td>' + item.id + '</td><td>' + item.title + '</td><td>' + (item.venue || '-') + '</td><td>' + status + '</td></tr>';
            });
            html += '</tbody></table>';
        } else if (type === 'user') {
            html = '<table class="table table-striped"><thead><tr><th>ID</th><th>用户名</th><th>邮箱</th><th>角色</th><th>状态</th></tr></thead><tbody>';
            $.each(data, function(i, item) {
                var role = item.role === 1 ? '<span class="badge bg-danger">管理员</span>' : '<span class="badge bg-secondary">普通用户</span>';
                var status = item.status === 1 ? '<span class="badge bg-success">正常</span>' : '<span class="badge bg-warning">封禁</span>';
                html += '<tr><td>' + item.id + '</td><td>' + item.username + '</td><td>' + (item.email || '-') + '</td><td>' + role + '</td><td>' + status + '</td></tr>';
            });
            html += '</tbody></table>';
        } else {
            html = '<table class="table table-striped"><thead><tr><th>ID</th><th>用户/参会ID</th><th>金额/会议ID</th><th>状态</th></tr></thead><tbody>';
            $.each(data, function(i, item) {
                var status = '';
                if (item.status === 1 || item.status === 'paid') {
                    status = '<span class="badge bg-success">正常</span>';
                } else {
                    status = '<span class="badge bg-warning">待处理</span>';
                }
                var col2 = item.user_id ? item.user_id : (item.attendee_id || '-');
                var col3 = item.amount ? '¥' + item.amount.toFixed(2) : (item.conference_id || '-');
                html += '<tr><td>' + item.id + '</td><td>' + col2 + '</td><td>' + col3 + '</td><td>' + status + '</td></tr>';
            });
            html += '</tbody></table>';
        }
        
        $('#modalContent').html(html);
    }
</script>