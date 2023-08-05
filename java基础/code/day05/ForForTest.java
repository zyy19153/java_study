/*
前台循环的使用
1. 嵌套循环：将一个循环结构A声明在另一个循环结构B的循环体中，就构成了嵌套循环

2.
外层循环：循环结构B
内层循环：循环结构A

3. 说明：
	内存循环结构遍历一遍，只相当于外部循环体执行了一次
	假设外层循环体需要执行m次，内层循环体需要执行n次，则内层循环体一共执行了mn次


*/




class ForForTest{
	public static void main(String[] args){
		
		for(int i = 1;i <= 5;i++){               //控制行数
			for(int j = 1;j <= i;j++){           //控制列数
				System.out.print('*');
			}
			
			System.out.println();
			
		}
		
		for(int i = 4;i >= 1;i--){               //控制行数
			for(int j = 1;j <= i;j++){           //控制列数
				System.out.print('*');
			}
			
			System.out.println();
			
		}
		
		
	}
}