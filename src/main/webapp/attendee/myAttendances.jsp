<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的参会记录 - 会务管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meetingSearch.css">
</head>
<body>
<div class="meeting-search-wrapper">
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
                <table class="table table-meeting mb-0">
                    <thead>
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th style="min-width: 200px;">会议名称</th>
                            <th style="width: 150px;">开始时间</th>
                            <th style="width: 150px;">结束时间</th>
                            <th style="min-width: 150px;">地点</th>
                            <th style="min-width: 130px;">住宿地址</th>
                            <th style="width: 90px;">报名费用</th>
                            <th style="width: 80px;">状态</th>
                            <th style="width: 120px;">操作</th>
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
var contextPath = '<%= request.getContextPath() %>';
</script>
<script>
(function() {
    var s = document.createElement('script');
    s.src = contextPath + '/js/myAttendances.js';
    document.body.appendChild(s);
})();
</script>
</body>
</html>
