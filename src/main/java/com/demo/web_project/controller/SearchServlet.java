package com.demo.web_project.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.service.ConferenceService;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/conference/search")
public class SearchServlet extends HttpServlet{
    private ObjectMapper mapper = new ObjectMapper();
    private ConferenceService conferenceService=new ConferenceService();

    // 把Conference转为Map，消除重复put代码
    private Map<String, Object> convertConferenceToMap(Conference conf) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", conf.getId());
        item.put("title", conf.getTitle());
        item.put("start_date", conf.getStart_date());
        item.put("end_date", conf.getEnd_date());
        item.put("venue", conf.getVenue());
        item.put("dorms", conf.getDorms());
        item.put("invite_codes", conf.getInvite_codes());
        item.put("amount", conf.getAmount());
        return item;
    }

    // 构建返回结果，简化重复创建Result的代码
    private Map<String, Object> buildResult(int code, String msg, Object data) {
        Map<String, Object> result = new HashMap<>();
        result.put("code", code);
        result.put("msg", msg);
        result.put("data", data);
        return result;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 配置JSON时间格式化
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 获取并处理关键词（防空指针）
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }
        // 日志：方便排查邀请码问题（可选，不影响功能）
        System.out.println("【SearchServlet】收到关键词：===" + keyword + "===");

        String regex="[A-Za-z0-9]{9}";// 9位邀请码正则（严格匹配字母+数字）

        if(keyword.matches(regex)){// 分支1：是邀请码
            Conference conference=conferenceService.findByCodes(keyword);
            System.out.println("【SearchServlet】邀请码查询结果：" + (conference == null ? "未找到" : "找到会议"));

            if(conference==null){// 查找失败
                out.print(mapper.writeValueAsString(buildResult(300, "会议不存在", null)));
            }
            else{// 查找成功
                Map<String, Object> data = convertConferenceToMap(conference);
                out.print(mapper.writeValueAsString(buildResult(200, "查找成功", data)));
            }
        }
        else if(keyword.trim().isEmpty()){// 分支2：检索全部已通过会议
            List<Conference> conferenceList=conferenceService.findDefault();
            if(!conferenceList.isEmpty()){
                List<Map<String, Object>> dataList = new ArrayList<>();
                for (Conference conf : conferenceList) {
                    dataList.add(convertConferenceToMap(conf));
                }
                out.print(mapper.writeValueAsString(buildResult(400, "查找相关会议成功", dataList)));
            }
            else{
                out.print(mapper.writeValueAsString(buildResult(500, "未找到相关会议", null)));
            }
        }
        else{// 分支3：普通关键词搜索
            List<Conference> conferenceList=conferenceService.findAll(keyword);
            if(!conferenceList.isEmpty()){
                List<Map<String, Object>> dataList = new ArrayList<>();
                for (Conference conf : conferenceList) {
                    dataList.add(convertConferenceToMap(conf));
                }
                out.print(mapper.writeValueAsString(buildResult(400, "查找相关会议成功", dataList)));
            }
            else{
                out.print(mapper.writeValueAsString(buildResult(500, "未找到相关会议", null)));
            }
        }

        out.flush();
        out.close();
    }
}