import java.util.Scanner;
class IfExer{
	public static void main(String[] args){
	
	Scanner scan = new Scanner(System.in);
	
	System.out.println("请输入你的身高：（cm）");
	int height = scan.nextInt();
	System.out.println("请输入你的财富：（千万）");
	double wealth = scan.nextDouble();
	//方式一：
	/*
	System.out.println("请输入你是否帅：（true/false）");
	boolean isHandsome = scan.nextBoolean();
	*/
	System.out.println("请输入你是否帅：（true/false）");
	String isHandsome = scan.next();
	
	if(height >= 180 && wealth >= 1 && isHandsome.equals("是")){
		System.out.println("我一定要嫁给他！！！");
	}else if(height >= 180 || wealth >= 1 || isHandsome.equals("是")){
		System.out.println("将就吧。。。");
	}else{
		System.out.println("滚！！！");
	}
	
	}
}