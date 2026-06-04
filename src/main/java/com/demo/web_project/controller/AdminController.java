package com.demo.web_project.controller;

import com.demo.web_project.service.ConferenceService;
import com.demo.web_project.service.StatisticsService;
import com.demo.web_project.service.UserService;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Conference;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private ObjectMapper mapper = new ObjectMapper();
    private UserService userService = new UserService();
    private ConferenceService conferenceService = new ConferenceService();
    private StatisticsService statisticsService = new StatisticsService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        switch (path) {
            case "/users":
                getAllUsers(request, response);
                break;
            case "/conferences":
                getAllConferences(request, response);
                break;
            case "/pending":
                getPendingConferences(request, response);
                break;
            case "/stats":
                getStatistics(request, response);
                break;
            case "/attendees":
                getAllAttendees(request, response);
                break;
            case "/payments":
                getAllPayments(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

        if (!isAdmin(request)) {
            sendErrorResponse(response, 403, "无权限访问");
            return;
        }

        switch (path) {
            case "/ban":
                banUser(request, response);
                break;
            case "/unban":
                unbanUser(request, response);
                break;
            case "/approve":
                approveConference(request, response);
                break;
            case "/reject":
                rejectConference(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        User user = (User) session.getAttribute("user");
        return user != null && user.getRole() == 1;
    }

    private void getAllUsers(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String roleParam = request.getParameter("role");
        String statusParam = request.getParameter("status");
        
        List<User> users;
        if (roleParam != null && roleParam.equals("1")) {
            users = userService.findByRole(1);
        } else if (statusParam != null && statusParam.equals("0")) {
            users = userService.findByStatus(0);
        } else {
            users = userService.findAll();
        }
        
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(users);
        response.getWriter().write(json);
    }

    private void getAllConferences(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String statusParam = request.getParameter("status");
        
        List<Conference> conferences;
        if (statusParam != null && !statusParam.isEmpty() && !"all".equals(statusParam)) {
            conferences = conferenceService.findByStatus(statusParam);
        } else {
            conferences = conferenceService.findAllConferences();
        }
        
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(conferences);
        response.getWriter().write(json);
    }

    private void getPendingConferences(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Conference> conferences = conferenceService.findPendingConferences();
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(conferences);
        response.getWriter().write(json);
    }

    private void getAllAttendees(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Attendee> attendees = conferenceService.findAllAttendees();
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(attendees);
        response.getWriter().write(json);
    }

    private void getAllPayments(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String statusParam = request.getParameter("status");
        
        List<Payment> payments;
        if (statusParam != null && statusParam.equals("paid")) {
            payments = conferenceService.findPaymentsByStatus("paid");
        } else {
            payments = conferenceService.findAllPayments();
        }
        
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(payments);
        response.getWriter().write(json);
    }

    private void getStatistics(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Map<String, Object> stats = statisticsService.getStatistics();
        response.setContentType("application/json;charset=UTF-8");
        String json = mapper.writeValueAsString(stats);
        response.getWriter().write(json);
    }

    private void banUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userService.updateStatus(userId, 0);
        sendResultResponse(response, success, success ? "用户已封禁" : "封禁失败");
    }

    private void unbanUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        boolean success = userService.updateStatus(userId, 1);
        sendResultResponse(response, success, success ? "用户已解封" : "解封失败");
    }

    private void approveConference(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int conferenceId = Integer.parseInt(request.getParameter("conferenceId"));
        String reason = request.getParameter("reason");
        boolean success = conferenceService.approveConference(conferenceId, reason);
        sendResultResponse(response, success, success ? "审核通过" : "审核失败");
    }

    private void rejectConference(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int conferenceId = Integer.parseInt(request.getParameter("conferenceId"));
        String reason = request.getParameter("reason");
        boolean success = conferenceService.rejectConference(conferenceId, reason);
        sendResultResponse(response, success, success ? "已拒绝" : "操作失败");
    }

    private void sendErrorResponse(HttpServletResponse response, int code, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("msg", message);
        response.getWriter().write(mapper.writeValueAsString(result));
    }

    private void sendResultResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();
        result.put("code", success ? 200 : 500);
        result.put("msg", message);
        response.getWriter().write(mapper.writeValueAsString(result));
    }
}