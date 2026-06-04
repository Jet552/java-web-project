/**
 * 会议检索页面 - 交互逻辑
 */
function buildRequestBody(searchKeyword) {
    return 'keyword=' + encodeURIComponent(searchKeyword);
}
var currentPage = 1;
var pageSize = 20;
var currentData = []; // 当前搜索结果
/**
 * 执行搜索
 */
function doSearch() {
    var searchKeyword = document.getElementById('searchKeyword').value.trim();
    showLoading(true);
    var url = contextPath + '/conference/search';
    var bodyData = 'keyword=' + encodeURIComponent(searchKeyword);
    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: bodyData
    })
        .then(function (response) { return response.json(); })
        .then(function (data) {
            showLoading(false);
            renderSearchResult(data);
        })
        .catch(function (error) {
            showLoading(false);
            Swal.fire({
                icon: 'error',
                title: '网络错误',
                text: '搜索请求失败，请稍后重试',
                confirmButtonColor: '#1890ff'
            });
        });
}
/**
 * 根据后端返回数据渲染结果
 */
function renderSearchResult(data) {
    var tbody = document.getElementById('meetingTableBody');
    var cardHeaderRight = document.getElementById('cardHeaderRight');
    var paginationContainer = document.getElementById('paginationContainer');
    // code 200: 邀请码查到单个 / code 400: 关键字查到多个
    if (data.code === 200) {
        currentData = [data.data];
        // 清空表格，避免旧内容闪现
        tbody.innerHTML = '';
        paginationContainer.innerHTML = '';
        joinMeeting(data.data.id,'invite');
        return;
    }
    else if (data.code === 400) {//列表
        currentData = data.data || [];
    } else {
        // 未找到
        currentData = [];
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted">'
            + '<i class="fas fa-inbox fa-2x d-block mb-2"></i>'
            + (data.msg || '暂无符合条件的会议记录')
            + '</td></tr>';
        cardHeaderRight.innerHTML = '共 <strong>0</strong> 条记录';
        paginationContainer.innerHTML = '';
        return;
    }
    cardHeaderRight.innerHTML = '共 <strong>' + currentData.length + '</strong> 条记录';
    currentPage = 1;
    renderTablePage();
    renderPagination();
}
/**
 * 客户端分页 - 渲染当前页表格数据
 */
function renderTablePage() {
    var tbody = document.getElementById('meetingTableBody');
    var start = (currentPage - 1) * pageSize;
    var end = Math.min(start + pageSize, currentData.length);
    var pageData = currentData.slice(start, end);
    var html = '';
    for (var i = 0; i < pageData.length; i++) {
        var item = pageData[i];
        var rowNum = start + i + 1;
        html += '<tr>';
        html += '<td class="text-muted small">' + rowNum + '</td>';
        html += '<td>' + item.id+ '</td>';
        html += '<td><span class="meeting-name" title="' + esc(item.title) + '">' + esc(item.title) + '</span></td>';
        html += '<td>' + esc((item.start_date || '').replace('T', ' ')) + '</td>';
        html += '<td>' + esc((item.end_date || '').replace('T', ' ')) + '</td>';
        html += '<td><i class="fas fa-map-marker-alt text-secondary me-1 small"></i>' + esc(item.venue) + '</td>';
        html += '<td>' + esc(item.dorms) + '</td>';
        html += '<td>' + esc(item.amount) + '</td>';
        // html += '<td><span class="status-badge ' + statusClass + '">' + status + '</span></td>';
        if (item.attendee_id != 0) {
            if(item.paid_status=="paid"){
                html += '<td><span class="text-success small fw-bold"><i class="fas fa-check-circle me-1"></i>已完成缴费</span></td>';
            }
            else {
                html += '<td class="text-nowrap">';
                html += '<a href="' + contextPath + '/attendee/join_meeting.jsp?id=' + item.id + '&title=' + item.title + '&invite_codes=' + item.invite_codes + '" class="btn btn-join btn-sm me-1">';
                html += '<i class="fas fa-credit-card me-1"></i>完善报名</a>';
                html += '<a href="javascript:void(0)" onclick="cancelSearchAttendance(' + (item.attendee_id) + ')" class="btn btn-sm" style="background:#e53e3e;color:#fff;font-size:0.82rem;padding:6px 12px;border-radius:6px;">';
                html += '<i class="fas fa-times me-1"></i>取消</a>';
                html += '</td>';
            }
        } else {
            html += '<td><a href="javascript:void(0)" onclick="joinMeeting(' + item.id +','+'search'+ ')" class="btn btn-join btn-sm">';
            html += '<i class="fas fa-sign-in-alt me-1"></i>点击参加</a></td>';
        }
        html += '</tr>';
    }
    tbody.innerHTML = html;
}
function cancelSearchAttendance(attendanceId) {
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
                        loadAllApproved(); // 刷新列表
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
/**
 * 渲染分页
 */
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
// (function () {
//     'use strict';
//     if (document.readyState === 'loading') {
//         document.addEventListener('DOMContentLoaded', function () {
//             loadAllApproved();
//         });
//     } else {
//         loadAllApproved();
//     }
// })();

function loadAllApproved() {
    showLoading(true);
    var url = contextPath + '/conference/search';
    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'keyword='
    })
        .then(function (response) { return response.json(); })
        .then(function (data) {
            showLoading(false);
            renderSearchResult(data);
        })
        .catch(function (error) {
            showLoading(false);
        });
}
/**
 * 根据 ID 从当前数据中查找会议
 */
function getMeetingById(id) {
    for (var i = 0; i < currentData.length; i++) {
        if (currentData[i].id == id) {
            return currentData[i];
        }
    }
    return null;
}
/**
 * 点击参加 - 获取该行会议数据并跳转
 */
function joinMeeting(id,source) {
    var meeting = getMeetingById(id);
    showLoading(true);
    // 用邀请码向后端校验会议是否仍有效
    fetch(contextPath + '/conference/search', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'keyword=' + meeting.invite_codes
    })
        .then(function (response) { return response.json(); })
        .then(function (data) {
            showLoading(false);
            if (data.code === 200) {
                // 会议仍存在，正常跳转
                window.location.href = contextPath + '/attendee/join_meeting.jsp?id=' + id+'&title='+ meeting.title+'&invite_codes='+ meeting.invite_codes + (source ? '&source=' + source : '');
            } else {
                // 会议已取消/不存在
                Swal.fire({
                    icon: 'warning',
                    title: '会议状态异常',
                    text: '该会议已被主办方取消或下架，无法报名参加',
                    confirmButtonColor: '#1890ff'
                });
            }
        })
        .catch(function () {
            showLoading(false);
            Swal.fire({ icon: 'error', title: '网络错误', text: '校验失败，请稍后重试', confirmButtonColor: '#1890ff' });
        });
}