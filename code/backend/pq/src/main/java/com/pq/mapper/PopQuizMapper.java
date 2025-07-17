package com.pq.mapper;

import com.pq.entity.PopQuiz;
import org.apache.ibatis.annotations.*;

@Mapper
public interface PopQuizMapper {
    @Insert("INSERT INTO popquiz(activityId, startTime, endTime, time, status) VALUES (#{activityId}, #{startTime}, #{endTime}, #{time}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(PopQuiz popQuiz);

    @Select("SELECT * FROM popquiz WHERE id = #{id}")
    PopQuiz selectById(@Param("id") Integer id);
} 