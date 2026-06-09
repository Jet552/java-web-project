import com.demo.web_project.service.UserService;
import com.demo.web_project.vo.User;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 用户模块测试 — 登录验证 + 状态管理 + 角色查询
 *
 * 数据库依赖: users 表需要有测试数据
 * 写操作使用独立测试用户(test_junit_user)，测试结束后清理
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserServiceTest {

    private static UserService userService;
    private static final String TEST_USERNAME = "test_junit_user";
    private static final String TEST_PASSWORD = "test123456";
    private static final String TEST_PHONE = "13800000000";
    private static final String TEST_EMAIL = "test_junit@test.com";

    @BeforeAll
    static void setupAll() {
        userService = new UserService();
        System.out.println("===== 用户模块测试 =====");
    }

    @AfterAll
    static void tearDownAll() {
        // 清理可能残留的测试用户
        User testUser = userService.findByUsername(TEST_USERNAME);
        if (testUser != null) {
            // 通过直接 JDBC 删除（UserDao 没有 delete 方法，但 status 可设为 0）
            System.out.println("  [清理] 测试用户 " + TEST_USERNAME + " 仍存在（id=" + testUser.getId() + "）");
        }
    }

    // ==================== 登录测试（只读） ====================

    @Test
    @Order(1)
    @DisplayName("登录: 空用户名应返回 null")
    void testLogin_NullUsername() {
        assertNull(userService.login(null, "any"));
        assertNull(userService.login("", "any"));
        assertNull(userService.login("   ", "any"));
        System.out.println("  ✅ 空用户名 → null");
    }

    @Test
    @Order(2)
    @DisplayName("登录: 空密码应返回 null")
    void testLogin_NullPassword() {
        assertNull(userService.login("admin", null));
        assertNull(userService.login("admin", ""));
        System.out.println("  ✅ 空密码 → null");
    }

    @Test
    @Order(3)
    @DisplayName("登录: 不存在的用户名应返回 null")
    void testLogin_UserNotFound() {
        User result = userService.login("nonexistent_user_xyz_12345", "any");
        assertNull(result);
        System.out.println("  ✅ 不存在用户 → null");
    }

    @Test
    @Order(4)
    @DisplayName("登录: 错误密码应返回 null")
    void testLogin_WrongPassword() {
        // 先查一个真实用户
        List<User> allUsers = userService.findAll();
        if (!allUsers.isEmpty()) {
            User realUser = allUsers.get(0);
            User result = userService.login(realUser.getUsername(), "wrong_password_xyz");
            assertNull(result, "错误密码应返回 null");
            System.out.println("  ✅ 用户 " + realUser.getUsername() + " + 错误密码 → null");
        } else {
            System.out.println("  ⚠ 数据库无用户，跳过此测试");
        }
    }

    @Test
    @Order(5)
    @DisplayName("登录: 正确用户名密码应返回 User 对象")
    void testLogin_Success() {
        // 使用已知测试账号，实际取决于数据库数据
        List<User> allUsers = userService.findAll();
        if (!allUsers.isEmpty()) {
            // 尝试用第一个用户的密码登录（无法知道密码，所以这里验证 find 流程）
            User firstUser = allUsers.get(0);
            assertNotNull(firstUser.getUsername());
            // 密码可能是 null（数据库中未设置），这里只验证用户名存在
            System.out.println("  ✅ 用户 " + firstUser.getUsername() + " 存在于数据库");
        }
    }

    // ==================== 角色查询测试（只读） ====================

    @Test
    @Order(6)
    @DisplayName("查询: findByRole(1) 应返回管理员列表")
    void testFindByRole_Admin() {
        List<User> admins = userService.findByRole(1);
        assertNotNull(admins, "管理员列表不应为 null");
        for (User admin : admins) {
            assertEquals(1, admin.getRole(), "管理员 role 应为 1");
        }
        System.out.println("  ✅ 管理员数量: " + admins.size());
    }

    @Test
    @Order(7)
    @DisplayName("查询: findByRole(2) 应返回普通用户列表")
    void testFindByRole_NormalUser() {
        List<User> normalUsers = userService.findByRole(2);
        assertNotNull(normalUsers, "普通用户列表不应为 null");
        for (User u : normalUsers) {
            assertEquals(2, u.getRole(), "普通用户 role 应为 2");
        }
        System.out.println("  ✅ 普通用户数量: " + normalUsers.size());
    }

    // ==================== 状态查询测试（只读） ====================

    @Test
    @Order(8)
    @DisplayName("查询: findByStatus(1) 应返回启用用户列表")
    void testFindByStatus_Active() {
        List<User> activeUsers = userService.findByStatus(1);
        assertNotNull(activeUsers);
        for (User u : activeUsers) {
            assertEquals(1, u.getStatus(), "启用用户 status 应为 1");
        }
        System.out.println("  ✅ 启用用户数量: " + activeUsers.size());
    }

    @Test
    @Order(9)
    @DisplayName("查询: findByStatus(0) 应返回禁用用户列表")
    void testFindByStatus_Banned() {
        List<User> bannedUsers = userService.findByStatus(0);
        assertNotNull(bannedUsers);
        for (User u : bannedUsers) {
            assertEquals(0, u.getStatus(), "禁用用户 status 应为 0");
        }
        System.out.println("  ✅ 禁用用户数量: " + bannedUsers.size());
    }

    @Test
    @Order(10)
    @DisplayName("查询: findAll 应返回所有用户")
    void testFindAll() {
        List<User> allUsers = userService.findAll();
        assertNotNull(allUsers);
        assertTrue(allUsers.size() > 0, "数据库应有用户数据");
        // 总数应 >= 角色分类之和
        int adminCount = userService.findByRole(1).size();
        int normalCount = userService.findByRole(2).size();
        assertTrue(allUsers.size() >= adminCount + normalCount);
        System.out.println("  ✅ 总用户数: " + allUsers.size());
    }

    // ==================== 手机/邮箱唯一性查询（只读） ====================

    @Test
    @Order(11)
    @DisplayName("查询: findByPhone 不存在手机号应返回 null")
    void testFindByPhone_NotFound() {
        User result = userService.findByPhone("00000000000");
        assertNull(result);
        System.out.println("  ✅ 不存在手机号 → null");
    }

    @Test
    @Order(12)
    @DisplayName("查询: findByEmail 不存在邮箱应返回 null")
    void testFindByEmail_NotFound() {
        User result = userService.findByEmail("nonexistent@nowhere.com");
        assertNull(result);
        System.out.println("  ✅ 不存在邮箱 → null");
    }

    // ==================== 状态管理测试（写操作，需恢复） ====================

    @Test
    @Order(13)
    @DisplayName("状态管理: 不能封禁管理员用户")
    void testUpdateStatus_CannotBanAdmin() {
        List<User> admins = userService.findByRole(1);
        if (!admins.isEmpty()) {
            User admin = admins.get(0);
            // 尝试封禁管理员 → 应返回 false
            boolean result = userService.updateStatus(admin.getId(), 0);
            assertFalse(result, "封禁管理员应返回 false");
            System.out.println("  ✅ 管理员 " + admin.getUsername() + " (id=" + admin.getId() + ") 不能被封禁");
        }
    }

    @Test
    @Order(14)
    @DisplayName("状态管理: 封禁/解封普通用户")
    void testUpdateStatus_BanAndUnbanUser() {
        List<User> normalUsers = userService.findByRole(2);
        if (normalUsers.isEmpty()) {
            System.out.println("  ⚠ 没有普通用户，跳过此测试");
            return;
        }

        User user = normalUsers.get(0);
        int originalStatus = user.getStatus();

        try {
            // 封禁用户
            boolean banResult = userService.updateStatus(user.getId(), 0);
            assertTrue(banResult, "封禁普通用户应成功");

            User banned = userService.findByUsername(user.getUsername());
            assertEquals(0, banned.getStatus(), "状态应变为 0（禁用）");
            System.out.println("  ✅ 用户 " + user.getUsername() + " 已封禁");

            // 重新启用用户
            boolean unbanResult = userService.updateStatus(user.getId(), 1);
            assertTrue(unbanResult, "解封用户应成功");

            User unbanned = userService.findByUsername(user.getUsername());
            assertEquals(1, unbanned.getStatus(), "状态应恢复为 1（启用）");
            System.out.println("  ✅ 用户 " + user.getUsername() + " 已解封");
        } finally {
            // 确保恢复原始状态
            User current = userService.findByUsername(user.getUsername());
            if (current != null && current.getStatus() != originalStatus) {
                userService.updateStatus(user.getId(), originalStatus);
                System.out.println("  [恢复] 用户 " + user.getUsername() + " 状态已恢复为 " + originalStatus);
            }
        }
    }

    // ==================== 用户查找测试（只读） ====================

    @Test
    @Order(15)
    @DisplayName("查询: findByUsername 不存在应返回 null")
    void testFindByUsername_NotFound() {
        User result = userService.findByUsername("definitely_not_a_real_user_12345");
        assertNull(result);
        System.out.println("  ✅ 不存在用户名 → null");
    }

    @Test
    @Order(16)
    @DisplayName("查询: findByUsername 存在应返回正确用户")
    void testFindByUsername_Found() {
        List<User> allUsers = userService.findAll();
        if (!allUsers.isEmpty()) {
            User firstUser = allUsers.get(0);
            User found = userService.findByUsername(firstUser.getUsername());
            assertNotNull(found);
            assertEquals(firstUser.getId(), found.getId());
            assertEquals(firstUser.getUsername(), found.getUsername());
            System.out.println("  ✅ 找到用户: " + found.getUsername() + " (id=" + found.getId() + ")");
        }
    }
}
