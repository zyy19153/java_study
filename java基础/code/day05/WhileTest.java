/*
While循环使用

一、循环结构的4个要素
1 初始化结构
2 循环结构
3 循环体
4 迭代条件

二、 while循环的结构

1
while（2）{
	3；
	4；
}

执行过程：1 > 2 > 3 > 4 > 2 > 3 >4 > ... > 2

说明：
1. 写while循环千万小心不要丢了迭代条件，一旦丢了，就可能导致死循环
2. 我们写程序要尽量避免出现死循环
3. for循环和while循环是可以相互转化的！
	区别：for循环和while循环的初始条件的作用范围不同
*/



class WhileTest{
	public static void main(String[] args){
		
		//遍历100以内的偶数
		int i = 1;
		while(i <= 100){
			if(i % 2 == 0){
				System.out.println(i);
			}
			i++;
		}
		//出了while循环后i依然可以使用
		System.out.println(i);
		
	}
}