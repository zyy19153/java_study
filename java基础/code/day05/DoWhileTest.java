/*
do-while循环的使用

一、循环结构的4个要素
1 初始化结构
2 循环结构
3 循环体
4 迭代条件

二、do-while循环的使用

1
do{
	3;
	4;
	}while(2);

执行过程：1 > 3 > 4 > 2 > 3 > 4 > 2 > ... > 2

说明：
1. do-while循环至少会执行一次循环体
2. 开发中使用for和while多一些，较少使用do-while


*/






class DoWhileTest{
	public static void main(String[] args){
	
	//遍历100以内的偶数
	int num = 1;
	do{
		if(num % 2 == 0){
			System.out.println(num);
		}
		num++;
		
	}while(num <= 100);
	
	int num2 = 10;
	do{
		System.out.println(num2);
		num2--;
	}while(num2 > 10);
	
	
	}
}