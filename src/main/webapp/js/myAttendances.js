/**
 * 我的参会记录页面 - 交互逻辑
 */
var attCurrentPage = 1;
var attPageSize = 20;
var attAllData = [];  // 原始全部数据
var attData = [];     // 筛选后的数据

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
                // status=1 优先靠前，然后再按 created_date 降序
                attAllData = data.data.sort(function(a, b) {
                    if (a.atten_status == 1 && b.atten_status != 1) return -1;
                    if (a.atten_status != 1 && b.atten_status == 1) return 1;
                    return (b.created_date || '').localeCompare(a.created_date || '');
                });
                console.log('排序后前5条:', attAllData.slice(0, 5).map(function(i) { return i.title + ' status:' + i.atten_status; }));
            } else {
                attAllData = [];
            }
            attApplyFilter();
        })
        .catch(function () {
            attShowLoading(false);
            attAllData = [];
            attApplyFilter();
        });
}

function attApplyFilter() {
    var statusVal = document.getElementById('filterStatus') ? document.getElementById('filterStatus').value : 'all';
    var nameVal = document.getElementById('filterName') ? document.getElementById('filterName').value.trim() : '';
    var startDate = document.getElementById('filterStartDate') ? document.getElementById('filterStartDate').value : '';
    var endDate = document.getElementById('filterEndDate') ? document.getElementById('filterEndDate').value : '';

    attData = attAllData.filter(function(item) {
        // 状态筛选
        if (statusVal != 'all' && item.atten_status != statusVal) return false;
        // 名称三级匹配：先整体匹配，再逐字匹配
        if (nameVal) {
            var title = (item.title || '').toLowerCase();
            var kw = nameVal.toLowerCase();
            // 第一级：整体包含
            if (title.indexOf(kw) !== -1) {
                // 匹配，继续
            }
            // 第二级：逐字匹配（每个字都在标题中出现）
            else {
                var allMatch = true;
                for (var j = 0; j < kw.length; j++) {
                    if (title.indexOf(kw.charAt(j)) === -1) {
                        allMatch = false;
                        break;
                    }
                }
                if (!allMatch) return false;
            }
        }
        // 开始时间筛选（会议开始时间 >= 选中的开始日期）
        if (startDate && item.start_date) {
            var itemStart = (item.start_date || '').replace('T', ' ').substring(0, 10);
            if (itemStart < startDate) return false;
        }
        // 结束时间筛选（会议结束时间 <= 选中的结束日期）
        if (endDate && item.end_date) {
            var itemEnd = (item.end_date || '').replace('T', ' ').substring(0, 10);
            if (itemEnd > endDate) return false;
        }
        return true;
    });

    var el = document.getElementById('cardHeaderRight');
    if (el) el.innerHTML = '共 <strong>' + attData.length + '</strong> 条记录';
    attCurrentPage = 1;
    attRenderPage();
    attRenderPagination();
}

function attResetFilter() {
    if (document.getElementById('filterStatus')) document.getElementById('filterStatus').value = 'all';
    if (document.getElementById('filterName')) document.getElementById('filterName').value = '';
    if (document.getElementById('filterStartDate')) document.getElementById('filterStartDate').value = '';
    if (document.getElementById('filterEndDate')) document.getElementById('filterEndDate').value = '';
    attApplyFilter();
}

function attRenderPage() {
    var tbody = document.getElementById('meetingTableBody');
    if (!tbody) return;
    if (attData.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="text-center py-5 text-muted">'
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
        var sourceHtml = item.join_source === 'invite'
            ? '<span class="badge bg-warning text-dark">特邀</span>'
            : '<span class="badge bg-light text-muted">普通</span>';
        html += '<td>' + sourceHtml + '</td>';
        html += '<td><span class="status-badge ' + statusClass + '">' + statusText + '</span></td>';
        if (item.atten_status == 1) {
            if (item.pay_status == "paid") {
                html += '<td><span class="text-success small fw-bold"><i class="fas fa-check-circle me-1"></i>已完成缴费</span></td>';
            } else {
                html += '<td class="text-nowrap">';
                html += '<a href="' + contextPath + '/attendee/join_meeting.jsp?id=' + item.id + '&title=' + item.title + '&invite_codes=' + item.invite_codes + '" class="btn btn-my-action btn-sm me-1">';
                html += '<i class="fas fa-credit-card me-1"></i>完善报名</a>';
                html += '<a href="javascript:void(0)" onclick="cancelAttendance(' + (item.atten_id) + ')" class="btn btn-sm" style="background:#e53e3e;color:#fff;font-size:0.82rem;padding:6px 12px;border-radius:6px;">';
                html += '<i class="fas fa-times me-1"></i>取消</a>';
                html += '</td>';
            }
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

function cancelAttendance(attendanceId) {
    Swal.fire({
        title: '确认取消',
        text: '取消后该会议状态将变为"已取消"',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '确认取消',
        cancelButtonText: '再想想',
        confirmButtonColor: '#e53e3e',
        cancelButtonColor: '#8c8c8c'
    }).then(function (result) {
        if (result.isConfirmed) {
            attShowLoading(true);
            var bodyData = 'atten_id=' + attendanceId;
            fetch(contextPath + '/attendee/cancel', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: bodyData
            })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    attShowLoading(false);
                    if (data.code === 200) {
                        Swal.fire({ icon: 'success', title: '已取消', text: '参会记录已取消', confirmButtonColor: '#52c41a' });
                        cancelPaymentRecord(attendanceId);
                        loadMyAttendances(); // 刷新列表
                    } else {
                        Swal.fire({ icon: 'error', title: '操作失败', text: data.msg, confirmButtonColor: '#e53e3e' });
                    }
                })
                .catch(function () {
                    attShowLoading(false);
                    Swal.fire({ icon: 'error', title: '网络错误', text: '请求失败', confirmButtonColor: '#e53e3e' });
                });
        }
    });
}
function cancelPaymentRecord(attendanceId) {
    var paymentBodyData = 'attendee_id=' + attendanceId;
    fetch(contextPath + '/payment/delete', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: paymentBodyData
    }).then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.code == 200) {
                console.error('删除缴费记录成功:', data.msg);
            }
            else{
                console.error('删除缴费记录失败:', data.msg);
            }
        })
        .catch(function () {
            console.error('网络异常');
        });
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
