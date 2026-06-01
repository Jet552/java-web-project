/**
 * 参会登记页面 - 交互逻辑
 */
var attendanceStatus = null; // null=未参加, 1=已参加, 0=已取消

(function () {
    'use strict';
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initJoinPage);
    } else {
        initJoinPage();
    }
})();

function initJoinPage() {
    loadConferenceInfo();
    checkAttendanceStatus();
    restoreFormData();  // ← 加这行
}

/**
 * 加载会议信息
 */
function loadConferenceInfo() {
    if (!conferenceId) {
        Swal.fire({ icon: 'error', title: '参数错误', text: '缺少会议ID', confirmButtonColor: '#1890ff' });
        return;
    }
    showLoading(true);
    fetch(contextPath + '/conference/search', { //用邀请码查看，会议是否还存在
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'keyword=' + inviteCodes
    })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            showLoading(false);
            if (data.code === 200 && data.data) {
                var conf = data.data;
                document.getElementById('confTitle').textContent = conf.title || '--';
                document.getElementById('confStartDate').textContent = (conf.start_date || '').replace('T', ' ');
                document.getElementById('confEndDate').textContent = (conf.end_date || '').replace('T', ' ');
                document.getElementById('confVenue').textContent = conf.venue || '--';
                document.getElementById('confDorms').textContent = conf.dorms || '--';
                document.getElementById('confAmount').textContent = conf.amount || '--';
            } else {
                Swal.fire({ icon: 'error', title: '会议不存在', text: '该会议可能已被取消', confirmButtonColor: '#1890ff' });
            }
        })
        .catch(function () {
            showLoading(false);
        });
}

/**
 * 检查是否已经参加过
 */
function checkAttendanceStatus() {
    if (!conferenceId) return;
    var bodyData = 'conferenceId=' + conferenceId
    fetch(contextPath + '/attendee/checkStatus', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: bodyData
    })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            console.log('checkStatus 返回:', JSON.stringify(data)); // ← 加这里
            if (data.code === 300 ) {//查到了已参加的记录
                attendanceStatus = 1;
                setFormDisabled(true);
                document.getElementById('btnJoin').disabled = true;
                document.getElementById('btnPay').disabled = false;
            }
            else if (data.code === 200) {//没有查到记录
                attendanceStatus = 0;
                setFormDisabled(false);
                document.getElementById('btnJoin').disabled = false;
                document.getElementById('btnPay').disabled = true;
            }
        })
        .catch(function () {});
}

/**
 * 提交参会申请
 */
function submitJoin() {
    if (!validateForm()) return;

    var arrivalTime = document.getElementById('arrivalTime').value;
    var departureTime = document.getElementById('departureTime').value;
    // 到达时间必须早于离开时间
    if (arrivalTime >= departureTime) {
        Swal.fire({
            icon: 'warning',
            title: '时间错误',
            text: '预计到达时间必须早于预计离开时间',
            confirmButtonColor: '#1890ff'
        });
        return;
    }
    Swal.fire({
        title: '确认参加',
        text: '请确认您的参会信息无误',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: '确认参加',
        cancelButtonText: '再检查一下',
        confirmButtonColor: '#1890ff',
        cancelButtonColor: '#8c8c8c'
    }).then(function (result) {
        if (result.isConfirmed) {
            doSubmitJoin();
        }
    });
}

function doSubmitJoin() {
    showLoading(true);
    var bodyData = 'conferenceId=' + conferenceId
        + '&arrivalTime=' + encodeURIComponent(document.getElementById('arrivalTime').value)
        + '&departureTime=' + encodeURIComponent(document.getElementById('departureTime').value)
        + '&accommodationType=' + encodeURIComponent(document.getElementById('accommodationType').value)
        + '&requirements=' + encodeURIComponent(document.getElementById('requirements').value);
    fetch(contextPath + '/attendee/join', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: bodyData
    })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            showLoading(false);
            if (data.code === 200) {//创建成功
                attendanceStatus = 1;
                clearFormData();
                // 表单禁用，参加按钮禁用，缴费按钮启用
                setFormDisabled(true);
                document.getElementById('btnJoin').disabled = true;
                document.getElementById('btnPay').disabled = false;
                // 报名成功后创建缴费记录
                createPaymentRecord();
                Swal.fire({
                    icon: 'success',
                    title: '报名成功',
                    text: '您已成功报名该会议，现在可以进行在线缴费',
                    confirmButtonText: '去缴费',
                    showCancelButton: true,
                    cancelButtonText: '稍后再说',
                    confirmButtonColor: '#52c41a',
                    cancelButtonColor: '#8c8c8c'
                }).then(function (result) {
                    if (result.isConfirmed) {
                        goToPayment();
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '报名失败',
                    text: data.msg ,
                    confirmButtonColor: '#1890ff'
                });
            }
        })
        .catch(function () {
            showLoading(false);
            Swal.fire({
                icon: 'error',
                title: '网络错误',
                text: '请求失败，请稍后重试',
                confirmButtonColor: '#1890ff'
            });
        });
}

/**
 * 创建缴费记录
 */
function createPaymentRecord() {
    var paymentBodyData = 'conference_id=' + conferenceId
                + '&amount=' + encodeURIComponent(document.getElementById('confAmount').textContent || '80');
    fetch(contextPath + '/payment/create', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: paymentBodyData
    }).then(function(r) { return r.json(); })
    .then(function(data) {
        if (data.code !== 200) {
            console.error('创建缴费记录失败:', data.msg);
        }
    })
    .catch(function () {
        console.error('创建缴费记录请求失败');
    });
}

/**
 * 跳转缴费页面
 */
function goToPayment() {
    if (!attendanceStatus) {
        Swal.fire({ icon: 'warning', title: '请先报名', text: '请先完成参会登记后再进行缴费', confirmButtonColor: '#1890ff' });
        return;
    }
    fetch(contextPath + '/payment/history', {
        method: 'Get',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    }) .then(function(response) {
        return response.json();
    })
        .then(function(data) {
            if(data.code==200) {
                var allData = data.data; //缴费记录列表
                var paymentList = allData.filter(function(item) {
                    return Number(item.conference_id) === Number(conferenceId) && item.status === "unpaid" && item.attendee_status === 1;
                });
                var payment = paymentList.length > 0 ? paymentList[0] : null;
                var amount = payment ? payment.amount : 0;
                var paymentId = payment ? payment.id : null;
                var attendeeId = payment ? payment.attendee_id : null;

                if (!payment) {
                    Swal.fire({ icon: 'error', title: '错误', text: '未找到待缴费记录', confirmButtonColor: '#f56565' });
                    return;
                }

                Swal.fire({
                    title: '确认缴费',
                    html: '<div class="text-center">' +
                        '<i class="fas fa-credit-card" style="font-size: 48px; color: #667eea;"></i>' +
                        '<p class="mt-3">确认支付 ¥' + parseFloat(amount).toFixed(2) + '</p>' +
                        '</div>',
                    showCancelButton: true,
                    confirmButtonText: '确认支付',
                    cancelButtonText: '取消',
                    confirmButtonColor: '#667eea'
                }).then(function(result) {
                    if (result.isConfirmed) {
                        if (!paymentId && paymentId !== 0) {
                            Swal.fire({ icon: 'error', title: '错误', text: '缴费记录ID无效', confirmButtonColor: '#f56565' });
                            return;
                        }
                        var url = contextPath + '/payment/pay';
                        fetch(url, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: 'amount=' + encodeURIComponent(payment.amount) + '&attendee_id=' + encodeURIComponent(attendeeId)
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
        })
        .catch(function(error) {
            Swal.fire({
                icon: 'failure',
                title: '失败',
                text: '网络出错',
                confirmButtonColor: '#667eea'
            });
        });

    // window.location.href = contextPath + '/attendee/payment.jsp?id=' + attendanceId;
}
/**
 * 表单校验
 */
function validateForm() {
    var arrival = document.getElementById('arrivalTime');
    var departure = document.getElementById('departureTime');
    var valid = true;

    [arrival, departure].forEach(function (el) {
        if (!el.value) {
            el.classList.add('is-invalid');
            valid = false;
        } else {
            el.classList.remove('is-invalid');
        }
    });
    if (!valid) {
        Swal.fire({
            icon: 'warning',
            title: '请完善信息',
            text: '预计到达时间和预计离开时间为必填项',
            confirmButtonColor: '#1890ff'
        });
    }
    return valid;
}

/**
 * 禁用/启用表单
 */
function setFormDisabled(disabled) {
    var inputs = document.querySelectorAll('#joinForm .form-input');
    inputs.forEach(function (el) {
        el.disabled = disabled;
    });
}

/**
 * 加载动画
 */
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
/**
 * 保存表单数据到 localStorage
 */
function saveFormData() {
    var data = {
        arrivalTime: document.getElementById('arrivalTime').value,
        departureTime: document.getElementById('departureTime').value,
        accommodationType: document.getElementById('accommodationType').value,
        requirements: document.getElementById('requirements').value
    };
    localStorage.setItem('joinFormData_' + conferenceId, JSON.stringify(data));
}

/**
 * 从 localStorage 恢复表单数据
 */
function restoreFormData() {
    var saved = localStorage.getItem('joinFormData_' + conferenceId);
    if (!saved) return;
    try {
        var data = JSON.parse(saved);
        if (data.arrivalTime) document.getElementById('arrivalTime').value = data.arrivalTime;
        if (data.departureTime) document.getElementById('departureTime').value = data.departureTime;
        if (data.accommodationType) document.getElementById('accommodationType').value = data.accommodationType;
        if (data.requirements) document.getElementById('requirements').value = data.requirements;
    } catch (e) {}
}

/**
 * 清除表单缓存
 */
function clearFormData() {
    localStorage.removeItem('joinFormData_' + conferenceId);
}