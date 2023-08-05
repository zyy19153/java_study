package cn.itcast.jvm.t2;

import java.util.ArrayList;

/**
 *  演示内存的分配策略
 */
public class Demo2_1 {
    private static final int _512KB = 512 * 1024;
    private static final int _1MB = 1024 * 1024;
    private static final int _6MB = 6 * 1024 * 1024;
    private static final int _7MB = 7 * 1024 * 1024;
    private static final int _8MB = 8 * 1024 * 1024;

    // -Xms20M -Xmx20M -Xmn10M -XX:+UseSerialGC -XX:+PrintGCDetails -verbose:gc -XX:-ScavengeBeforeFullGC
    public static void main(String[] args) throws InterruptedException {
/*
        ArrayList<byte[]> list = new ArrayList<>();
        list.add(new byte[_8MB]); // 大对象的直接晋升机制
        list.add(new byte[_8MB]); // OutOfMemoryError
*/
        new Thread(() -> {
            ArrayList<byte[]> list = new ArrayList<>();
            list.add(new byte[_8MB]); // 大对象的直接晋升机制
            list.add(new byte[_8MB]); // OutOfMemoryError
        }).start(); // 一个线程内的 OutOfMemory 不会导致整个 java 进程的结束
        System.out.println("sleep....");
        Thread.sleep(1000L);
    }
}
