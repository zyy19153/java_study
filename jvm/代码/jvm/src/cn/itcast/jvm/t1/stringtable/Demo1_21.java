package cn.itcast.jvm.t1.stringtable;

/**
 * 演示字符串相关面试题
 */
public class Demo1_21 {

    public static void main(String[] args) {
        String s1 = "a";
        String s2 = "b";
        String s3 = "a" + "b"; // ab
        String s4 = s1 + s2;   // new String("ab")
        String s5 = "ab";
        String s6 = s4.intern();

// 问
        System.out.println(s3 == s4); // false 前者是串池中的，后者是heap中的
        System.out.println(s3 == s5); // true 两着都是串池中的
        System.out.println(s3 == s6); // true 两着都是串池中的

        String x2 = new String("c") + new String("d"); // new String("cd")
        x2.intern();
        String x1 = "cd";

// 问，如果调换了【最后两行代码】的位置呢(false)，如果是jdk1.6呢 (false)
        System.out.println(x1 == x2); // true
    }
}
