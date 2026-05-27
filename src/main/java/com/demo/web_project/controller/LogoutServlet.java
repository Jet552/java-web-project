package com.demo.web_project.controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/user/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //获取 Session
        HttpSession session = request.getSession(false);
        if (session != null) {
            //方式1：只移除 user 属性
            session.removeAttribute("user");
            //方式2：销毁整个 Session
            //session.invalidate();
        }
        // 重定向到登录页
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}