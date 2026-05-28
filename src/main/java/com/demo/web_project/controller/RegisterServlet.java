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
        String email=request.getParameter("phone");
        String role = "0";
        // 调用 Service 验证
        User user = userService.login(username, password);
        PrintWriter out = response.getWriter();
        //不存在该用户，可以创建
//        if(userService.findByUsername(username)==null){
//            if (userService.save())
//            Map<String, Object> data = new HashMap<>();
//            Map<String, Object> result = new HashMap<>();
//            result.put("code", 200);
//            result.put("msg", "登录成功");
//            result.put("data", data);
//        }
        //否则报错，用户已存在
//        else{
//            Map<String, Object> data = new HashMap<>();
//            Map<String, Object> result = new HashMap<>();
//            result.put("code", 400);
//            result.put("msg", "登录失败");
//            result.put("data", data);
//        }
        if (user != null) {
            HttpSession session = request.getSession();  //获取 Session（不存在则自动创建）
            session.setAttribute("user", user);       //存入用户对象
            //设置 Session 过期时间30分钟（单位：秒）
            session.setMaxInactiveInterval(30 * 60);
            // 构造成功响应数据
            Map<String, Object> data = new HashMap<>();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("role", user.getRole());
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("msg", "登录成功");
            result.put("data", data);
            // 转成 JSON 字符串并输出
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        else {
            // 登录失败
            Map<String, Object> result = new HashMap<>();
            result.put("code", 400);
            result.put("msg", "用户名或密码错误");
            result.put("data", null);
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        out.flush();
        out.close();
    }
}
