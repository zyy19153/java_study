package com.zhouyu.comsumer;

import com.zhouyu.framework.ProxyFactory;
import com.zhouyu.provider.api.HelloService;

public class Consumer {

    public static void main(String[] args) {
        HelloService helloService = ProxyFactory.getProxy(HelloService.class);
        String result = helloService.sayHello("周瑜");
        System.out.println(result);

    }
}
