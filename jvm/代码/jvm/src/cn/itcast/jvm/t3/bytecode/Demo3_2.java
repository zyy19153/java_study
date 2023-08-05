package cn.itcast.jvm.t3.bytecode;

/**
 * 从字节码角度分析　a++  相关题目
 */
public class Demo3_2 {
    public static void main(String[] args) {
        int a = 10;
        int b = a++ + ++a + a--; // 10 + 12 + 12
        System.out.println(a); // 11
        System.out.println(b); // 34
    }
}
