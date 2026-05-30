<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* 欢迎区域 */
        .welcome-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 0;
            margin-bottom: 30px;
            color: #fff;
        }

        .welcome-banner h2 {
            font-weight: 600;
            margin-bottom: 10px;
        }

        .welcome-banner p {
            opacity: 0.9;
            margin: 0;
        }
    </style>
</head>
<body>
<!-- 欢迎区域 -->
<div class="welcome-banner">
    <div class="container-fluid">
        <h2><i class="fas fa-hand-sparkles me-2"></i>欢迎，${username}，发现精彩会议</h2>
        <p>浏览最新会议活动，一键报名参加，享受便捷的会务服务体验。</p>
    </div>
</div>

<!-- 近期推荐会议 -->
<div class="content-wrapper">
    <div class="content-card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5><i class="fas fa-star me-2 text-warning"></i>近期推荐会议</h5>
            <a href="#" class="btn btn-outline-primary btn-sm" onclick="showDeveloping('查看更多')">
                查看更多 <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-custom">
                    <thead>
                    <tr>
                        <th>会议名称</th>
                        <th>时间</th>
                        <th>地点</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- 表格数据 -->
                    <tr>
                        <td>2024年人工智能峰会</td>
                        <td>2024-06-15 至 2024-06-17</td>
                        <td>北京国际会议中心</td>
                        <td><span class="status-badge upcoming">即将开始</span></td>
                        <td>
                            <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                <i class="fas fa-eye me-1"></i>查看
                            </button>
                        </td>
                    </tr>
                    <tr>
                        <td>绿色能源发展论坛</td>
                        <td>2024-06-20 至 2024-06-21</td>
                        <td>上海国际会议中心</td>
                        <td><span class="status-badge upcoming">即将开始</span></td>
                        <td>
                            <button class="btn btn-primary btn-sm" onclick="showDeveloping('查看详情')">
                                <i class="fas fa-eye me-1"></i>查看
                            </button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 底部版权 -->
    <div class="footer">
        <div class="container-fluid">
            <p class="mb-0">
                <i class="fas fa-copyright me-1"></i>2024 会务管理系统. All rights reserved.
                <span class="mx-2">|</span>
                <span class="text-muted">让会议管理更简单</span>
            </p>
        </div>
    </div>
</div>
</body>
</html>
