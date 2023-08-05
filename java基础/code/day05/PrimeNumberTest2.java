/*
100000以内的质数输出：实现方式二




*/



class PrimeNumberTest2{
	public static void main(String[] args){
		
			int count = 0;
			long start = System.currentTimeMillis(); //获取当前时间距离1970-01-01 00:00:00 的毫秒数 
			
			
			
			label:for(int i = 2;i <= 100000;i++){                  
				//for(int j = 2;j < i;j++){ 
				for(int j = 2;j <= Math.sqrt(i);j++){       //优化2：对本身是质数的自然数是有效的   
					if(i % j == 0){
						continue label;                     //优化1：只对本身非质数的自然数是有效的
					}
				}
				//执行到此步骤的都是质数
					count++;
				
				                          
			}
			
			long end = System.currentTimeMillis();
			System.out.println("质数的个数为：" + count);
			System.out.println("说花费的时间：" + (end - start));//20019 > 优化1：2435 > 优化2：785
			                                                     //11762 > 优化1：1498 > 优化2：14
	}
}