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
import java.time.LocalDateTime;
//URL映射，servlet
@WebServlet("/user/register")
public class RegisterServlet extends HttpServlet{
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private UserService userService=new UserService();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        // 接收参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone=request.getParameter("phone");
        String email=request.getParameter("email");
        // 调用 Service 验证
        PrintWriter out = response.getWriter();
        //不存在该用户，可以创建
        if(userService.findByUsername(username)!=null){
            Map<String, Object> result = new HashMap<>();
            result.put("code", 400);
            result.put("msg", "用户名已存在");
            // 转成 JSON 字符串并输出
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        //否则报错，用户已存在
        else if(userService.findByPhone(phone)!=null||userService.findByEmail(email)!=null){
            Map<String, Object> result = new HashMap<>();
            result.put("code", 500);
            result.put("msg", "注册用的手机或邮箱已存在");
            // 转成 JSON 字符串并输出
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        else{
            User user = new User(username,password,phone,email);
            if (userService.save(user)) {
                Map<String, Object> result = new HashMap<>();
                result.put("code", 200);
                result.put("msg", "您的账户已成功创建，正在跳转到登录页面...");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                result.put("code", 300);
                result.put("msg", "注册失败");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
        }
    }
}
