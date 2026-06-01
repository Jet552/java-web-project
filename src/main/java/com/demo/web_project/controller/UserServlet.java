package com.demo.web_project.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
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
import java.util.List;
import java.util.Map;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private UserService userService=new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        switch (pathInfo) {
            case "/profile":
                getProfile(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendError(404);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        switch (pathInfo) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            case "/update":
                updateInfo(request, response);
                break;
            case "/changePassword":
                updatePassword(request, response);
                break;
            default:
                response.sendError(404);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 登录逻辑
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        // 接收参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        // 调用 Service 验证

        User user = userService.login(username, password);
        PrintWriter out = response.getWriter();
        // 登录成功
        if (user != null&&user.getStatus()!=0) {
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
            // 登录失败：区分"用户不存在"、"密码错误"和"账号被禁用"
            Map<String, Object> result = new HashMap<>();
            result.put("data", null);
            // 先查用户是否存在
            User existUser = userService.findByUsername(username);
            if (existUser == null) {
                result.put("code", 400);
                result.put("msg", "用户名或密码错误");
            } else if (existUser.getStatus() == 0) {
                result.put("code", 400);
                result.put("msg", "对不起，账号已被禁用");
            } else {
                result.put("code", 400);
                result.put("msg", "用户名或密码错误");
            }
            String jsonStr = mapper.writeValueAsString(result);
            out.print(jsonStr);
        }
        out.flush();
        out.close();
    }
    private void register(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 注册逻辑
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
        out.flush();
        out.close();
    }
    private void updateInfo(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 更新逻辑
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        //从 Session 获取当前登录用户
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if ((phone == currentUser.getPhone() || phone.trim().isEmpty()) &&
                (email == currentUser.getEmail() || email.trim().isEmpty())) {
            result.put("code", 400);
            result.put("msg", "请填写正确的信息");
            result.put("data", null);
            out.print(mapper.writeValueAsString(result));
            out.flush();
            out.close();
            return;
        }

        boolean completed = userService.updateUserInfo(currentUser.getId(), phone, email);

        if (completed) {
            User updatedUser = userService.findByUsername(currentUser.getUsername());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            result.put("code", 200);
            result.put("msg", "修改成功");
            result.put("data", null);
        } else {
            result.put("code", 500);
            result.put("msg", "更新失败，存在错误");
            result.put("data", null);
        }

        String jsonStr = mapper.writeValueAsString(result);
        out.print(jsonStr);
        out.flush();
        out.close();
    }
    private void getProfile(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 获取个人信息
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
    private void logout(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 退出逻辑
        //获取 Session
        HttpSession session = request.getSession(false);
        if (session != null) {
            //方式1：只移除 user 属性
            session.removeAttribute("user");
            //方式2：销毁整个 Session
            //session.invalidate();
        }
        // 重定向到登录页
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    private void updatePassword(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        // 更新密码逻辑
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        // 2. 从 Session 获取当前登录用户
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");

        // 3. 接收参数
        String password = request.getParameter("password");

        boolean completed = userService.updateUserPassword(currentUser.getId(),password);

        if (completed) {
            User updatedUser = userService.findByUsername(currentUser.getUsername());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            result.put("code", 200);
            result.put("msg", "修改密码成功");
            result.put("data", null);
        } else {
            result.put("code", 500);
            result.put("msg", "修改失败，存在错误");
            result.put("data", null);
        }

        String jsonStr = mapper.writeValueAsString(result);
        out.print(jsonStr);
        out.flush();
        out.close();
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
