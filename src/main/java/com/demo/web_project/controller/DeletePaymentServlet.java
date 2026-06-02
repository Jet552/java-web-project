package com.demo.web_project.controller;

import com.demo.web_project.service.AttendeeService;
import com.demo.web_project.service.PaymentService;
import com.demo.web_project.vo.Attendee;
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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;

@WebServlet("/payment/delete")
public class DeletePaymentServlet extends HttpServlet {
    private ObjectMapper mapper;
    private AttendeeService attendeeService = new AttendeeService();
    private PaymentService paymentService = new PaymentService();


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        int attendee_id=Integer.parseInt(request.getParameter("attendee_id"));

        boolean success=paymentService.deleteByAttendeeId(attendee_id);

        if(success) {
            result.put("code", 200);
            result.put("msg", "成功删除");
        } else {
            result.put("code", 400);
            result.put("msg", "删除失败");
        }

        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }
}

