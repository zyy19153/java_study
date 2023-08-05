/*
1. 凡是可以使用switch-case的结构都可以转换成if-else，反之不成立
2. 当我们写分支结构时，既可以使用switch-case（switch中的表达式取值情况不太多），又可以使用if-else时，
   我们优先选择switch-case，原因：switch-case执行效率高


*/



import java.util.Scanner;
class SwitchCaseExer{
	public static void main(String[] args){
		Scanner scan = new Scanner(System.in);
		
		System.out.println("请输入年份");
		int year = scan.nextInt();
		System.out.println("请输入" + year + "年的月份");
		int mouth = scan.nextInt();
		System.out.println("请输入" + year + "年的日期");
		int day = scan.nextInt();
		
		int sumDays = 0;
		switch(mouth){
			case 12:
				sumDays += 30;
			case 11:
				sumDays += 31;
			case 10:
				sumDays += 30;
			case 9:
				sumDays += 31;
			case 8:
				sumDays += 31;
			case 7:
				sumDays += 30;
			case 6:
				sumDays += 31;
			case 5:
				sumDays += 30;
			case 4:
				sumDays += 31;
			case 3:
				//sumDays += 28
				if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0){
					sumDays += 29;
				}else{
					sumDays += 28;
				}
			case 2:
				sumDays += 31;
			case 1:
				sumDays += day;
		
		}
		System.out.println(year + "年" + mouth + "月" + day + "日" + "是当年的第" + sumDays + "天");
		
	}
}