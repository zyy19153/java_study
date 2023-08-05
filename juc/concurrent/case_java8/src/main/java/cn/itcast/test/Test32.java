package cn.itcast.test;

import lombok.extern.slf4j.Slf4j;

import static cn.itcast.n2.util.Sleeper.sleep;

@Slf4j(topic = "c.Test32")
public class Test32 {
    // 易变
    // volatile 避免线程从自己的工作缓存中查找变量的值，必须到主存中寻找它的值。
    volatile static boolean run = true;

    // 锁对象
    final static Object lock = new Object();

    // volatile 和 synchronized 都可以保证数据的可见性 - 一个线程对变量的修改对另一个变量可见

    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            while (true) {
                synchronized (lock) {
                    if (!run) {
                        break;
                    }
                }
            }
        });
        t.start();

        sleep(1);
        synchronized (lock) {
            run = false; // 线程 t不会如预想的停下来
        }
    }
}
