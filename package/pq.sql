/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 90200 (9.2.0)
 Source Host           : localhost:3306
 Source Schema         : pq

 Target Server Type    : MySQL
 Target Server Version : 90200 (9.2.0)
 File Encoding         : 65001

 Date: 23/07/2025 17:28:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createId` int NOT NULL,
  `Title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `Content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详情',
  `Location` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地点',
  `startTime` datetime NULL DEFAULT NULL,
  `endTime` datetime NULL DEFAULT NULL,
  `inviteCode` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `curNum` int NOT NULL DEFAULT 0 COMMENT '当前人数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (8, 1, '李正鹏的课堂', 'no contene', '云南', '2025-07-13 18:00:00', '2025-07-18 20:00:00', '411166', '2025-07-12 10:53:18', 2, 3);
INSERT INTO `activity` VALUES (14, 1, '李正鹏的课堂', 'no contene', '云南', '2025-06-30 18:00:00', '2025-07-01 20:00:00', '269766', '2025-07-13 13:23:57', 2, 1);
INSERT INTO `activity` VALUES (15, 1, '666', NULL, NULL, '2025-07-13 14:23:34', '2025-07-13 14:23:36', '666666', '2025-07-13 14:23:49', 2, 1);
INSERT INTO `activity` VALUES (16, 1, 'v的', 'vdf', 'vre', '2025-07-10 08:00:00', '2025-07-09 08:00:00', '003674', '2025-07-20 16:34:48', 2, 1);
INSERT INTO `activity` VALUES (17, 1, '语言', '个人合同烦烦烦', '二等', '2025-07-01 08:00:00', '2025-07-09 08:00:00', '987853', '2025-07-20 16:35:46', 2, 1);
INSERT INTO `activity` VALUES (27, 2, '44', 'fdsg', 'gf', '2025-07-09 08:00:02', '2025-07-01 08:00:08', '885230', '2025-07-21 00:13:42', 2, 1);
INSERT INTO `activity` VALUES (28, 2, '555', 'vrfe', '4343', '2025-07-01 08:00:00', '2025-07-31 08:00:00', '888025', '2025-07-21 00:31:22', 1, 3);

-- ----------------------------
-- Table structure for activity_member
-- ----------------------------
DROP TABLE IF EXISTS `activity_member`;
CREATE TABLE `activity_member`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `activityId` int NOT NULL,
  `userId` int NOT NULL,
  `nickName` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动内昵称',
  `joinTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity_member
-- ----------------------------
INSERT INTO `activity_member` VALUES (2, 8, 2, 'gy nb 666', '2025-07-13 12:27:47');
INSERT INTO `activity_member` VALUES (3, 8, 3, 'ljs', '2025-07-13 14:24:29');
INSERT INTO `activity_member` VALUES (7, 28, 1, 'lzp666', '2025-07-21 00:48:21');
INSERT INTO `activity_member` VALUES (8, 8, 4, 'user444', '2025-07-14 00:01:31');
INSERT INTO `activity_member` VALUES (9, 8, 5, 'user555', '2025-07-14 00:02:09');
INSERT INTO `activity_member` VALUES (10, 8, 6, 'user666', '2025-07-14 00:02:28');
INSERT INTO `activity_member` VALUES (11, 28, 9, 'zhuce', '2025-07-23 15:31:40');

-- ----------------------------
-- Table structure for discussion_comment
-- ----------------------------
DROP TABLE IF EXISTS `discussion_comment`;
CREATE TABLE `discussion_comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `activityId` int NOT NULL COMMENT '所属活动ID',
  `userId` int NOT NULL COMMENT '发布者用户ID',
  `userName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发布者昵称',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色：老师、学生',
  `anonymous` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否匿名',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `parentId` int NULL DEFAULT NULL COMMENT '一级为NULL，二级为父评论id',
  `replyTo` int NULL DEFAULT NULL COMMENT '一级为NULL，二级为被回复评论id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discussion_comment
-- ----------------------------
INSERT INTO `discussion_comment` VALUES (1, 8, 1, 'lzp666', 'teacher', 0, '这是老师的评论', '2025-07-22 23:56:08', NULL, NULL);
INSERT INTO `discussion_comment` VALUES (2, 8, 2, 'gy NB', 'student', 0, '学生评论222', '2025-07-22 23:56:52', NULL, NULL);
INSERT INTO `discussion_comment` VALUES (3, 8, 3, 'ljs', 'student', 0, '学生评论333', '2025-07-22 23:57:52', 1, 1);
INSERT INTO `discussion_comment` VALUES (5, 8, 2, 'gy NB', 'student', 0, 'abcdefg', '2025-07-23 01:45:48', NULL, NULL);
INSERT INTO `discussion_comment` VALUES (7, 8, 1, 'lzp666', 'teacher', 1, '急急急', '2025-07-23 01:51:13', 5, 5);
INSERT INTO `discussion_comment` VALUES (8, 8, 1, 'lzp666', 'teacher', 0, '哈哈哈', '2025-07-23 01:54:20', 2, 2);
INSERT INTO `discussion_comment` VALUES (26, 8, 2, 'gy NB', 'student', 0, '00000000', '2025-07-23 02:57:36', 1, 3);
INSERT INTO `discussion_comment` VALUES (28, 8, 2, 'gy NB', 'student', 0, 'hhhhhhhh', '2025-07-23 03:06:53', NULL, NULL);
INSERT INTO `discussion_comment` VALUES (29, 8, 2, 'gy NB', 'student', 0, 'ggggg', '2025-07-23 03:06:58', 28, 28);
INSERT INTO `discussion_comment` VALUES (30, 8, 2, 'gy NB', 'student', 0, '0000000', '2025-07-23 03:07:04', 28, 29);
INSERT INTO `discussion_comment` VALUES (31, 8, 2, 'gy NB', 'student', 0, '1111', '2025-07-23 03:07:11', 28, 30);
INSERT INTO `discussion_comment` VALUES (32, 8, 2, 'gy NB', 'student', 0, '你他妈的', '2025-07-23 03:07:24', 1, 3);

-- ----------------------------
-- Table structure for feedback_activity
-- ----------------------------
DROP TABLE IF EXISTS `feedback_activity`;
CREATE TABLE `feedback_activity`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '序号',
  `activityId` int NOT NULL COMMENT '关联活动ID',
  `userId` int NOT NULL COMMENT '反馈学生ID',
  `feedbackData_Pace` int NULL DEFAULT NULL COMMENT '课堂节奏：0fast，1normal，2slow',
  `feedbackData_Difficulty` int NULL DEFAULT NULL COMMENT '内容难度：0hard，1normal，2easy',
  `feedbackData_Understanding` int NULL DEFAULT NULL COMMENT '理解程度：0clear，1confused',
  PRIMARY KEY (`id`, `activityId`, `userId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of feedback_activity
-- ----------------------------
INSERT INTO `feedback_activity` VALUES (1, 8, 2, 0, 1, 1);
INSERT INTO `feedback_activity` VALUES (3, 8, 3, 1, 0, 1);
INSERT INTO `feedback_activity` VALUES (5, 8, 0, 1, 2, 0);

-- ----------------------------
-- Table structure for popquiz
-- ----------------------------
DROP TABLE IF EXISTS `popquiz`;
CREATE TABLE `popquiz`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `activityId` int NOT NULL COMMENT '所属测试id',
  `startTime` datetime NOT NULL COMMENT '开始时间',
  `endTime` datetime NOT NULL COMMENT '结束时间',
  `status` int NOT NULL COMMENT '状态（进行中/已结束）0/1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of popquiz
-- ----------------------------
INSERT INTO `popquiz` VALUES (48, 8, '2025-07-19 15:52:38', '2025-07-19 15:53:38', 1);
INSERT INTO `popquiz` VALUES (49, 8, '2025-07-19 16:02:21', '2025-07-19 16:03:21', 1);
INSERT INTO `popquiz` VALUES (50, 8, '2025-07-19 16:07:15', '2025-07-19 16:08:15', 1);
INSERT INTO `popquiz` VALUES (51, 8, '2025-07-19 16:10:24', '2025-07-19 16:11:24', 1);
INSERT INTO `popquiz` VALUES (52, 8, '2025-07-19 16:11:18', '2025-07-19 16:12:18', 1);
INSERT INTO `popquiz` VALUES (53, 8, '2025-07-19 16:11:43', '2025-07-19 16:12:43', 1);
INSERT INTO `popquiz` VALUES (54, 8, '2025-07-19 16:16:20', '2025-07-19 16:17:20', 1);
INSERT INTO `popquiz` VALUES (55, 8, '2025-07-19 16:20:30', '2025-07-19 16:21:30', 1);
INSERT INTO `popquiz` VALUES (56, 8, '2025-07-19 16:23:45', '2025-07-19 16:24:45', 1);
INSERT INTO `popquiz` VALUES (57, 8, '2025-07-19 16:24:08', '2025-07-19 16:25:08', 1);
INSERT INTO `popquiz` VALUES (58, 8, '2025-07-19 16:24:35', '2025-07-19 16:25:35', 1);
INSERT INTO `popquiz` VALUES (59, 8, '2025-07-19 16:27:51', '2025-07-19 16:28:51', 1);
INSERT INTO `popquiz` VALUES (60, 8, '2025-07-19 16:28:10', '2025-07-19 16:29:10', 1);
INSERT INTO `popquiz` VALUES (61, 8, '2025-07-19 16:29:53', '2025-07-19 16:30:53', 1);
INSERT INTO `popquiz` VALUES (62, 8, '2025-07-19 16:31:42', '2025-07-19 16:32:42', 1);
INSERT INTO `popquiz` VALUES (63, 8, '2025-07-19 16:34:41', '2025-07-19 16:35:41', 1);
INSERT INTO `popquiz` VALUES (64, 8, '2025-07-19 16:38:13', '2025-07-19 16:39:13', 1);
INSERT INTO `popquiz` VALUES (65, 8, '2025-07-19 16:40:46', '2025-07-19 16:41:46', 1);
INSERT INTO `popquiz` VALUES (66, 8, '2025-07-19 16:43:57', '2025-07-19 16:44:57', 1);
INSERT INTO `popquiz` VALUES (67, 8, '2025-07-19 16:46:19', '2025-07-19 16:47:19', 1);
INSERT INTO `popquiz` VALUES (68, 8, '2025-07-19 16:48:47', '2025-07-19 16:49:47', 1);
INSERT INTO `popquiz` VALUES (69, 8, '2025-07-19 16:50:46', '2025-07-19 16:51:46', 1);
INSERT INTO `popquiz` VALUES (70, 8, '2025-07-19 16:52:18', '2025-07-19 16:53:18', 1);
INSERT INTO `popquiz` VALUES (71, 8, '2025-07-19 16:54:53', '2025-07-19 16:55:53', 1);
INSERT INTO `popquiz` VALUES (72, 8, '2025-07-19 16:56:36', '2025-07-19 16:57:36', 1);
INSERT INTO `popquiz` VALUES (73, 8, '2025-07-19 17:00:27', '2025-07-19 17:01:27', 1);
INSERT INTO `popquiz` VALUES (74, 8, '2025-07-19 17:01:37', '2025-07-19 17:02:37', 1);
INSERT INTO `popquiz` VALUES (75, 8, '2025-07-19 17:08:15', '2025-07-19 17:09:15', 1);
INSERT INTO `popquiz` VALUES (76, 8, '2025-07-19 17:27:48', '2025-07-19 17:28:48', 1);
INSERT INTO `popquiz` VALUES (77, 8, '2025-07-19 17:30:16', '2025-07-19 17:31:16', 1);
INSERT INTO `popquiz` VALUES (78, 8, '2025-07-19 17:39:28', '2025-07-19 17:40:28', 1);
INSERT INTO `popquiz` VALUES (79, 8, '2025-07-19 17:45:21', '2025-07-19 17:46:21', 1);
INSERT INTO `popquiz` VALUES (80, 8, '2025-07-20 00:02:07', '2025-07-20 00:12:07', 1);
INSERT INTO `popquiz` VALUES (81, 8, '2025-07-20 00:06:39', '2025-07-20 00:16:39', 1);
INSERT INTO `popquiz` VALUES (82, 8, '2025-07-20 00:08:20', '2025-07-20 00:18:20', 1);
INSERT INTO `popquiz` VALUES (83, 8, '2025-07-20 00:14:10', '2025-07-20 00:24:10', 1);
INSERT INTO `popquiz` VALUES (84, 8, '2025-07-20 00:15:06', '2025-07-20 00:16:06', 1);
INSERT INTO `popquiz` VALUES (85, 8, '2025-07-20 00:19:20', '2025-07-20 00:21:20', 1);
INSERT INTO `popquiz` VALUES (89, 8, '2025-07-20 22:56:13', '2025-07-20 22:58:13', 1);
INSERT INTO `popquiz` VALUES (90, 8, '2025-07-20 23:06:00', '2025-07-20 23:07:00', 1);
INSERT INTO `popquiz` VALUES (91, 8, '2025-07-20 23:06:20', '2025-07-20 23:07:20', 1);
INSERT INTO `popquiz` VALUES (92, 8, '2025-07-20 23:06:37', '2025-07-20 23:07:37', 1);
INSERT INTO `popquiz` VALUES (93, 8, '2025-07-20 23:40:32', '2025-07-20 23:41:32', 1);
INSERT INTO `popquiz` VALUES (94, 8, '2025-07-20 23:43:38', '2025-07-20 23:44:38', 1);
INSERT INTO `popquiz` VALUES (95, 8, '2025-07-20 23:49:04', '2025-07-20 23:50:04', 1);
INSERT INTO `popquiz` VALUES (96, 8, '2025-07-20 23:50:30', '2025-07-20 23:51:30', 1);
INSERT INTO `popquiz` VALUES (97, 8, '2025-07-20 23:55:32', '2025-07-20 23:56:32', 1);

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `popQuizId` int NOT NULL COMMENT '该题目所属活动id',
  `content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '题目内容',
  `options` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '选项（json形式）',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '正确答案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 837 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES (441, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (442, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (443, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (444, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (445, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (446, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (447, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (448, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (449, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (450, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (451, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (452, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (453, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (454, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (455, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (456, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (457, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (458, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (459, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (460, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (461, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (462, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (463, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (464, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (465, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (466, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (467, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (468, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (469, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (470, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (471, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (472, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (473, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (474, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (475, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (476, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (477, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (478, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (479, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (480, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (481, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (482, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (483, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (484, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (485, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (486, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (487, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (488, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (489, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (490, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (491, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (492, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (493, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (494, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (495, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (496, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (497, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (498, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (499, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (500, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (501, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (502, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (503, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (504, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (505, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (506, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (507, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (508, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (509, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (510, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (511, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (512, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (513, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (514, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (515, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (516, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (517, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (518, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (519, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (520, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (521, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (522, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (523, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (524, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (525, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (526, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (527, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (528, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (529, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (530, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (531, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (532, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (533, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (534, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (535, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (536, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (537, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (538, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (539, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (540, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (541, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (542, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (543, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (544, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (545, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (546, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (547, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (548, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (549, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (550, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (551, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (552, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (553, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (554, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (555, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (556, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (557, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (558, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (559, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (560, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (561, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (562, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (563, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (564, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (565, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (566, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (567, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (568, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (569, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (570, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (571, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (572, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (573, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (574, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (575, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (576, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (577, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (578, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (579, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (580, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (581, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (582, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (583, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (584, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (585, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (586, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (587, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (588, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (589, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (590, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (591, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (592, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (593, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (594, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (595, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (596, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (597, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (598, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (599, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (600, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (601, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (602, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (603, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (604, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (605, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (606, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (607, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (608, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (609, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (610, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (611, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (612, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (613, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (614, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (615, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (616, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (617, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (618, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (619, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (620, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (621, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (622, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (623, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (624, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (625, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (626, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (627, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (628, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (629, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (630, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (631, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (632, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (633, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (634, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (635, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (636, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (637, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (638, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (639, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (640, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (641, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (642, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (643, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (644, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (645, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (646, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (647, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (648, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (649, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (650, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (651, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (652, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (653, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (654, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (655, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (656, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (657, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (658, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (659, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (660, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (661, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (662, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (663, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (664, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (665, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (666, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (667, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (668, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (669, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (670, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (671, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (672, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (673, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (674, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (675, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (676, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (677, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (678, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (679, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (680, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (681, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (682, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (683, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (684, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (685, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (686, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (687, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (688, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (689, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (690, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (691, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (692, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (693, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (694, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (695, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (696, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (697, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (698, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (699, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (700, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (701, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (702, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (703, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (704, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (705, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (706, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (707, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (708, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (709, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (710, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (711, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (712, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (713, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (714, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (715, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (716, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (717, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (718, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (719, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (720, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (721, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (722, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (723, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (724, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (725, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (726, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (727, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (728, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (729, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (730, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (731, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (732, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (733, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (734, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (735, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (736, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (737, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (738, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (739, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (740, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (741, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (742, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (743, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (744, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (745, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (746, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (747, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (748, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (749, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (750, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (751, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (752, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (753, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (754, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (755, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (756, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (757, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (758, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (759, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (760, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (761, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (762, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (763, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (764, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (765, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (766, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (767, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (768, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (769, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (770, 80, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (771, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (772, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (773, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (774, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (775, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (776, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (777, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (778, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (779, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (780, 81, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (781, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (782, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (783, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (784, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (785, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (786, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (787, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (788, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (789, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (790, 82, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (791, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (792, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (793, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (794, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (795, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (796, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (797, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (798, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (799, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (800, 83, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (801, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (802, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (803, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (804, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (805, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (806, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (807, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (808, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (809, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (810, 84, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (811, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (812, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (813, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (814, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (815, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (816, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (817, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (818, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (819, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (820, 85, '题目：你看浪费谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (828, 89, '数字1122的数字排列规律最可能是？', '[\"A. 前两个数字相同，后两个数字相同且比前两个大1\",\"B. 每个数字依次递增1\",\"C. 数字之和为6\",\"D. 奇数和偶数交替出现\"]', 'A');
INSERT INTO `question_bank` VALUES (829, 90, '8的平方等于多少？', '[\"64\",\"49\",\"81\",\"100\"]', 'A');
INSERT INTO `question_bank` VALUES (830, 91, '8的平方等于多少？', '[\"A. 16\",\"B. 56\",\"C. 64\",\"D. 72\"]', 'C');
INSERT INTO `question_bank` VALUES (831, 92, '8的平方等于多少？', '[\"A. 16\",\"B. 49\",\"C. 64\",\"D. 81\"]', 'C');
INSERT INTO `question_bank` VALUES (832, 93, '下列哪个数是最小的质数？', '[\"A.1\",\"B.2\",\"C.3\",\"D.4\"]', 'B');
INSERT INTO `question_bank` VALUES (833, 94, '5在自然数中属于下列哪一类？', '[\"A.质数\",\"B.合数\",\"C.偶数\",\"D.小数\"]', 'A');
INSERT INTO `question_bank` VALUES (834, 95, '数字2是以下哪种数？', '[\"A. 质数\",\"B. 合数\",\"C. 奇数\",\"D. 既不是质数也不是合数\"]', 'A');
INSERT INTO `question_bank` VALUES (835, 96, '数字序列“3333333”中包含的数字个数是多少？', '[\"A.5\",\"B.6\",\"C.7\",\"D.8\"]', 'C');
INSERT INTO `question_bank` VALUES (836, 97, '根据材料内容，以下哪项关于创新的说法正确？', '[\"A. 创新者往往在其拿手领域之外实现成功创新\",\"B. 只有成为所在领域的专家才能进行有效创新\",\"C. 技术创新是商业创新成功的唯一关键因素\",\"D. 学术领域的成功专家总能实现商业创新\"]', 'A');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`, `username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'user1', 'abc12345', 'lzp666');
INSERT INTO `user` VALUES (2, 'user2', 'abc12345', 'gy NB');
INSERT INTO `user` VALUES (3, 'user3', 'abc12345', 'ljs');
INSERT INTO `user` VALUES (4, 'user4', 'abc12345', 'user444');
INSERT INTO `user` VALUES (5, 'user5', 'abc12345', 'user555');
INSERT INTO `user` VALUES (6, 'user6', 'abc12345', 'user666');
INSERT INTO `user` VALUES (9, 'zhuce', 'abc12345', 'redis注册');

-- ----------------------------
-- Table structure for user_answer
-- ----------------------------
DROP TABLE IF EXISTS `user_answer`;
CREATE TABLE `user_answer`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL COMMENT '答题人ID',
  `popQuizId` int NOT NULL,
  `questionIds` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目id集合',
  `options` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所选选项',
  `answerTime` datetime NULL DEFAULT NULL COMMENT '答题时间',
  `isCorrect` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否正确',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_answer
-- ----------------------------
INSERT INTO `user_answer` VALUES (87, 1, 48, '444,448,449', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (88, 2, 48, '443,449,446', 'A,C,', '2025-07-19 15:53:39', '0,1,0');
INSERT INTO `user_answer` VALUES (89, 3, 48, '443,449,441', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (90, 2, 49, '451,460,457,454', ',,,', '2025-07-19 16:03:22', '0,0,0,0');
INSERT INTO `user_answer` VALUES (91, 3, 49, '459,458,457,453', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (92, 2, 50, '469,466,470,463', ',,,', '2025-07-19 16:08:16', '0,0,0,0');
INSERT INTO `user_answer` VALUES (93, 3, 50, '467,468,461,463', 'A,B,C,', '2025-07-19 16:08:16', '0,0,0,0');
INSERT INTO `user_answer` VALUES (94, 2, 51, '479,475,480,476', 'A,B,A,A', '2025-07-19 16:10:31', '0,0,0,1');
INSERT INTO `user_answer` VALUES (95, 3, 51, '471,480,475,478', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (96, 2, 52, '481,486,488,489', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (97, 3, 52, '486,481,488,485', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (98, 2, 53, '500,495,497,499', 'A,B,B,A', '2025-07-19 16:11:51', '0,0,0,0');
INSERT INTO `user_answer` VALUES (99, 3, 53, '497,494,496,500', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (100, 2, 54, '505,501,502,504', 'A,B,C,D', '2025-07-19 16:16:29', '0,0,0,1');
INSERT INTO `user_answer` VALUES (101, 3, 54, '508,507,510,506', 'A,B,C,D', '2025-07-19 16:16:34', '0,0,0,0');
INSERT INTO `user_answer` VALUES (102, 2, 55, '515,514,511,520', ',,,', '2025-07-19 16:21:31', '0,0,0,0');
INSERT INTO `user_answer` VALUES (103, 3, 55, '511,512,517,519', ',,,', '2025-07-19 16:21:31', '0,0,0,0');
INSERT INTO `user_answer` VALUES (104, 2, 56, '525,522,521', 'A,B,B', '2025-07-19 16:24:04', '0,0,1');
INSERT INTO `user_answer` VALUES (105, 3, 56, '523,528,522', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (106, 2, 57, '534,540,535', 'D,D,D', '2025-07-19 16:24:31', '0,0,0');
INSERT INTO `user_answer` VALUES (107, 3, 57, '534,532,535', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (108, 2, 58, '550,548,544', ',,', '2025-07-19 16:25:37', '0,0,0');
INSERT INTO `user_answer` VALUES (109, 3, 58, '549,548,546', ',,', '2025-07-19 16:25:38', '0,0,0');
INSERT INTO `user_answer` VALUES (110, 2, 59, '553,551,556', 'A,B,C', '2025-07-19 16:27:57', '1,0,0');
INSERT INTO `user_answer` VALUES (111, 3, 59, '554,559,553', 'A,C,D', '2025-07-19 16:28:03', '0,0,0');
INSERT INTO `user_answer` VALUES (112, 2, 60, '561,569,566', ',,', '2025-07-19 16:29:12', '0,0,0');
INSERT INTO `user_answer` VALUES (113, 3, 60, '566,568,569', ',,', '2025-07-19 16:29:12', '0,0,0');
INSERT INTO `user_answer` VALUES (114, 2, 61, '573,575,577', ',,', '2025-07-19 16:31:35', '0,0,0');
INSERT INTO `user_answer` VALUES (115, 3, 61, '580,578,579', ',,', '2025-07-19 16:31:40', '0,0,0');
INSERT INTO `user_answer` VALUES (116, 2, 62, '581,589,586', ',,', '2025-07-19 16:32:44', '0,0,0');
INSERT INTO `user_answer` VALUES (117, 3, 62, '583,589,586', ',,', '2025-07-19 16:32:45', '0,0,0');
INSERT INTO `user_answer` VALUES (118, 2, 63, '595,600,597', ',,', '2025-07-19 16:35:42', '0,0,0');
INSERT INTO `user_answer` VALUES (119, 3, 63, '592,598,593', ',,', '2025-07-19 16:35:43', '0,0,0');
INSERT INTO `user_answer` VALUES (120, 2, 64, '610,609,604', ',,', '2025-07-19 16:39:40', '0,0,0');
INSERT INTO `user_answer` VALUES (121, 3, 64, '603,610,604', ',,', '2025-07-19 16:39:39', '0,0,0');
INSERT INTO `user_answer` VALUES (122, 2, 65, '620,612,619', ',,', '2025-07-19 16:41:47', '0,0,0');
INSERT INTO `user_answer` VALUES (123, 3, 65, '614,619,612', 'A,C,', '2025-07-19 16:41:47', '0,1,0');
INSERT INTO `user_answer` VALUES (124, 2, 66, '623,629,621', ',,', '2025-07-19 16:45:00', '0,0,0');
INSERT INTO `user_answer` VALUES (125, 3, 66, '621,629,627', ',,', '2025-07-19 16:45:00', '0,0,0');
INSERT INTO `user_answer` VALUES (126, 2, 67, '640,636,637', ',,', '2025-07-19 16:47:21', '0,0,0');
INSERT INTO `user_answer` VALUES (127, 3, 67, '635,633,639', 'A,C,D', '2025-07-19 16:46:31', '0,1,1');
INSERT INTO `user_answer` VALUES (128, 2, 68, '642,646,647', ',,', '2025-07-19 16:49:50', '0,0,0');
INSERT INTO `user_answer` VALUES (129, 3, 68, '643,645,647', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (130, 2, 69, '655,651,652', 'A,C,C', '2025-07-19 16:50:51', '0,0,0');
INSERT INTO `user_answer` VALUES (131, 3, 69, '656,659,653', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (132, 2, 70, '670,666,664', ',,', '2025-07-19 16:53:20', '0,0,0');
INSERT INTO `user_answer` VALUES (133, 3, 70, '665,666,668', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (134, 2, 71, '679,674,677', ',,', '2025-07-19 16:55:54', '0,0,0');
INSERT INTO `user_answer` VALUES (135, 3, 71, '673,677,680', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (136, 2, 72, '688,690,686', ',,', '2025-07-19 16:57:37', '0,0,0');
INSERT INTO `user_answer` VALUES (137, 3, 72, '684,682,688', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (138, 2, 73, '694,692,698', 'A,B,D', '2025-07-19 17:00:32', '0,1,0');
INSERT INTO `user_answer` VALUES (139, 3, 73, '697,699,696', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (140, 2, 74, '709,701,710', 'A,B,', '2025-07-19 17:02:39', '0,1,0');
INSERT INTO `user_answer` VALUES (141, 3, 74, '705,703,710', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (142, 2, 75, '715,716,718', 'A,C,', '2025-07-19 17:09:16', '0,0,0');
INSERT INTO `user_answer` VALUES (143, 3, 75, '715,714,713', 'A,C,D', '2025-07-19 17:08:20', '0,1,0');
INSERT INTO `user_answer` VALUES (144, 2, 76, '721,724,723', ',,', '2025-07-19 17:28:50', '0,0,0');
INSERT INTO `user_answer` VALUES (145, 3, 76, '729,728,727', ',,', '2025-07-19 17:28:50', '0,0,0');
INSERT INTO `user_answer` VALUES (146, 2, 77, '734,738,731', 'A,C,C', '2025-07-19 17:31:17', '0,1,0');
INSERT INTO `user_answer` VALUES (147, 3, 77, '735,738,737', ',,', '2025-07-19 17:31:17', '0,0,0');
INSERT INTO `user_answer` VALUES (148, 2, 78, '741,749,744', ',,', '2025-07-19 17:40:30', '0,0,0');
INSERT INTO `user_answer` VALUES (149, 3, 78, '747,743,742', ',,', '2025-07-19 17:40:30', '0,0,0');
INSERT INTO `user_answer` VALUES (150, 2, 79, '753,759,752', 'A,B,C', '2025-07-19 17:45:26', '0,0,1');
INSERT INTO `user_answer` VALUES (151, 3, 79, '753,758,752', 'A,B,C', '2025-07-19 17:46:23', '0,0,1');
INSERT INTO `user_answer` VALUES (152, 2, 80, '765', '', NULL, '');
INSERT INTO `user_answer` VALUES (153, 3, 80, '766', '', NULL, '');
INSERT INTO `user_answer` VALUES (154, 2, 81, '780', '', NULL, '');
INSERT INTO `user_answer` VALUES (155, 3, 81, '776', '', NULL, '');
INSERT INTO `user_answer` VALUES (156, 2, 82, '786,781', 'A,D', '2025-07-20 00:08:46', '1,0');
INSERT INTO `user_answer` VALUES (157, 3, 82, '782,784', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (158, 2, 83, '791,795', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (159, 3, 83, '795,799', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (160, 2, 84, '805,808,804,802', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (161, 3, 84, '805,801,807,808', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (162, 2, 85, '814,818,819,816', 'A,C,B,B', '2025-07-20 00:19:48', '1,1,0,0');
INSERT INTO `user_answer` VALUES (163, 3, 85, '814,813,817,815', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (167, 2, 89, '828', '', NULL, '');
INSERT INTO `user_answer` VALUES (168, 3, 89, '828', '', NULL, '');
INSERT INTO `user_answer` VALUES (169, 2, 90, '829', 'A', '2025-07-20 23:06:17', '1');
INSERT INTO `user_answer` VALUES (170, 3, 90, '829', '', NULL, '');
INSERT INTO `user_answer` VALUES (171, 2, 91, '830', 'C', '2025-07-20 23:06:47', '1');
INSERT INTO `user_answer` VALUES (172, 3, 91, '830', '', NULL, '');
INSERT INTO `user_answer` VALUES (173, 2, 92, '831', '', NULL, '');
INSERT INTO `user_answer` VALUES (174, 3, 92, '831', '', NULL, '');
INSERT INTO `user_answer` VALUES (175, 2, 93, '832', '', NULL, '');
INSERT INTO `user_answer` VALUES (176, 3, 93, '832', '', NULL, '');
INSERT INTO `user_answer` VALUES (177, 2, 94, '833', '', '2025-07-20 23:44:55', '0');
INSERT INTO `user_answer` VALUES (178, 3, 94, '833', '', NULL, '');
INSERT INTO `user_answer` VALUES (179, 2, 95, '834', 'A', '2025-07-20 23:49:21', '1');
INSERT INTO `user_answer` VALUES (180, 3, 95, '834', '', NULL, '');
INSERT INTO `user_answer` VALUES (181, 2, 96, '835', 'A', '2025-07-20 23:55:48', '0');
INSERT INTO `user_answer` VALUES (182, 3, 96, '835', '', NULL, '');
INSERT INTO `user_answer` VALUES (183, 2, 97, '836', '', NULL, '');
INSERT INTO `user_answer` VALUES (184, 3, 97, '836', '', NULL, '');

SET FOREIGN_KEY_CHECKS = 1;
