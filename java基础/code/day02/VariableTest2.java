/*
基本数据类型之间的运算规则：

前提：这里讨论的只是7中数据类型变量间的运算，不包含boolean类型的

1. 自动类型提升：
	当容量小的数据类型的变量与容量大的数据类型的变量做运算时，结果自动提升为容量大的数据类型
	byte 、 short 、 char--> int --> long --> float --> double
	特别的：当byte、short、char做运算时，结果为int型


2. 强制类型转换：见VariableTest3



说明：此时的容量大小指的是，表示的数的范围的大和小，比如：float容量大于long的容量

*/



class VariableTest2{
	public static void main(String[] args){
		
		byte b1 = 2;
		int i1 = 129;
		//byte b2 = b1 + i1; //编译不通过
		//int b2 = b1 + i1;
		float b2 = b1 + i1; // 123.0
		
		System.out.println(b2);
		//***************************************************
		char c1 = 'a'; //'a' = 97
		int i3 = 10;
		int i4 = c1 + i3;
		System.out.println(i4);
		
		
		short s2 = 10;
		/*short s3 = c1 + s2;
		System.out.println(s3); // 从int转换到short可能会有损失
		*/
		
		//char s4 = c1 + s2;
		//System.out.println(s4); //从int转换到char可能会有损失
		
		byte b3 = 10;
		//char c3 = c1 + b3;
		//System.out.println(c3); //从int转换到char可能会有损失
		
		//short s5 = b3 + s2;
		//System.out.println(s5); //从int转换到short可能会有损失
		
		short s6 = b1 + b3;
		System.out.println(s6); //从int转换到short可能会有损失
		
		//****************************************************
		
		
	
	}

}