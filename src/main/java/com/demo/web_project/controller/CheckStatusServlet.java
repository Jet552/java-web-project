package com.demo.web_project.controller;
import com.demo.web_project.service.AttendeeService;
import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.AccommodationDao;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.dao.impl.AccommodationDaoImpl;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Checkin;
import com.demo.web_project.vo.Accommodation;
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

@WebServlet("/attendee/checkStatus")
public class CheckStatusServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    private AttendeeService attendeeService = new AttendeeService();
    private CheckinDao checkinDao = new CheckinDaoImpl();
    private AccommodationDao accommodationDao = new AccommodationDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int userId = user.getId();
        int conferenceId = Integer.parseInt(request.getParameter("conferenceId"));

        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        int attendeeId = attendeeService.checkAttendeesStatus(userId, conferenceId);
        if (attendeeId == 0) {
            // 未报名
            result.put("code", 200);
            result.put("msg", "可以参加");
            result.put("data", null);
        } else {
            // 已报名：返回参会详情 + M5状态
            result.put("code", 300);
            result.put("msg", "不可重复参加");

            Map<String, Object> data = new HashMap<>();
            // 获取参会记录
            List<Attendee> attendeeList = attendeeService.checkAttendees(userId);
            for (Attendee a : attendeeList) {
                if (a.getConference_id() == conferenceId) {
                    data.put("arrival_time", a.getArrival_time() != null ? a.getArrival_time().toString() : null);
                    data.put("departure_time", a.getDeparture_time() != null ? a.getDeparture_time().toString() : null);
                    data.put("accommodation_type", a.getAccommodation_type());
                    data.put("requirements", a.getRequirements());
                    data.put("join_source", a.getJoin_source());
                    break;
                }
            }
            // 签到状态
            Checkin checkin = checkinDao.findByAttendeeId(attendeeId);
            data.put("checkedIn", checkin != null);
            data.put("checkinTime", checkin != null ? checkin.getCheckinTime().toString() : null);
            // 入住状态
            Accommodation acc = accommodationDao.findByAttendeeId(attendeeId);
            data.put("roomNumber", acc != null ? acc.getRoomNumber() : null);
            data.put("roomStatus", acc != null ? acc.getStatus() : -1);

            result.put("data", data);
        }
        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }
}
