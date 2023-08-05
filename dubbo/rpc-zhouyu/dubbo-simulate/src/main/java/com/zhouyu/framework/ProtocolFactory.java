package com.zhouyu.framework;

import com.zhouyu.protocol.dubbo.DubboProtocol;
import com.zhouyu.protocol.http.HttpProtocol;

public class ProtocolFactory {

    public static Protocol getProtocol() {
        // 简单工厂模式
        // 扩展：工厂模式分为简单工厂、工厂方法、抽象工厂
        // protocolName是虚拟机参数
        String name = System.getProperty("protocolName");
        if (name == null || name.equals("")) name = "http";
        switch (name) {
            case "http":
                return new HttpProtocol();
            case "dubbo":
                return new DubboProtocol();
            default:
                break;
        }
        return new HttpProtocol();
    }
}
