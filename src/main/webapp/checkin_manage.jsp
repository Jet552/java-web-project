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
    <h4 class="mb-4"><i class="fas fa-check-circle text-primary me-2"></i>签到管理</h4>

    <!-- 选择会议 -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <label class="form-label fw-bold">选择会议</label>
            <select id="conferenceSelect" class="form-select" onchange="loadCheckinList()">
                <option value="">-- 请选择会议 --</option>
            </select>
        </div>
    </div>

    <!-- 签到统计 -->
    <div id="statsBar" class="row g-3 mb-4 d-none">
        <div class="col-md-4">
            <div class="card shadow-sm border-primary">
                <div class="card-body text-center">
                    <h2 class="text-primary" id="statTotal">0</h2>
                    <small class="text-muted">参会总人数</small>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-success">
                <div class="card-body text-center">
                    <h2 class="text-success" id="statCheckedIn">0</h2>
                    <small class="text-muted">已签到</small>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-sm border-warning">
                <div class="card-body text-center">
                    <h2 class="text-warning" id="statUnchecked">0</h2>
                    <small class="text-muted">未签到</small>
                </div>
            </div>
        </div>
    </div>

    <!-- 签到列表 -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="fw-bold"><i class="fas fa-list me-2"></i>参会人员</span>
            <span id="listCount" class="badge bg-secondary">0 人</span>
        </div>
        <div class="card-body p-0">
            <div id="loadingHint" class="text-center py-5 text-muted">
                <i class="fas fa-hand-pointer fa-2x mb-2"></i>
                <p>请先选择一个会议</p>
            </div>
            <table class="table table-striped table-hover mb-0 d-none" id="checkinTable">
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
                        opt.textContent = conf.title + (conf.status === 'approved' ? ' [已审核]' : '');
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
        fetch(ctx + '/checkin/list?conferenceId=' + conferenceId)
            .then(function(res) { return res.json(); })
            .then(function(resp) {
                if (resp.code !== 200) return;
                var list = resp.data;
                document.getElementById('listCount').textContent = list.length + ' 人';
                document.getElementById('checkinTable').classList.remove('d-none');

                var checkedIn = list.filter(function(r) { return r.checkedIn; }).length;
                document.getElementById('statTotal').textContent = list.length;
                document.getElementById('statCheckedIn').textContent = checkedIn;
                document.getElementById('statUnchecked').textContent = list.length - checkedIn;
                document.getElementById('statsBar').classList.remove('d-none');

                var tbody = document.getElementById('checkinBody');
                tbody.innerHTML = '';
                list.forEach(function(row) {
                    var tr = document.createElement('tr');
                    tr.innerHTML =
                        '<td>' + row.username + '</td>' +
                        '<td>' + (row.phone || '-') + '</td>' +
                        '<td>' + (row.checkinTime || '-') + '</td>' +
                        '<td>' + (row.checkedIn
                            ? '<span class="badge bg-success">已签到</span>'
                            : '<span class="badge bg-warning text-dark">未签到</span>') + '</td>' +
                        '<td>' + (row.checkedIn
                            ? '<button class="btn btn-sm btn-secondary" disabled>已签到</button>'
                            : '<button class="btn btn-sm btn-primary" onclick="window.doCheckin(' + row.attendeeId + ')">签到</button>') + '</td>';
                    tbody.appendChild(tr);
                });
            });
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
                Swal.fire({ icon: 'success', title: '签到成功', timer: 1500, showConfirmButton: false });
                window.loadCheckinList();
            } else if (data.code === 401) {
                location.href = ctx + '/login.jsp';
            } else {
                Swal.fire({ icon: 'error', title: '签到失败', text: data.msg });
            }
        });
    };
})();
</script>
