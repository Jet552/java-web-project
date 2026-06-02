<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.demo.web_project.vo.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<div class="content-wrapper">
    <h5 class="mb-4 fw-bold"><i class="fas fa-check-circle text-primary me-2"></i>签到管理</h5>

    <!-- 选择会议 -->
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
            <label class="form-label fw-bold"><i class="fas fa-calendar-alt me-2"></i>选择会议</label>
            <select id="conferenceSelect" class="form-select" onchange="loadCheckinList()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <!-- 签到统计 -->
    <div id="statsBar" class="row g-3 mb-4 d-none">
        <div class="col-md-4">
            <div class="card shadow-sm border-0" style="border-left: 4px solid #1a56db;">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">参会总人数</div>
                            <h3 class="mb-0 fw-bold" id="statTotal">0</h3>
                        </div>
                        <i class="fas fa-users fa-2x text-primary opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-0" style="border-left: 4px solid #057a55;">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">已签到</div>
                            <h3 class="mb-0 fw-bold text-success" id="statCheckedIn">0</h3>
                        </div>
                        <i class="fas fa-user-check fa-2x text-success opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-0" style="border-left: 4px solid #c27803;">
                <div class="card-body py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">未签到</div>
                            <h3 class="mb-0 fw-bold text-warning" id="statUnchecked">0</h3>
                        </div>
                        <i class="fas fa-user-clock fa-2x text-warning opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 签到列表 -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="fw-bold"><i class="fas fa-list me-2"></i>参会人员</span>
            <div class="d-flex gap-2 align-items-center">
                <input type="text" id="nameSearch" class="form-control form-control-sm" style="width:180px;"
                       placeholder="搜索姓名..." oninput="filterByName()">
                <span id="listCount" class="badge bg-secondary rounded-pill">0 人</span>
            </div>
        </div>
        <div class="card-body p-0">
            <div id="loadingHint" class="text-center py-5 text-muted">
                <i class="fas fa-hand-pointer fa-2x mb-2"></i>
                <p>请先选择一个会议</p>
            </div>
            <table class="table table-hover align-middle mb-0 d-none" id="checkinTable">
                <thead class="table-light">
                    <tr>
                        <th>姓名</th>
                        <th>手机号</th>
                        <th>签到时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="checkinBody"></tbody>
            </table>
        </div>
    </div>
</div>

<script>
(function() {
    var ctx = window.contextPath || '';
    var allCheckinData = [];

    loadConferences();

    function loadConferences() {
        fetch(ctx + '/conference/myList?_=' + Date.now(), { cache: 'no-store' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var select = document.getElementById('conferenceSelect');
                if (data.code === 200 && data.data) {
                    data.data.forEach(function(conf) {
                        var opt = document.createElement('option');
                        opt.value = conf.id;
                        opt.textContent = conf.title + (conf.status === 'approved' ? '' : ' [待审核]');
                        if (conf.status !== 'approved') opt.disabled = true;
                        select.appendChild(opt);
                    });
                }
            })
            .catch(function(err) { console.error('加载会议列表失败', err); });
    }

    window.loadCheckinList = function() {
        var conferenceId = document.getElementById('conferenceSelect').value;
        if (!conferenceId) return;

        document.getElementById('loadingHint').classList.add('d-none');
        document.getElementById('nameSearch').value = '';
        fetch(ctx + '/checkin/list?conferenceId=' + conferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                if (resp.code !== 200) return;
                allCheckinData = resp.data;
                renderTable(allCheckinData);
                updateStats(allCheckinData);
            });
    };

    function renderTable(list) {
        document.getElementById('listCount').textContent = list.length + ' 人';
        document.getElementById('checkinTable').classList.remove('d-none');
        document.getElementById('statsBar').classList.remove('d-none');

        var tbody = document.getElementById('checkinBody');
        tbody.innerHTML = '';
        if (list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center py-4 text-muted">暂无参会人员</td></tr>';
            return;
        }
        list.forEach(function(row) {
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td><strong>' + (row.username || '-') + '</strong></td>' +
                '<td class="text-muted">' + (row.phone || '-') + '</td>' +
                '<td>' + (row.checkinTime ? row.checkinTime.replace('T',' ') : '<span class="text-muted">-</span>') + '</td>' +
                '<td>' + (row.checkedIn
                    ? '<span class="badge bg-success rounded-pill">已签到</span>'
                    : '<span class="badge bg-warning text-dark rounded-pill">未签到</span>') + '</td>' +
                '<td>' + (row.checkedIn
                    ? '<span class="text-muted small">' + (row.checkinTime ? row.checkinTime.replace('T',' ').substring(0,16) : '') + '</span>'
                    : '<button class="btn btn-primary btn-sm rounded-pill" onclick="window.doCheckin(' + row.attendeeId + ')"><i class="fas fa-check me-1"></i>签到</button>') + '</td>';
            tbody.appendChild(tr);
        });
    }

    function updateStats(list) {
        var checkedIn = list.filter(function(r) { return r.checkedIn; }).length;
        document.getElementById('statTotal').textContent = list.length;
        document.getElementById('statCheckedIn').textContent = checkedIn;
        document.getElementById('statUnchecked').textContent = list.length - checkedIn;
    }

    window.filterByName = function() {
        var keyword = document.getElementById('nameSearch').value.trim().toLowerCase();
        if (!keyword) { renderTable(allCheckinData); return; }
        var filtered = allCheckinData.filter(function(r) {
            return (r.username || '').toLowerCase().includes(keyword);
        });
        renderTable(filtered);
    };

    window.doCheckin = function(attendeeId) {
        var formData = new URLSearchParams();
        formData.append('attendeeId', attendeeId);
        fetch(ctx + '/checkin/doCheckin', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.code === 200) {
                Swal.fire({ icon: 'success', title: '签到成功', timer: 1200, showConfirmButton: false });
                window.loadCheckinList();
            } else if (data.code === 401) {
                location.href = ctx + '/login.jsp';
            } else {
                Swal.fire({ icon: 'info', title: '提示', text: data.msg });
            }
        });
    };
})();
</script>
