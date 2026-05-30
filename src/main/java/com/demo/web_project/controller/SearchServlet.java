package com.demo.web_project.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.service.ConferenceService;
import jakarta.servlet.http.HttpSession;
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        String keyword = request.getParameter("keyword");
        String regex="[A-Za-z0-9]{9}";//用于匹配是否是邀请码
        PrintWriter out = response.getWriter();
        if(keyword.matches(regex)){//是邀请码
            Conference conference=conferenceService.findByCodes(keyword);
            if(conference==null){//查找失败
                Map<String, Object> result = new HashMap<>();
                result.put("code", 400);
                result.put("msg", "会议不存在");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                Map<String, Object> data = new HashMap<>();
                data.put("title", conference.getTitle());
                data.put("start_date", conference.getStart_date());
                data.put("end_date", conference.getEnd_date());
                data.put("venue",conference.getVenue());
                data.put("dorms",conference.getDorms());
                result.put("code", 200);
                result.put("msg", "查找成功");
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
                    item.put("title", conf.getTitle());
                    item.put("start_date", conf.getStart_date());
                    item.put("end_date", conf.getEnd_date());
                    item.put("venue", conf.getVenue());
                    item.put("dorms", conf.getDorms());
                    dataList.add(item);
                }
                result.put("data", dataList);  // 整个列表作为 data
                result.put("code", 200);
                result.put("msg", "查找成功");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
            else{
                Map<String, Object> result = new HashMap<>();
                result.put("code", 300);
                result.put("msg", "未找到相关会议");
                // 转成 JSON 字符串并输出
                String jsonStr = mapper.writeValueAsString(result);
                out.print(jsonStr);
            }
        }
    }
}
