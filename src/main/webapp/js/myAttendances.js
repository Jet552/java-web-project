/**
 * 我的参会记录页面 - 交互逻辑
 */
var attCurrentPage = 1;
var attPageSize = 20;
var attData = [];

(function () {
    'use strict';
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadMyAttendances);
    } else {
        loadMyAttendances();
    }
})();

function loadMyAttendances() {
    attShowLoading(true);
    fetch(contextPath + '/attendee/myList', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            attShowLoading(false);
            if (data.code === 200 && data.data) {
                attData = data.data;
                document.getElementById('cardHeaderRight').innerHTML = '共 <strong>' + attData.length + '</strong> 条记录';
            } else {
                attData = [];
                document.getElementById('cardHeaderRight').innerHTML = '共 <strong>0</strong> 条记录';
            }
            attCurrentPage = 1;
            attRenderPage();
            attRenderPagination();
        })
        .catch(function () {
            attShowLoading(false);
            attData = [];
            var el = document.getElementById('cardHeaderRight');
            if (el) el.innerHTML = '共 <strong>0</strong> 条记录';
            attRenderPage();
        });
}

function attRenderPage() {
    var tbody = document.getElementById('meetingTableBody');
    if (!tbody) return;
    if (attData.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" class="text-center py-5 text-muted">'
            + '<i class="fas fa-inbox fa-2x d-block mb-2"></i>暂无参会记录</td></tr>';
        return;
    }
    var start = (attCurrentPage - 1) * attPageSize;
    var end = Math.min(start + attPageSize, attData.length);
    var pageData = attData.slice(start, end);
    var html = '';
    for (var i = 0; i < pageData.length; i++) {
        var item = pageData[i];
        var rowNum = start + i + 1;
        var statusText = item.atten_status == 1 ? '参加中' : '已取消';
        var statusClass = item.atten_status == 1 ? 'status-ongoing' : 'status-ended';
        html += '<tr>';
        html += '<td class="text-muted small">' + rowNum + '</td>';
        html += '<td><span class="meeting-name" title="' + attEsc(item.title) + '">' + attEsc(item.title) + '</span></td>';
        html += '<td>' + attEsc((item.start_date || '').replace('T', ' ')) + '</td>';
        html += '<td>' + attEsc((item.end_date || '').replace('T', ' ')) + '</td>';
        html += '<td><i class="fas fa-map-marker-alt text-secondary me-1 small"></i>' + attEsc(item.venue) + '</td>';
        html += '<td>' + attEsc(item.dorms) + '</td>';
        html += '<td>' + attEsc(item.amount) + ' 元</td>';
        html += '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>';
        if (item.atten_status == 1) {
            html += '<td><a href="' + contextPath + '/attendee/join_meeting.jsp?id=' + item.id + '&title=' + item.title + '&invite_codes=' + item.invite_codes + '" class="btn btn-my-action btn-sm">';
            html += '<i class="fas fa-credit-card me-1"></i>完善报名</a></td>';
        } else {
            html += '<td><span class="text-muted small">无法操作</span></td>';
        }
        html += '</tr>';
    }
    tbody.innerHTML = html;
}

function attRenderPagination() {
    var container = document.getElementById('paginationContainer');
    var totalPages = Math.ceil(attData.length / attPageSize);
    if (totalPages <= 1) { container.innerHTML = ''; return; }
    var html = '<nav><ul class="pagination mb-0">';
    html += '<li class="page-item ' + (attCurrentPage === 1 ? 'disabled' : '') + '">'
        + '<a class="page-link" href="javascript:void(0)" onclick="attGoToPage(' + (attCurrentPage - 1) + ')">'
        + '<i class="fas fa-chevron-left small me-1"></i>上一页</a></li>';
    html += '<li class="page-item active"><span class="page-link">第 ' + attCurrentPage + ' / ' + totalPages + ' 页</span></li>';
    html += '<li class="page-item ' + (attCurrentPage === totalPages ? 'disabled' : '') + '">'
        + '<a class="page-link" href="javascript:void(0)" onclick="attGoToPage(' + (attCurrentPage + 1) + ')">'
        + '下一页<i class="fas fa-chevron-right small ms-1"></i></a></li>';
    html += '</ul></nav>';
    container.innerHTML = html;
}

function attGoToPage(page) {
    var totalPages = Math.ceil(attData.length / attPageSize);
    if (page < 1 || page > totalPages) return;
    attCurrentPage = page;
    attRenderPage();
    attRenderPagination();
}

function attEsc(str) {
    if (!str) return '';
    var d = document.createElement('div');
    d.appendChild(document.createTextNode(str));
    return d.innerHTML;
}

function attShowLoading(show) {
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
