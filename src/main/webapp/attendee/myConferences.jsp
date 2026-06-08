<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="${pageContext.request.contextPath}/js/common.js?v=5"></script>
<!-- 我的会议页面 -->
<div class="content-wrapper">
    <!-- 操作栏 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3><i class="fas fa-list me-2 text-primary"></i>我的会议</h3>
        <button class="btn btn-primary-custom" onclick="showCreateConferenceModal()">
            <i class="fas fa-plus"></i> 创建新会议
        </button>
    </div>

    <!-- 会议列表 -->
    <div class="content-card">
        <div class="card-body p-0">
            <table class="table table-custom">
                <thead>
                <tr>
                    <th>会议名称</th>
                    <th>举办地点</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="myConferenceList">
                <tr>
                    <td colspan="6" class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">加载中...</span>
                        </div>
                        <p class="mt-3 text-muted">正在加载您的会议...</p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 空状态 -->
    <div id="emptyState" class="text-center py-5 d-none">
        <i class="fas fa-calendar-plus fa-4x text-muted opacity-25 mb-3"></i>
        <h4 class="text-muted">您还没有创建任何会议</h4>
        <p class="text-muted">点击上方按钮创建您的第一个会议</p>
    </div>
</div>

<!-- 创建/编辑会议模态框 -->
<div class="modal fade" id="conferenceModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle"><i class="fas fa-plus me-2"></i>创建新会议</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="conferenceForm">
                    <input type="hidden" id="conferenceId">
                    <div class="row g-4">
                        <div class="col-12">
                            <label class="form-label required">会议名称</label>
                            <input type="text" class="form-control" id="title"
                                   placeholder="请输入会议名称" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">会议描述</label>
                            <textarea class="form-control" id="description" rows="3"
                                      placeholder="请输入会议描述"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label required">举办地点</label>
                            <input type="text" class="form-control" id="venue"
                                   placeholder="请输入举办地点" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label required">住宿安排</label>
                            <input type="text" class="form-control" id="dorms"
                                   placeholder="请输入住宿安排" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label required">开始时间</label>
                            <input type="datetime-local" class="form-control" id="start_date" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label required">结束时间</label>
                            <input type="datetime-local" class="form-control" id="end_date" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary-custom" onclick="saveConference()">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 生成邀请码模态框 -->
<div class="modal fade" id="inviteCodeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="fas fa-qrcode me-2"></i>会议邀请码</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <div class="mb-4">
                    <div class="invite-code-display" id="inviteCodeDisplay">
                        点击下方按钮生成邀请码
                    </div>
                    <div class="form-text text-muted mt-2">
                        <i class="fas fa-info-circle"></i> 邀请码仅对已审核通过的会议有效
                    </div>
                </div>
                <input type="hidden" id="currentConferenceId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary-custom" id="generateCodeBtn" onclick="generateInviteCode()">
                    <i class="fas fa-refresh"></i> 生成邀请码
                </button>
                <button type="button" class="btn btn-success" id="copyCodeBtn" onclick="copyInviteCode()" style="display: none;">
                    <i class="fas fa-copy"></i> 复制邀请码
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // SPA中DOMContentLoaded已触发过，直接执行
    loadMyConferences();

    // 加载我的会议列表
    function loadMyConferences() {
        const listContainer = document.getElementById('myConferenceList');
        const emptyState = document.getElementById('emptyState');

        fetch(contextPath + '/conference/myList?_=' + Date.now(), { cache: 'no-store' })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200 && data.data && data.data.length > 0) {
                    // 有数据，渲染列表
                    emptyState.classList.add('d-none');
                    listContainer.innerHTML = '';

                    data.data.forEach(conference => {
                        // 状态徽章
                        let statusBadge = '';
                        switch(conference.status) {
                            case 'pending':
                                statusBadge = '<span class="status-badge bg-warning text-dark">待审核</span>';
                                break;
                            case 'approved':
                                statusBadge = '<span class="status-badge bg-success">已通过</span>';
                                break;
                            case 'rejected':
                                statusBadge = '<span class="status-badge bg-danger">已拒绝</span>';
                                break;
                            default:
                                statusBadge = '<span class="status-badge bg-secondary">未知</span>';
                        }

                        // 操作按钮
                        let actions = '';
                        if (conference.status === 'pending') {
                            actions = `
                                <button class="btn btn-sm btn-primary me-1" onclick="editConference(\${conference.id})">
                                    <i class="fas fa-edit"></i> 编辑
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteConference(\${conference.id})">
                                    <i class="fas fa-trash"></i> 删除
                                </button>
                            `;
                        } else if (conference.status === 'approved') {
                            actions = `
                                <button class="btn btn-sm btn-info me-1" onclick="showInviteCodeModal(\${conference.id}, '\${conference.invite_codes || ''}')">
                                    <i class="fas fa-qrcode"></i> 邀请码
                                </button>
                                <button class="btn btn-sm btn-secondary" disabled>
                                    <i class="fas fa-lock"></i> 已锁定
                                </button>
                            `;
                        } else {
                            actions = `
                                <button class="btn btn-sm btn-danger" onclick="deleteConference(\${conference.id})">
                                    <i class="fas fa-trash"></i> 删除
                                </button>
                            `;
                        }

                        const tr = document.createElement('tr');
                        tr.innerHTML = `
                            <td><strong>\${conference.title}</strong></td>
                            <td>\${conference.venue}</td>
                            <td>\${formatDateTime(conference.start_date)}</td>
                            <td>\${formatDateTime(conference.end_date)}</td>
                            <td>\${statusBadge}</td>
                            <td>\${actions}</td>
                        `;
                        listContainer.appendChild(tr);
                    });
                } else {
                    // 无数据，显示空状态
                    listContainer.innerHTML = '';
                    emptyState.classList.remove('d-none');
                }
            })
            .catch(err => {
                console.error('加载我的会议失败', err);
                listContainer.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-5 text-danger">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                        <p>加载会议列表失败，请稍后重试</p>
                    </td>
                </tr>
            `;
            });
    }

    // 显示创建会议模态框
    function showCreateConferenceModal() {
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-plus me-2"></i>创建新会议';
        document.getElementById('conferenceId').value = '';
        document.getElementById('conferenceForm').reset();
        new bootstrap.Modal(document.getElementById('conferenceModal')).show();
    }

    // 编辑会议
    function editConference(conferenceId) {
        fetch(contextPath + '/conference/detail?id=' + conferenceId)
            .then(res => res.json())
            .then(data => {
                if (data.code !== 200 || !data.data) {
                    Swal.fire({
                        icon: 'error',
                        title: '获取会议信息失败',
                        text: data.msg
                    });
                    return;
                }

                const conference = data.data;
                document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit me-2"></i>编辑会议';
                document.getElementById('conferenceId').value = conference.id;
                document.getElementById('title').value = conference.title;
                document.getElementById('description').value = conference.description || '';
                document.getElementById('venue').value = conference.venue;
                document.getElementById('dorms').value = conference.dorms;
                document.getElementById('start_date').value = formatDateTimeLocal(conference.start_date);
                document.getElementById('end_date').value = formatDateTimeLocal(conference.end_date);

                new bootstrap.Modal(document.getElementById('conferenceModal')).show();
            });
    }

    // 保存会议
    function saveConference() {
        const conferenceId = document.getElementById('conferenceId').value;
        const title = document.getElementById('title').value.trim();
        const description = document.getElementById('description').value.trim();
        const venue = document.getElementById('venue').value.trim();
        const dorms = document.getElementById('dorms').value.trim();
        const startDate = document.getElementById('start_date').value;
        const endDate = document.getElementById('end_date').value;

        // 简单校验
        if (!title || !venue || !dorms || !startDate || !endDate) {
            Swal.fire({
                icon: 'error',
                title: '参数不完整',
                text: '请填写所有必填项'
            });
            return;
        }

        if (new Date(startDate) > new Date(endDate)) {
            Swal.fire({
                icon: 'error',
                title: '日期错误',
                text: '开始时间不能晚于结束时间'
            });
            return;
        }

        const formData = new URLSearchParams();
        if (conferenceId) formData.append('id', conferenceId);
        formData.append('title', title);
        formData.append('description', description);
        formData.append('venue', venue);
        formData.append('dorms', dorms);
        formData.append('start_date', startDate);
        formData.append('end_date', endDate);

        const url = conferenceId
            ? contextPath + '/conference/update'
            : contextPath + '/conference/create';

        fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    Swal.fire({
                        icon: 'success',
                        title: conferenceId ? '修改成功' : '创建成功',
                        text: conferenceId ? '会议信息已更新' : '会议已提交审核',
                        timer: 1500,
                        showConfirmButton: false
                    }).then(() => {
                        bootstrap.Modal.getInstance(document.getElementById('conferenceModal')).hide();
                        loadMyConferences();
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: conferenceId ? '修改失败' : '创建失败',
                        text: data.msg
                    });
                }
            });
    }

    // 删除会议
    function deleteConference(conferenceId) {
        Swal.fire({
            title: '确认删除',
            text: '删除后将无法恢复，所有相关数据也会被删除',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: '确认删除',
            cancelButtonText: '取消'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(contextPath + '/conference/delete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'id=' + conferenceId
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.code === 200) {
                            Swal.fire({
                                icon: 'success',
                                title: '删除成功',
                                timer: 1500,
                                showConfirmButton: false
                            }).then(() => {
                                loadMyConferences();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '删除失败',
                                text: data.msg
                            });
                        }
                    });
            }
        });
    }

    // 显示邀请码模态框
    function showInviteCodeModal(conferenceId, existingCode) {
        document.getElementById('currentConferenceId').value = conferenceId;
        const codeDisplay = document.getElementById('inviteCodeDisplay');
        const generateBtn = document.getElementById('generateCodeBtn');
        const copyBtn = document.getElementById('copyCodeBtn');

        if (existingCode) {
            codeDisplay.textContent = existingCode;
            codeDisplay.style.fontSize = '2.5rem';
            codeDisplay.style.fontWeight = 'bold';
            codeDisplay.style.letterSpacing = '0.5rem';
            generateBtn.style.display = 'none';
            copyBtn.style.display = 'inline-block';
        } else {
            codeDisplay.textContent = '点击下方按钮生成邀请码';
            codeDisplay.style.fontSize = '1rem';
            codeDisplay.style.fontWeight = 'normal';
            codeDisplay.style.letterSpacing = 'normal';
            generateBtn.style.display = 'inline-block';
            copyBtn.style.display = 'none';
        }

        new bootstrap.Modal(document.getElementById('inviteCodeModal')).show();
    }

    // 生成邀请码
    function generateInviteCode() {
        const conferenceId = document.getElementById('currentConferenceId').value;

        fetch(contextPath + '/conference/genCode', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'id=' + conferenceId
        })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    const codeDisplay = document.getElementById('inviteCodeDisplay');
                    codeDisplay.textContent = data.data;
                    codeDisplay.style.fontSize = '2.5rem';
                    codeDisplay.style.fontWeight = 'bold';
                    codeDisplay.style.letterSpacing = '0.5rem';

                    document.getElementById('generateCodeBtn').style.display = 'none';
                    document.getElementById('copyCodeBtn').style.display = 'inline-block';

                    Swal.fire({
                        icon: 'success',
                        title: '邀请码生成成功',
                        timer: 1000,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '生成失败',
                        text: data.msg
                    });
                }
            });
    }

    // 复制邀请码
    function copyInviteCode() {
        const inviteCode = document.getElementById('inviteCodeDisplay').textContent;
        navigator.clipboard.writeText(inviteCode).then(() => {
            Swal.fire({
                icon: 'success',
                title: '复制成功',
                text: '邀请码已复制到剪贴板',
                timer: 1500,
                showConfirmButton: false
            });
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

    // 格式化为datetime-local格式
    function formatDateTimeLocal(dateStr) {
        if (!dateStr) return '';
        const date = new Date(dateStr);
        return date.toISOString().slice(0, 16);
    }
</script>