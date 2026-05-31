var currentPage = 1;
var pageSize = 10;
var currentData = [];

// 页面加载时初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('conferencePayment.js 加载完成');
    // 只有当缴费页面元素存在于当前 DOM 中时才加载数据
    // （避免在 index2.jsp 主框架加载时就发起请求）
    if (document.getElementById('paymentTableBody')) {
        loadPaymentData();
    }
});

function loadPaymentData() {
    var url = contextPath + '/payment/history';

    fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(function(response) {
            console.log('响应状态:', response.status);
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            console.log('返回数据:', data);
            if (data.code === 200) {
                currentData = data.data || [];
                console.log('缴费记录数量:', currentData.length);
                renderPayments(currentData);
                if (data.statistics) {
                    updateStatistics(data.statistics);
                }
            } else if (data.code === 401) {
                Swal.fire({
                    icon: 'error',
                    title: '未登录',
                    text: '请先登录',
                    confirmButtonColor: '#f56565'
                }).then(function() {
                    window.location.href = contextPath + '/login.jsp';
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '加载失败',
                    text: data.msg || '获取缴费记录失败',
                    confirmButtonColor: '#f56565'
                });
                showEmptyTable();
            }
        })
        .catch(function(error) {
            console.error('请求失败:', error);
            Swal.fire({
                icon: 'error',
                title: '网络错误',
                text: '请检查网络连接后重试',
                confirmButtonColor: '#f56565'
            });
            showEmptyTable();
        });
}

function showEmptyTable() {
    var tbody = document.getElementById('paymentTableBody');
    if (tbody) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-5">暂无缴费记录</td></tr>';
    }
    var paginationInfo = document.getElementById('paginationInfo');
    if (paginationInfo) paginationInfo.innerText = '共 0 条记录';
    var pageNumbers = document.getElementById('pageNumbers');
    if (pageNumbers) pageNumbers.innerHTML = '';
}

function renderPayments(payments) {
    var filteredData = filterData(payments);
    var totalPages = Math.ceil(filteredData.length / pageSize);
    var start = (currentPage - 1) * pageSize;
    var pageData = filteredData.slice(start, start + pageSize);

    var tbody = document.getElementById('paymentTableBody');

    if (pageData.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center py-5">
                    <div class="empty-state">
                        <i class="fas fa-receipt"></i>
                        <h5>暂无缴费记录</h5>
                        <p>还没有任何缴费记录，快去参加感兴趣的会议吧！</p>
                        <button class="btn btn-primary" onclick="parent.loadPage('conferenceHall')">
                            <i class="fas fa-calendar-alt me-1"></i>浏览会议
                        </button>
                    </div>
                </td>
            </tr>
        `;
        document.getElementById('paginationInfo').innerText = '共 0 条记录';
        document.getElementById('pageNumbers').innerHTML = '';
        return;
    }

    var html = '';
    for (var i = 0; i < pageData.length; i++) {
        var p = pageData[i];
        var statusClass = p.status === 'paid' ? 'status-paid' : 'status-unpaid';
        var statusText = p.status === 'paid' ? '已缴费' : '待缴费';
        var amountClass = p.status === 'paid' ? 'amount-paid' : 'amount-unpaid';
        var amountText = '¥' + (p.amount || 0).toFixed(2);

        // 使用后端返回的 paidAt 作为缴费时间
        var paymentTime = p.paidAt ? formatDateTime(p.paidAt) : '--';
        // 会议名称
        var conferenceName = p.conferenceName || '会议ID:' + (p.conference_id || '--');
        // 会议时间
        var conferenceDate = p.conferenceDate || '--';

        html += '<tr>';
        html += '<td><i class="fas fa-calendar-alt me-2 text-primary"></i>' + escapeHtml(conferenceName) + '</td>';
        html += '<td>' + conferenceDate + '</td>';
        html += '<td><span class="' + amountClass + '">' + amountText + '</span></td>';
        html += '<td>' + paymentTime + '</td>';
        html += '<td><span class="payment-status ' + statusClass + '">' + statusText + '</span></td>';
        html += '<td>';

        if (p.status === 'unpaid') {
            html += '<button class="btn btn-primary btn-sm" onclick="payNow(' + p.id + ')">' +
                '<i class="fas fa-credit-card me-1"></i>立即缴费</button>';
        } else {
            html += '<button class="btn btn-outline-secondary btn-sm" onclick="viewDetail(' + p.id + ')">' +
                '<i class="fas fa-eye me-1"></i>查看详情</button>';
        }

        html += '</td>';
        html += '</tr>';
    }

    tbody.innerHTML = html;

    // 更新分页
    document.getElementById('paginationInfo').innerText = '共 ' + filteredData.length + ' 条记录';

    var pageHtml = '';
    for (var i = 1; i <= totalPages; i++) {
        pageHtml += '<button class="page-number' + (i === currentPage ? ' active' : '') + '" onclick="goToPage(' + i + ')">' + i + '</button>';
    }
    document.getElementById('pageNumbers').innerHTML = pageHtml;
}

function filterData(payments) {
    var status = document.getElementById('filterStatus').value;
    var keyword = document.getElementById('searchConference').value.toLowerCase();
    var startDate = document.getElementById('startDate').value;
    var endDate = document.getElementById('endDate').value;

    return payments.filter(function(p) {
        if (status !== 'all' && p.status !== status) return false;
        var conferenceName = (p.conferenceName || '').toLowerCase();
        if (keyword && conferenceName.indexOf(keyword) === -1) return false;
        // 使用 paidAt 进行时间筛选
        var paidAt = p.paidAt || '';
        if (startDate && paidAt && paidAt.substring(0, 10) < startDate) return false;
        if (endDate && paidAt && paidAt.substring(0, 10) > endDate) return false;
        return true;
    });
}

function updateStatistics(statistics) {
    document.getElementById('totalCount').innerText = statistics.totalCount || 0;
    document.getElementById('paidCount').innerText = statistics.paidCount || 0;
    document.getElementById('unpaidCount').innerText = statistics.unpaidCount || 0;
    document.getElementById('totalAmount').innerText = '¥' + (statistics.totalAmount || 0).toFixed(2);
}

function filterPayments() {
    currentPage = 1;
    renderPayments(currentData);
}

function refreshData() {
    loadPaymentData();
}

function goToPage(page) {
    currentPage = page;
    renderPayments(currentData);
}

function changePage(direction) {
    var filteredData = filterData(currentData);
    var totalPages = Math.ceil(filteredData.length / pageSize);
    if (direction === 'prev' && currentPage > 1) {
        currentPage--;
    } else if (direction === 'next' && currentPage < totalPages) {
        currentPage++;
    }
    renderPayments(currentData);
}

function formatDateTime(dateTimeStr) {
    if (!dateTimeStr) return '--';
    try {
        var date = new Date(dateTimeStr);
        if (isNaN(date.getTime())) return dateTimeStr;
        var year = date.getFullYear();
        var month = String(date.getMonth() + 1).padStart(2, '0');
        var day = String(date.getDate()).padStart(2, '0');
        var hours = String(date.getHours()).padStart(2, '0');
        var minutes = String(date.getMinutes()).padStart(2, '0');
        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    } catch(e) {
        return dateTimeStr;
    }
}

function payNow(paymentId) {
    var payment = currentData.find(function(p) { return p.id === paymentId; });
    var amount = payment ? payment.amount : 0;

    Swal.fire({
        title: '确认缴费',
        html: '<div class="text-center">' +
            '<i class="fas fa-credit-card" style="font-size: 48px; color: #667eea;"></i>' +
            '<p class="mt-3">确认支付 ¥' + amount.toFixed(2) + '</p>' +
            '</div>',
        showCancelButton: true,
        confirmButtonText: '确认支付',
        cancelButtonText: '取消',
        confirmButtonColor: '#667eea'
    }).then(function(result) {
        if (result.isConfirmed) {
            var url = contextPath + '/payment/pay';
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: 'status='+encodeURIComponent("paid")
            })
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if(data.code==200) {
                        Swal.fire({
                            icon: 'success',
                            title: '缴费成功',
                            text: '您已成功缴纳会议费用',
                            confirmButtonColor: '#667eea'
                        }).then(function() {
                            refreshData();
                        });
                    }
                })
                .catch(function(error) {
                    Swal.fire({
                        icon: 'failure',
                        title: '缴费失败',
                        text: '网络出错',
                        confirmButtonColor: '#667eea'
                    });
                });

        }
    });
}

function viewDetail(paymentId) {
    var payment = currentData.find(function(p) { return p.id === paymentId; });
    if (!payment) {
        Swal.fire({ title: '错误', text: '未找到记录', icon: 'error' });
        return;
    }

    Swal.fire({
        title: '缴费详情',
        html: '<div class="text-start">' +
            '<p><strong>会议名称：</strong>' + escapeHtml(payment.conferenceName || '--') + '</p>' +
            '<p><strong>缴费金额：</strong>¥' + (payment.amount || 0).toFixed(2) + '</p>' +
            '<p><strong>缴费时间：</strong>' + formatDateTime(payment.paidAt) + '</p>' +
            '<p><strong>缴费状态：</strong>' + (payment.status === 'paid' ? '已缴费' : '待缴费') + '</p>' +
            '</div>',
        icon: 'info',
        confirmButtonText: '关闭',
        confirmButtonColor: '#667eea'
    });
}

function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/[&<>]/g, function(m) {
        return m === '&' ? '&amp;' : (m === '<' ? '&lt;' : '&gt;');
    });
}