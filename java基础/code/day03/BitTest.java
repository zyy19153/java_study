/*
运算符之五：位运算符（了解）

结论：
1. 位运算符操作的都是整型的数据
2.  << ：在一定的范围内，每向左移一位，相当于*2
    >> ：在一定的范围内，每向右移一位，相当于/2

面试题：
最高效的方式计算2 * 8 ?  2 << 3 或 8 << 1



*/


class BitTest{

	public static void main(String[] args){
	
		int i = 21;
		i = -84;
		System.out.println("i >> 2 :" + (i >> 2));//右移拿最高位补
		
		int m = 12;
		int n = 5;
		System.out.println("m & n :" + (m & n));
		System.out.println("m | n :" + (m | n));
		System.out.println("m ^ n :" + (m ^ n));
		
		//练习：交换两个变量的值
		int num1 = 10;
		int num2 = 20;
		
		//方式一： 定义临时变量
		//推荐
		int temp = num1;
		num1 = num2;
		num2 = temp;
		System.out.println("num1 = " + num1 + '\n' + "num2 = " + num2);
		
		//方式二：好处：不用定义临时变量
		//        弊端：① 相加操作可能超出存储范围 ② 有局限性：只能适用于数据类型
		num1 = 10;num2 = 20;
		num1 = num1 + num2;
		num2 = num1 - num2;
		num1 = num1 - num2;
		System.out.println("num1 = " + num1 + '\n' + "num2 = " + num2);
		
		//方式三：使用位运算符
		num1 = 10;num2 = 20;
      	num1 = num1 ^ num2;
		num2 = num1 ^ num2;
		num1 = num1 ^ num2;
		System.out.println("num1 = " + num1 + '\n' + "num2 = " + num2);
		
	}
}