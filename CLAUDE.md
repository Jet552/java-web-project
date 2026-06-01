# CLAUDE.md — 会务管理系统

## 项目概述

Java Web 期末大作业，会务管理系统（6 人小组）。技术栈：Jakarta EE 10 + JSP + Servlet + JDBC + MySQL 8.0 + Bootstrap 5。

## 开发环境

- JDK 21 + Tomcat 10.1 + Maven 3.9
- 包路径：`com.demo.web_project`
- IDE：IntelliJ IDEA
- 数据库：MySQL `web_db`，连接串 `jdbc:mysql://localhost:3306/web_db`

## 代码规范

- VO：私有字段 + getter/setter，无注解
- DAO：接口 + impl 分离，使用 try-with-resources + PreparedStatement
- Service：每个模块一个 Service 类，薄封装调用 DAO
- Servlet：`@WebServlet("/xxx")` 注解声明，ObjectMapper 输出 JSON
- JSP：JSTL + EL 表达式，不嵌入 Java 业务逻辑，用 Bootstrap 5 CDN

## UI 设计规范

### 美学方向：专业商务（Professional Business）
适用于会务管理系统，强调清晰、可信赖、高效的感觉。

### 配色方案（CSS 变量可直接用于 `<style>` 标签）
```css
:root {
    --primary: #1a56db;       /* 主色 - 深蓝，专业感 */
    --primary-light: #e8f0fe; /* 主色浅底 */
    --success: #057a55;       /* 成功绿 */
    --warning: #c27803;       /* 警告橙 */
    --danger: #c81e1e;        /* 危险红 */
    --bg-page: #f3f4f6;       /* 页面底色 */
    --bg-card: #ffffff;       /* 卡片白 */
    --text-main: #111928;     /* 主文字 */
    --text-secondary: #6b7280;/* 辅助文字 */
    --border: #e5e7eb;        /* 边框 */
    --shadow: 0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.06);
}
```

### 排版
- 字体：`'Segoe UI', 'Microsoft YaHei', system-ui, sans-serif`
- 标题：`font-weight: 600`，正文：`font-weight: 400`
- 表格行高：`line-height: 1.6`

### 组件规范
| 组件 | Bootstrap 类 | 说明 |
|------|-------------|------|
| 页面底色 | `bg-light` | #f3f4f6 |
| 卡片 | `card shadow-sm border-0` | 白色圆角卡片，无边框，微阴影 |
| 表格 | `table table-hover align-middle` | 悬停高亮，垂直居中 |
| 主按钮 | `btn btn-primary btn-sm` | 深蓝底色，小尺寸 |
| 危险按钮 | `btn btn-danger btn-sm` | 红色，用于删除/取消 |
| 表单 | `form-control form-control-sm` | 小尺寸输入框 |
| 标签/徽章 | `badge rounded-pill` | 胶囊型标签 |
| 统计卡片 | 白底 + 左侧色条（4px 左边框） | 不用满底色的卡片 |

### 布局
- 侧边栏：深色背景 `bg-dark`，宽度 240-250px
- 主内容区：`bg-light`，内边距 `p-4`
- 页面标题：`<h5 class="mb-4 fw-bold">` + Font Awesome 图标

### JSP 页面通用 CDN
```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
```

### 注意事项
- 不要用 emoji 做图标，用 Font Awesome
- 不要用 `alert` 弹窗，用 SweetAlert2
- 不要用内联 style，优先用 Bootstrap 工具类
- 移动端不做适配（课程要求是桌面端展示）

## M5 模块（签到与入住管理）

- 分支：`feature/checkin`
- 依赖：M1（Session 登录态）+ M2（/conference/myList）+ M3（attendees 表）
- 详见 memory 中的 [M5 Checkin Module]
