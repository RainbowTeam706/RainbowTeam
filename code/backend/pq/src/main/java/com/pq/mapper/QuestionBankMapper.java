package com.pq.mapper;

import com.pq.entity.QuestionBank;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface QuestionBankMapper {
    @Insert("INSERT INTO question_bank(activityId, content, options, answer) VALUES (#{activityId}, #{content}, #{options}, #{answer})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(QuestionBank question);

    @Select("SELECT * FROM question_bank WHERE id = #{id}")
    QuestionBank selectById(@Param("id") Integer id);

    @Select("SELECT * FROM question_bank WHERE activityId = #{activityId}")
    List<QuestionBank> selectByActivityId(@Param("activityId") Integer activityId);
} 