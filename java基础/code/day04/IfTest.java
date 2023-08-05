/*
说明;
1. else结构是可选的
2. 针对于条件表达式：
	如果多个条件表达式之间是“互斥”关系（或没有交际的关系），哪个判断和执行语句声明在上面还是下面，无所谓
	如果多个条件表达式之间是有交集的关系，需要根据实际情况考虑清楚应该将哪个结构声明在上面
	如果多个条件表达式之间又包含的关系，通常情况下，需要将范围小的声明在范围大的上面，否则，范围小的将不会执行
*/

import java.util.Scanner;

class IfTest{
	public static void main(String[] args){
		
		Scanner scan = new Scanner(System.in);
		
		System.out.println("请输入岳小鹏的成绩：（0-100）");
		int score = scan.nextInt();
		
		if(score == 100){
			System.out.println("奖励一辆宝马BMW");
		}else if(score >= 60){
			System.out.println("奖励一台Ipad");
		}else if(score >= 80){
			System.out.println("奖励一台Iphone XS MAX");
		}//else{
		//	System.out.println("谢谢参与");
		//}
		
		
	}
}