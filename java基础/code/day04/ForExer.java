class ForExer{
	public static void main(String[] args){
		
		for(int i = 1;i <= 150;i++){
			
			System.out.print(i);
			if(i % 3 == 0){
				if(i % 5 == 0){
					if(i % 7 == 0){
						System.out.println(" foo biz baz");
					}else{
						System.out.println(" foo biz");
					}
				}else if(i % 7 == 0){
					System.out.println(" foo baz");
				}else{
					System.out.println(" foo");
				}
			}else if(i % 5 == 0){
				if(i % 7 == 0){
					System.out.println(" biz baz");
				}else{
					System.out.println(" biz");
				}
			}else if(i % 7 ==0){
				System.out.println(" baz");
			}else{
				System.out.println();//»»ÐÐ
			}
			
		}
		
	}
}