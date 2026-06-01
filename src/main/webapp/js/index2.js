
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


// ========== 下拉菜单初始化 ==========
document.addEventListener('DOMContentLoaded', function() {
    console.log('页面加载完成，初始化下拉菜单...');
    initDropdownMenu();
    initSubMenuClick();
});

/**
 * 初始化下拉菜单（展开/收起）
 */
function initDropdownMenu() {
    const toggles = document.querySelectorAll('.nav-toggle');
    console.log('找到 toggle 数量:', toggles.length);

    toggles.forEach(function(toggle, index) {
        // 移除可能存在的旧事件
        toggle.removeEventListener('click', toggleClickHandler);
        // 添加新事件
        toggle.addEventListener('click', toggleClickHandler);
    });
}

/**
 * 下拉菜单点击处理函数
 */
function toggleClickHandler(e) {
    e.preventDefault();
    e.stopPropagation();

    const groupName = this.getAttribute('data-group');
    console.log('点击菜单 group:', groupName);

    // 找到对应的子菜单
    const submenu = document.querySelector('.nav-submenu[data-parent="' + groupName + '"]');
    console.log('找到子菜单:', submenu);

    if (submenu) {
        // 切换 show 类
        submenu.classList.toggle('show');
        // 切换当前菜单的 active 类（用于旋转箭头）
        this.classList.toggle('active');

        console.log('子菜单 show 类状态:', submenu.classList.contains('show'));
    } else {
        console.log('未找到子菜单，data-parent="' + groupName + '"');
    }
}

/**
 * 初始化菜单点击事件（包括直接点击和子菜单）
 */
function initSubMenuClick() {
    // 1. 处理直接点击的菜单（无子菜单，如首页）
    const directLinks = document.querySelectorAll('.nav-direct');

    directLinks.forEach(function(link) {
        // 移除旧事件，避免重复绑定
        link.removeEventListener('click', directClickHandler);
        link.addEventListener('click', directClickHandler);
    });

    // 2. 处理子菜单项（有下拉的）
    const subLinks = document.querySelectorAll('.nav-sub-link');

    subLinks.forEach(function(link) {
        link.removeEventListener('click', subMenuClickHandler);
        link.addEventListener('click', subMenuClickHandler);
    });
}

/**
 * 直接菜单点击处理（首页等）
 */
function directClickHandler(e) {
    e.preventDefault();
    e.stopPropagation();

    // 移除所有菜单的 active 状态
    document.querySelectorAll('.nav-direct, .nav-sub-link').forEach(function(l) {
        l.classList.remove('active');
    });
    this.classList.add('active');

    // 获取页面标识
    const page = this.getAttribute('data-page');

    if (page) {
        loadPage(page);
    }
}

/**
 * 子菜单点击处理
 */
function subMenuClickHandler(e) {
    e.preventDefault();
    e.stopPropagation();

    // 移除所有菜单的 active 状态
    document.querySelectorAll('.nav-direct, .nav-sub-link').forEach(function(l) {
        l.classList.remove('active');
    });
    this.classList.add('active');

    // 获取页面标识
    const page = this.getAttribute('data-page');

    if (page) {
        loadPage(page);
    }
}

/**
 * 异步加载页面
 */
function loadPage(pageName) {
    showLoading(true);

    let url = getPageUrl(pageName);

    fetch(url, {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('HTTP ' + response.status);
            }
            return response.text();
        })
        .then(function(html) {
            var container = document.getElementById('pageContent');
            container.innerHTML = html;
            // 执行内联 <script> 标签（innerHTML 不会自动执行脚本）
            var scripts = container.querySelectorAll('script');
            scripts.forEach(function(oldScript) {
                var newScript = document.createElement('script');
                newScript.textContent = oldScript.textContent;
                oldScript.parentNode.replaceChild(newScript, oldScript);
            });
            showLoading(false);
            window.scrollTo(0, 0);
        })
        .catch(function(error) {
            document.getElementById('pageContent').innerHTML =
                '<div class="content-wrapper"><div class="alert alert-danger">页面加载失败，请刷新重试</div></div>';
            showLoading(false);
        });
}

/**
 * 获取页面URL映射
 */
function getPageUrl(pageName) {
    var urlMap = {
        'default': contextPath + '/attendee/default.jsp',
        'conferenceHall': contextPath + '/attendee/conferenceHall.jsp',
        'joinConference': contextPath + '/attendee/joinConference.jsp',
        'myConferences': contextPath + '/attendee/myConferences.jsp',
        'checkin': contextPath + '/checkin_manage.jsp',
        'room': contextPath + '/room_manage.jsp',
        'conferencePayment': contextPath + '/attendee/conferencePayment.jsp',
        'meetingSearch': contextPath + '/attendee/meetingSearch.jsp',
    };

    return urlMap[pageName] || contextPath + '/index2.jsp';
}

/**
 * 显示/隐藏加载动画
 */
function showLoading(show) {
    var overlay = document.getElementById('loadingOverlay');
    if (!overlay) {
        var div = document.createElement('div');
        div.id = 'loadingOverlay';
        div.className = 'loading-overlay';
        div.innerHTML = '<div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status"><span class="visually-hidden">加载中...</span></div>';
        document.body.appendChild(div);
        overlay = div;
    }
    overlay.style.display = show ? 'flex' : 'none';
}

/**
 * 显示功能开发中提示
 */
function showDeveloping(featureName) {
    Swal.fire({
        icon: 'info',
        title: '功能开发中',
        text: '"' + featureName + '" 功能正在开发中，敬请期待！',
        confirmButtonText: '知道了',
        confirmButtonColor: '#667eea'
    });
}
