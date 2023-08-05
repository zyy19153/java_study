/*
java定义的数据类型：
	一、变量按照数据类型来分：
		
		基本数据类型：
			整型：byte 、 short 、 int 、 long
			浮点型：float、double
			字符型：char
			布尔型：boolean
			
		引用数据类型：
		类（class）：
		接口（interface）：
		数组（array）：

	二、变量在类中的位置声明：
			成员变量 VS 局部变量


*/





class VariableTest1{
	public static void main(String[] args){
		//1. 整型：byte(1字节=8bit) 、 short(2字节) 、 int(4字节) 、 long(8字节)
		//①byte范围： -128 ~ 127
		byte b1 = 12;
		byte b2 = -128;
		//b2 = 128； 编译不通过
		System.out.println(b1);
		System.out.println(b2);
		//②声明long型变量时，必须以“l”或“L”结尾
		//③通常选择int来定义整型变量
		short s1 = 128;
		int i1 = 1234;
		long l1 = 123123123L;
		System.out.println(l1);
		
		//2. 浮点型：float(4字节)、double(8字节)
		//①浮点型：表示带小数点的数值
		//②float表示的数值范围比long还大
		
		double d1 = 12.2;
		System.out.println(d1 + 1);
		//③定义float变量时，变量要以“f”或“F”结尾
		float f1 = 1212f;          //这里我不加f结尾也行，不知道为啥？？？？？？？？
		System.out.println(f1);
		//④通常选择double来定义浮点型变量
		
		//3. 字符型：char（1字符=2个字节）
		//① 定义char型变量，通常使用一对''，内部只能写一个字符
		char c1 = 'a';
		//c1 = 'AB';编译不通过
		System.out.println(c1);
		char c2 = '中';
		System.out.println(c2);
		//②表示方式：1. 声明一个字符 2. 转义字符 3. 直接使用unicode值来表示字符型常量
		char c3 = '\n';
		System.out.print("hello" + c3);
		System.out.print("world");
		System.out.print("\n");
		char c4 = '\u0021';
		System.out.println(c4);
		
		//4. 布尔型：boolean
		//①只能取两个值之一：true、false
		//②常常在条件判断、循环结构中使用
		boolean bb1 = true;
		System.out.println(bb1);
		boolean isMarried = true;
		if(isMarried){
			System.out.println("你就\"无法\"参加聚会！\\n可惜！");
		}
		else{
			System.out.println("恭喜！");
		}
		
		
	}
	
}