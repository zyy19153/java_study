/*
100以内的所有质数
质数：素数，只能被1和它本身整除的自然数。
最小的质数是2



*/


class PrimeNumberTest{
	public static void main(String[] args){
		
		boolean isFlag = true;
		
		
		System.out.println("100以内的质数有：");
		
		for(int i = 2;i <= 100;i++){                  //遍历100以内的自然数
			for(int j = 2;j <= (i - 1);j++){          //j被i整除
				if(i % j == 0){
					isFlag = false;
				}
			}
			if(isFlag == true){
				System.out.println(i);
			}
			isFlag = true;                             //重置isFlag,不重置isFlag在第一次变成false后会一直是false
		}
	}
}