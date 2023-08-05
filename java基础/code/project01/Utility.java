import java.util.Scanner;

public class Utility {
    private static Scanner sc = new Scanner(System.in);

    /*
    该方法用于从键盘读取主菜单的1,2,3,4选项，返回用户输入的选择
     */
    public static char readMenuSelection() {
        char c;
        for (; ;){
            String str = readKeyBoard(1);
            c = str.charAt(0);
            if(c != '1' && c != '2' && c!= '3' && c != '4'){
                System.out.print("选择错误，请重新输入：");
            } else break;
        }
        return c;
    }

    /*
    该方法用于从键盘上读取数字金额数据，数字大小不超过4位数，返回输入的数字
     */
    public static int readNumber() {
        int n;
        for (; ;){
            String str = readKeyBoard(4);
            try {
                n = Integer.parseInt(str);
                break;
            } catch (NumberFormatException e){
                System.out.println("输入数字错误，请重新输入：");
            }
        }
        return n;
    }

    /*
    该方法用于收入和支出说明输入，该方法从键盘读取一个字符串并返回
     */
    public static String readString() {
        return readKeyBoard(8);
    }

    public static char readConfirmSelection(){
        char c;
        System.out.print("是否退出，请输入（Y/N）：");
        for(;  ;){
            String str = readKeyBoard(1).toUpperCase();
            c = str.charAt(0);
            if(c == 'Y' || c == 'N'){
                break;
            } else {
                System.out.println("输入错误，请重新输入：");
            }
        }
        return c;
    }

    /*
    改方法用于从键盘读指定长度的取字符串，返回一个字符串
     */
    public static String readKeyBoard(int length) {
        String str;
        for (; ;){
            str = sc.next();
            if(str.length() > length){
                System.out.println("输入数据超出范围，请重新输入" + length + "个数据：");
            } else break;
        }
        return str;
    }

}