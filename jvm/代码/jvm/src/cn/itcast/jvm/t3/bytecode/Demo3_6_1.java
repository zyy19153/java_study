package cn.itcast.jvm.t3.bytecode;

public class Demo3_6_1 {
    public static void main(String[] args) {
        int i = 0;
        int x = 0;
        while (i < 10) {
            x = x++;
            i++;
        }
        System.out.println(x);
    }
    // x++: iload_x -> iinc x 1
    // 每次循环中先把x(0)取到操作数栈中，然后在局部变量的中的x自增1(1)，最后赋值操作再把操作数栈的中的x(0)赋值给局部变量的中的x(1)
}
