package com.demo.web_project.controller;
import com.demo.web_project.service.AttendeeService;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;
@WebServlet("/attendee/show")
public class ShowMyAttendee extends HttpServlet{
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置编码
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int user_id = user.getId();//获得ID
        PrintWriter out = response.getWriter();
        out.flush();
        out.close();
    }
}
