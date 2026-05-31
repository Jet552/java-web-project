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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/attende/join")
public class JoinServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user=(User)session.getAttribute("user");//获取user的各种数据
        int user_id = user.getId();
        int conference_id=Integer.parseInt(request.getParameter("conference_id"));
        String title=request.getParameter("title");
        Attendee attendee=new Attendee();
        // 调用 Service 验证
        PrintWriter out = response.getWriter();
        //不存在该用户，可以创建
        if(attendeeService.createAttend(attendee)){//创建成功
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("msg", "参加成功");
        }
        else {
            Map<String, Object> result = new HashMap<>();
            result.put("code", 300);
            result.put("msg", "不可重复参加同一场会议!");
        }
        out.flush();
        out.close();
    }
}
