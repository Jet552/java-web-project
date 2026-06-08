// common.js — 全局 fetch 拦截器（每个页面都要引用）
(function() {
    var originalFetch = window.fetch;
    window.fetch = function(url, options) {
        // 自动给所有 fetch 请求加上 X-Requested-With 头，确保后端 Filter 识别为 AJAX
        options = options || {};
        options.headers = options.headers || {};
        if (!options.headers['X-Requested-With'] && typeof options.headers.append !== 'function') {
            options.headers['X-Requested-With'] = 'XMLHttpRequest';
        }
        return originalFetch.call(this, url, options).then(function(response) {
            var cloned = response.clone();
            return cloned.json().then(function(data) {
                if (data.code === 401) {
                    // 先关掉 loading 遮罩，否则 Swal 被挡住点不到
                    var overlay = document.getElementById('loadingOverlay');
                    if (overlay) overlay.style.display = 'none';
                    Swal.fire({
                        icon: 'warning',
                        title: '登录已过期',
                        text: data.msg || '请重新登录',
                        confirmButtonColor: '#1890ff',
                        allowOutsideClick: false
                    }).then(function() {
                        window.location.href = (window.contextPath || '') + '/login.jsp';
                    });
                    return new Promise(function() {});
                }
                if (data.code === 403) {
                    var overlay = document.getElementById('loadingOverlay');
                    if (overlay) overlay.style.display = 'none';
                    Swal.fire({
                        icon: 'error',
                        title: '账号已被禁用',
                        text: data.msg || '您的账号已被管理员禁用',
                        confirmButtonColor: '#f56565',
                        allowOutsideClick: false
                    }).then(function() {
                        window.location.href = (window.contextPath || '') + '/login.jsp';
                    });
                    return new Promise(function() {});
                }
                return response;
            }).catch(function(e) {
                return response;
            });
        });
    };
})();