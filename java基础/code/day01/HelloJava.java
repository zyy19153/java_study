 //若javadoc后出现“错误: 编码GBK的不可映射字符”，则在编码里转为ANSI编码，保存再试即可。
 /*
 1. java规范的三种注释方式：
 单行注释
 多行注释
 文档注释（java所特有的）
 
 2. 单行注释和多行注释的作用：
 ① 对所写的程序进行解释说明，增强可读性。方便自己，方便别人！
 ② 调试所写的代码。
 
 3. 特点：单行注释和多行注释的内容不参与编译，
    换句话说，编译后的字节码文件（.class结尾的文件）不包含注释掉的信息。
 
 4.文档注释的使用：
     注释的内容可以被javadoc解析，生成一套以网页文件形式体现的该程序的说明文档。
 
 */
 
 /**
 文档注释的使用
 @author shkstart
 @version v1.0
 这是我的第一个java程序！
 */
 
 
public class HelloJava{
	/*
	单行注释：如下的main方法是程序的入口！
	main方法的格式是固定的！
	*/
	/**
	如下的方法是main（），作用是程序的入口。
	*/
	public static void main(String[] args){
		//单行注释：如下的语句表示输出到控制台
		System.out.println("Hello World!");
	}
}