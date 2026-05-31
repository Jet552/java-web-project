<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<body>
<div class="content-wrapper">
    <!-- 页面头部 -->
    <div class="page-header">
        <div class="header-bg"></div>
        <div class="header-content">
            <div>
                <h3 class="page-title">
                    <span class="title-icon"><i class="fas fa-credit-card"></i></span>
                    我的缴费记录
                </h3>
                <p class="page-subtitle">查看所有会议的缴费明细和状态</p>
            </div>
            <button class="btn-refresh" onclick="refreshData()">
                <i class="fas fa-sync-alt"></i>
                <span>刷新数据</span>
            </button>
        </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-row">
        <div class="stat-card total">
            <div class="stat-glow"></div>
            <div class="stat-inner">
                <div class="stat-icon-wrap">
                    <i class="fas fa-receipt"></i>
                </div>
                <div class="stat-text">
                    <h4 id="totalCount">0</h4>
                    <p>总缴费笔数</p>
                </div>
            </div>
            <div class="stat-decor"></div>
        </div>
        <div class="stat-card paid">
            <div class="stat-glow"></div>
            <div class="stat-inner">
                <div class="stat-icon-wrap">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-text">
                    <h4 id="paidCount">0</h4>
                    <p>已缴费</p>
                </div>
            </div>
            <div class="stat-decor"></div>
        </div>
        <div class="stat-card unpaid">
            <div class="stat-glow"></div>
            <div class="stat-inner">
                <div class="stat-icon-wrap">
                    <i class="fas fa-hourglass-half"></i>
                </div>
                <div class="stat-text">
                    <h4 id="unpaidCount">0</h4>
                    <p>待缴费</p>
                </div>
            </div>
            <div class="stat-decor"></div>
        </div>
        <div class="stat-card amount">
            <div class="stat-glow"></div>
            <div class="stat-inner">
                <div class="stat-icon-wrap">
                    <i class="fas fa-coins"></i>
                </div>
                <div class="stat-text">
                    <h4 id="totalAmount">0</h4>
                    <p>累计缴费金额</p>
                </div>
            </div>
            <div class="stat-decor"></div>
        </div>
    </div>

    <!-- 筛选栏 -->
    <div class="filter-panel">
        <div class="filter-grid">
            <div class="filter-item">
                <label>缴费状态</label>
                <div class="custom-select">
                    <select id="filterStatus" onchange="filterPayments()">
                        <option value="all">全部状态</option>
                        <option value="paid">已缴费</option>
                        <option value="unpaid">待缴费</option>
                    </select>
                    <i class="fas fa-chevron-down select-arrow"></i>
                </div>
            </div>
            <div class="filter-item">
                <label>会议名称</label>
                <div class="input-wrap">
                    <i class="fas fa-search input-icon"></i>
                    <input type="text" id="searchConference" placeholder="输入会议名称搜索" onkeyup="filterPayments()">
                </div>
            </div>
            <div class="filter-item date-range">
                <label>缴费时间</label>
                <div class="date-inputs">
                    <input type="date" id="startDate">
                    <span class="date-sep">至</span>
                    <input type="date" id="endDate">
                </div>
            </div>
            <div class="filter-item filter-action">
                <label>&nbsp;</label>
                <button class="btn-search" onclick="filterPayments()">
                    <i class="fas fa-filter"></i>筛选
                </button>
            </div>
        </div>
    </div>

    <!-- 缴费记录表格 -->
    <div class="data-card">
        <div class="card-head">
            <div class="card-title">
                <span class="title-dot"></span>
                <h5>缴费明细</h5>
            </div>
            <div class="card-badge" id="recordBadge">0 条记录</div>
        </div>
        <div class="card-body">
            <div class="table-wrap">
                <table class="data-table">
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
                        <td colspan="6" class="loading-cell">
                            <div class="loading-ring"></div>
                            <p>正在加载数据...</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-foot">
            <div class="pagination-wrap">
                <div class="page-info" id="paginationInfo">共 0 条记录</div>
                <div class="page-controls">
                    <button class="page-arrow" onclick="changePage('prev')" id="prevBtn">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <div class="page-numbers" id="pageNumbers"></div>
                    <button class="page-arrow" onclick="changePage('next')" id="nextBtn">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
