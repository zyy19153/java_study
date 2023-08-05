/*
说明：
1. if-else是可以相互嵌套的
2. 如果if-else中的执行语句只有一行时，{}是可以省略的，但不建议这么做


*/






import java.util.Scanner;
class IfTest2{
	public static void main(String[] args){
		Scanner scan = new Scanner(System.in);
		
		System.out.println("请输入第一个整数：");
		int num1 = scan.nextInt();
		System.out.println("请输入第二个整数：");
		int num2 = scan.nextInt();
		System.out.println("请输入第三个整数：");
		int num3 = scan.nextInt();
		
		/*
		int a,b,c,d;
		if(num1 >= num2){
			a = num1;
			c = num2;
		}else{
			a = num2;
			c = num1;
		}if(a >= num3){
			b = a;
			d = num3;
		}else{
			b = num3;
			d = a;
		}if(c >= d){
			System.out.println("从小到大为：" + d + " < " + c + " < " + b);
		}else{
			System.out.println("从小到大为：" + c + " < " + d + " < " + b);
		}
		*/
		
		if(num1 >= num2){
			if(num3 >= num1){
				System.out.println(num2 + " < " + num1 + " < " + num3);
			}else if(num3 >= num2){
				System.out.println(num2 + " < " + num3 + " < " + num1);
			}else{
				System.out.println(num3 + " < " + num2 + " < " + num1);
		    }
		}else{
		 	if(num3 >= num2){
			System.out.println(num1 + " < " + num2 + " < " + num3);
		    }else if(num3 >= num1){
			System.out.println(num1 + " < " + num3 + " < " + num2);
		    }else{
			System.out.println(num3 + " < " + num1 + " < " + num2);
		    }
		}
		
		//课后练习：如何随机获取一个随机数
		int value = (int)Math.random() * 90 + 10;//[0.0,1.0) --> [0.0,90) --> [10,90)
		System.out.println(value);
		//公式：[a,b] : (int)(Math.random() * (b - a + 1) + a)
		
	}
}