# 第16章 Java8的其它新特性



## Java8新特性概述

![image-20211202193107758](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202193107758.png)



## Lambda表达式

1. Lambda表达式使用前后的对比

   举例一

   ```java
   @Test
   public void test1(){
       Runnable r1 = new Runnable(){
           @Override
           public void run() {
               System.out.println("我爱北京天安门");
           }
       };
   
       r1.run();
   
       System.out.println("************");
   
       Runnable r2 = () -> System.out.println("我爱北京故宫");
   
   
   
       r2.run();
   }
   ```

   举例二

   ```java
   @Test
   public void test2(){
       Comparator<Integer> com1 = new Comparator<Integer>() {
           @Override
           public int compare(Integer o1, Integer o2) {
               return Integer.compare(o1,o2);
           }
       };
   
       int comapare1 = com1.compare(12, 21);
       System.out.println(comapare1);
   
       System.out.println("*********");
   
       //Lambda表达式的写法
       Comparator<Integer> com2 = (o1, o2) -> Integer.compare(o1,o2);
   
       int comapare2 = com2.compare(32, 21);
       System.out.println(comapare2);
   
   
       System.out.println("*********");
   
       //方法引用
       Comparator<Integer> com3 = Integer::compare;
   
       int comapare3 = com3.compare(32, 21);
       System.out.println(comapare3);
   
   }
   ```

2. Lambda表达式的基本语法

   ```
   1. 举例：(o1,o2) -> Integer.compare(o1,o2);
   
   2. 格式：
       -> ：Lambda操作符 或 箭头操作符
       ->左边 ：Lambda形参列表 （其实就是接口中的抽象方法的形参列表）
       ->右边 ：Lambda体 （其实就是重写的抽象方法的方法体）
   ```

3. 如何使用：分为6中情况

   ![image-20211202193855393](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202193855393.png)

   ![image-20211202193934544](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202193934544.png)

   总结6中情况

   ```
   ->左边 ：Lambda形参列表种的参数类型都可以省略（类型推断）；如果Lambda形参列表只有一个参数，其一对()也可以省略；
   ->右边 ：Lambda应该使用一对{}进行包裹，如果Lambda只有一条执行语句（可能时return语句），可以省略一对{}和return关键字
   ```



## 函数式接口

1. 函数式接口的使用说明

   ```
   如果一个接口中只声明了一个方法，就叫函数式接口。
   我们可以在一个接口上添加@FunctionalInterface，这样做可以检查它是否是一个函数式接口
   Lambda表达式的本质：作为函数式接口的实例（接口的要求：只有一个抽象方法，即函数式接口）
   ```

2. Java8中关于Lambda表达式提供的4个基本的函数式接口

   具体使用

   ![image-20211202194610084](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202194610084.png)

3. 总结

   3.1 如何使用Lambda表达式

   ```
   当需要对一个函数式接口实例化时，可以使用lambda表达式
   ```

   3.2 何时使用给定的函数式接口

   ```
   如果我们开发中需要定义一个函数式接口，首先看一看已有的JDK提供的函数式接口是否提供了能满足需求的函数式接口。如果有，则直接调用即可，不需要自己声明。
   ```

   

## 方法引用

1. 理解

   ```
   方法引用可以看作Lambda表达式的深层次的表达。换句话说，方法引用就是Lambda表达式，也就是函数式接口的一个实例，通过方法的名字来指向一个方法
   ```

2. 使用情景

   ```
   当要传递给Lambda体的操作，已经有实现的方法了，可以使用方法引用
   ```

3. 格式

   ```
   类（或对象） :: 方法名
   ```

4. 分为如下的3种情况

   ```
   情况1     对象 :: 非静态方法
   情况2     类 :: 静态方法
   
   情况3     类 :: 非静态方法
   ```

5. 要求

   ```
   要求接口中的抽象方法形参列表和返回值类型与方法引用的方法的形参列表和返回值类型都必须相同 （针对于情况1和2）
   当函数式接口方法的第一个参数时需要引用方法的调用者，并且第二个参数是需要引用方法的参数（或无参数）时：ClassName::methodName（针对于情况3）
   ```

6. 使用建议

   ```
   如果给函数式接口提供实例，恰好满足方法引用的使用情景，大家就可以考虑使用方法引用给函数式接口提供实例。如果大家不熟悉方法引用，那么还可以使用Lambda表达式
   ```

7. 使用举例

   ```java
   /*
   情况一：对象 :: 实例方法
   Consumer中的void accept(T t)
   PrintStream中的void println(T t)
    */
   @Test
   public void test1(){
       Consumer<String> con1 = str -> System.out.println(str);
       con1.accept("北京");
   
       System.out.println("************");
   
       PrintStream ps = System.out;
       Consumer<String> con2 = ps::println;
       con2.accept("beijing");
   }
   
   /*
   supplier中的T get()
   Employee中的String getName()
    */
   @Test
   public void test2(){
   
   }
   
   /*
   情况二： 类::静态方法
   Comparator中的int compare(T t1,T t2)
   Integer中的int compare(T t1,T t2)
    */
   @Test
   public void test3(){
       Comparator<Integer> com1 = (t1,t2) -> Integer.compare(t1,t2);
       System.out.println(com1.compare(12, 21));
   
       System.out.println("**************");
   
       Comparator<Integer> com2 = Integer::compare;
       System.out.println(com2.compare(12, 21));
   }
   
   /*
   Function中的R apply(T t)
   Math中的Long round(Double d)
    */
   @Test
   public void test4(){
       Function<Double,Long> func1 = d -> Math.round(d);
       System.out.println(func1.apply(12.3));
   
       System.out.println("***********");
   
       Function<Double,Long> func2 = Math::round;
       System.out.println(func2.apply(12.6));
   }
   
   /*
   情况三：    类::实例方法（有难度）
   Comparator中的int compare(T t1,T t2)
   String中的int t1.compareTo(t2)
    */
   @Test
   public void test5(){
       Comparator<String> com1 = (s1,s2) -> s1.compareTo(s2);
       System.out.println(com1.compare("abc", "abd"));
   
       System.out.println("************");
   
       Comparator<String> com2 = String::compareTo;
       System.out.println(com2.compare("abc","abm"));
   }
   
   /*
   Function中的R apply(T t)
   Employee中的String getName()
    */
   ```

   

## 构造器引用和数组引用

1. 构造器引用格式

   ```
   类名::new
   ```

2. 构造器引用使用要求

   ```
   和方法引用类似，函数式接口的抽象方法的形参列表和构造器的形参列表一致
   抽象方法的返回值类型即为构造器所属的类的类型
   ```

3. 构造器引用举例

4. 数组引用格式

   ```
   数组类型[]::new
   ```

5. 数组引用举例

   ```java
   /*
   数组引用
   Function中的R apply(T t)
    */
   @Test
   public void test2(){
       Function<Integer,String[]> func1 = length -> new String[length];
       String[] arr1 = func1.apply(5);
       System.out.println(Arrays.toString(arr1));
   
       System.out.println("**************");
   
       Function<Integer,String[]> func2 = String[] :: new;
       String[] arr2 = func2.apply(2);
       System.out.println(Arrays.toString(arr2));
   }
   ```



## Stream API

1. Stream API的理解

   ```
   Stream关注的是对数据的运算，与CPU打交道
   集合关注的是数据的存储，与内存打交道
   
   java8提供了一套API，使用这套API可以对内存中的数组进行过滤、排序、映射、规约等操作。类似于sql对数据库中表的操作
   ```

2. 注意点 

   ```
   ①Stream自己不会存储元素
   ②Stream不会改变源对象。相反，他们会返回一个持有结果的新Stream
   ③Stream操作时有延迟的。这意味着他们会等到需要结果的时候才执行
   ```

3. Stream的使用流程

   ```
   ①Stream的实例化
   ②一系列的中间操作（过滤、映射、...）
   ③终止操作
   ```

4. 使用流程的注意点

   ```
   4.1 一个中间操作链，对数据源的数据进行处理
   4.2 一旦执行终止操作，就执行中间操作链，并产生结果。之后，不会在被使用
   ```

5. 步骤一：Stream的实例化

   ```java
   //创建Stream方式一：通过集合
   @Test
   public void test1(){
       /*
       List<Employee> employees = EmployeeData.getEmployees();
   
       //default Stream<E> stream() ： 返回一个顺序流
       Stream<Employee> stream = employees.stream();
   
       //default Stream<E> parallelStream() ： 返回一个并行流
       Stream<Employee> parallelStream = employees.parallelStream();
        */
   }
   
   //创建Stream方式二：通过数组
   @Test
   public void test2(){
       /*
       int[] arr = new int[]{1,2,3,4,5,6};
       //调用Arrays类的static<T> Stream<T> stream(T[] array): 返回一个流
       IntStream stream = Arrays.stream(arr);
   
       Employee e1 = new Employee(1001,"Tom");
       Employee e2 = new Employee(1002,"Jerry");
       Employee[] arr1 = new Employee[]{e1,e2};
       Stream<Employee> stream1 = Arrays.stream(arr1);
        */
   }
   
   //创建Stream方式三：通过Stream的of()
   @Test
   public void test3(){
       /*
       Stream<integer> stream = Stream.of(1,2,3,4,5,6);
        */
   }
   
   //创建Stream方式四：创建无限流
   @Test
   public void test4(){
       /*
   
       迭代：
       public static<T> Stream<T> iterate(final T seed,final UnaryOperator<T> f)
       //遍历前十个偶数
       Stream.iterate(0,t -> t + 2).limit(10).forEach(System.out::println);
   
       生成：
       public static<T> Stream<T> generate(Supplier<T> s)
       Stream.generate(Math::random).limit(10).forEach(System.out::println);
        */
   }
   ```

6. 步骤二：中间操作

   ![image-20211202201616670](pictures\Stream中间操作1.jpg)

   ![image-20211202201655212](pictures\Stream中间操作2.jpg)

   ![image-20211202201755981](pictures\Stream中间操作3.jpg)

7. 步骤三：终止操作

   ![image-20211202201847081](pictures\Stream终止操作1.jpg)

   ![image-20211202201927207](pictures\Stream终止操作2.jpg)

   ![image-20211202202000316](pictures\Stream终止操作3.jpg)

   ![image-20211202202057184](pictures\Stream终止操作4.jpg)

   <!-- ![image-20211202202213256](pictures\Stream终止操作5.jpg) -->



## Optional类的使用

1. 理解

   ```
   Optional<T>类（java.util.Optional）是一个容器类，它可以保存类型T的值，代表这个值存在。或者仅仅保存null，表示这个值不存在。原来用null表示一个值不存在，现在Optional可以更好的表达这个概念。并且可以避免空指针异常
   ```

2. 常用方法

   ```java
   @Test
       public void test1(){
           Optional<Object> op1 = Optional.empty();
           if(!op1.isPresent()){//Optional封装的数据是否包含数据
               System.out.println("数组为空");
           }
           System.out.println(op1);
           System.out.println(op1.isPresent());
           //如果Optional封装的数据为空，则get()报错，否则，value不为空时，返回value
   //        System.out.println(op1.get());
       }
   
       @Test
       public void test2(){
           String str = "hello";
   //        str = null;
           //of(T t)：封装数据t生成Optional对象。要求t非空，否则报错
           Optional<String> op1 = Optional.of(str);
           //get()通常与of()方法搭配使用。用于获取内部封装的数据value
           String str1 = op1.get();
           System.out.println(str1);
       }
   
       @Test
       public void test3(){
           String str = "beijing";
   //        str = null;
           //ofNullable(T t) ： 封装数据t赋给Optional内部的value，不要求t非空
           Optional<String> op1 = Optional.ofNullable(str);
           //orElse(T t1)：如果Optional内部的value非空，则返回value值。如果value为空，返回t1值
           String str2 = op1.orElse("shanghai");
           System.out.println(str2);
       }
   ```

3. 典型练习

   ```java
   //使用Optional类的getFGirlName():
   public String getGirlName2(Boy boy){
       Optional<Boy> boyOptional = Optional.ofNullable(boy);
       Boy boy1 = boyOptional.orElse(new Boy(new Girl("迪丽热巴")));
       //此时的boy1一定非空
       Girl girl = boy1.getGirl();
       Optional<Girl> girlOptional = Optional.ofNullable(girl);
       Girl girl1 = girlOptional.orElse(new Girl("古力娜扎"));
       //此时的girl1一定非空
       return girl1.getName();
   }
   
   @Test
   public void test5(){
       Boy boy = null;
       String girlName = getGirlName2(boy);
       System.out.println(girlName);
       Boy boy1 = new Boy();
       System.out.println(getGirlName2(boy1));
       Boy boy2 = new Boy(new Girl("苍老师"));
       System.out.println(getGirlName2(boy2));
   }
   ```

