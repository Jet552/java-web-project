/*
 Navicat Premium Dump SQL

 Source Server         : 123
 Source Server Type    : MySQL
 Source Server Version : 80023 (8.0.23)
 Source Host           : localhost:3306
 Source Schema         : web_db

 Target Server Type    : MySQL
 Target Server Version : 80023 (8.0.23)
 File Encoding         : 65001

 Date: 03/06/2026 23:00:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for accommodations
-- ----------------------------
DROP TABLE IF EXISTS `accommodations`;
CREATE TABLE `accommodations`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `room_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkin_date` date NOT NULL,
  `checkout_date` date NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  CONSTRAINT `accommodations_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `accommodations_chk_1` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accommodations
-- ----------------------------
INSERT INTO `accommodations` VALUES (2, 1, '908', '2026-06-09', '2026-06-12', 1);
INSERT INTO `accommodations` VALUES (3, 2, '605B', '2026-07-05', '2026-07-07', 1);
INSERT INTO `accommodations` VALUES (4, 8, '1012', '2026-03-05', '2026-03-06', 0);

-- ----------------------------
-- Table structure for attendees
-- ----------------------------
DROP TABLE IF EXISTS `attendees`;
CREATE TABLE `attendees`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `conference_id` int NOT NULL,
  `arrival_time` datetime NOT NULL,
  `departure_time` datetime NOT NULL,
  `accommodation_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `requirements` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `join_source` enum('invite','search') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'search',
  `status` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_conference_active`(`user_id` ASC, `conference_id` ASC, ((case when (`status` = 1) then 1 else NULL end)) ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_conference`(`conference_id` ASC) USING BTREE,
  CONSTRAINT `attendees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `attendees_ibfk_2` FOREIGN KEY (`conference_id`) REFERENCES `conferences` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `attendees_chk_1` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendees
-- ----------------------------
INSERT INTO `attendees` VALUES (1, 78, 1, '2026-06-09 14:30:00', '2026-06-12 20:00:00', '单人间', '需要清真餐', 'search', 1);
INSERT INTO `attendees` VALUES (2, 32, 2, '2026-07-05 08:00:00', '2026-07-07 22:00:00', '双人间', '无特殊要求', 'search', 1);
INSERT INTO `attendees` VALUES (3, 91, 3, '2026-08-15 07:15:00', '2026-08-17 18:00:00', '单人间', '需要无障碍设施', 'search', 1);
INSERT INTO `attendees` VALUES (4, 14, 4, '2026-09-01 12:00:00', '2026-09-03 21:30:00', '不需住宿', '需要素食餐', 'search', 1);
INSERT INTO `attendees` VALUES (5, 67, 5, '2026-10-22 09:00:00', '2026-10-24 16:00:00', '单人间', '无特殊要求', 'search', 1);
INSERT INTO `attendees` VALUES (6, 5, 6, '2025-11-12 10:00:00', '2025-11-14 17:00:00', '双人间', '需要加床', 'search', 1);
INSERT INTO `attendees` VALUES (7, 90, 7, '2026-03-05 13:00:00', '2026-03-06 19:00:00', '单人间', '无特殊要求', 'search', 1);
INSERT INTO `attendees` VALUES (8, 22, 8, '2026-04-18 08:00:00', '2026-04-20 16:00:00', '不需住宿', '需要会议资料电子版', 'search', 1);
INSERT INTO `attendees` VALUES (9, 45, 9, '2026-05-10 09:30:00', '2026-05-12 15:00:00', '单人间', '因航班取消无法参会', 'search', 0);
INSERT INTO `attendees` VALUES (10, 100, 10, '2026-05-25 10:00:00', '2026-05-26 11:30:00', '双人间', '临时有紧急会议', 'search', 0);
INSERT INTO `attendees` VALUES (11, 91, 1, '2026-06-08 20:06:00', '2026-06-12 20:06:00', '单人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (18, 89, 1, '2026-06-09 21:18:00', '2026-06-13 21:18:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (22, 89, 1, '2026-05-07 22:01:00', '2026-05-31 22:01:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (23, 89, 1, '2026-05-10 22:10:00', '2026-05-31 22:10:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (24, 89, 1, '2026-05-15 22:11:00', '2026-05-31 22:11:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (25, 89, 4, '2026-06-07 20:20:00', '2026-06-27 20:20:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (26, 89, 21, '2026-06-01 20:22:00', '2026-06-27 20:20:00', '单人间', '', 'search', 0);
INSERT INTO `attendees` VALUES (27, 89, 1, '2026-06-12 20:48:00', '2026-06-28 20:48:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (28, 89, 4, '2026-06-05 22:11:00', '2026-06-20 22:11:00', '双人间', '', 'search', 0);
INSERT INTO `attendees` VALUES (29, 89, 1, '2026-06-02 11:22:00', '2026-06-28 11:22:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (30, 89, 38, '2026-06-02 11:30:00', '2026-06-21 11:30:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (31, 89, 1, '2026-06-04 11:54:00', '2026-06-14 11:54:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (32, 89, 1, '2026-06-01 11:56:00', '2026-06-05 11:57:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (33, 89, 1, '2026-06-03 11:58:00', '2026-06-26 11:58:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (34, 89, 1, '2026-06-05 11:59:00', '2026-06-28 11:59:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (35, 89, 1, '2026-06-05 12:20:00', '2026-06-26 12:20:00', '单人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (36, 89, 4, '2026-06-07 15:41:00', '2026-06-13 15:41:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (37, 89, 4, '2026-06-07 15:48:00', '2026-06-12 15:48:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (38, 89, 4, '2026-06-13 16:19:00', '2026-06-21 16:19:00', '双人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (39, 89, 21, '2026-06-02 17:38:00', '2026-06-05 16:39:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (40, 89, 22, '2026-06-07 16:50:00', '2026-06-28 16:50:00', '单人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (41, 89, 21, '2026-06-02 17:38:00', '2026-06-05 16:39:00', '双人间', '无', 'search', 0);
INSERT INTO `attendees` VALUES (42, 89, 21, '2026-06-02 17:38:00', '2026-06-05 16:39:00', '双人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (43, 89, 22, '2026-06-07 16:50:00', '2026-06-28 16:50:00', '单人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (44, 89, 23, '2026-06-07 16:55:00', '2026-06-21 16:55:00', '单人间', '无', 'search', 1);
INSERT INTO `attendees` VALUES (45, 89, 24, '2026-06-04 20:58:00', '2026-06-18 20:58:00', '双人间', '无', 'search', 1);

-- ----------------------------
-- Table structure for checkins
-- ----------------------------
DROP TABLE IF EXISTS `checkins`;
CREATE TABLE `checkins`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `checkin_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checked_by` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  INDEX `checked_by`(`checked_by` ASC) USING BTREE,
  CONSTRAINT `checkins_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `checkins_ibfk_2` FOREIGN KEY (`checked_by`) REFERENCES `conferences` (`organizer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checkins
-- ----------------------------
INSERT INTO `checkins` VALUES (4, 1, '2026-06-09 09:15:00', 24);
INSERT INTO `checkins` VALUES (5, 2, '2026-07-05 08:30:00', 8);
INSERT INTO `checkins` VALUES (6, 8, '2026-03-05 13:45:00', 2);

-- ----------------------------
-- Table structure for conferences
-- ----------------------------
DROP TABLE IF EXISTS `conferences`;
CREATE TABLE `conferences`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `organizer_id` int NOT NULL,
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `venue` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dorms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `invite_codes` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` enum('pending','approved','rejected','invalid') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'pending',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '管理员审核理由',
  `amount` decimal(10, 2) NOT NULL DEFAULT 30.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invite_codes`(`invite_codes` ASC) USING BTREE,
  INDEX `idx_organizer`(`organizer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  FULLTEXT INDEX `idx_title`(`title`) WITH PARSER `ngram`,
  CONSTRAINT `conferences_ibfk_1` FOREIGN KEY (`organizer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `conferences_chk_1` CHECK (`amount` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of conferences
-- ----------------------------
INSERT INTO `conferences` VALUES (1, 24, '全球人工智能峰会', '探讨AI前沿技术与产业应用', '上海国际会议中心', '浦东香格里拉大酒店', '7aB9cD2eF', '2026-06-10 09:00:00', '2026-06-12 18:00:00', 'approved', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (2, 8, '区块链开发者大会', 'Web3.0生态与智能合约实战', '深圳会展中心', '深圳湾万怡酒店', NULL, '2026-07-05 10:30:00', '2026-07-07 17:30:00', 'pending', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (3, 37, '量子计算国际论坛', '量子算法与硬件突破研讨会', '北京国家会议中心', '中关村皇冠假日酒店', NULL, '2026-08-15 08:45:00', '2026-08-17 16:00:00', 'rejected', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (4, 15, '2026数字医疗峰会', 'AI在精准医疗中的应用案例', '杭州国际博览中心', '钱江新城万豪酒店', 'S9tU0vW1x', '2026-09-01 13:20:00', '2026-09-03 19:00:00', 'approved', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (5, 42, '绿色能源技术展', '光伏与储能系统创新方案', '广州琶洲会展中心', '南丰朗豪酒店', '', '2026-10-22 09:15:00', '2026-10-24 14:45:00', 'pending', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (6, 5, '2025金融科技峰会', '数字货币监管与跨境支付', '上海世博中心', '浦东丽思卡尔顿酒店', NULL, '2025-11-12 09:00:00', '2025-11-14 17:30:00', 'invalid', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (7, 19, '物联网安全研讨会', '工业物联网防护实战', '深圳南山科技园', '深圳科兴科学园亚朵酒店', NULL, '2026-03-05 14:00:00', '2026-03-06 18:00:00', 'invalid', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (8, 33, '5G+工业互联网大会', '智能制造与边缘计算', '北京亦创国际会展中心', '大兴机场木棉花酒店', NULL, '2026-04-18 08:30:00', '2026-04-20 16:45:00', 'invalid', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (9, 2, '元宇宙开发者大会', '虚拟现实与数字孪生技术', '杭州未来科技城', '西溪喜来登度假酒店', NULL, '2026-05-10 10:00:00', '2026-05-12 15:30:00', 'invalid', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (10, 47, '2026网络安全峰会', '零信任架构与攻防演练', '广州白云国际会议中心', '四季酒店珠江新城店', NULL, '2026-05-25 09:20:00', '2026-05-26 12:00:00', 'invalid', '2026-05-26 18:56:07', NULL, 30.00);
INSERT INTO `conferences` VALUES (21, 12, '2025年人工智能前沿技术研讨会', '探讨大语言模型、多模态AI等前沿技术的最新进展与应用趋势', '北京国际会议中心A厅', '北京北辰五洲大酒店', 'A1B2C3D4E', '2025-06-15 09:00:00', '2025-06-15 17:00:00', 'approved', '2025-05-10 10:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (22, 8, '第六届大数据与云计算技术论坛', '聚焦大数据存储、计算引擎与云原生技术的实践与落地', '上海浦东展览馆2层', '上海浦东嘉里大酒店', 'F5G6H7I8J', '2025-06-20 08:30:00', '2025-06-21 18:00:00', 'approved', '2025-05-12 14:20:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (23, 23, '软件工程最佳实践峰会2025', '分享敏捷开发、DevOps、持续集成等软件工程最佳实践案例', '深圳南山科技园会议中心', '深圳湾万丽酒店', 'K9L0M1N2O', '2025-07-01 09:00:00', '2025-07-03 17:00:00', 'approved', '2025-05-15 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (24, 5, '网络安全攻防技术交流会', '红蓝对抗实战演练、零日漏洞分析与安全防护体系建设', '北京大学信息学院报告厅', '北京北大博雅国际酒店', 'P3Q4R5S6T', '2025-05-28 14:00:00', '2025-05-28 17:00:00', 'approved', '2025-05-01 11:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (25, 17, '物联网与边缘计算创新论坛', '边缘智能、IoT安全与低功耗传感网络技术交流', '杭州国际博览中心', '杭州洲际酒店', 'U7V8W9X0Y', '2025-07-10 09:00:00', '2025-07-10 18:00:00', 'approved', '2025-05-20 08:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (26, 31, '区块链赋能数字经济研讨会', 'Web3、数字人民币、供应链金融与分布式账本技术应用', '广州天河国际会议中心', '广州四季酒店', 'Z1A2B3C4D', '2025-06-25 09:00:00', '2025-06-26 17:00:00', 'approved', '2025-05-18 16:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (27, 9, '5G与工业互联网融合发展大会', '5G专网、工业互联平台与智能制造典型场景研讨', '武汉光谷科技会展中心', '武汉光谷凯悦酒店', 'E5F6G7H8I', '2025-05-15 08:30:00', '2025-05-16 18:00:00', 'approved', '2025-04-20 09:15:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (28, 42, '量子计算与量子信息前沿论坛', '超导量子比特、离子阱架构与量子纠错编码研究进展', '合肥量子信息国家实验室', '合肥皇冠假日酒店', 'J9K0L1M2N', '2025-08-01 09:00:00', '2025-08-02 17:00:00', 'approved', '2025-06-10 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (29, 14, '生物信息学与精准医疗研讨会', '基因组学数据分析、蛋白质结构预测与AI辅助诊断', '成都世纪城国际会议中心', '成都世纪城天堂洲际大饭店', 'O3P4Q5R6S', '2025-07-20 09:00:00', '2025-07-21 17:30:00', 'approved', '2025-05-25 13:40:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (30, 28, '数字化转型与智能制造论坛', '工业4.0、数字孪生与智能工厂建设经验分享', '南京国际博览中心A馆', '南京国际青年会议酒店', 'T7U8V9W0X', '2025-06-10 09:00:00', '2025-06-11 18:00:00', 'approved', '2025-05-05 15:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (31, 6, 'CCF中国软件大会2025', '中国计算机学会软件工程专委会年度学术盛会', '西安曲江国际会议中心', '西安W酒店', 'Y1Z2A3B4C', '2025-09-15 08:00:00', '2025-09-18 18:00:00', 'approved', '2025-07-01 08:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (32, 33, '第二届智能驾驶与车联网峰会', '自动驾驶感知算法、V2X通信与智能座舱技术', '重庆国际博览中心', '重庆丽晶酒店', 'D5E6F7G8H', '2025-08-20 09:00:00', '2025-08-21 17:00:00', 'approved', '2025-06-15 11:20:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (33, 19, '云计算架构设计与运维实践', 'Kubernetes集群管理、Serverless架构与服务网格实践', '北京国家会议中心E2厅', '北京国家会议中心大酒店', 'I9J0K1L2M', '2025-05-20 14:00:00', '2025-05-20 18:00:00', 'approved', '2025-04-25 16:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (34, 41, '高校信息化建设经验交流会', '智慧校园、教务系统升级与一网通办实施经验分享', '清华大学信息技术中心', '北京文津国际酒店', 'N3O4P5Q6R', '2025-07-05 09:00:00', '2025-07-05 17:00:00', 'approved', '2025-05-28 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (35, 7, '金融科技创新与监管研讨会', '数字货币、智能风控与监管科技的国际比较与本土实践', '上海陆家嘴金融中心', '上海浦东丽思卡尔顿酒店', 'S7T8U9V0W', '2025-06-18 09:00:00', '2025-06-19 17:00:00', 'approved', '2025-05-08 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (36, 25, '智慧城市建设与物联网应用', '城市感知网络、数据中台与城市治理数字化转型', '天津滨海国际会议中心', '天津滨海喜来登酒店', 'X1Y2Z3A4B', '2025-08-10 09:00:00', '2025-08-10 18:00:00', 'approved', '2025-06-20 14:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (37, 3, '学术期刊编委年度工作会议', '科技期刊数字化转型与学术评价体系改革研讨', '科学出版社多功能厅', '北京西苑饭店', 'C5D6E7F8G', '2025-05-25 09:00:00', '2025-05-25 12:00:00', 'approved', '2025-04-30 09:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (38, 47, '青年学者交叉学科创新论坛', '鼓励青年科研人员跨学科合作，推动原创性科学研究', '浙江大学紫金港校区', '杭州紫金港国际饭店', 'H9I0J1K2L', '2025-09-01 09:00:00', '2025-09-02 17:00:00', 'approved', '2025-07-15 10:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (39, 11, 'DevOps与持续交付技术沙龙', 'CI/CD流水线优化、GitOps与混沌工程实践分享', '深圳腾讯滨海大厦', '深圳丽思卡尔顿酒店', 'M3N4O5P6Q', '2025-05-30 14:00:00', '2025-05-30 18:00:00', 'approved', '2025-05-02 15:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (40, 36, '遥感技术与地理信息研讨会', '高分辨率遥感影像处理、GIS时空分析与数字孪生城市', '武汉大学测绘学院', '武汉珞珈山宾馆', 'R7S8T9U0V', '2025-07-25 09:00:00', '2025-07-26 17:00:00', 'approved', '2025-05-22 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (41, 15, '数据安全与隐私保护高峰论坛', '个人信息保护法实施、跨境数据流动与隐私计算技术', '北京国家会议中心C厅', '北京北辰洲际酒店', 'W1X2Y3Z4A', '2025-08-05 09:00:00', '2025-08-05 18:00:00', 'approved', '2025-06-12 08:45:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (42, 29, '机器翻译与自然语言处理研讨会', '神经机器翻译、预训练语言模型与多语言NLP前沿进展', '哈尔滨工业大学活动中心', '哈尔滨万达文华酒店', 'B5C6D7E8F', '2025-06-28 09:00:00', '2025-06-28 17:00:00', 'approved', '2025-05-14 11:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (43, 2, '集成电路产业创新发展论坛', '芯片设计EDA、先进制程工艺与半导体产业链协同创新', '苏州国际博览中心', '苏州洲际酒店', 'G9H0I1J2K', '2025-09-10 09:00:00', '2025-09-11 18:00:00', 'approved', '2025-07-05 14:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (44, 44, '高校教务管理信息化研讨会', '学分制改革、智慧排课算法与教务数据治理', '复旦大学邯郸校区', '上海复旦皇冠假日酒店', 'L3M4N5O6P', '2025-07-15 09:00:00', '2025-07-15 17:00:00', 'approved', '2025-05-30 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (45, 18, 'Web前端技术趋势与发展峰会', 'WebAssembly、React Server Components与微前端架构实践', '北京望京凯悦酒店', '北京中关村皇冠假日酒店', 'Q7R8S9T0U', '2025-08-25 09:00:00', '2025-08-26 17:00:00', 'approved', '2025-06-20 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (46, 38, '新能源技术与碳中和论坛', '光伏储能、氢能产业链与碳排放交易市场分析', '深圳国际低碳城会展中心', '深圳隐秀山居酒店', 'V1W2X3Y4Z', '2025-10-10 09:00:00', '2025-10-11 17:00:00', 'approved', '2025-08-01 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (47, 21, '智慧医疗与健康大数据峰会', '电子病历NLP分析、医学影像AI与健康数据共享平台', '广州琶洲国际会展中心', '广州香格里拉大酒店', 'A5B6C7D8E', '2025-09-20 09:00:00', '2025-09-21 18:00:00', 'approved', '2025-07-10 08:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (48, 50, '云原生微服务架构实践沙龙', 'Spring Cloud、Istio服务网格与云原生可观测性', '杭州阿里巴巴西溪园区', '杭州西溪宾馆', 'F9G0H1I2J', '2025-06-05 14:00:00', '2025-06-05 18:00:00', 'approved', '2025-05-01 16:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (49, 13, '智能制造与机器人技术峰会', '工业机器人、协作机器人与柔性生产线智能化升级', '沈阳新世界博览馆', '沈阳香格里拉大酒店', 'K3L4M5N6O', '2025-08-15 09:00:00', '2025-08-16 17:00:00', 'approved', '2025-06-25 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (50, 4, '深度学习与计算机视觉研讨会', 'Vision Transformer、3D重建与视频理解前沿技术', '中山大学东校区', '广州大学城雅乐轩酒店', 'P7Q8R9S0T', '2025-06-22 09:00:00', '2025-06-22 17:00:00', 'approved', '2025-05-10 14:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (51, 34, '跨境电商与全球供应链论坛', '品牌出海、海外仓布局与跨境支付合规', '义乌国际博览中心', '义乌香格里拉大酒店', 'U1V2W3X4Y', '2025-07-28 09:00:00', '2025-07-29 17:00:00', 'approved', '2025-05-20 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (52, 16, '轨道交通智能化研讨会', '高铁信号系统、地铁全自动运行与智能运维技术', '北京铁道大厦', '北京铁道大厦酒店', 'Z5A6B7C8D', '2025-06-08 09:00:00', '2025-06-09 17:00:00', 'approved', '2025-04-28 11:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (53, 46, '算力网络与高性能计算论坛', '东数西算、智算中心建设与高性能计算应用', '贵阳国际生态会议中心', '贵阳万丽酒店', 'E9F0G1H2I', '2025-09-05 09:00:00', '2025-09-06 17:00:00', 'approved', '2025-07-01 09:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (54, 1, '第六届国际教育技术年会', '在线教育、自适应学习系统与VR/AR教育应用', '北京师范大学国际学术交流中心', '北京师范大学京师大厦', 'J3K4L5M6N', '2025-07-08 08:30:00', '2025-07-10 18:00:00', 'approved', '2025-05-05 08:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (55, 27, '碳达峰碳中和路径研讨会', '各行业碳中和路线图、碳足迹核算与低碳技术', '上海环境能源交易所', '上海浦西万怡酒店', 'O7P8Q9R0S', '2025-10-20 09:00:00', '2025-10-20 17:00:00', 'approved', '2025-08-10 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (56, 40, '数据库技术前沿论坛', 'NewSQL、图数据库与时序数据库技术选型与实践', '北京中关村软件园', '北京中关村皇冠假日酒店', 'T1U2V3W4X', '2025-07-18 09:00:00', '2025-07-18 18:00:00', 'approved', '2025-05-15 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (57, 10, '创新创业教育师资培训班', '创新创业课程设计、项目孵化与导师能力提升', '厦门大学思明校区', '厦门大学国际学术交流中心', 'Y5Z6A7B8C', '2025-08-08 09:00:00', '2025-08-10 17:00:00', 'approved', '2025-06-01 14:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (58, 48, '低空经济与无人机产业发展论坛', 'eVTOL、无人机物流与低空空域管理政策研讨', '深圳大中华国际交易广场', '深圳大中华喜来登酒店', 'D9E0F1G2H', '2025-09-25 09:00:00', '2025-09-26 17:00:00', 'approved', '2025-07-20 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (59, 22, '精密仪器与测量技术交流会', '高精度传感器、精密测量与仪器国产化替代', '长春国际会展中心', '长春净月潭益田喜来登酒店', 'I3J4K5L6M', '2025-08-18 09:00:00', '2025-08-19 17:00:00', 'approved', '2025-06-18 08:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (60, 35, '虚拟现实产业应用峰会', 'XR工业应用、元宇宙场景与空间计算技术', '南昌绿地国际博览中心', '南昌绿地铂瑞酒店', 'N7O8P9Q0R', '2025-09-08 09:00:00', '2025-09-09 17:00:00', 'approved', '2025-07-02 15:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (61, 7, '城市更新与建筑设计论坛', '历史建筑保护、绿色建筑与智慧社区规划设计', '上海同济大学建筑学院', '上海同济君禧大酒店', 'S1T2U3V4W', '2025-10-15 09:00:00', '2025-10-16 17:00:00', 'approved', '2025-08-05 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (62, 26, '食品安全检测技术研讨会', '食品快检、溯源区块链与食品安全风险预警', '广州华南理工大学', '广州大学城中心酒店', 'X5Y6Z7A8B', '2025-07-22 09:00:00', '2025-07-22 17:00:00', 'approved', '2025-05-20 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (63, 19, '智能仓储与物流机器人峰会', 'AGV/AMR机器人、仓储自动化与物流AI调度系统', '上海新国际博览中心', '上海浦东温德姆酒店', 'C9D0E1F2G', '2025-08-28 09:00:00', '2025-08-29 17:00:00', 'approved', '2025-06-28 11:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (64, 43, '海洋科学与蓝色经济论坛', '深海探测、海洋牧场与海洋可再生能源开发', '青岛国际会议中心', '青岛海尔洲际酒店', 'H3I4J5K6L', '2025-10-08 09:00:00', '2025-10-09 17:00:00', 'approved', '2025-08-15 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (65, 11, 'AIGC内容创作与版权研讨会', 'AI生成内容的版权归属、检测技术与产业生态建设', '北京798艺术区', '北京诺金酒店', 'M7N8O9P0Q', '2025-07-12 09:00:00', '2025-07-12 17:00:00', 'approved', '2025-05-25 15:30:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (66, 32, '电力系统与智能电网论坛', '新型电力系统、微电网与电力市场化改革', '西安陕西宾馆', '西安陕西宾馆', 'R1S2T3U4V', '2025-09-22 09:00:00', '2025-09-23 17:00:00', 'approved', '2025-07-15 08:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (67, 5, '工业软件自主创新研讨会', 'CAD/CAE/EDA国产替代与工业软件生态体系建设', '成都天府国际会议中心', '成都秦皇假日酒店', 'W5X6Y7Z8A', '2025-10-25 09:00:00', '2025-10-26 17:00:00', 'approved', '2025-08-20 10:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (68, 39, '航天技术创新与发展论坛', '商业航天、卫星互联网与深空探测技术', '北京航天城', '北京唐拉雅秀酒店', 'B9C0D1E2F', '2025-08-12 09:00:00', '2025-08-13 17:00:00', 'approved', '2025-06-10 09:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (69, 8, '医学影像AI临床应用研讨会', 'CT/MRI智能辅助诊断、病理AI与放射组学', '上海交通大学医学院', '上海交大医学院学术交流中心', 'G3H4I5J6K', '2025-06-25 09:00:00', '2025-06-26 17:00:00', 'approved', '2025-05-08 14:00:00', NULL, 30.00);
INSERT INTO `conferences` VALUES (70, 45, '乡村振兴与数字农业论坛', '智慧农业、农产品电商与乡村数字化治理', '西安杨凌国际会展中心', '杨凌国际会展中心酒店', 'L7M8N9O0P', '2025-09-18 09:00:00', '2025-09-18 17:00:00', 'approved', '2025-07-10 09:00:00', NULL, 30.00);

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `status` enum('unpaid','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `paid_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payments
-- ----------------------------
INSERT INTO `payments` VALUES (1, 1, 285.50, 'paid', '2026-05-20 14:30:00');
INSERT INTO `payments` VALUES (2, 2, 260.00, 'paid', '2026-05-18 09:15:00');
INSERT INTO `payments` VALUES (3, 3, 299.99, 'paid', '2026-05-22 11:20:00');
INSERT INTO `payments` VALUES (4, 6, 245.00, 'paid', '2025-11-10 16:45:00');
INSERT INTO `payments` VALUES (5, 7, 198.50, 'unpaid', '2026-05-28 16:30:42');
INSERT INTO `payments` VALUES (6, 25, 30.00, 'unpaid', '2026-06-01 20:20:21');
INSERT INTO `payments` VALUES (7, 26, 30.00, 'unpaid', '2026-06-01 20:20:49');
INSERT INTO `payments` VALUES (8, 27, 30.00, 'unpaid', '2026-06-01 20:48:44');
INSERT INTO `payments` VALUES (9, 28, 30.00, 'unpaid', '2026-06-01 22:11:30');
INSERT INTO `payments` VALUES (10, 29, 30.00, 'unpaid', '2026-06-02 11:22:18');
INSERT INTO `payments` VALUES (11, 30, 30.00, 'unpaid', '2026-06-02 11:30:49');
INSERT INTO `payments` VALUES (12, 31, 30.00, 'unpaid', '2026-06-02 11:54:38');
INSERT INTO `payments` VALUES (13, 32, 30.00, 'unpaid', '2026-06-02 11:57:09');
INSERT INTO `payments` VALUES (16, 35, 30.00, 'paid', '2026-06-02 12:21:01');
INSERT INTO `payments` VALUES (19, 38, 30.00, 'paid', '2026-06-02 16:38:28');
INSERT INTO `payments` VALUES (20, 42, 30.00, 'paid', '2026-06-02 16:53:47');
INSERT INTO `payments` VALUES (21, 43, 30.00, 'paid', '2026-06-02 16:55:02');
INSERT INTO `payments` VALUES (22, 44, 30.00, 'paid', '2026-06-02 16:55:39');
INSERT INTO `payments` VALUES (23, 45, 30.00, 'paid', '2026-06-03 20:58:58');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` smallint NOT NULL DEFAULT 1,
  `role` smallint NOT NULL DEFAULT 0 COMMENT '0=普通用户, 1=系统管理员',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  CONSTRAINT `chk_phone_email` CHECK ((`phone` is not null) or (`email` is not null)),
  CONSTRAINT `chk_role` CHECK (`role` in (0,1)),
  CONSTRAINT `chk_status` CHECK (`status` in (1,0))
) ENGINE = InnoDB AUTO_INCREMENT = 129 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'zhangwei', 'zhangwei123', '13801011001', 'zhangwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (2, 'zhangjing', 'zhangjing123', '13901011002', 'zhangjing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (3, 'zhanglei', 'zhanglei123', '15001011003', 'zhanglei@126.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (4, 'zhangfang', 'zhangfang123', '15101011004', 'zhangfang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (5, 'zhangqiang', 'zhangqiang123', '18601011005', 'zhangqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (6, 'zhangna', 'zhangna123', '13501011006', 'zhangna@outlook.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (7, 'zhangming', 'zhangming123', '15801011007', 'zhangming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (8, 'zhanghua', 'zhanghua123', '15901011008', 'zhanghua@163.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (9, 'zhangjun', 'zhangjun123', '18801011009', 'zhangjun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (10, 'zhangxia', 'zhangxia123', '13801011010', 'zhangxia@gmail.com', '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (11, 'liwei', 'liwei123', '13901011011', 'liwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (12, 'lijing', 'lijing123', '15001011012', 'lijing@outlook.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (13, 'lilei', 'lilei123', '15101011013', 'lilei@qq.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (14, 'lifang', 'lifang123', '18601011014', 'lifang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (15, 'liqiang', 'liqiang123', '13501011015', 'liqiang@126.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (16, 'lina', 'lina123', '15801011016', 'lina@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (17, 'liming', 'liming123', '15901011017', 'liming@sina.com', '2025-07-30 21:50:08', 0, 0);
INSERT INTO `users` VALUES (18, 'lihua', 'lihua123', '18801011018', 'lihua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (19, 'lijun', 'lijun123', '13801011019', 'lijun@qq.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (20, 'lixia', 'lixia123', '13901011020', 'lixia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (21, 'wangwei', 'wangwei123', '15001011021', 'wangwei@126.com', '2024-03-15 08:20:30', 0, 0);
INSERT INTO `users` VALUES (22, 'wangjing', 'wangjing123', '15101011022', 'wangjing@gmail.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (23, 'wanglei', 'wanglei123', '18601011023', 'wanglei@sina.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (24, 'wangfang', 'wangfang123', '13501011024', 'wangfang@outlook.com', '2024-11-05 18:40:20', 0, 0);
INSERT INTO `users` VALUES (25, 'wangqiang', 'wangqiang123', '15801011025', 'wangqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (26, 'wangna', 'wangna123', '15901011026', 'wangna@163.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (27, 'wangming', 'wangming123', '18801011027', 'wangming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (28, 'wanghua', 'wanghua123', '13801011028', 'wanghua@gmail.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (29, 'wangjun', 'wangjun123', '13901011029', 'wangjun@sina.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (30, 'wangxia', 'wangxia123', '15001011030', 'wangxia@outlook.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (31, 'zhaowei', 'zhaowei123', '15101011031', 'zhaowei@qq.com', '2024-03-15 08:20:30', 0, 0);
INSERT INTO `users` VALUES (32, 'zhaojing', 'zhaojing123', '18601011032', 'zhaojing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (33, 'zhaolei', 'zhaolei123', '13501011033', 'zhaolei@126.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (34, 'zhaofang', 'zhaofang123', '15801011034', 'zhaofang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (35, 'zhaoqiang', 'zhaoqiang123', '15901011035', 'zhaoqiang@sina.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (36, 'zhaona', 'zhaona123', '18801011036', 'zhaona@outlook.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (37, 'zhaoming', 'zhaoming123', '13801011037', 'zhaoming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (38, 'zhaohua', 'zhaohua123', '13901011038', 'zhaohua@163.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (39, 'zhaojun', 'zhaojun123', '15001011039', 'zhaojun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (40, 'zhaoxia', 'zhaoxia123', '15101011040', 'zhaoxia@gmail.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (41, 'chenwei', 'chenwei123', '18601011041', 'chenwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (42, 'chenjing', 'chenjing123', '13501011042', 'chenjing@outlook.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (43, 'chenlei', 'chenlei123', '15801011043', 'chenlei@qq.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (44, 'chenfang', 'chenfang123', '15901011044', 'chenfang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (45, 'chenqiang', 'chenqiang123', '18801011045', 'chenqiang@126.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (46, 'chenna', 'chenna123', '13801011046', 'chenna@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (47, 'chenming', 'chenming123', '13901011047', 'chenming@sina.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (48, 'chenhua', 'chenhua123', '15001011048', 'chenhua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (49, 'chenjun', 'chenjun123', '15101011049', 'chenjun@qq.com', '2026-01-08 22:45:50', 0, 0);
INSERT INTO `users` VALUES (50, 'chenxia', 'chenxia123', '18601011050', 'chenxia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (51, 'liuwei', 'liuwei123', '13501011051', 'liuwei@126.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (52, 'liujing', 'liujing123', '15801011052', 'liujing@gmail.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (53, 'liulei', 'liulei123', '15901011053', 'liulei@sina.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (54, 'liufang', 'liufang123', '18801011054', 'liufang@outlook.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (55, 'liuqiang', 'liuqiang123', '13801011055', 'liuqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (56, 'liuna', 'liuna123', '13901011056', 'liuna@163.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (57, 'liuming', 'liuming123', '15001011057', 'liuming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (58, 'liuhua', 'liuhua123', '15101011058', 'liuhua@gmail.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (59, 'liujun', 'liujun123', '18601011059', 'liujun@sina.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (60, 'liuxia', 'liuxia123', '13501011060', 'liuxia@outlook.com', '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (61, 'yangwei', 'yangwei123', '15801011061', 'yangwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (62, 'yangjing', 'yangjing123', '15901011062', 'yangjing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (63, 'yanglei', 'yanglei123', '18801011063', 'yanglei@126.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (64, 'yangfang', 'yangfang123', '13801011064', 'yangfang@gmail.com', '2024-11-05 18:40:20', 0, 0);
INSERT INTO `users` VALUES (65, 'yangqiang', 'yangqiang123', '13901011065', 'yangqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (66, 'yangna', 'yangna123', '15001011066', 'yangna@outlook.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (67, 'yangming', 'yangming123', '15101011067', 'yangming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (68, 'yanghua', 'yanghua123', '18601011068', 'yanghua@163.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (69, 'yangjun', 'yangjun123', '13501011069', 'yangjun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (70, 'yangxia', 'yangxia123', '15801011070', 'yangxia@gmail.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (71, 'huangwei', 'huangwei123', '15901011071', 'huangwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (72, 'huangjing', 'huangjing123', '18801011072', 'huangjing@outlook.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (73, 'huanglei', 'huanglei123', '13801011073', 'huanglei@qq.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (74, 'huangfang', 'huangfang123', '13901011074', 'huangfang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (75, 'huangqiang', 'huangqiang123', '15001011075', 'huangqiang@126.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (76, 'huangna', 'huangna123', '15101011076', 'huangna@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (77, 'huangming', 'huangming123', '18601011077', 'huangming@sina.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (78, 'huanghua', 'huanghua123', '13501011078', 'huanghua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (79, 'huangjun', 'huangjun123', '15801011079', 'huangjun@qq.com', '2026-01-08 22:45:50', 0, 0);
INSERT INTO `users` VALUES (80, 'huangxia', 'huangxia123', '15901011080', 'huangxia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (81, 'wuwei', 'wuwei123', '18801011081', 'wuwei@126.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (82, 'wujing', 'wujing123', '13801011082', 'wujing@gmail.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (83, 'wulei', 'wulei123', '13901011083', 'wulei@sina.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (84, 'wufang', 'wufang123', '15001011084', 'wufang@outlook.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (85, 'wuqiang', 'wuqiang123', '15101011085', 'wuqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (86, 'wuna', 'wuna123', '18601011086', 'wuna@163.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (87, 'wuming', 'wuming123', '13501011087', 'wuming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (88, 'wuhua', 'wuhua123', '15801011088', 'wuhua@gmail.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (89, 'wujun', 'wujun123', '15901011089', 'wujun@sina.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (90, 'wuxia', 'wuxia123', '18801011090', 'wuxia@outlook.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (91, 'zhouwei', 'zhouwei123', NULL, 'zhouwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (92, 'zhoujing', 'zhoujing123', NULL, 'zhoujing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (93, 'zhoulei', 'zhoulei123', NULL, 'zhoulei@126.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (94, 'zhoufang', 'zhoufang123', NULL, 'zhoufang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (95, 'zhouqiang', 'zhouqiang123', NULL, 'zhouqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (96, 'zhouna', 'zhouna123', '13801011091', NULL, '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (97, 'zhouming', 'zhouming123', '13901011092', NULL, '2025-07-30 21:50:08', 0, 0);
INSERT INTO `users` VALUES (98, 'zhouhua', 'zhouhua123', '15001011093', NULL, '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (99, 'zhoujun', 'zhoujun123', '15101011094', NULL, '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (100, 'zhouxia', 'zhouxia123', '18601011095', NULL, '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (101, 'ops_director', 'Meetings$2025!', '13700137001', 'operations@conference-system.com', '2026-05-26 20:18:24', 1, 1);
INSERT INTO `users` VALUES (102, 'finance_admin', 'Finance@2025', '13600136001', 'billing@conference-system.com', '2026-05-26 20:18:24', 1, 1);
INSERT INTO `users` VALUES (103, 'disaster_recovery', 'DRP@ssw0rd!2025', '13500135001', 'drp@conference-system.com', '2026-05-26 20:18:24', 1, 1);
INSERT INTO `users` VALUES (108, '123', '123123', '15257689387', '', '2026-05-29 21:13:10', 1, 0);

SET FOREIGN_KEY_CHECKS = 1;
