package com.zhouyu.provider;

import com.zhouyu.framework.Protocol;
import com.zhouyu.framework.ProtocolFactory;
import com.zhouyu.framework.URL;
import com.zhouyu.protocol.http.HttpServer;
import com.zhouyu.provider.api.HelloService;
import com.zhouyu.provider.impl.HelloServiceImpl;
import com.zhouyu.register.LocalRegister;
import com.zhouyu.register.RemoteMapRegister;

public class Provider {

    private static boolean isRun = true;

    public static void main(String[] args) {
        // 1. 注册服务
        // 2. 本地注册
        // 3. 启动tomcat

        // 注册服务 localhost应该使用代码去本机的ip，端口应该去拿用户的配置的
        URL url = new URL("localhost", 8080);
        RemoteMapRegister.regist(HelloService.class.getName(), url);

        //  服务：实现类
        LocalRegister.regist(HelloService.class.getName(), HelloServiceImpl.class);

        Protocol protocol = ProtocolFactory.getProtocol();
        protocol.start(url);



    }
}
