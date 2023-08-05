/*
分支结构二：switch-case

1. 格式
switch（表达式）{
	case 常量1；
	执行语句1；
	//break；
	
	case 常量2：
	执行语句2；
	//break；
	
	...
	
	default:
	执行语句n；
	//break;
}

2. 说明：
① 根据switch表达式中的值，依次匹配各个case中的常量。一旦匹配成功，则进入相应case结构中，调用其执行语句。
  当调用完执行语句之后，则仍然继续向下执行其他case结构中的执行语句，知道遇到break关键字或此switch-case结构末尾结束为止

② break关键字可以使用在switch-case结构中，表示一旦执行到此关键字，就跳出switch-case结构

③ switch-case中的表达式，只能是以下的6中类型之一：byte,short,char,int,枚举类型（JDK5.0新增）,String(JDK7.0新增)

④ case之后只能声明常量，不能声明范围

⑤ break关键字是可选的

⑥ default相当于if-else中的else
          default结构是可选的而且位置是灵活的

*/



class SwitchCaseTest{
	public static void main(String[] args){
		
		
		int number = 2;
		switch(number){
			
		    case 0:
				System.out.println("zero");
				break;
			case 1:
				System.out.println("one");
				break;
			case 2:
				System.out.println("two");
				break;
			case 3:
				System.out.println("three");
				break;
			default:
				System.out.println("other");
				
		}
		
		
		//****************************************
		
		//错误示范
		/*
		boolean isHandsome = true;
		switch(isHandsome){
			case true:
			System.out.println("雀氏帅");
			break;
			case false:
			System.out.println("sorry");
			break;
			default:
			System.out.println("输入有误");
		}
		*/
	}
}