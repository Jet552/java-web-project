<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String status = request.getParameter("status");
    String defaultStatus = status != null && status.equals("all") ? "all" : "pending";
%>
<div class="card">
    <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
            <h5><i class="bi bi-calendar me-2 text-primary"></i>会议管理</h5>
            <ul class="nav nav-tabs card-header-tabs">
                <li class="nav-item">
                    <button class="nav-link <%= defaultStatus.equals("pending") ? "active" : "" %>" onclick="loadConferences('pending')">待审核</button>
                </li>
                <li class="nav-item">
                    <button class="nav-link <%= defaultStatus.equals("all") ? "active" : "" %>" onclick="loadConferences('all')">全部会议</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>会议名称</th>
                        <th>地点</th>
                        <th>开始时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="conferenceTableBody">
                    <tr><td colspan="6" class="text-center py-5 text-muted"><i class="bi bi-hourglass"></i> 加载中...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="reviewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">审核会议</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="conferenceId">
                <div class="mb-3">
                    <label class="form-label">会议名称</label>
                    <p class="form-control-plaintext" id="modalTitleText"></p>
                </div>
                <div class="mb-3">
                    <label class="form-label">审核意见</label>
                    <textarea class="form-control" id="reviewReason" rows="3" placeholder="请输入审核意见..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-success" onclick="submitReview('approve')">通过</button>
                <button type="button" class="btn btn-danger" onclick="submitReview('reject')">拒绝</button>
            </div>
        </div>
    </div>
</div>

<script>
    var contextPath = '<%= request.getContextPath() %>';
    var currentMode = '<%= defaultStatus %>';
    
    $(document).ready(function() {
        loadConferences(currentMode);
    });
    
    function loadConferences(mode) {
        currentMode = mode;
        var url = mode === 'all' ? contextPath + '/admin/conferences' : contextPath + '/admin/pending';
        $.get(url, function(data) {
            renderConferences(data);
        });
    }
    
    function renderConferences(data) {
        var tbody = $('#conferenceTableBody');
        if (!data || data.length === 0) {
            tbody.html('<tr><td colspan="6" class="text-center py-5 text-muted">暂无会议</td></tr>');
            return;
        }
        
        var html = '';
        $.each(data, function(i, conf) {
            var status = '';
            switch(conf.status) {
                case 'pending': status = '<span class="badge bg-warning">待审核</span>'; break;
                case 'approved': status = '<span class="badge bg-success">已通过</span>'; break;
                case 'rejected': status = '<span class="badge bg-danger">已拒绝</span>'; break;
                default: status = '<span class="badge bg-secondary">' + conf.status + '</span>';
            }
            
            var action = conf.status === 'pending' 
                ? '<button class="btn btn-sm btn-primary" onclick="showReviewModal(' + conf.id + ', \'' + escapeHtml(conf.title) + '\')">审核</button>'
                : '<span class="text-muted text-sm">-</span>';
            
            html += '<tr>';
            html += '<td>' + conf.id + '</td>';
            html += '<td>' + escapeHtml(conf.title) + '</td>';
            html += '<td>' + escapeHtml(conf.venue || '-') + '</td>';
            html += '<td>' + formatDateTime(conf.start_date) + '</td>';
            html += '<td>' + status + '</td>';
            html += '<td>' + action + '</td>';
            html += '</tr>';
        });
        tbody.html(html);
    }
    
    function showReviewModal(id, title) {
        $('#conferenceId').val(id);
        $('#modalTitleText').text(title);
        $('#reviewReason').val('');
        var modal = new bootstrap.Modal(document.getElementById('reviewModal'));
        modal.show();
    }
    
    function submitReview(action) {
        var id = $('#conferenceId').val();
        var reason = $('#reviewReason').val();
        $.post(contextPath + '/admin/' + action, {conferenceId: id, reason: reason}, function(data) {
            if (data.code === 200) {
                Swal.fire('成功', data.msg, 'success');
                var modal = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
                modal.hide();
                loadConferences(currentMode);
            } else {
                Swal.fire('失败', data.msg, 'error');
            }
        });
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
</script>