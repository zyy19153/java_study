/*
运算符之六：三元运算符
1. 结构：（条件表达式）? 表达式一：表达式二
2. 说明：
① 条件表达式的结果为boolean类型
② 根据条件表达式真或假，决定执行表达式一还是二
  如果表达式为true，则执行表达式一
  如果表达式为false，则执行表达式二
③ 表达式1 和表达式2要求是一致的（说白了就是能用统一的类型去接收）
④ 三元运算符是可以嵌套使用的

3. 凡是可以使用三元运算符的地方都可以改写成if-else
   但反之不成立
4. 如果程序既可以使用三元运算符又可以使用if-else结构，那么优先选择三元运算符。原因：简洁，执行效率高
*/
class SanYuanTest{

	public static void main(String[] args){
	
		//获取两个整数的较大值
		int m = 12;
		int n = 12;
		
		int max = (m > n)? m : n;
		System.out.println(max);
		
		double max1 = (m > n)? 1 : 2.0;
		System.out.println(max1);
		
		//**********************************
		String maxStr = (m > n)? "m大" : ((m == n)? "m和n相等" : "n大");
		System.out.println(maxStr);
		
		//***********************************
		//获取三个数中的最大值
		int n1 = 12;
		int n2 = 30;
		int n3 = -3;
		int mid;
		int max2 = (n3 > (mid = (n1 > n2)? n1 : n2))? n3 : mid;//不建议这样写
		System.out.println("max2=" + max2);
	} 
}