
// 页面加载时初始化
document.addEventListener('DOMContentLoaded', function() {
    // 只有当缴费页面元素存在于当前 DOM 中时才加载数据
    // （避免在 index2.jsp 主框架加载时就发起请求）
    if (document.getElementById('paymentTableBody')) {
    loadRecommendedConferences();
    }
});

function loadRecommendedConferences() {
    fetch(contextPath + '/conference/search', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'keyword='
    })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var list = [];
            if (data.code === 200) {
                list = [data.data];
            } else if (data.code === 400) {
                list = data.data || [];
            }
            renderTable(list);
        })
        .catch(function() {
            document.getElementById('conferenceTableWrapper').innerHTML =
                '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>数据加载失败</p></div>';
        });
}

function renderTable(conferences) {
    var wrapper = document.getElementById('conferenceTableWrapper');

    if (!conferences || conferences.length === 0) {
    wrapper.innerHTML =
    '<div class="empty-state"><i class="fas fa-inbox"></i><p>暂无会议数据</p></div>';
    return;
    }

    //只显示最近20条
    var displayList = conferences.slice(0, 20);
    window._confList = displayList;

    var html = '<table class="table-dashboard">' +
    '<thead><tr>' +
    '<th style="width:50px;">序号</th>' +
    '<th>会议名称</th>' +
    '<th>时间</th>' +
    '<th>地点</th>' +
    '<th style="width:100px;">操作</th>' +
    '</tr></thead><tbody>';

    for (var i = 0; i < displayList.length; i++) {
    var c = displayList[i];
    var startDate = (c.start_date || '').replace('T', ' ');
    var endDate = (c.end_date || '').replace('T', ' ');
    var timeRange = startDate ? (startDate.substring(0, 10) + ' 至 ' + endDate.substring(0, 10)) : '--';

    html += '<tr>' +
    '<td class="text-muted small">' + (i + 1) + '</td>' +
    '<td><span class="fw-medium">' + escapeHtml(c.title || '--') + '</span></td>' +
    '<td class="small text-secondary">' + timeRange + '</td>' +
    '<td class="small text-secondary"><i class="fas fa-map-marker-alt me-1" style="color:#9ca3af;"></i>' + escapeHtml(c.venue || '--') + '</td>' +
    '<td><button onclick="showConferenceDetail(' + i + ')" class="btn-view"><i class="fas fa-eye me-1"></i>详情</button></td>' +
    '</tr>';
    }

    html += '</tbody></table>';
    wrapper.innerHTML = html;
}

function showConferenceDetail(index) {
    var c = window._confList[index];
    if (!c) return;

    var startDate = (c.start_date || '').replace('T', ' ');
    var endDate = (c.end_date || '').replace('T', ' ');
    var timeRange = startDate ? (startDate.substring(0, 10) + ' 至 ' + endDate.substring(0, 10)) : '--';
    var fees = c.amount ? '¥' + parseFloat(c.amount).toFixed(2) : '免费';
    var dormsInfo = c.dorms || '未提供';

    Swal.fire({
    title: '',
    html:
    '<div class="swal-conference-card">' +
    '<div class="conf-title">' + escapeHtml(c.title || '--') + '</div>' +
    '<div class="conf-info">' +
    '<i class="fas fa-calendar-alt"></i>' +
    '<span class="label">时间</span>' +
    '<span class="value">' + timeRange + '</span>' +
    '</div>' +
    '<div class="conf-info">' +
    '<i class="fas fa-map-marker-alt"></i>' +
    '<span class="label">地点</span>' +
    '<span class="value">' + escapeHtml(c.venue || '--') + '</span>' +
    '</div>' +
    '<div class="conf-info">' +
    '<i class="fas fa-bed"></i>' +
    '<span class="label">住宿</span>' +
    '<span class="value">' + escapeHtml(dormsInfo) + '</span>' +
    '</div>' +
    '<div class="conf-info">' +
    '<i class="fas fa-tag"></i>' +
    '<span class="label">费用</span>' +
    '<span class="value amount">' + fees + '</span>' +
    '</div>' +
    '</div>',
    showCloseButton: true,
    confirmButtonText: '知道了',
    confirmButtonColor: '#e6f7ff',    // 按钮背景色
    customClass: {
    popup: 'rounded-4',
    confirmButton: 'btn px-4 py-2',
    },
    buttonsStyling: false,
    width: 480,
    padding: '24px 28px'
    });
}

function escapeHtml(str) {
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
}