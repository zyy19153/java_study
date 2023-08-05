/*
Forx循环结构的使用：
一、循环结构的4个要素
1 初始化结构
2 循环结构 --> 是boolean类型
3 循环体
4 迭代条件

二、for循环的结构

for(1;2;4){
	3
}

执行过程：1 > 2 > 3 > 4 > 2 > 3 > 4 > ... > 2

*/


class ForTest{
	public static void main(String[] args){
		
		for(int i = 1;i <= 5;i++){
		System.out.println("Hello World!!!");
		}
		
		//i:只在for循环内有效，出了循环就无效了
		
		//练习
		int num = 1;
		for(System.out.print('a');num <= 3;System.out.print('c'),num++){
			System.out.print('b');
		}
		
		//例题：遍历100以内的偶数,输出所有偶数的和、个数
		int sum = 0;
		int count = 0;
		for(int i = 1;i <= 100;i++){
			if(i % 2 == 0)
				System.out.println(i);
			sum += i;
			count++;
		}
		System.out.println("总和为" + sum + "\n个数为" + count);
	}
}