package com.demo.web_project.controller;

import com.demo.web_project.service.ConferenceService;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/conference/*")
public class ConferenceServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    private ConferenceService conferenceService = new ConferenceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/myList".equals(path)) {
            handleMyList(req, resp);
        } else {
            sendError(resp, 404, "接口不存在");
        }
    }

    private void handleMyList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print(mapper.writeValueAsString(buildResult(401, "请先登录", null)));
            out.flush(); out.close(); return;
        }
        User user = (User) session.getAttribute("user");

        List<Conference> list = conferenceService.getMyList(user.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("msg", "success");
        result.put("data", list);
        out.print(mapper.writeValueAsString(result));
        out.flush(); out.close();
    }

    private void sendError(HttpServletResponse resp, int code, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(code);
        PrintWriter out = resp.getWriter();
        out.print(mapper.writeValueAsString(buildResult(code, msg, null)));
        out.flush(); out.close();
    }

    private Map<String, Object> buildResult(int code, String msg, Object data) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("msg", msg);
        map.put("data", data);
        return map;
    }
}
