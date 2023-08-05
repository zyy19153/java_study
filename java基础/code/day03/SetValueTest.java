/*
运算符之二：赋值运算符
= += -= *= /= %=



*/



class SetValueTest{

	public static void main(String[] args){
		
		//赋值符号：=
		int i1 = 10;
		int j1 = 10;
		
		int i2,j2;
		//连续赋值
		i2 = j2 = 10;
		
		int i3 = 10,j3 = 10;//中间别用分号
		
		//**********************************
		int num1 = 10;
		num1 += 2;//num1 = num1 + 2
		

		System.out.println(num1);
		
		int num2 = 12;
		num2 %= 5;
		System.out.println(num2);
		
		short s1 = 10;
		s1 += 2;//这种写法不会改变数据本身的数据类型
		System.out.println(s1);
		
		//开发中，如果希望变量实现+2的操作，有几种方法？（前提：int num = 10;）
		//方式一：num = num + 2;
		//方式二：num += 2;(推荐)
		
		//开发中，如果希望变量实现+1的操作，有几种方法？（前提：int num = 10;）
		//方式一：num = num + 1;
		//方式二：num += 1;
		//方式三：num++;(推荐)
		
		//练习一：
		int m = 2;
		int n = 3;
		n *= m++;
		System.out.println("m=" + m);
		System.out.println("n=" + n);
		
		//练习二：
		int n1 = 10;
		n1 += (n1++) + (++n1);
		System.out.println("n1=" + n1);//32
		
		//练习三：
		int i = 1;
		i *= 0.1;
		System.out.println(i);//0
		i++;
		System.out.println(i);//1
		
		
		
	} 
}