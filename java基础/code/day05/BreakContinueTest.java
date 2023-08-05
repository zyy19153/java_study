/*
                 使用范围                循环中使用的作用(不同点)       相同点
break:			switch-case                    
                循环结构中				 结束当前循环                   关键字后面不能声明执行语句

continue:       循环结构中               结束当此循环                   关键字后面不能声明执行语句
*/


class BreakContinueTest{
	public static void main(String[] args){
		for(int i = 1;i <= 10;i++){
			if(i % 4 ==0){
				//break;//123
				continue;//12345678910
				//System.out.print("今晚猎个痛快！！！");//编译会报错
			}
			System.out.print(i);
		}
		
		System.out.println();
		//************************************************
		
		label:for(int i = 1;i <= 4;i++){
			for(int j = 1;j <= 10;j++){
				if(j % 4 == 0){
					//break;//就近原则，默认跳出包裹此关键字最近的一层循环
					//continue;
					
					//break label;//结束指定标识的一层循环结构
					continue label;//结束指定表示的一层循环结构的档次循环
				}
				System.out.print(j);
			}
			System.out.println();
		}
		
		
	}
}