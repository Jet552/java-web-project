<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/myAttendances.css">

<div class="my-attendances-wrapper">
    <div class="content-card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="fas fa-clipboard-list text-primary me-2"></i>我的参会记录
            </h5>
            <span class="text-muted small" id="cardHeaderRight">
                加载中...
            </span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-attendance mb-0">
                    <thead>
                    <tr>
                        <th style="width: 40px;">#</th>
                        <th style="width: 200px;">会议名称</th>
                        <th style="width: 140px;">开始时间</th>
                        <th style="width: 140px;">结束时间</th>
                        <th style="width: 160px;">地点</th>
                        <th style="width: 140px;">住宿地址</th>
                        <th style="width: 80px;">费用</th>
                        <th style="width: 70px;">状态</th>
                        <th style="width: 90px;">操作</th>
                    </tr>
                    </thead>
                    <tbody id="meetingTableBody">
                        <tr>
                            <td colspan="9" class="text-center py-5 text-muted">
                                <i class="fas fa-spinner fa-pulse fa-2x d-block mb-2"></i>
                                加载中...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div id="paginationContainer"></div>
</div>

<script>
(function() {
    var s = document.createElement('script');
    s.src = contextPath + '/js/myAttendances.js';
    document.body.appendChild(s);
})();
</script>
