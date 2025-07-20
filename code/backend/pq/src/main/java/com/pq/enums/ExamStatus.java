package com.pq.enums;

public enum ExamStatus {
    RUNNING(0, "测试进行中"),
    ENDED(1, "测试已结束");

    private final int code;
    private final String description;

    ExamStatus(int code, String description) {
        this.code = code;
        this.description = description;
    }

    public int getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public static ExamStatus fromCode(int code) {
        for (ExamStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid status code: " + code);
    }
}
