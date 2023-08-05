/*
String类型变量的使用
1. String属于引用型数据类型（不是基本数据类型！）
2. 声明String类型变量时，使用一对“”
3. String可以和8种基本数据类型做运算，且运算只能是连接运算：+
4. String和8种数据类型运算后仍是String类型


*/





class StringTest{

	public static void main(String[] args){
		
		String s1 = "Hello,World!";
		
		System.out.println(s1);
		
		String s2 = "a";
		
		String s3 = "";//string里没啥限制
		//char c1 = '';//char里面有且必须放一个字符，空格也行
		
		
		//*******************
		int number = 1001;
		String numberStr = "学号：";
		String info = numberStr + number;// 连接运算
		System.out.println(info);
		
		boolean b1 = true;
		String info1 = info + b1;
		System.out.println(info1);
		
		//*********************************************
		//练习1
		char c = 'a';   //'a'对应的ASCII码：97 'A'对应的ASCII码：65
		int num = 10;
		String str = "Hello";
		System.out.println(c + num +str);//107Hello
		System.out.println(c +str + num);//aHello10
		System.out.println(c + (num +str));//a10Hello
		System.out.println((c + num) +str);//107Hello
		System.out.println(num +str + c);//10Helloa
		
		//练习2
		//*	*
		
		System.out.println("*	*");
		System.out.println('*' + '\t' + '*');//”\t“是制表符相当于Tab键
		System.out.println('*' + "\t" + '*');
		System.out.println('*' + '\t' + "*");
		System.out.println('*' + ("\t" + "*"));
	}
}