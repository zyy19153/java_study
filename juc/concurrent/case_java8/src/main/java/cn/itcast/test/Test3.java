package cn.itcast.test;

import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.TimeUnit;

@Slf4j(topic = "c.Test3")
public class Test3 {
    public static void main(String[] args) throws InterruptedException {
//        new Thread(() -> {
//            while(true) {
//                log.debug("running...");
//            }
//        }, "t1").start();
//
//        new Thread(() -> {
//            while(true) {
//                log.debug("running...");
//            }
//        }, "t2").start();
        TwoPhaseTermiation tpt = new TwoPhaseTermiation();
        tpt.start();
        Thread.sleep(3500);
        tpt.stop();
    }
}

@Slf4j(topic = "c.Test3")
class TwoPhaseTermiation {
    private Thread monitor;

    // 启动监控线程
    public void start() {
        monitor = new Thread(()-> {
            while (true) {
                Thread current = Thread.currentThread();
                if (current.isInterrupted()) {
                    log.debug("料理后事");
                    break;
                }
                try {
                    TimeUnit.SECONDS.sleep(1); // 情况1 此时被打断会出现异常
                    log.debug("执行监控");              // 情况2 此时被打断不会出现异常
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    // 重新设置打断标记，因为 sleep 中被打断，打断标记会被重置为 false
                    current.interrupt();
                }
            }
        });
        monitor.start();
    }

    // 启动停止线程
    public void stop() {
        monitor.interrupt();
    }
}