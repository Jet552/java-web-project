package com.demo.web_project.controller;
import com.demo.web_project.service.AttendeeService;
import com.demo.web_project.service.ConferenceService;
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
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@WebServlet("/attendee/cancel")
public class CancelAttendee extends HttpServlet{
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        int atten_id=Integer.parseInt(request.getParameter("atten_id"));
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        if(attendeeService.cancelAttendee(atten_id)){
            result.put("code", 200);
            result.put("msg", "取消参加成功");
            // 转成 JSON 字符串并输出
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        else {
            result.put("code", 300);
            result.put("msg", "取消失败!");
            // 转成 JSON 字符串并输出
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        out.flush();
        out.close();
    }
}
