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
import java.util.HashMap;
import java.util.Map;
@WebServlet("/attendee/checkStatus")
public class CheckStatusServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user=(User)session.getAttribute("user");//获取user的各种数据
        int user_id = user.getId();//获取userid
        int conference_id=Integer.parseInt(request.getParameter("conferenceId"));
        // 调用 Service 验证
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        if(attendeeService.checkAttendeesStatus(user_id,conference_id).getId()==0){//不存在已参加的记录
            result.put("code", 200);
            result.put("msg", "可以参加");;
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        else{
            result.put("code", 300);
            result.put("msg", "不可重复参加");
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        //不存在该用户，可以创建
        out.flush();
        out.close();
    }
}

