package com.pq.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;


@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("question_bank")
public class QuestionBank {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private Integer popQuizId;

    private String content;

    private String options;

    private String answer;

} 