/*
练习：
随意给出一个三位数，打印出其个位数，十位数，百位数



*/


class AriExer{

	public static void main(String[] args){
		
			int num = 123;
			int c = num / 100;
			int b = (num % 100) / 10;
			int a = (num % 100) % 10; // int a = num % 10;更巧妙
	
			System.out.println("个位数是：" + a);
			System.out.println("十位数是：" + b);
			System.out.println("百位数是：" + c);
	}
}