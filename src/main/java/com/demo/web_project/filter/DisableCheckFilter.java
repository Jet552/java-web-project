package com.demo.web_project.filter;

import com.demo.web_project.service.UserService;
import com.demo.web_project.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebFilter("/*")
public class DisableCheckFilter implements Filter {

    private UserService userService = new UserService();
    private ObjectMapper mapper = new ObjectMapper();

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path = request.getRequestURI();

        // 白名单放行：登录相关 + 静态资源
        if (path.endsWith("/user/login") || path.endsWith("/user/register")
                || path.endsWith("/user/logout") || path.endsWith("/user/resetPassword")
                || path.endsWith("/login.jsp") || path.endsWith("/register.jsp")
                || path.endsWith("/forgetPassword.jsp")
                || path.contains("/css/") || path.contains("/js/")
                || path.endsWith(".ico") || path.endsWith(".png") || path.endsWith(".jpg")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        // 未登录
        if (session == null || session.getAttribute("user") == null) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                Map<String, Object> result = new HashMap<>();
                result.put("code", 401);
                result.put("msg", "未登录，请重新登录");
                response.getWriter().print(mapper.writeValueAsString(result));
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        // 已登录 → 查数据库最新状态
        User sessionUser = (User) session.getAttribute("user");
        User dbUser = userService.findByUsername(sessionUser.getUsername());

        // 账号已被禁用
        if (dbUser != null && dbUser.getStatus() == 0) {
            session.invalidate();
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                Map<String, Object> result = new HashMap<>();
                result.put("code", 403);
                result.put("msg", "账号已被禁用");
                response.getWriter().print(mapper.writeValueAsString(result));
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        chain.doFilter(req, res);
    }
}