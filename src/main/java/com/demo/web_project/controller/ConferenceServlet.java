package com.demo.web_project.controller;

import com.demo.web_project.service.ConferenceService;
import com.demo.web_project.vo.Conference;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/conference/*")
public class ConferenceServlet extends HttpServlet {
    // 关闭时间戳数组输出，统一返回字符串格式
    private ObjectMapper mapper = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    private ConferenceService conferenceService = new ConferenceService();
    private DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/myList".equals(path)) {
            handleMyList(req, resp);
        } else if ("/detail".equals(path)) {
            handleDetail(req, resp);
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

        List<Conference> list = conferenceService.findByOrganizerId(user.getId());
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String path = req.getPathInfo();
        if (path == null) path = "";

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            sendError(resp, 401, "请先登录");
            return;
        }
        User user = (User) session.getAttribute("user");

        try {
            switch (path) {
                case "/create":
                    handleCreate(req, resp, user);
                    break;
                case "/update":
                    handleUpdate(req, resp, user);
                    break;
                case "/delete":
                    handleDelete(req, resp, user);
                    break;
                case "/genCode":
                    handleGenCode(req, resp, user);
                    break;
                default:
                    sendError(resp, 404, "接口不存在");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, 500, "服务器内部错误");
        }
    }

    /**
     * 从请求中解析并校验会议参数
     * @param req HTTP请求
     * @return 解析后的Conference对象，参数错误返回null
     */
    private Conference parseAndValidateConference(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String venue = req.getParameter("venue");
        String dorms = req.getParameter("dorms");
        String startDateStr = req.getParameter("start_date");
        String endDateStr = req.getParameter("end_date");
        String amountStr = req.getParameter("amount");

        // 参数非空校验
        if (title == null || title.trim().isEmpty() ||
                venue == null || venue.trim().isEmpty() ||
                dorms == null || dorms.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty()) {
            sendError(resp, 400, "参数不完整");
            return null;
        }

        // 解析日期
        LocalDateTime startDate;
        LocalDateTime endDate;
        try {
            startDate = LocalDateTime.parse(startDateStr, dateFormatter);
            endDate = LocalDateTime.parse(endDateStr, dateFormatter);
        } catch (Exception e) {
            sendError(resp, 400, "日期格式错误，请使用yyyy-MM-ddTHH:mm格式");
            return null;
        }

        // 日期逻辑校验
        if (startDate.isAfter(endDate)) {
            sendError(resp, 400, "开始日期不能晚于结束日期");
            return null;
        }

        // 构建并返回Conference对象
        Conference conference = new Conference();
        conference.setTitle(title);
        conference.setDescription(description);
        conference.setVenue(venue);
        conference.setDorms(dorms);
        conference.setStart_date(startDate);
        conference.setEnd_date(endDate);
        conference.setAmount(amountStr != null && !amountStr.trim().isEmpty() ? Double.parseDouble(amountStr) : 0);

        return conference;
    }

    /**
     * 创建会议接口
     */
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        // 调用公共方法解析参数
        Conference conference = parseAndValidateConference(req, resp);
        if (conference == null) {
            return; // 参数错误，公共方法已经发送了错误响应
        }

        // 设置组织者ID
        conference.setOrganizer_id(user.getId());

        // 调用服务创建会议
        int conferenceId = conferenceService.createConference(conference);
        if (conferenceId > 0) {
            Map<String, Object> result = buildResult(200, "创建成功，等待管理员审核", conferenceId);
            PrintWriter out = resp.getWriter();
            out.print(mapper.writeValueAsString(result));
            out.flush();
        } else {
            sendError(resp, 500, "创建失败");
        }
    }

    /**
     * 更新会议接口
     */
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        // 单独获取ID参数（创建不需要ID，更新需要）
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            sendError(resp, 400, "会议ID不能为空");
            return;
        }

        int conferenceId;
        try {
            conferenceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            sendError(resp, 400, "会议ID格式错误");
            return;
        }

        // 调用公共方法解析其他参数
        Conference conference = parseAndValidateConference(req, resp);
        if (conference == null) {
            return;
        }

        // 设置ID
        conference.setId(conferenceId);

        // 调用服务更新会议
        boolean success = conferenceService.updateConference(conference, user.getId());
        if (success) {
            Map<String, Object> result = buildResult(200, "修改成功", null);
            PrintWriter out = resp.getWriter();
            out.print(mapper.writeValueAsString(result));
            out.flush();
        } else {
            sendError(resp, 400, "修改失败，会议不存在或已审核通过");
        }
    }

    /**
     * 删除会议接口
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            sendError(resp, 400, "参数不完整");
            return;
        }

        int conferenceId;
        try {
            conferenceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            sendError(resp, 400, "会议ID格式错误");
            return;
        }

        boolean success = conferenceService.deleteConference(conferenceId, user.getId());
        if (success) {
            Map<String, Object> result = buildResult(200, "删除成功", null);
            PrintWriter out = resp.getWriter();
            out.print(mapper.writeValueAsString(result));
            out.flush();
        } else {
            sendError(resp, 400, "删除失败，会议不存在或无权限");
        }
    }

    /**
     * 生成邀请码接口
     */
    private void handleGenCode(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            sendError(resp, 400, "参数不完整");
            return;
        }

        int conferenceId;
        try {
            conferenceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            sendError(resp, 400, "会议ID格式错误");
            return;
        }

        String inviteCode = conferenceService.generateInviteCode(conferenceId, user.getId());
        if (inviteCode != null) {
            Map<String, Object> result = buildResult(200, "邀请码生成成功", inviteCode);
            PrintWriter out = resp.getWriter();
            out.print(mapper.writeValueAsString(result));
            out.flush();
        } else {
            sendError(resp, 400, "生成失败，会议不存在或未审核通过");
        }
    }

    /**
     * 获取会议详情接口
     */
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            sendError(resp, 400, "参数不完整");
            return;
        }

        int conferenceId;
        try {
            conferenceId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            sendError(resp, 400, "会议ID格式错误");
            return;
        }

        Conference conference = conferenceService.getConferenceById(conferenceId);
        if (conference != null) {
            Map<String, Object> result = buildResult(200, "success", conference);
            PrintWriter out = resp.getWriter();
            out.print(mapper.writeValueAsString(result));
            out.flush();
        } else {
            sendError(resp, 404, "会议不存在");
        }
    }
}
