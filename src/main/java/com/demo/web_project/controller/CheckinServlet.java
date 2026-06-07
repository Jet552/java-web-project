package com.demo.web_project.controller;

import com.demo.web_project.service.CheckinService;
import com.demo.web_project.service.AccommodationService;
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

@WebServlet("/checkin/*")
public class CheckinServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    private CheckinService checkinService = new CheckinService();
    private AccommodationService accommodationService = new AccommodationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 根据 URL 路径分发到具体方法
        String path = req.getPathInfo();
        if ("/statistics".equals(path)) {
            handleStatistics(req, resp);
        } else if ("/roomList".equals(path)) {
            handleRoomList(req, resp);
        } else if ("/list".equals(path)) {
            handleList(req, resp);
        } else {
            sendError(resp, 404, "接口不存在");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if ("/doCheckin".equals(path)) {
            handleDoCheckin(req, resp);
        } else if ("/assignRoom".equals(path)) {
            handleAssignRoom(req, resp);
        } else if ("/checkout".equals(path)) {
            handleCheckout(req, resp);
        } else {
            sendError(resp, 404, "接口不存在");
        }
    }

    // ---- 签到相关 ----

    private void handleDoCheckin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        // 验证登录 + 角色
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print(mapper.writeValueAsString(buildResult(401, "请先登录", null)));
            out.flush(); out.close(); return;
        }
        User user = (User) session.getAttribute("user");

        try {
            int attendeeId = Integer.parseInt(req.getParameter("attendeeId"));
            String result = checkinService.doCheckin(attendeeId, user.getId());
            if ("success".equals(result)) {
                out.print(mapper.writeValueAsString(buildResult(200, "签到成功", null)));
            } else {
                out.print(mapper.writeValueAsString(buildResult(400, result, null)));
            }
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        }
        out.flush(); out.close();
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // GET /checkin/list?conferenceId=1
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print(mapper.writeValueAsString(buildResult(401, "请先登录", null)));
            out.flush(); out.close(); return;
        }

        try {
            int conferenceId = Integer.parseInt(req.getParameter("conferenceId"));
            List<Map<String, Object>> list = checkinService.getCheckinList(conferenceId);
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("msg", "success");
            result.put("data", list);
            out.print(mapper.writeValueAsString(result));
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        }
        out.flush(); out.close();
    }

    private void handleStatistics(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int conferenceId = Integer.parseInt(req.getParameter("conferenceId"));
            Map<String, Integer> stats = checkinService.getStatistics(conferenceId);
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("msg", "success");
            result.put("data", stats);
            out.print(mapper.writeValueAsString(result));
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        }
        out.flush(); out.close();
    }

    // ---- 入住相关 ----

    private void handleAssignRoom(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print(mapper.writeValueAsString(buildResult(401, "请先登录", null)));
            out.flush(); out.close(); return;
        }

        try {
            int attendeeId = Integer.parseInt(req.getParameter("attendeeId"));
            String roomNumber = req.getParameter("roomNumber");
            String checkinDate = req.getParameter("checkinDate");
            String checkoutDate = req.getParameter("checkoutDate");

            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                sendError(resp, 400, "房间号不能为空");
                return;
            }

            String result = accommodationService.assignRoom(attendeeId, roomNumber, checkinDate, checkoutDate);
            if ("success".equals(result)) {
                out.print(mapper.writeValueAsString(buildResult(200, "房间分配成功", null)));
            } else {
                out.print(mapper.writeValueAsString(buildResult(400, result, null)));
            }
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        } catch (java.time.format.DateTimeParseException e) {
            sendError(resp, 400, "日期格式错误，正确格式为 yyyy-MM-dd");
            return;
        }
        out.flush(); out.close();
    }

    private void handleRoomList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int conferenceId = Integer.parseInt(req.getParameter("conferenceId"));
            var list = accommodationService.getRoomList(conferenceId);
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("msg", "success");
            result.put("data", list);
            out.print(mapper.writeValueAsString(result));
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        }
        out.flush(); out.close();
    }

    // ---- 退房相关 ----

    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int roomId = Integer.parseInt(req.getParameter("roomId"));
            boolean ok = accommodationService.checkout(roomId);
            if (ok) {
                out.print(mapper.writeValueAsString(buildResult(200, "退房成功", null)));
            } else {
                out.print(mapper.writeValueAsString(buildResult(400, "退房失败", null)));
            }
        } catch (NumberFormatException e) {
            sendError(resp, 400, "参数错误");
            return;
        }
        out.flush(); out.close();
    }

    // ---- 工具方法 ----

    private Map<String, Object> buildResult(int code, String msg, Object data) {
        Map<String, Object> map = new HashMap<>();
        map.put("code", code);
        map.put("msg", msg);
        map.put("data", data);
        return map;
    }

    private void sendError(HttpServletResponse resp, int code, String msg) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setStatus(code);
        PrintWriter out = resp.getWriter();
        out.print(mapper.writeValueAsString(buildResult(code, msg, null)));
        out.flush();
        out.close();
    }
}
