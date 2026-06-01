<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 会议大厅页面 -->
<div class="content-wrapper">
    <!-- 搜索栏 -->
    <div class="row mb-4">
        <div class="col-md-8">
            <div class="input-group">
                <input type="text" class="form-control" id="searchInput" placeholder="搜索会议名称..."
                       onkeypress="if(event.key==='Enter') searchConferences()">
                <button class="btn btn-primary" onclick="searchConferences()">
                    <i class="fas fa-search"></i> 搜索
                </button>
            </div>
        </div>
        <div class="col-md-4 text-end">
            <button class="btn btn-primary-custom" onclick="showJoinConferenceModal()">
                <i class="fas fa-sign-in-alt"></i> 输入邀请码加入
            </button>
        </div>
    </div>

    <!-- 会议列表容器 -->
    <div id="conferenceList" class="row g-4">
        <!-- 加载中提示 -->
        <div class="col-12 text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">加载中...</span>
            </div>
            <p class="mt-3 text-muted">正在加载会议列表...</p>
        </div>
    </div>

    <!-- 空状态 -->
    <div id="emptyState" class="col-12 text-center py-5 d-none">
        <i class="fas fa-calendar-times fa-4x text-muted opacity-25 mb-3"></i>
        <h4 class="text-muted">暂无公开会议</h4>
        <p class="text-muted">没有找到符合条件的会议</p>
    </div>
</div>

<!-- 加入会议模态框 -->
<div class="modal fade" id="joinConferenceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-sign-in-alt me-2"></i>加入会议</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label required">会议邀请码</label>
                    <input type="text" class="form-control" id="inviteCodeInput"
                           placeholder="请输入9位邀请码" maxlength="9">
                    <div class="form-text text-muted">
                        <i class="fas fa-info-circle"></i> 请向会议组织者获取邀请码
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary-custom" onclick="joinConference()">加入会议</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 页面加载时获取会议列表
    document.addEventListener('DOMContentLoaded', function() {
        loadConferences('');
    });

    // 搜索框回车事件
    document.getElementById('searchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchConferences();
        }
    });

    // 搜索会议
    function searchConferences() {
        const keyword = document.getElementById('searchInput').value.trim();
        loadConferences(keyword);
    }

    // 加载会议列表
    function loadConferences(keyword) {
        const listContainer = document.getElementById('conferenceList');
        const emptyState = document.getElementById('emptyState');

        // 显示加载状态
        listContainer.innerHTML = `
        <div class="col-12 text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">加载中...</span>
            </div>
            <p class="mt-3 text-muted">正在加载会议列表...</p>
        </div>
    `;

        // ✅ 正确：POST请求 /conference/search
        fetch(contextPath + '/conference/search', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'keyword=' + encodeURIComponent(keyword || '')
        })
            .then(res => res.json())
            .then(data => {
                // 无论成功失败，先关闭加载状态
                emptyState.classList.add('d-none');

                if ((data.code === 200 || data.code === 400) && data.data && data.data.length > 0) {
                    // 有数据，渲染列表
                    listContainer.innerHTML = '';
                    data.data.forEach(conference => {
                        const card = document.createElement('div');
                        card.className = 'col-md-6 col-lg-4';
                        card.innerHTML = `
                    <div class="content-card h-100">
                        <div class="card-body p-4">
                            <h5 class="card-title mb-3">\${conference.title}</h5>
                            <div class="mb-2 text-muted">
                                <i class="fas fa-map-marker-alt me-2"></i>\${conference.venue}
                            </div>
                            <div class="mb-2 text-muted">
                                <i class="fas fa-hotel me-2"></i>\${conference.dorms}
                            </div>
                            <div class="mb-3 text-muted">
                                <i class="fas fa-calendar-alt me-2"></i>
                                \${formatDateTime(conference.start_date)} - \${formatDateTime(conference.end_date)}
                            </div>
                            <button class="btn btn-primary-custom w-100" onclick="showJoinConferenceModal()">
                                <i class="fas fa-sign-in-alt"></i> 加入会议
                            </button>
                        </div>
                    </div>
                `;
                        listContainer.appendChild(card);
                    });
                } else {
                    // 无数据，显示空状态
                    listContainer.innerHTML = '';
                    emptyState.classList.remove('d-none');
                }
            })
            .catch(err => {
                console.error('加载会议列表失败', err);
                listContainer.innerHTML = `
            <div class="col-12 text-center py-5 text-danger">
                <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                <p>加载会议列表失败，请稍后重试</p>
            </div>
        `;
            });
    }

    // 显示加入会议模态框
    function showJoinConferenceModal() {
        document.getElementById('inviteCodeInput').value = '';
        new bootstrap.Modal(document.getElementById('joinConferenceModal')).show();
    }

    // 加入会议
    function joinConference() {
        const inviteCode = document.getElementById('inviteCodeInput').value.trim().toUpperCase();

        if (!inviteCode || inviteCode.length !== 9) {
            Swal.fire({
                icon: 'error',
                title: '邀请码格式错误',
                text: '请输入9位有效的邀请码'
            });
            return;
        }

        fetch(contextPath + '/attendee/join', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'inviteCode=' + inviteCode
        })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    Swal.fire({
                        icon: 'success',
                        title: '加入成功',
                        text: '您已成功加入该会议',
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => {
                        bootstrap.Modal.getInstance(document.getElementById('joinConferenceModal')).hide();
                        // 跳转到我的会议页面
                        loadPage('myConferences');
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '加入失败',
                        text: data.msg
                    });
                }
            });
    }

    // 格式化日期时间
    function formatDateTime(dateStr) {
        if (!dateStr) return '-';

        let date;
        // 处理数组格式
        if (Array.isArray(dateStr)) {
            const [year, month, day, hour, minute, second = 0] = dateStr;
            date = new Date(year, month - 1, day, hour, minute, second);
        }
        // 处理字符串格式
        else if (typeof dateStr === 'string') {
            const isoStr = dateStr.replace(' ', 'T');
            date = new Date(isoStr);
        }
        // 其他格式
        else {
            date = new Date(dateStr);
        }

        if (isNaN(date.getTime())) {
            console.error('日期解析失败:', dateStr);
            return '日期错误';
        }

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        return year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    }
</script>