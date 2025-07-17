package com.pq.mapper;

import com.pq.entity.UserAnswer;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface UserAnswerMapper {
    @Insert("INSERT INTO user_answer(userId, questionId, selected_option, answerTime, is_corret) VALUES (#{userId}, #{questionId}, #{selectedOption}, #{answerTime}, #{isCorret})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(UserAnswer answer);

    @Select("SELECT ua.* FROM user_answer ua JOIN question_bank qb ON ua.questionId = qb.id WHERE ua.userId = #{userId} AND qb.activityId = #{activityId}")
    List<UserAnswer> selectByUserIdAndActivityId(@Param("userId") Integer userId, @Param("activityId") Integer activityId);
} 