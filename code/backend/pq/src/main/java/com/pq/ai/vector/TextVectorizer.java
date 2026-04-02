package com.pq.ai.vector;

import java.util.List;

public interface TextVectorizer {
    List<Double> vectorize(String text);
}
