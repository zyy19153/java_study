/*



*/

class variableTest4{
	public static void main(String[] args){
	
		//编码情况1
		
		//编译成功
		//long l1 = 123123;//没加l结尾即被认为时int型，此时就是自动类型提升
		
		//编译失败
		//long i1 = 123123123123123; //过大的整数: 123123123123123
		//System.out.println(l1);
		
		//***********************************************************
		
		//编译失败
		//float f1 = 12.4; //没加f结尾会被认为时double，从double转换到float可能会有损失
		
		
		//编码情况2
		//整型常量默认为int型，浮点常量默认未double型

		//编译失败
		byte b = 12;
		//byte b1 = b + 1; // 从int转换到byte可能会有损失
		
		//编译失败
		float f1 = b + 12.3; // 从double转换到float可能会有损失
	}
}