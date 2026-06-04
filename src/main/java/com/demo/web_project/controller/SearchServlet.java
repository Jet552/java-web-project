package com.demo.web_project.controller;
import com.demo.web_project.service.AttendeeService;
import com.demo.web_project.service.PaymentService;
import com.demo.web_project.vo.Attendee;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.User;
import com.demo.web_project.service.ConferenceService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;
@WebServlet("/conference/search")
public class SearchServlet extends HttpServlet{
    private ObjectMapper mapper = new ObjectMapper();  //创建一次，重复使用
    private ConferenceService conferenceService=new ConferenceService();
    private AttendeeService attendeeService=new AttendeeService();
    private PaymentService paymentService=new PaymentService();
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置编码
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int user_id = (user != null) ? user.getId() : 0;
        String keyword = request.getParameter("keyword");
        String regex="[A-Za-z0-9]{9}";//用于匹配是否是邀请码
        PrintWriter out = response.getWriter();
        if(keyword.matches(regex)){//是邀请码
            Conference conference=conferenceService.findByCodes(keyword);
            if(conference==null){//查找失败
                Map<String, Object> result = new HashMap<>();
                result.put("code", 300);
                result.put("msg", "会议不存在");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                Map<String, Object> data = new HashMap<>();
                int attendee_id=attendeeService.checkAttendeesStatus(user_id,conference.getId());//对应的记录是否已经参加,即是否存在
                String paid_status=paymentService.findByAttendeeId(attendee_id).getStatus();
                data.put("paid_status",paid_status);
                data.put("id",conference.getId());
                data.put("attendee_id",attendee_id);
                data.put("title", conference.getTitle());
                data.put("invite_codes",conference.getInvite_codes());
                data.put("start_date", conference.getStart_date());
                data.put("end_date", conference.getEnd_date());
                data.put("venue",conference.getVenue());
                data.put("dorms",conference.getDorms());
                data.put("amount",conference.getAmount());
                data.put("description",conference.getDescription());
                result.put("data",data);
                result.put("code", 200);
                result.put("msg", "查找成功");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
        }
        else if(keyword == null||keyword=="" || keyword.trim().isEmpty()){//检索全部的会议
            List<Conference> conferenceList=conferenceService.findDefault();
            if(!conferenceList.isEmpty()){
                Map<String, Object> result = new HashMap<>();
                List<Map<String, Object>> dataList = new ArrayList<>();
                for (Conference conf : conferenceList) {
                    Map<String, Object> item = new HashMap<>();//将检索的会议全部返回
                    int attendee_id=attendeeService.checkAttendeesStatus(user_id,conf.getId());//对应的记录是否已经参加,即是否存在
                    String paid_status=paymentService.findByAttendeeId(attendee_id).getStatus();
                    item.put("paid_status",paid_status);
                    item.put("attendee_id",attendee_id);
                    item.put("id",conf.getId());
                    item.put("title", conf.getTitle());
                    item.put("start_date", conf.getStart_date());
                    item.put("end_date", conf.getEnd_date());
                    item.put("venue", conf.getVenue());
                    item.put("dorms", conf.getDorms());
                    item.put("invite_codes",conf.getInvite_codes());
                    item.put("amount",conf.getAmount());
                    item.put("description",conf.getDescription());
                    dataList.add(item);
                }
                result.put("data", dataList);  // 整个列表作为 data
                result.put("code", 400);
                result.put("msg", "查找相关会议成功");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                result.put("code", 500);
                result.put("msg", "未找到相关会议");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
        }
        else{//不是邀请码,关键字搜索,可能会有一大批
            List<Conference> conferenceList=conferenceService.findAll(keyword);
            if(!conferenceList.isEmpty()){
                Map<String, Object> result = new HashMap<>();
                List<Map<String, Object>> dataList = new ArrayList<>();
                for (Conference conf : conferenceList) {
                    Map<String, Object> item = new HashMap<>();//将检索的会议全部返回
                    int attendee_id=attendeeService.checkAttendeesStatus(user_id,conf.getId());//对应的记录是否已经参加,即是否存在
                    String paid_status=paymentService.findByAttendeeId(attendee_id).getStatus();
                    item.put("paid_status",paid_status);
                    item.put("attendee_id",attendee_id);
                    item.put("id",conf.getId());
                    item.put("title", conf.getTitle());
                    item.put("start_date", conf.getStart_date());
                    item.put("end_date", conf.getEnd_date());
                    item.put("venue", conf.getVenue());
                    item.put("dorms", conf.getDorms());
                    item.put("invite_codes",conf.getInvite_codes());
                    item.put("amount",conf.getAmount());
                    item.put("description",conf.getDescription());
                    dataList.add(item);
                }
                result.put("data", dataList);  // 整个列表作为 data
                result.put("code", 400);
                result.put("msg", "查找相关会议成功");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                result.put("code", 500);
                result.put("msg", "未找到相关会议");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
        }
        out.flush();
        out.close();
    }
}
