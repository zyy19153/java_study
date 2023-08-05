package cn.itcast.jvm.t1.stringtable;

public class Demo1_23 {

    //  ["ab", "a", "b"]
    public static void main(String[] args) {

        String x = "ab"; // 位置 - 1
        String s = new String("a") + new String("b");

        // 堆  new String("a")   new String("b") new String("ab")
        String s2 = s.intern(); // 将这个字符串对象尝试放入串池，如果有则并不会放入，如果没有则放入串池， 会把串池中的对象返回
        // 注意，如果s在执行intern方法前，串池中没有ab，那么s自己也会指向intern后串池中的ab对象
        // 而如果之前串池已经有了ab，那么s就依然指向heap中的对象 本质上s自己一直指向heap中的ab对象，但是该对象如果能出现在串池中，那么
        // 不就等于s也指向串池中的对象了嘛。 如果intern方法执行前，串池中没有相应的字符串，那么intern做的就是把s指向的heap中的字符串的地址
        // 放入串池中。
        // 而无论之前串池中有没有ab，s2一定是返回的串池中的ab
        // =========== 注： 以上所说为 JDK1.8 的版本  =================
        // JDK1.6主要的不同就是，如果intern执行前串池中没有相应的字符串，那么就会把此对象复制一份放入串池中
        // 这时候串池中的对象和heap中的对象其实就是两个对象了

//        String x = "ab"; // 位置 - 2

        System.out.println( s2 == "ab"); // true s2此时引用的也是串池中的ab对象
        System.out.println( s2 == x); // true s2此时引用的也是串池中的ab对象
        System.out.println( s == x ); // false 如果 x的初始化出现在 位置 - 2 的话，那么结果就是 true
    }

}
