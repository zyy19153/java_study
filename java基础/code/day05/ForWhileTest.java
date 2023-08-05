/*
题目：
从键盘输入个数不确定的整数，并判断读入的正数和负数的个数，输入为0时结束程序


说明：
1. 不在循环条件部分限制次数的结构：for(;;)或while(true)
2. 结束循环的方式：
	方式一：循环条件部分返回false
	方式二：循环体中执行break


*/


import java.util.Scanner;

class ForWhileTest{
	public static void main(String[] args){
		
		Scanner scan = new Scanner(System.in);
		
		
		int positiveNumber = 0;
		int negativeNumber = 0;
		
		for(;;){//while(true){
			System.out.println("请输入整数:");
			int number = scan.nextInt();
			
			if(number > 0){
				positiveNumber++;
			}else if(number < 0){
				negativeNumber++;
			}else{
				break;
			}

		}
		
		System.out.println("正数的个数：" + positiveNumber);
		System.out.println("复数的个数：" + negativeNumber);
	}
}