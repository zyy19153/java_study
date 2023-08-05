/*
题目：输入两个正整数，求其最大公约数和最小公倍数
      




*/
import java.util.Scanner;
class ForTest1{
	public static void main(String[] args){
		Scanner scan = new Scanner(System.in);
		
		System.out.println("请输入第一个正整数：");
		int m = scan.nextInt();
		System.out.println("请输入第二个正整数：");
		int n = scan.nextInt();
		
		
		int min = (m <= n)? m : n;
		for(int i = min;i >= 1;i--){
			if(m % i == 0 && n % i == 0){
				System.out.println("最大公约数是" + i);
				break;//一旦在循环中遇到break，就跳出循环
			}
		}
		
		int max = (m >= n)? m : n;
		for(int i = max;i > 0;i++){
			if(i % m == 0 && i % n == 0){
				System.out.println("最小公倍数是" + i);
				break;
			}
		}
		
		
		//***********************************************
		//水仙花数
		int ge,shi,bai;
		for(int i = 100;i < 1000;i++){
			ge = i % 10;
			shi = i % 100 / 10;
			bai = i / 100;
			if(ge ^ ge * ge + shi * shi * shi + bai * bai * bai == i) {
				System.out.println("100-999内的水仙数有：" + i);
			}
		}			
		
		
	
	}
}