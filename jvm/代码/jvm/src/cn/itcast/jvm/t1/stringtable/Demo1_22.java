package cn.itcast.jvm.t1.stringtable;

// StringTable [ "a", "b" ,"ab" ]  hashtable 结构，不能扩容
public class Demo1_22 {
    // 常量池中的信息，都会被加载到运行时常量池中， 这时 a b ab 都是常量池中的符号，还没有变为 java 字符串对象
    // ldc #2 会把 a 符号变为 "a" 字符串对象
    // ldc #3 会把 b 符号变为 "b" 字符串对象
    // ldc #4 会把 ab 符号变为 "ab" 字符串对象

    public static void main(String[] args) {
        String s1 = "a"; // 懒惰的 -> 用到了才会创建 （其实会先在串池里找，没有才会创建，有的话就用现成的）
        String s2 = "b";
        String s3 = "ab";
        String s4 = s1 + s2; // new StringBuilder().append("a").append("b").toString()  创建了一个新的对象 new String("ab")
        String s5 = "a" + "b";  // javac 在编译期间的优化，因为两个常量的拼接结果是一定的，所以结果已经在编译期确定为 "ab"
        // s4是两个变量拼接 s5是两个常量拼接
        // 编译期间 变量的拼接结果是不确定的，而常量的拼接结果是确定的

        System.out.println(s3 == s4); // false 虽然两个的值是一样的，都是”ab”，但是原来的ab(s3)是在串池中，而新的ab(s4)是在heap中
        System.out.println(s3 == s5); // true



    }
}
