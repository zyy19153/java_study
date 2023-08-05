package cn.itcast.jvm;

//import com.sun.xml.internal.ws.org.objectweb.asm.ClassWriter;
//import com.sun.xml.internal.ws.org.objectweb.asm.Opcodes;
//
///**
// * 演示永久代内存溢出  java.lang.OutOfMemoryError: PermGen space
// * -XX:MaxPermSize=8m
// */
//public class Demo1_8 extends ClassLoader { // 可以用来加载类的二进制字节码
//    public static void main(String[] args) {
//        int j = 0;
//        try {
//            Demo1_8 test = new Demo1_8();
//            for (int i = 0; i < 20000; i++, j++) {
//                // ClassWriter 作用是生成类的二进制字节码
//                ClassWriter cw = new ClassWriter(0);
//                // 参数： 版本号 public 类名 包名 类的父类 类实现的接口名称
//                cw.visit(Opcodes.V1_6, Opcodes.ACC_PUBLIC, "Class" + i, null, "java/lang/Object", null);
//                // 生成类 并 返回 类的二进制字节码
//                byte[] code = cw.toByteArray();
//                // 加载类 执行类的加载
//                test.defineClass("Class" + i, code, 0, code.length);
//            }
//        } finally {
//            System.out.println(j);
//        }
//    }
//}
