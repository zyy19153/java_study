package com.zhouyu.framework;

import java.util.List;
import java.util.Random;

public class LoadBalance {

    // 负载均衡的算法
    public static URL random(List<URL> list) {
        Random random =new Random();
        int n = random.nextInt(list.size());
        return list.get(n);
    }

    // TODO 轮询 - hash
}
