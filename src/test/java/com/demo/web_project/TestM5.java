package com.demo.web_project;

import com.demo.web_project.service.CheckinService;
import com.demo.web_project.service.AccommodationService;
import com.demo.web_project.service.ConferenceService;
import com.demo.web_project.vo.Checkin;
import com.demo.web_project.vo.Accommodation;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.CheckinDaoImpl;

import java.util.List;
import java.util.Map;

/**
 * M5 模块独立测试（不需要 Tomcat，直接测 Service/DAO 层）
 * 运行: mvn compile exec:java -Dexec.mainClass="com.demo.web_project.TestM5"
 *      或直接在 IDEA 右键 Run
 */
public class TestM5 {

    private static CheckinService checkinService = new CheckinService();
    private static AccommodationService accommodationService = new AccommodationService();
    private static CheckinDao checkinDao = new CheckinDaoImpl();

    private static ConferenceService conferenceService = new ConferenceService();

    private static int pass = 0, fail = 0;

    public static void main(String[] args) {
        System.out.println("===== M5 + M2 联调测试 =====\n");

        // M5 原有测试
        test_getCheckinList();
        test_getStatistics();
        test_findByAttendeeId_exists();
        test_findByAttendeeId_notExists();
        test_doCheckin_duplicate();
        test_doCheckin_success();
        test_assignRoom_noCheckin();
        test_assignRoom_success();
        test_getRoomList();

        // M2 新接口测试
        test_conferenceMyList();

        // 清理测试数据
        cleanup();

        System.out.printf("\n===== 结果: %d 通过, %d 失败 =====\n", pass, fail);
    }

    // 1. 签到列表 - 会议 1 有 1 个参会者(attendee 1)，已签到
    static void test_getCheckinList() {
        print("签到列表(conferenceId=1)");
        List<Map<String, Object>> list = checkinService.getCheckinList(1);
        check("返回记录数 > 0", list.size() > 0);
    }

    // 2. 签到统计
    static void test_getStatistics() {
        print("签到统计(conferenceId=1)");
        Map<String, Integer> stats = checkinService.getStatistics(1);
        System.out.println("  统计结果: " + stats);
        check("total > 0", stats.get("total") != null && stats.get("total") > 0);
        check("checkedIn >= 0", stats.get("checkedIn") != null && stats.get("checkedIn") >= 0);
    }

    // 3. 查询已签到参会者
    static void test_findByAttendeeId_exists() {
        print("查询已签到参会者(attendeeId=1)");
        Checkin c = checkinDao.findByAttendeeId(1);
        check("找到签到记录", c != null);
    }

    // 4. 查询未签到参会者
    static void test_findByAttendeeId_notExists() {
        print("查询未签到参会者(attendeeId=3)");
        Checkin c = checkinDao.findByAttendeeId(3);
        check("返回 null", c == null);
    }

    // 5. 重复签到应被拒绝
    static void test_doCheckin_duplicate() {
        print("重复签到(attendeeId=1)");
        String result = checkinService.doCheckin(1, 24);
        check("返回错误信息", !"success".equals(result));
        System.out.println("  返回: " + result);
    }

    // 6. 正常签到（attendee 3 目前未签到）
    static void test_doCheckin_success() {
        print("正常签到(attendeeId=3, checkedBy=24)");
        String result = checkinService.doCheckin(3, 24);
        check("签到成功", "success".equals(result));
        System.out.println("  返回: " + result);
    }

    // 7. 未签到就分配房间应被拒绝
    static void test_assignRoom_noCheckin() {
        print("未签到就分房(attendeeId=4)");
        String result = accommodationService.assignRoom(4, "888", "2026-06-01", "2026-06-03");
        check("返回错误信息", !"success".equals(result));
        System.out.println("  返回: " + result);
    }

    // 8. 签到后正常分配房间
    static void test_assignRoom_success() {
        print("签到后分房(attendeeId=3, room=999)");
        String result = accommodationService.assignRoom(3, "999", "2026-06-01", "2026-06-03");
        check("分房成功", "success".equals(result));
        System.out.println("  返回: " + result);
    }

    // 9. 入住列表
    static void test_getRoomList() {
        print("入住列表(conferenceId=1)");
        List<Accommodation> list = accommodationService.getRoomList(1);
        check("返回记录数 > 0", list.size() > 0);
    }

    // 10. M2 会议列表接口
    static void test_conferenceMyList() {
        print("会议列表(organizerId=24)");
        List<Conference> list = conferenceService.getMyList(24);
        check("返回记录数 > 0", list.size() > 0);
        if (list.size() > 0) {
            Conference c = list.get(0);
            System.out.println("  第一条: id=" + c.getId() + ", title=" + c.getTitle() + ", status=" + c.getStatus());
            check("包含 id 字段", c.getId() > 0);
            check("包含 title 字段", c.getTitle() != null && !c.getTitle().isEmpty());
            check("包含 status 字段", c.getStatus() != null);
        }
    }

    static void cleanup() {
        // 删除测试产生的签到和入住记录
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            java.sql.Connection conn = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/web_db?allowPublicKeyRetrieval=true&useSSL=false", "root", "334203");
            conn.createStatement().execute("DELETE FROM accommodations WHERE attendee_id = 3");
            conn.createStatement().execute("DELETE FROM checkins WHERE attendee_id = 3");
            conn.close();
            System.out.println("\n[清理] 测试数据已清理");
        } catch (Exception e) {
            System.out.println("\n[清理] 数据清理失败: " + e.getMessage());
        }
    }

    // ---- 工具 ----

    static void print(String name) {
        System.out.println("\n[测试] " + name);
    }

    static void check(String desc, boolean condition) {
        if (condition) {
            pass++;
            System.out.println("  PASS: " + desc);
        } else {
            fail++;
            System.out.println("  FAIL: " + desc);
        }
    }
}
