package com.pq.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.pq.entity.Activity;
import org.apache.ibatis.annotations.Update;

public interface ActivityMapper extends BaseMapper<Activity> {

    @Update("UPDATE activity SET curNum = curNum + 1 WHERE id = #{id}")
    void incrementCount(int id);
}
