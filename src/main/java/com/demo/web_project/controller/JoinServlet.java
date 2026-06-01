package com.demo.web_project.controller;

import com.demo.web_project.service.AttendeeService;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/attendee/join")
public class JoinServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();
    private AttendeeService attendeeService=new AttendeeService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        try {
            // 登录校验
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                result.put("code", 401);
                result.put("msg", "请先登录");
                out.print(mapper.writeValueAsString(result));
                return;
            }
            User user = (User) session.getAttribute("user");
            int user_id = user.getId();

            // 必传参数判空
            String conferenceIdStr = request.getParameter("conferenceId");
            String arrivalTimeStr = request.getParameter("arrivalTime");
            String departureTimeStr = request.getParameter("departureTime");
            String accommodationType = request.getParameter("accommodationType");

            if (conferenceIdStr == null || arrivalTimeStr == null || departureTimeStr == null || accommodationType == null) {
                result.put("code", 400);
                result.put("msg", "参数不完整");
                out.print(mapper.writeValueAsString(result));
                return;
            }

            // 解析参数
            int conference_id = Integer.parseInt(conferenceIdStr);
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime arrivalTime = LocalDateTime.parse(arrivalTimeStr, fmt);
            LocalDateTime departureTime = LocalDateTime.parse(departureTimeStr, fmt);
            String requirements = request.getParameter("requirements");

            // 参会提交
            Attendee attendee = new Attendee(user_id, conference_id, arrivalTime, departureTime, accommodationType, requirements);
            if (attendeeService.createAttend(attendee)) {
                result.put("code", 200);
                result.put("msg", "参加成功");
            } else {
                result.put("code", 300);
                result.put("msg", "不可重复参加同一场会议!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "服务器错误");
        }

        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }
}