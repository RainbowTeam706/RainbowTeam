package com.pq.ai.memory;

import com.pq.ai.memory.model.LongTermMemoryItem;

import java.util.List;

public interface LongTermMemoryService {

    List<LongTermMemoryItem> retrieveTopK(String queryText, int k);

    void saveMemoryItem(LongTermMemoryItem item, int maxItems);

    String buildMemoryContext(List<LongTermMemoryItem> items);
}
