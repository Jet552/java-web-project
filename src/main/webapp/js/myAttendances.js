/**
 * 我的参会记录页面 - 交互逻辑
 */
var currentPage = 1;
var pageSize = 20;
var currentData = [];

(function () {
    'use strict';
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadMyAttendances);
    } else {
        loadMyAttendances();
    }
})();

function loadMyAttendances() {
    showLoading(true);
    fetch(contextPath + '/attendee/myAttendances', {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            showLoading(false);
            if (data.code === 400 && data.data) {
                currentData = data.data;
                document.getElementById('cardHeaderRight').innerHTML = '共 <strong>' + currentData.length + '</strong> 条记录';
            } else {
                currentData = [];
                document.getElementById('cardHeaderRight').innerHTML = '共 <strong>0</strong> 条记录';
            }
            currentPage = 1;
            renderTablePage();
            renderPagination();
        })
        .catch(function () {
            showLoading(false);
            currentData = [];
            document.getElementById('cardHeaderRight').innerHTML = '共 <strong>0</strong> 条记录';
            renderTablePage();
        });
}

function renderTablePage() {
    var tbody = document.getElementById('meetingTableBody');
    if (currentData.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" class="text-center py-5 text-muted">'
            + '<i class="fas fa-inbox fa-2x d-block mb-2"></i>暂无参会记录</td></tr>';
        return;
    }
    var start = (currentPage - 1) * pageSize;
    var end = Math.min(start + pageSize, currentData.length);
    var pageData = currentData.slice(start, end);
    var html = '';
    for (var i = 0; i < pageData.length; i++) {
        var item = pageData[i];
        var rowNum = start + i + 1;
        var statusText = item.status == 1 ? '参加中' : '已取消';
        var statusClass = item.status == 1 ? 'status-ongoing' : 'status-ended';

        html += '<tr>';
        html += '<td class="text-muted small">' + rowNum + '</td>';
        html += '<td><span class="meeting-name" title="' + esc(item.title) + '">' + esc(item.title) + '</span></td>';
        html += '<td>' + esc((item.start_date || '').replace('T', ' ')) + '</td>';
        html += '<td>' + esc((item.end_date || '').replace('T', ' ')) + '</td>';
        html += '<td><i class="fas fa-map-marker-alt text-secondary me-1 small"></i>' + esc(item.venue) + '</td>';
        html += '<td>' + esc(item.dorms) + '</td>';
        html += '<td>' + esc(item.amount) + ' 元</td>';
        html += '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>';
        if (item.status == 1) {
            html += '<td><a href="' + contextPath + '/attendee/payment.jsp?id=' + item.attendanceId + '" class="btn btn-join btn-sm">';
            html += '<i class="fas fa-credit-card me-1"></i>缴费</a></td>';
        } else {
            html += '<td><span class="text-muted small">已取消</span></td>';
        }
        html += '</tr>';
    }
    tbody.innerHTML = html;
}

function renderPagination() {
    var container = document.getElementById('paginationContainer');
    var totalPages = Math.ceil(currentData.length / pageSize);
    if (totalPages <= 1) { container.innerHTML = ''; return; }
    var html = '<nav><ul class="pagination mb-0">';
    html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">'
        + '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage - 1) + ')">'
        + '<i class="fas fa-chevron-left small me-1"></i>上一页</a></li>';
    html += '<li class="page-item active"><span class="page-link">第 ' + currentPage + ' / ' + totalPages + ' 页</span></li>';
    html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">'
        + '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (currentPage + 1) + ')">'
        + '下一页<i class="fas fa-chevron-right small ms-1"></i></a></li>';
    html += '</ul></nav>';
    container.innerHTML = html;
}

function goToPage(page) {
    var totalPages = Math.ceil(currentData.length / pageSize);
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    renderTablePage();
    renderPagination();
}

function esc(str) {
    if (!str) return '';
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(str));
    return d.innerHTML;
}

function showLoading(show) {
    var overlay = document.getElementById('loadingOverlay');
    if (!overlay) {
        var d = document.createElement('div');
        d.id = 'loadingOverlay';
        d.className = 'loading-overlay';
        d.innerHTML = '<div class="spinner-border text-primary" style="width:3rem;height:3rem"></div>';
        document.body.appendChild(d);
        overlay = d;
    }
    overlay.style.display = show ? 'flex' : 'none';
}
