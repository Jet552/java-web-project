<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/meetingSearch.css">
</head>
<body>
<div class="meeting-search-wrapper">
    <div class="search-section">
        <div class="search-form">
            <div class="input-group search-input-group">
                <span class="input-group-text search-icon">
                    <i class="fas fa-search"></i>
                </span>
                <input
                    type="text"
                    id="searchKeyword"
                    name="keyword"
                    class="form-control search-field"
                    placeholder="请输入会议名称或关键词\邀请码..."
                    value=""
                    autocomplete="off"
                />
                <button class="btn btn-search" type="button" onclick="doSearch()">
                    <i class="fas fa-search me-1"></i>搜索
                </button>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="fas fa-list-alt text-primary me-2"></i>会议列表
            </h5>
            <span class="text-muted small" id="cardHeaderRight">
                请输入关键词搜索会议
            </span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-meeting mb-0">
                    <thead>
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th style="width: 50px;">会议ID</th>
                            <th style="min-width: 200px;">会议名称</th>
                            <th style="width: 180px;">开始时间</th>
                            <th style="width: 180px;">结束时间</th>
                            <th style="min-width: 180px;">地点</th>
                            <th style="min-width: 180px;">住宿地址</th>
                            <th style="width: 50px;">报名费用</th>
                            <th style="width: 160px;">操作</th>
                        </tr>
                    </thead>
                    <tbody id="meetingTableBody">
                        <tr>
                            <td colspan="8" class="text-center py-5 text-muted">
                                <i class="fas fa-search fa-2x d-block mb-2"></i>
                                请输入关键词搜索会议
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
    // 动态获取 contextPath（必须留在 JSP 中）
    var contextPath = '<%= request.getContextPath() %>';
</script>
<!-- 引入注册页面的 JS 文件 -->
<%--<script src="${pageContext.request.contextPath}/js/meetingSearch.js"></script>--%>
</body>