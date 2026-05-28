
function showProfile() {

    // 构建请求参数
    var url = contextPath + '/user/profile';

    // 发送登录请求
    fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
        // 不需要 body 参数
    })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            // 处理响应数据
            if(data.code==200) {
                window.location.href = contextPath + '/profile.jsp';
            }
            else if(data.code==401) {
                Swal.fire({
                    icon: 'error',
                    title: '未登录',
                    text: "未登录状态，请登录",
                    confirmButtonColor: '#f56565'
                }).then(function() {
                    window.location.href = contextPath + '/login.jsp';
                });
            }
        })
        .catch(function(error) {
            // 处理错误
            handleError(error)
        });
}



/**
 * 处理登录错误
 * @param {Error} error 错误对象
 */
function handleError(error) {
    console.error('请求失败:', error);
    showError('网络错误，请稍后重试');
}

/**
 * 显示错误提示
 */
function showError() {
    Swal.fire({
        icon: 'error',
        title: '出现错误',
        text: 'index2.jsp个人中心出现错误',
        confirmButtonColor: '#f56565'
    });
}