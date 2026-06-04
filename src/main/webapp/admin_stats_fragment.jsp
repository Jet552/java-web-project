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
    .stat-card:hover .card-icon {
        transform: scale(1.1);
    }
    .card-icon {
        transition: transform 0.2s;
    }
    .view-detail {
        font-size: 12px;
        opacity: 0;
        transition: opacity 0.2s;
    }
    .stat-card:hover .view-detail {
        opacity: 1;
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

<div class="mb-6">
    <h1 class="text-2xl font-bold text-gray-800">系统统计</h1>
    <p class="text-gray-600 mt-2">查看系统运营数据统计，点击卡片可查看详细信息</p>
</div>

<div class="row mb-6">
    <div class="col-md-3">
        <div class="stat-card card bg-primary text-white p-4 rounded-lg shadow" onclick="showConferenceDetail('all')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">总会议数</p>
                    <p id="totalConferences" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-calendar text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-success text-white p-4 rounded-lg shadow" onclick="showConferenceDetail('pending')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">待审核会议</p>
                    <p id="pendingConferences" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-clock text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-info text-white p-4 rounded-lg shadow" onclick="showConferenceDetail('approved')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">通过会议</p>
                    <p id="approvedConferences" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-check-circle text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-warning text-white p-4 rounded-lg shadow" onclick="showConferenceDetail('rejected')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">拒绝会议</p>
                    <p id="rejectedConferences" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-x-circle text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-gray text-white p-4 rounded-lg shadow" onclick="showConferenceDetail('invalid')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">已过期会议</p>
                    <p id="invalidConferences" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-calendar-x text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="row mb-6">
    <div class="col-md-3">
        <div class="stat-card card bg-purple text-white p-4 rounded-lg shadow" onclick="showUserDetail('all')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">总用户数</p>
                    <p id="totalUsers" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-users text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-teal text-white p-4 rounded-lg shadow" onclick="showUserDetail('active')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">活跃用户</p>
                    <p id="activeUsers" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-user-check text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-orange text-white p-4 rounded-lg shadow" onclick="showUserDetail('admin')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">管理员</p>
                    <p id="adminUsers" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-shield text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-danger text-white p-4 rounded-lg shadow" onclick="showUserDetail('banned')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">被封禁</p>
                    <p id="bannedUsers" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-user-x text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="row mb-6">
    <div class="col-md-3">
        <div class="stat-card card bg-indigo text-white p-4 rounded-lg shadow" onclick="showAttendeeDetail()">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">总参会人数</p>
                    <p id="totalAttendees" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-people text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-cyan text-white p-4 rounded-lg shadow" onclick="showPaymentDetail('paid')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">已缴费人数</p>
                    <p id="paidAttendees" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-credit-card text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-lime text-white p-4 rounded-lg shadow" onclick="showPaymentDetail('all')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">缴费笔数</p>
                    <p id="totalPayments" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-receipt text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card card bg-pink text-white p-4 rounded-lg shadow" onclick="showPaymentDetail('all')">
            <div class="d-flex justify-content-between">
                <div>
                    <p class="text-sm opacity-80">缴费总额</p>
                    <p id="totalAmount" class="text-3xl font-bold">--</p>
                    <p class="view-detail mt-2"><i class="bi bi-arrow-right"></i> 查看详情</p>
                </div>
                <i class="card-icon bi bi-wallet text-4xl opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="card shadow rounded-lg">
    <div class="card-header bg-white border-0">
        <h3 class="font-semibold">详细统计</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <h5 class="mb-3">会议状态统计</h5>
                <table class="table table-sm">
                    <tr>
                        <td class="text-muted">待审核</td>
                        <td class="text-right font-bold text-warning" id="pendingPercent">--%</td>
                    </tr>
                    <tr>
                        <td class="text-muted">已通过</td>
                        <td class="text-right font-bold text-success" id="approvedPercent">--%</td>
                    </tr>
                    <tr>
                        <td class="text-muted">已拒绝</td>
                        <td class="text-right font-bold text-danger" id="rejectedPercent">--%</td>
                    </tr>
                </table>
            </div>
            <div class="col-md-6">
                <h5 class="mb-3">用户状态统计</h5>
                <table class="table table-sm">
                    <tr>
                        <td class="text-muted">活跃用户</td>
                        <td class="text-right font-bold text-success" id="activePercent">--%</td>
                    </tr>
                    <tr>
                        <td class="text-muted">被封禁</td>
                        <td class="text-right font-bold text-danger" id="bannedPercent">--%</td>
                    </tr>
                    <tr>
                        <td class="text-muted">管理员</td>
                        <td class="text-right font-bold text-primary" id="adminPercent">--%</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="detailModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">详情列表</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="table-responsive" id="modalContent">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>加载中...</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center text-muted">正在加载数据...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script>
    var contextPath = '<%= request.getContextPath() %>';

    function loadStats() {
        fetch(contextPath + '/admin/stats')
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalConferences').textContent = data.totalConferences || 0;
                document.getElementById('pendingConferences').textContent = data.pendingConferences || 0;
                document.getElementById('approvedConferences').textContent = data.approvedConferences || 0;
                document.getElementById('rejectedConferences').textContent = data.rejectedConferences || 0;
                document.getElementById('invalidConferences').textContent = data.invalidConferences || 0;

                document.getElementById('totalUsers').textContent = data.totalUsers || 0;
                document.getElementById('activeUsers').textContent = data.activeUsers || 0;
                document.getElementById('adminUsers').textContent = data.adminUsers || 0;
                document.getElementById('bannedUsers').textContent = data.bannedUsers || 0;

                document.getElementById('totalAttendees').textContent = data.totalAttendees || 0;
                document.getElementById('paidAttendees').textContent = data.paidAttendees || 0;
                document.getElementById('totalPayments').textContent = data.totalPayments || 0;
                document.getElementById('totalAmount').textContent = '¥' + (data.totalAmount || 0).toFixed(2);

                var totalConf = data.totalConferences || 1;
                document.getElementById('pendingPercent').textContent = ((data.pendingConferences || 0) / totalConf * 100).toFixed(1) + '%';
                document.getElementById('approvedPercent').textContent = ((data.approvedConferences || 0) / totalConf * 100).toFixed(1) + '%';
                document.getElementById('rejectedPercent').textContent = ((data.rejectedConferences || 0) / totalConf * 100).toFixed(1) + '%';

                var totalUsers = data.totalUsers || 1;
                document.getElementById('activePercent').textContent = ((data.activeUsers || 0) / totalUsers * 100).toFixed(1) + '%';
                document.getElementById('bannedPercent').textContent = ((data.bannedUsers || 0) / totalUsers * 100).toFixed(1) + '%';
                document.getElementById('adminPercent').textContent = ((data.adminUsers || 0) / totalUsers * 100).toFixed(1) + '%';
            })
            .catch(error => console.error('加载统计数据失败:', error));
    }

    function showConferenceDetail(status) {
        var title = '';
        switch(status) {
            case 'all': title = '全部会议'; break;
            case 'pending': title = '待审核会议'; break;
            case 'approved': title = '已通过会议'; break;
            case 'rejected': title = '已拒绝会议'; break;
            case 'invalid': title = '已过期会议'; break;
        }
        document.getElementById('modalTitle').textContent = title;
        
        fetch(contextPath + '/admin/conferences?status=' + status)
            .then(response => response.json())
            .then(data => renderConferenceTable(data))
            .catch(error => console.error('加载会议数据失败:', error));
        
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();
    }

    function showUserDetail(type) {
        var title = '';
        switch(type) {
            case 'all': title = '全部用户'; break;
            case 'active': title = '活跃用户'; break;
            case 'admin': title = '管理员列表'; break;
            case 'banned': title = '被封禁用户'; break;
        }
        document.getElementById('modalTitle').textContent = title;
        
        var url = contextPath + '/admin/users';
        if (type === 'admin') {
            url += '?role=1';
        } else if (type === 'banned') {
            url += '?status=0';
        }
        
        fetch(url)
            .then(response => response.json())
            .then(data => renderUserTable(data))
            .catch(error => console.error('加载用户数据失败:', error));
        
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();
    }

    function showAttendeeDetail() {
        document.getElementById('modalTitle').textContent = '参会人员列表';
        
        fetch(contextPath + '/admin/attendees')
            .then(response => response.json())
            .then(data => renderAttendeeTable(data))
            .catch(error => console.error('加载参会数据失败:', error));
        
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();
    }

    function showPaymentDetail(type) {
        document.getElementById('modalTitle').textContent = type === 'paid' ? '已缴费记录' : '全部缴费记录';
        
        var url = contextPath + '/admin/payments';
        if (type === 'paid') {
            url += '?status=paid';
        }
        
        fetch(url)
            .then(response => response.json())
            .then(data => renderPaymentTable(data))
            .catch(error => console.error('加载缴费数据失败:', error));
        
        var modal = new bootstrap.Modal(document.getElementById('detailModal'));
        modal.show();
    }

    function renderConferenceTable(data) {
        if (!data || data.length === 0) {
            document.getElementById('modalContent').innerHTML = '<p class="text-center text-muted py-5">暂无数据</p>';
            return;
        }
        
        var html = '<table class="table table-striped"><thead><tr><th>ID</th><th>会议名称</th><th>地点</th><th>开始时间</th><th>状态</th></tr></thead><tbody>';
        data.forEach(function(conf) {
            var status = '';
            switch(conf.status) {
                case 'pending': status = '<span class="badge bg-warning">待审核</span>'; break;
                case 'approved': status = '<span class="badge bg-success">已通过</span>'; break;
                case 'rejected': status = '<span class="badge bg-danger">已拒绝</span>'; break;
                case 'invalid': status = '<span class="badge bg-secondary">已过期</span>'; break;
                default: status = conf.status;
            }
            html += '<tr><td>' + conf.id + '</td><td>' + escapeHtml(conf.title) + '</td><td>' + escapeHtml(conf.venue || '-') + '</td><td>' + formatDateTime(conf.start_date) + '</td><td>' + status + '</td></tr>';
        });
        html += '</tbody></table>';
        document.getElementById('modalContent').innerHTML = html;
    }

    function renderUserTable(data) {
        if (!data || data.length === 0) {
            document.getElementById('modalContent').innerHTML = '<p class="text-center text-muted py-5">暂无数据</p>';
            return;
        }
        
        var html = '<table class="table table-striped"><thead><tr><th>ID</th><th>用户名</th><th>邮箱</th><th>手机号</th><th>角色</th><th>状态</th></tr></thead><tbody>';
        data.forEach(function(user) {
            var role = user.role === 1 ? '<span class="badge bg-primary">管理员</span>' : '<span class="badge bg-secondary">普通用户</span>';
            var status = user.status === 1 ? '<span class="badge bg-success">正常</span>' : '<span class="badge bg-danger">封禁</span>';
            html += '<tr><td>' + user.id + '</td><td>' + escapeHtml(user.username) + '</td><td>' + escapeHtml(user.email || '-') + '</td><td>' + escapeHtml(user.phone || '-') + '</td><td>' + role + '</td><td>' + status + '</td></tr>';
        });
        html += '</tbody></table>';
        document.getElementById('modalContent').innerHTML = html;
    }

    function renderAttendeeTable(data) {
        if (!data || data.length === 0) {
            document.getElementById('modalContent').innerHTML = '<p class="text-center text-muted py-5">暂无数据</p>';
            return;
        }
        
        var html = '<table class="table table-striped"><thead><tr><th>ID</th><th>用户ID</th><th>会议ID</th><th>入住类型</th><th>到达时间</th><th>状态</th></tr></thead><tbody>';
        data.forEach(function(attendee) {
            var status = attendee.status === 1 ? '<span class="badge bg-success">正常</span>' : '<span class="badge bg-danger">取消</span>';
            html += '<tr><td>' + attendee.id + '</td><td>' + attendee.user_id + '</td><td>' + attendee.conference_id + '</td><td>' + escapeHtml(attendee.accommodation_type || '-') + '</td><td>' + formatDateTime(attendee.arrival_time) + '</td><td>' + status + '</td></tr>';
        });
        html += '</tbody></table>';
        document.getElementById('modalContent').innerHTML = html;
    }

    function renderPaymentTable(data) {
        if (!data || data.length === 0) {
            document.getElementById('modalContent').innerHTML = '<p class="text-center text-muted py-5">暂无数据</p>';
            return;
        }
        
        var html = '<table class="table table-striped"><thead><tr><th>ID</th><th>参会ID</th><th>金额</th><th>状态</th><th>缴费时间</th></tr></thead><tbody>';
        data.forEach(function(payment) {
            var status = payment.status === 'paid' ? '<span class="badge bg-success">已缴费</span>' : '<span class="badge bg-warning">未缴费</span>';
            html += '<tr><td>' + payment.id + '</td><td>' + payment.attendee_id + '</td><td>¥' + payment.amount.toFixed(2) + '</td><td>' + status + '</td><td>' + formatDateTime(payment.paid_at) + '</td></tr>';
        });
        html += '</tbody></table>';
        document.getElementById('modalContent').innerHTML = html;
    }

    function formatDateTime(dateStr) {
        if (!dateStr) return '-';
        var date = new Date(dateStr);
        return date.toLocaleString('zh-CN');
    }

    function escapeHtml(str) {
        if (!str) return '';
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    document.addEventListener('DOMContentLoaded', loadStats);
</script>