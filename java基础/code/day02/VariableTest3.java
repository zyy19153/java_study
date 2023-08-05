/*
强制类型转换：自动提升类型运算的逆运算
1. 需要使用强转符：（）
2. 注意点：强制类型转换可能导致精度损失
*/



class VariableTest3{
	public static void main(String[] args){

		double d1 = 12.3;
		//int i1 = d1;

		//System.out.println(i1); //从double转换到int可能会有损失
		
		//精度损失例子1
		int i1 = (int)d1;
		System.out.println(i1); //12  截断操作，就算是12.999也会变成12
	
		//没有精度损失
		//long l1 = 123;
		//short s2 = (short)l1;

		//精度损失列子2
		int i2 = 128;
		byte b = (byte)i2;
		System.out.println(b); //-128
	}
}