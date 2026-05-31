<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>支付查询</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>--%>

<%--    <link href="${pageContext.request.contextPath}/css/conferencePayment.css" rel="stylesheet"/>--%>
<%--</head>--%>
<body>
<div class="content-wrapper">
    <!-- 页面标题 -->
    <div class="page-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h3 class="mb-1"><i class="fas fa-credit-card me-2 text-primary"></i>我的缴费记录</h3>
                <p class="text-muted mb-0">查看所有会议的缴费明细和状态</p>
            </div>
            <div>
                <button class="btn btn-outline-primary btn-sm" onclick="refreshData()">
                    <i class="fas fa-sync-alt me-1"></i>刷新
                </button>
            </div>
        </div>
    </div>

    <!-- 统计卡片 -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stats-card total-card">
                <div class="stats-icon">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stats-info">
                    <h3 id="totalCount">0</h3>
                    <p>总缴费笔数</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card paid-card">
                <div class="stats-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stats-info">
                    <h3 id="paidCount">0</h3>
                    <p>已缴费</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card unpaid-card">
                <div class="stats-icon">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stats-info">
                    <h3 id="unpaidCount">0</h3>
                    <p>待缴费</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card amount-card">
                <div class="stats-icon">
                    <i class="fas fa-yen-sign"></i>
                </div>
                <div class="stats-info">
                    <h3 id="totalAmount">¥0</h3>
                    <p>累计缴费金额</p>
                </div>
            </div>
        </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-bar mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-md-3">
                <label class="form-label mb-1">缴费状态</label>
                <select class="form-select form-select-sm" id="filterStatus" onchange="filterPayments()">
                    <option value="all">全部</option>
                    <option value="paid">已缴费</option>
                    <option value="unpaid">待缴费</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label mb-1">会议名称</label>
                <input type="text" class="form-control form-control-sm" id="searchConference"
                       placeholder="输入会议名称" onkeyup="filterPayments()">
            </div>
            <div class="col-md-4">
                <label class="form-label mb-1">缴费时间</label>
                <div class="d-flex gap-2">
                    <input type="date" class="form-control form-control-sm" id="startDate" placeholder="开始日期">
                    <span class="align-self-center">至</span>
                    <input type="date" class="form-control form-control-sm" id="endDate" placeholder="结束日期">
                </div>
            </div>
            <div class="col-md-2">
                <label class="form-label mb-1">&nbsp;</label>
                <button class="btn btn-primary btn-sm w-100" onclick="filterPayments()">
                    <i class="fas fa-search me-1"></i>查询
                </button>
            </div>
        </div>
    </div>

    <!-- 缴费记录表格 -->
    <div class="content-card">
        <div class="card-header">
            <h5><i class="fas fa-list me-2"></i>缴费明细</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-payment">
                    <thead>
                    <tr>
                        <th>会议名称</th>
                        <th>会议时间</th>
                        <th>缴费金额</th>
                        <th>缴费时间</th>
                        <th>缴费状态</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="paymentTableBody">
                    <tr>
                        <td colspan="7" class="text-center py-5">
                            <div class="spinner-border text-primary" role="status"></div>
                            <p class="text-muted mt-2">加载中...</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 分页 -->
        <div class="card-footer bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-muted small" id="paginationInfo">共 0 条记录</div>
                <div class="pagination-box">
                    <button class="page-btn" onclick="changePage('prev')" id="prevBtn">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <span id="pageNumbers" class="mx-2"></span>
                    <button class="page-btn" onclick="changePage('next')" id="nextBtn">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>