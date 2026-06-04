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
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int user_id = user.getId();
            int conference_id = Integer.parseInt(request.getParameter("conferenceId"));
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime arrivalTime = LocalDateTime.parse(request.getParameter("arrivalTime"), fmt);
            LocalDateTime departureTime = LocalDateTime.parse(request.getParameter("departureTime"), fmt);
            String accommodationType = request.getParameter("accommodationType");
            String requirements = request.getParameter("requirements");
            String join_source=request.getParameter("join_source");
            Attendee attendee = new Attendee(user_id, conference_id, arrivalTime, departureTime, accommodationType, requirements);
            attendee.setJoin_source(join_source);
            int id=attendeeService.createAttend(attendee);
            if (id!=0) {
                Map<String,Object> data= new HashMap<>();
                data.put("attendee_id",id);
                result.put("data",data);
                result.put("code", 200);
                result.put("msg", "参加成功");
            } else {
                result.put("code", 300);
                result.put("msg", "不可重复参加同一场会议!");
            }
        } catch (Exception e) {
            result.put("code", 500);
            result.put("msg", "服务器错误：" + e.getMessage());
        }
        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }
}
