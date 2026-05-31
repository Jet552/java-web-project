package com.demo.web_project.controller;

import com.demo.web_project.service.PaymentService;
import com.demo.web_project.vo.Payment;
import com.demo.web_project.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.service.ConferenceService;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;

@WebServlet("/payment/pay")
public class StartPayServlet extends HttpServlet {

    private ObjectMapper mapper;
    private PaymentService paymentService = new PaymentService();

    @Override
    public void init() throws ServletException {
        // 初始化 ObjectMapper，支持 Java 8 时间类型
        mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> dataj = new HashMap<>();

        try {
            // 获取当前登录用户
            HttpSession session = request.getSession(false);
            User currentUser = (User) session.getAttribute("user");

            String status=request.getParameter("status");
            paymentService.updateStatus(currentUser.getId(),status);
            dataj.put("paymentId",currentUser.getId());
            result.put("code",200);
            result.put("msg","缴费成功");
            result.put("data",dataj);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "服务器内部错误：" + e.getMessage());
            result.put("data", null);
        }

        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }
}