package com.pq.mapper;

import com.pq.entity.PopQuizQuestion;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface PopQuizQuestionMapper {
    @Insert("INSERT INTO popquiz_question(popquizId, questionId) VALUES (#{popquizId}, #{questionId})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(PopQuizQuestion pqQuestion);

    @Select("SELECT * FROM popquiz_question WHERE popquizId = #{popQuizId}")
    List<PopQuizQuestion> selectByPopQuizId(@Param("popQuizId") Integer popQuizId);
} 