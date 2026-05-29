package com.demo.web_project.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.demo.web_project.vo.User;
import com.demo.web_project.service.UserService;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

//URL映射，servlet
@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    // 创建 ObjectMapper 时注册 JavaTimeModule
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        mapper.registerModule(new JavaTimeModule());
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out =response.getWriter();

        //创建Session
        HttpSession session=request.getSession();
        User user=null;
        if(session!=null)
        {
            user=(User) session.getAttribute("user");
        }
        if(user!=null)//用户存在返回信息
        {
            writeSuccessData(out,200,"已登录",user);
        }
        else//用户不存在
        {
            writeErrorData(out,401,"未登录");
        }
    }

    private void writeSuccessData(PrintWriter out,int code,String message,User user)throws IOException{
        Map<String, Object> data = new HashMap<>();
        data.put("phone", user.getPhone());
        data.put("username", user.getUsername());
        data.put("role", user.getRole());
        data.put("email", user.getEmail());
        data.put("createdDate", user.getCreatedDate().toString());
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("msg", message);
        result.put("data", data);
        // 转成 JSON 字符串并输出
        String jsonStr = mapper.writeValueAsString(result);
        out.print(jsonStr);
    }
    private void writeErrorData(PrintWriter out,int code,String message)throws IOException{
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("msg", message);
        result.put("data", null);
        // 转成 JSON 字符串并输出
        String jsonStr = mapper.writeValueAsString(result);
        out.print(jsonStr);
    }
}


