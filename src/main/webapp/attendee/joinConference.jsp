<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="content-wrapper">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="content-card">
                <div class="card-body p-5 text-center">
                    <div class="mb-4">
                        <i class="fas fa-sign-in-alt fa-5x text-primary mb-3"></i>
                        <h3>加入会议</h3>
                        <p class="text-muted">输入会议邀请码加入会议</p>
                    </div>

                    <form id="joinForm">
                        <div class="mb-4">
                            <input type="text" class="form-control form-control-lg text-center"
                                   id="inviteCodeInput" placeholder="请输入9位邀请码"
                                   maxlength="9" style="font-size: 2rem; letter-spacing: 0.5rem;">
                            <div class="form-text text-muted mt-2">
                                <i class="fas fa-info-circle"></i> 邀请码不区分大小写
                            </div>
                        </div>

                        <button type="button" class="btn btn-primary-custom btn-lg w-100" onclick="joinConference()">
                            <i class="fas fa-arrow-right"></i> 加入会议
                        </button>
                    </form>

                    <div class="mt-4 pt-4 border-top">
                        <p class="text-muted mb-0">
                            没有邀请码？去<a href="#" onclick="loadPage('conferenceHall')">会议大厅</a>浏览公开会议
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 页面加载时聚焦输入框
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('inviteCodeInput').focus();
    });

    // 加入会议
    function joinConference() {
        const inviteCode = document.getElementById('inviteCodeInput').value.trim();

        // 校验空值
        if (!inviteCode) {
            Swal.fire({
                icon: 'error',
                title: '邀请码不能为空',
                text: '请输入9位有效的邀请码'
            });
            return;
        }

        // 校验格式
        if (inviteCode.length !== 9) {
            Swal.fire({
                icon: 'error',
                title: '邀请码格式错误',
                text: '邀请码必须是9位字符'
            });
            return;
        }

        // 第一步：用邀请码搜索会议，确认会议存在
        fetch(contextPath + '/conference/search', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'keyword=' + encodeURIComponent(inviteCode)
        })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200 && data.data) {
                    // 会议存在，跳转到参会登记页填写详细信息
                    var conf = data.data;
                    window.location.href = contextPath + '/attendee/join_meeting.jsp?id='
                        + conf.id + '&invite_codes=' + encodeURIComponent(inviteCode) + '&source=invite';
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: '会议不存在',
                        text: data.msg || '邀请码无效或会议已失效'
                    });
                }
            })
            .catch(err => {
                console.error('请求失败:', err);
                Swal.fire({
                    icon: 'error',
                    title: '网络错误',
                    text: '请求失败，请稍后重试'
                });
            });
    }

    // 回车键提交
    document.getElementById('inviteCodeInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            joinConference();
        }
    });
</script>