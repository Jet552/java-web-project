<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/myAttendances.css?v=4">

<div class="my-attendances-wrapper">
    <!-- 筛选栏 -->
    <div class="filter-bar">
        <div class="filter-row">
            <div class="filter-item">
                <label>参会状态</label>
                <div class="filter-select-wrap">
                    <select id="filterStatus" >
                        <option value="all">全部状态</option>
                        <option value="1">参加中</option>
                        <option value="0">已取消</option>
                    </select>
                    <i class="fas fa-chevron-down filter-select-arrow"></i>
                </div>
            </div>
            <div class="filter-item">
                <label>会议名称</label>
                <div class="filter-input-wrap">
                    <i class="fas fa-search filter-input-icon"></i>
                    <input type="text" id="filterName" placeholder="输入会议名称搜索" >
                </div>
            </div>
            <div class="filter-item">
                <label>会议时间范围</label>
                <div class="filter-date-row">
                    <input type="date" id="filterStartDate" >
                    <span class="filter-date-sep">至</span>
                    <input type="date" id="filterEndDate" >
                </div>
            </div>
            <div class="filter-item">
                <label>&nbsp;</label>
                <div class="filter-actions">
                    <button class="btn-filter-apply" onclick="attApplyFilter()">
                        <i class="fas fa-filter"></i> 筛选
                    </button>
                    <button class="btn-filter-reset" onclick="attResetFilter()">
                        <i class="fas fa-redo-alt"></i> 重置
                    </button>
                </div>
            </div>
        </div>
    </div>

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
                        <th style="width: 65px;">身份</th>
                        <th style="width: 70px;">状态</th>
                        <th style="width: 90px;">操作</th>
                    </tr>
                    </thead>
                    <tbody id="meetingTableBody">
                        <tr>
                            <td colspan="10" class="text-center py-5 text-muted">
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

