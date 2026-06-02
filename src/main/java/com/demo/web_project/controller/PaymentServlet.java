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
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/payment/*")
public class PaymentServlet extends HttpServlet {

    private ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    private PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            switch (path) {
                case "/history":
                    handleHistory(req,resp);
                    break;
                case "/single":
                    handleSingle(req, resp);
                    break;
                default:
                    sendError(resp, 404, "接口不存在");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "服务器内部错误");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String path = req.getPathInfo();
        if (path == null) path = "";

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(resp, 401, "请先登录");
            return;
        }

        try {
            switch (path) {
                case "/create":
                    handleCreate(req, resp);
                    break;
                case "/delete":
                    handleDelete(req, resp);
                    break;
                case "/pay":
                    handlePay(req, resp);
                    break;
                default:
                    sendError(resp, 404, "接口不存在");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "服务器内部错误");
        }
    }

    /**
     * 这个是GET！ /payment/history获取当前用户的缴费记录
     */
    private void handleHistory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print(mapper.writeValueAsString(buildResult(401, "未登录", null)));
            out.flush();
            out.close();
            return;
        }
        User currentUser = (User) session.getAttribute("user");

        List<Payment> paymentList = paymentService.findByUserID(currentUser.getId());

        List<Map<String, Object>> paymentDataList = new ArrayList<>();
        int totalPaid = 0;
        int totalUnpaid = 0;
        double totalAmount = 0;

        for (Payment payment : paymentList) {
            Map<String, Object> paymentData = new HashMap<>();
            paymentData.put("id", payment.getId());
            paymentData.put("attendee_id", payment.getAttendee_id());
            paymentData.put("conference_id", payment.getConference_id());
            paymentData.put("conferenceName", payment.getConferenceTitle());
            paymentData.put("conferenceStartDate", payment.getConferenceStartDate());
            paymentData.put("conferenceEndDate", payment.getConferenceEndDate());
            paymentData.put("amount", payment.getAmount());
            paymentData.put("status", payment.getStatus());
            paymentData.put("paidAt", payment.getPaid_at());
            paymentData.put("attendee_status", payment.getAttendee_status());

            paymentDataList.add(paymentData);

            if ("paid".equals(payment.getStatus())) {
                totalPaid++;
                totalAmount += payment.getAmount();
            } else {
                totalUnpaid++;
            }
        }

        Map<String, Object> statistics = new HashMap<>();
        statistics.put("totalCount", paymentList.size());
        statistics.put("paidCount", totalPaid);
        statistics.put("unpaidCount", totalUnpaid);
        statistics.put("totalAmount", totalAmount);

        Map<String, Object> result = buildResult(200, "成功", paymentDataList);
        result.put("statistics", statistics);
        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }

    /**
     * 这个是GET！ /payment/single获取当前用户的一条缴费记录
     */
    private void handleSingle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String attendeeIdStr=req.getParameter("attendee_id");
        if (attendeeIdStr == null || attendeeIdStr.trim().isEmpty()) {
            sendError(resp, 400, "会议记录ID不能为空");
            return;
        }
        int attendee_id=Integer.parseInt(attendeeIdStr);
        Payment payment=paymentService.findByAttendeeId(attendee_id);

        Map<String, Object> result = buildResult(200, "成功", payment);

        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }

    /**
     * POST /payment/create创建缴费记录
     */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        int attendeeId = Integer.parseInt(req.getParameter("attendee_id"));
        double amount = Double.parseDouble(req.getParameter("amount"));

        Payment payment = new Payment();
        payment.setAttendee_id(attendeeId);
        payment.setStatus("unpaid");
        payment.setAmount(amount);
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        payment.setPaid_at(timestamp.toLocalDateTime());

        boolean success = paymentService.save(payment);

        if (success) {
            Map<String, Object> data = new HashMap<>();
            data.put("paymentId", payment.getId());
            Map<String, Object> result = buildResult(200, "成功提交", data);
            out.print(mapper.writeValueAsString(result));
        } else {
            sendError(resp, 400, "创建缴费记录失败");
        }
        out.flush();
        out.close();
    }

    /**
     * POST /payment/delete删除缴费记录
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        int attendeeId = Integer.parseInt(req.getParameter("attendee_id"));
        boolean success = paymentService.deleteByAttendeeId(attendeeId);

        if (success) {
            out.print(mapper.writeValueAsString(buildResult(200, "成功删除", null)));
        } else {
            sendError(resp, 400, "删除失败");
        }
        out.flush();
        out.close();
    }

    /**
     * POST /payment/pay执行缴费（更新状态为 paid）
     */
    private void handlePay(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        int attendeeId = Integer.parseInt(req.getParameter("attendee_id"));
        boolean success = paymentService.updateStatus(attendeeId, "paid");

        if (success) {
            out.print(mapper.writeValueAsString(buildResult(200, "缴费成功", null)));
        } else {
            sendError(resp, 400, "缴费失败");
        }
        out.flush();
        out.close();
    }

    private void sendError(HttpServletResponse resp, int code, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print(mapper.writeValueAsString(buildResult(code, msg, null)));
        out.flush();
        out.close();
    }

    private Map<String, Object> buildResult(int code, String msg, Object data) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("msg", msg);
        map.put("data", data);
        return map;
    }
}
