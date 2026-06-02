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

@WebServlet("/attendee/myList")
public class ConferenceListServlet extends HttpServlet {
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private AttendeeService attendeeService=new AttendeeService();
    private ConferenceService conferenceService=new ConferenceService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user=(User)session.getAttribute("user");//获取user的各种数据
        int user_id = user.getId();
        List<Attendee> attende_list=attendeeService.checkAttendees(user_id);
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> conferenceDataList = new ArrayList<>();
            for (Attendee attendee : attende_list) {
                Conference conference=conferenceService.findByConfID(attendee.getConference_id());
                Map<String, Object> dataj = new HashMap<>();
                dataj.put("id",conference.getId());
                dataj.put("organizer_id",conference.getOrganizer_id());
                dataj.put("title",conference.getTitle());
                dataj.put("description",conference.getDescription());
                dataj.put("venue",conference.getVenue());
                dataj.put("dorms",conference.getDorms());
                dataj.put("invite_codes",conference.getInvite_codes());
                dataj.put("start_date",conference.getStart_date());
                dataj.put("end_date",conference.getEnd_date());
                dataj.put("conf_status",conference.getStatus()); //会议的状态
                dataj.put("atten_status",attendee.getStatus()); //参会记录的状态
                dataj.put("atten_id",attendee.getId()); //参会记录的状态
                dataj.put("created_date",conference.getCreated_date());
                dataj.put("reason",conference.getReason());
                dataj.put("amount",conference.getAmount());
                conferenceDataList.add(dataj);
            }
            result.put("code", 200);
            result.put("msg", "成功");
            result.put("data", conferenceDataList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "服务器内部错误：" + e.getMessage());
            result.put("data", null);
        }
        out.print(mapper.writeValueAsString(result));
        out.flush();
        out.close();
    }


}

