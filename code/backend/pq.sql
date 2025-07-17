/*
 Navicat Premium Dump SQL

 Source Server         : 922106840320
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : localhost:3306
 Source Schema         : pq

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 17/07/2025 12:14:38
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
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for popquiz
-- ----------------------------
DROP TABLE IF EXISTS `popquiz`;
CREATE TABLE `popquiz`  (
  `id` int NOT NULL,
  `activityId` int NOT NULL COMMENT '所属活动id',
  `startTime` datetime NOT NULL COMMENT '开始时间',
  `endTime` datetime NOT NULL COMMENT '结束时间',
  `time` int NOT NULL COMMENT '持续时长',
  `status` int NOT NULL COMMENT '状态（进行中/已结束）0/1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for popquiz_question
-- ----------------------------
DROP TABLE IF EXISTS `popquiz_question`;
CREATE TABLE `popquiz_question`  (
  `id` int NOT NULL,
  `popquizId` int NOT NULL COMMENT '题目所属的popquiz',
  `questionId` int NOT NULL COMMENT '题目',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `id` int NOT NULL,
  `activityId` int NOT NULL COMMENT '该题目所属活动id',
  `content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '题目内容',
  `options` json NOT NULL COMMENT '选项（json形式）',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '正确答案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_answer
-- ----------------------------
DROP TABLE IF EXISTS `user_answer`;
CREATE TABLE `user_answer`  (
  `id` int NOT NULL,
  `userId` int NOT NULL COMMENT '答题人ID',
  `questionId` int NOT NULL COMMENT '题目id',
  `selected_option` int NULL DEFAULT NULL COMMENT '所选选项',
  `answerTime` datetime NULL DEFAULT NULL COMMENT '答题时间',
  `is_corret` int NULL DEFAULT NULL COMMENT '是否正确，0错，1对',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
