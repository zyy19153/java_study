package cn.itcast.test;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

@Slf4j(topic = "c.Test8")
public class Test8 {

    public static void main(String[] args) throws InterruptedException {
        log.debug("enter");
        TimeUnit.SECONDS.sleep(1); // 可以取代之前的 Thread.sleep() 本质就是对 Thread.sleep() 的封装
        log.debug("end");
//        Thread.sleep(1000);
    }
}
