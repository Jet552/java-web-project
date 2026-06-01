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
    // 页面初始化
    console.log('会议大厅页面加载完成，开始初始化');
    setTimeout(() => {
        loadConferences('');
    }, 50);

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

        fetch(contextPath + '/conference/search', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'keyword=' + encodeURIComponent(keyword || '')
        })
            .then(res => {
                // 这里我加了容错：不认识的状态一律不抛错
                if (!res.ok) {
                    console.warn('接口返回异常，但继续执行', res.status);
                    return { code: 200, data: [] };
                }
                return res.json();
            })
            .then(data => {
                console.log('会议大厅返回数据：', data);
                emptyState.classList.add('d-none');

                if ((data.code === 200 || data.code === 400) && data.data && data.data.length > 0) {
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
                            <button class="btn btn-primary-custom w-100" onclick="joinConferenceById(\${conference.id}, '\${conference.invite_codes || ''}')">
                                <i class="fas fa-sign-in-alt"></i> 立即报名
                            </button>
                        </div>
                    </div>
                `;
                        listContainer.appendChild(card);
                    });
                } else {
                    listContainer.innerHTML = '';
                    emptyState.classList.remove('d-none');
                }
            })
            .catch(err => {
                // 接口报错也不红屏，只显示空页面
                console.error('加载会议失败，但不崩页面：', err);
                listContainer.innerHTML = '';
                emptyState.classList.remove('d-none');
            });
    }

    // 跳转到参会登记页
    function joinConferenceById(conferenceId, inviteCodes) {
        const encodedInviteCodes = encodeURIComponent(inviteCodes || '');
        window.location.href = contextPath + '/attendee/join_meeting.jsp?id=' + conferenceId + '&invite_codes=' + encodedInviteCodes;
    }

    // 显示邀请码模态框
    function showJoinConferenceModal() {
        document.getElementById('inviteCodeInput').value = '';
        new bootstrap.Modal(document.getElementById('joinConferenceModal')).show();
    }

    // 通过邀请码加入
    function joinConference() {
        const inviteCode = document.getElementById('inviteCodeInput').value.trim().toUpperCase();
        if (!inviteCode || inviteCode.length !== 9) {
            Swal.fire({icon: 'error', title: '邀请码格式错误', text: '请输入9位有效的邀请码'});
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
                    Swal.fire({icon: 'success', title: '加入成功', timer: 1500, showConfirmButton: false})
                        .then(() => {
                            bootstrap.Modal.getInstance(document.getElementById('joinConferenceModal')).hide();
                            loadPage('myConferences');
                        });
                } else {
                    Swal.fire({icon: 'error', title: '加入失败', text: data.msg});
                }
            });
    }

    // 格式化日期
    function formatDateTime(dateStr) {
        if (!dateStr) return '-';
        let date;
        if (Array.isArray(dateStr)) {
            const [year, month, day, hour, minute, second = 0] = dateStr;
            date = new Date(year, month - 1, day, hour, minute, second);
        } else if (typeof dateStr === 'string') {
            date = new Date(dateStr.replace(' ', 'T'));
        } else {
            date = new Date(dateStr);
        }
        if (isNaN(date.getTime())) return '日期错误';
        return date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, '0') + "-" + String(date.getDate()).padStart(2, '0') + " " + String(date.getHours()).padStart(2, '0') + ":" + String(date.getMinutes()).padStart(2, '0');
    }
</script>