package com.zhouyu.register;

import java.util.HashMap;
import java.util.Map;

public class LocalRegister {

    private static Map<String, Class> map = new HashMap<>();

    // regist 可以决定将哪些服务暴露出去 只有注册到服务表中的服务才能被调用
    public static void regist(String interfaceName, Class implClass) {
        map.put(interfaceName, implClass);
    }

    public static Class get(String interfaceName) {
       return map.get(interfaceName);
    }
}
