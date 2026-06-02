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

@WebServlet("/payment/history")
public class GetPaymentServlet extends HttpServlet {

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        try {
            // 获取当前登录用户
            HttpSession session = request.getSession(false);
            if (session == null) {
                result.put("code", 401);
                result.put("msg", "未登录");
                out.print(mapper.writeValueAsString(result));
                return;
            }
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                result.put("code", 401);
                result.put("msg", "未登录");
                out.print(mapper.writeValueAsString(result));
                return;
            }

            List<Payment> paymentList = paymentService.findByUserID(currentUser.getId());


            List<Map<String, Object>> paymentDataList = new ArrayList<>();
            int totalPaid = 0;
            int totalUnpaid = 0;
            double totalAmount = 0;

            for (Payment payment : paymentList) {
                Map<String, Object> paymentData = new HashMap<>();
                paymentData.put("id", payment.getId());
                paymentData.put("attendee_id",payment.getAttendee_id());
                paymentData.put("conference_id", payment.getConference_id());
                paymentData.put("conferenceName",payment.getConferenceTitle());
                paymentData.put("conferenceStartDate", payment.getConferenceStartDate());
                paymentData.put("conferenceEndDate", payment.getConferenceEndDate());
                paymentData.put("amount", payment.getAmount());
                paymentData.put("status", payment.getStatus());
                paymentData.put("paidAt", payment.getPaid_at());
                paymentData.put("attendee_status", payment.getAttendee_status());

                paymentDataList.add(paymentData);

                // 统计
                if ("paid".equals(payment.getStatus())) {
                    totalPaid++;
                    totalAmount += payment.getAmount();
                } else {
                    totalUnpaid++;
                }
            }

            // 构建统计数据
            Map<String, Object> statistics = new HashMap<>();
            statistics.put("totalCount", paymentList.size());
            statistics.put("paidCount", totalPaid);
            statistics.put("unpaidCount", totalUnpaid);
            statistics.put("totalAmount", totalAmount);

            result.put("code", 200);
            result.put("msg", "成功");
            result.put("data", paymentDataList);
            result.put("statistics", statistics);

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

