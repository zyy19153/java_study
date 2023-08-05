# 第15章 Java反射机制

## 反射的概述

1. 本章的主要内容

   ![image-20211202165055173](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202165055173.png)

2. 关于反射的理解

   ```
   Reflection反射是被视为动态语言的关键，反射机制允许程序在执行期借助于Reflection API取得任何类的内部信息，并能直接操作任意对象的内部属性及方法
   
   框架 = 反射 + 注解 + 设计模式
   ```

3. 体会反射机制的“动态性”

   ```java
   //体会反射的动态性
   @Test
   public void test2(){
       int num = new Random().nextInt(3);
       String classPath = "";
       switch(num){
           case 0:
               classPath = "java.util.Date";
               break;
           case 1:
               classPath = "java.lang.Object";
               break;
           case 2:
               classPath = "com.atguigu.java.Person";
               break;
       }
   
       try {
           Object obj = getInstance(classPath);
           System.out.println(obj);
       } catch (Exception e) {
           e.printStackTrace();
       }
   
   }
   
   /*
   创建一个指定类的对象
   classPath：指定类的全类名
    */
   public Object getInstance(String classPath) throws Exception {
       Class clazz = Class.forName(classPath);
       return clazz.newInstance();
   }
   ```

4. 反射机制能提供的功能

   ![image-20211202170132316](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202170132316.png)

5. 相关API

   ```
   java.lang.Class：反射的源头
   java.lang.reflect.Method
   java.lang.reflect.Field
   java.lang.reflect.Constructor
   ...
   ```

## Class类的理解和获取Class的实例

1. Class类的理解

   ```
   1. 类的加载过程
   程序在经过javac.exe命令后，会生成一个或多个字节码文件（.class结尾），接着我们使用
   java.exe命令对某个字节码文件进行解释运行。相当于将某个字节码文件加载到内存中。此过程
   就成为类的加载。加载到内存中的类，我们就成为运行时类，此运行时类，就作为Class的一个实例
   2. 话句话说，Class实例就对应着一个运行时类
   3. 加载到内存中的运行时类，会缓存一定的时间。在此时间内，我们可以通过不同的方式来获取此运
       行时类。
   ```

2. 获取Class实例的几种方式

   ```java
   //获取Class类的实例（前三种方式需要掌握）
       @Test
       public void test3() throws ClassNotFoundException {
           //方式一：调用运行时类的属性:.class
           Class clazz1 = Person.class;
           System.out.println(clazz1);
           //方式二：通过运行时类的对象,调用getClass()
           Person p1 = new Person();
           Class clazz2 = p1.getClass();
           //方式三：调用Class的静态方法：forName(String classPath)  (使用频率最高）
           Class clazz3 = Class.forName("com.atguigu.java.Person");
   //        clazz3 = Class.forName("java.lang.String");
           System.out.println(clazz3);
   
           System.out.println(clazz1 == clazz2);
           System.out.println(clazz1 == clazz3);
   
           //方式四：使用类的加载器：ClassLoader  (了解)
           ClassLoader classLoader = ReflectionTest.class.getClassLoader();
           Class<?> clazz4 = classLoader.loadClass("com.atguigu.java.Person");
           System.out.println(clazz4);
           System.out.println(clazz1 == clazz4);
       }
   ```

3. 总结：创建类的对象的方式

   ```
   方式一：new + 构造器
   方式二：要创建Xxx类的对象，可以考虑：Xxx、Xxxs、XxxFactory、XxxBuilder类中查看是否有相应的静态方法的存在。可以调用其静态方法，创建Xxx对象
   方式三：通过反射
   ```

4. Class实例可以是哪些结构的说明

   ![image-20211202171005740](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202171005740.png)

## 了解ClassLoader

1. 类的加载过程----了解

   ![image-20211202171134247](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202171134247.png)

2. 类的加载器的作用

   ```
   将class文件字节码内容加载到内存中，并将这些静态数据转换成方法区的运行时数据结构，然后在堆中生成一个代表这个类的java.lang.Class对象，作为方法区中类数据的访问接口
   ```

3. 类的加载器的分类

   ![image-20211202171433436](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202171433436.png)

4. Java类编译、运行的执行的流程

   ![image-20211202171619221](C:\Users\19153\AppData\Roaming\Typora\typora-user-images\image-20211202171619221.png)

5. 使用ClassLoader加载src目录下的配置文件

   ```java
       /*
       Properties：读取配置文件
        */
       @Test
       public void test2() throws IOException {
           Properties pros = new Properties();
           //此时的文件默认在当前的module下
           //读取配置文件的方式一
   //        FileInputStream fis = new FileInputStream("src/jdbc.properties");
   //        pros.load(fis);
   
           //读取配置文件的方式二：使用ClassLoader
           //配置文件默认识别为：当前module的src下
           ClassLoader classLoader = ClassLoaderTest.class.getClassLoader();
           InputStream is = classLoader.getResourceAsStream("jdbc.properties");
           pros.load(is);
   
           String user = pros.getProperty("user");
           String password = pros.getProperty("password");
           System.out.println("user = " + user + ", password = " + password);
       }
   ```

## 反射应用一：创建运行时类的对象

1. 代码举例

   ```java
   @Test
   public void test1() throws InstantiationException, IllegalAccessException {
       Class<Person> clazz = Person.class;
   
       Person obj = clazz.newInstance();//类的泛型决定了getClass()的返回值
       System.out.println(obj);
   }
   ```

2. 说明

   ```
   newInstance()：调用此方法，创建对应的运行时类的对象。内部调用了运行时类的空参构造器
   
   要想此方法正常的创建运行时类的对象，要求：
   1. 运行时类必须提供空参的构造器
   2. 空参的构造器的访问权限得够。通常，设置为public
   
   在javaBean中要求提供一个public的空参构造器，原因：
   1. 便于通过反射，创建运行时类的对象
   2. 便于子类继承此运行时类时，默认调用super()时，保证父类由此构造器
   ```

## 反射应用二：获取运行时类的完整结构

```java
@Test
public void test1(){
    Class clazz = Person.class;

    //获取属性结构
    //getFields()：获取当前运行时类及其父类中声明为public访问权限的属性
    Field[] fields = clazz.getFields();
    for(Field f : fields){
        System.out.println(f);
    }

    //getDeclaredFields()：获取当前运行时类当中声明的所有属性。（不包含父类中的属性）
    Field[] declaredFields = clazz.getDeclaredFields();
    for(Field f : declaredFields){
        System.out.println(f);
    }
}
```

```java
@Test
public void test1(){
    Class clazz = Person.class;

    //getMethods()：获取当前运行时类及其父类中声明为public权限的方法
    Method[] methods = clazz.getMethods();
    for(Method m : methods){
        System.out.println(m);
    }

    System.out.println("******");

    //getDeclaredMethods()：获取当前运行时类中声明的所有方法（不包含父类中声明的）
    Method[] declaredMethods = clazz.getDeclaredMethods();
    for (Method dM : declaredMethods) {
        System.out.println(dM);
    }


}
```

```java
/*
    获取构造器

     */
    @Test
    public void test1(){
        Class clazz = Person.class;
        //getConstructors()：获取当前运行时类中声明为public的构造器
        Constructor[] constructors = clazz.getConstructors();
        for (Constructor c : constructors) {
            System.out.println(c);
        }

        System.out.println();

        //getDeclaredConstructors()：获取当前运行时类中的所有的构造器
        Constructor[] declaredConstructors = clazz.getDeclaredConstructors();
        for (Constructor d : declaredConstructors) {
            System.out.println(d);
        }


    }

    /*
    获取运行时类的父类
     */
    @Test
    public void test2(){
        Class clazz = Person.class;
        Class superclass = clazz.getSuperclass();
        System.out.println(superclass);
    }

    /*
    获取运行时类的带泛型的父类
    */
    @Test
    public void test3(){
        Class clazz = Person.class;
        Type genericSuperclass = clazz.getGenericSuperclass();
        System.out.println(genericSuperclass);
    }

    /*
   获取运行时类的带泛型的父类的泛型

   代码：逻辑性代码 VS 功能性代码
   */
    @Test
    public void test4(){
        Class clazz = Person.class;
        Type genericSuperclass = clazz.getGenericSuperclass();
        ParameterizedType paramType = (ParameterizedType)genericSuperclass;
        //获取泛型类型
        Type[] actualTypeArguments = paramType.getActualTypeArguments();
//        System.out.println(actualTypeArguments[0].getTypeName());
        System.out.println(((Class)actualTypeArguments[0]).getName());
    }

    /*
    获取运行时类的接口
     */
    @Test
    public void test5(){
        Class clazz = Person.class;
        Class[] interfaces = clazz.getInterfaces();
        for (Class c : interfaces) {
            System.out.println(c);
        }

        System.out.println();

        //获取运行时类的父类实现的接口
        Class[] interfaces1 = clazz.getSuperclass().getInterfaces();
        for (Class c1 : interfaces1) {
            System.out.println(c1);
        }


    }

    /*
    获取运行时类的所在的包
    */
    @Test
    public void test6(){
        Class clazz = Person.class;
        Package pack = clazz.getPackage();
        System.out.println(pack);
    }

    /*
    获取运行时类声明的注解
    */
    @Test
    public void test7(){
        Class clazz = Person.class;
        Annotation[] annotations = clazz.getAnnotations();
        for (Annotation annotation : annotations) {
            System.out.println(annotation);
        }

    }
```

## 反射应用三：获取运行时类的指定结构

1. 调用指定的属性

   ```java
   /*
   如何操作运行时类的指定的属性  --- 需要掌握
    */
   @Test
   public void test2() throws Exception {
       Class clazz = Person.class;
   
       Person p = (Person) clazz.newInstance();
   
       //1. getDeclaredField(String fieldName)：获取运行时类中指定变量名的属性
       Field name = clazz.getDeclaredField("name");
   
       //2. 保证当前的属性是可访问的
       name.setAccessible(true);
   
       //3. 获取、设置指定对象的此属性值
       name.set(p,"Tom");
   
       System.out.println(name.get(p));
   
   }
   ```

2. 调用指定的方法

   ```java
   /*
   如何操作运行时类的指定的方法  --- 需要掌握
   */
   @Test
   public void test3() throws Exception {
       Class clazz = Person.class;
   
       //创建运行时类的对象
       Person p = (Person) clazz.newInstance();
   
       /*
       1. 获取指定的某个方法
       getDeclaredMethod()：参数1：指明获取的方法的名称 参数2： 指明获取的方法的形参列表
        */
       Method show = clazz.getDeclaredMethod("show", String.class);
   
       //2. 保证当前方法是可访问的
       show.setAccessible(true);
   
       /*
       3. invoke()：参数1：方法的调用者 参数2：给方法形参赋值的实参
       invoke()方法的返回值即为对应的类中调用的方法的返回值
        */
       Object returnValue = show.invoke(p, "CHN");//String nation = p.show("CHN");
       System.out.println(returnValue);
   
       System.out.println("****************如何调用静态方法*******************");
   
       //private static void showDesc()
   
       Method showDesc = clazz.getDeclaredMethod("showDesc");
       showDesc.setAccessible(true);
       //如果调用的运行时类中的方法没有返回值，则此invoke()返回null
       Object returnVal = showDesc.invoke(Person.class);
       Object returnVal1 = showDesc.invoke(null);//也可以
       System.out.println(returnVal);//null
       System.out.println(returnVal1);//null
   
   
   }
   ```

3. 调用指定过的构造器

   ```java
   /*
   如何调用运行时类中的指定的构造器
    */
   @Test
   public void testConstructor() throws Exception {
       Class clazz  = Person.class;
   
       //private Person(String name)
       /*
       1. 获取指定的构造器
       getDeclaredConstructor():参数：指明构造器的参数列表
        */
       Constructor constructor = clazz.getDeclaredConstructor(String.class);
   
       //2. 保证此构造器是可访问的
       constructor.setAccessible(true);
   
       //3. 调用此构造器创建运行时类的对象
       Person person = (Person) constructor.newInstance("Tom");
       System.out.println(person);
   }
   ```

## 反射应用四：动态代理

1. 代理模式的原理

   ```
   使用一个代理将对象包装起来，然后用该代理对象取代原始对象。任何对原始对象的调用都要通过代理。代理对象决定是否以及何时将方法调用转到原始对象上。
   ```

2. 静态代理

   2.1 举例

   ```
   实现Runnable接口的方式创建多线程
   Class MyThread implements Runnable{}//相当于被代理类
   Class thread implements Runnable{}//相当于代理类
   main(){
   	MyThread t = new MyThread();
   	Thread thread = new Thread(t);
   	thread.start();//启动线程；调用线程的run()
   }
   ```

   2.2 静态代理的缺点

   ```
   1. 代理类和目标代理对象都在编译期间确定下来，不利于程序的扩展
   2. 每一个代理类只能为一个接口服务，这样一来程序开发中必然产生过多的代理
   ```

3. 动态代理的特点

   ```
   动态代理是指客户通过代理类来调用其他对象的方法，并且是在程序运行时根据需要动态创建目标的代理对象
   ```

4. 动态代理的实现

   4.1 需要解决的两个主要问题

   ```
   问题一：如何根据加载到内存中的被代理类，动态的创建一个代理类及其对象  
   	（通过Proxy.newProxyInstance()实现）
   问题二：当通过代理类的对象调用方法时，如何动态的调用被代理类中的同名方法
   	（通过InvocationHandler接口的实现及其方法invoke()）
   ```

   4.2 代码实现

   ```java
   /*
   动态代理的举例
   
    */
   
   interface Human{
       String getBelief();
   
       void eat(String food);
   }
   
   //被代理类
   class SuperMan implements Human{
       @Override
       public String getBelief() {
           return "I believe i can fly";
       }
   
       @Override
       public void eat(String food) {
           System.out.println("我喜欢吃" + food);
       }
   }
   
   class HumanUtil{
       public void method1(){
           System.out.println("****通用方法一*********");
       }
   
       public void method2(){
           System.out.println("*****通用方法二********");
       }
   }
   
   
   
   /*
   要想生成动态代理，需要解决的问题？
   
   问题一：如何根据加载到内存中的被代理类，动态的创建一个代理类及其对象
   
   问题二：当通过代理类的对象调用方法时，如何动态的调用被代理类中的同名方法
    */
   
   class proxyFactory{
       //调用此方法，返回一个代理类的对象。解决问题一
       public static Object getProxyInstance(Object obj){//obj：被代理类的对象
   
           MyInvocationHandler handler = new MyInvocationHandler();
   
           handler.bind(obj);
   
           return Proxy.newProxyInstance(obj.getClass().getClassLoader(), obj.getClass().getInterfaces(),handler);
   
       }
   }
   
   class MyInvocationHandler implements InvocationHandler{
   
       private Object obj;//赋值时，也需要使用被代理类的对象进行赋值
   
       public void bind(Object obj){
           this.obj = obj;
       }
   
       //当我们通过代理类的对象，调用方法a时，就会自动的调用如下的方法：invoke()
       //将被代理类要执行的方法a的功能声明在invoke()方法中
       @Override
       public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
   
           HumanUtil util = new HumanUtil();
           util.method1();
   
           //method：即为代理类对象调用的方法，此方法也就作为了被代理类对象要调用的方法
           //obj:被代理类的对象
           Object returnVal = method.invoke(obj, args);
           util.method2();
           //上述方法的返回值就作为当前类中的invoke()方法的返回值
           return returnVal;
       }
   }
   
   public class ProxyTest {
       public static void main(String[] args) {
           SuperMan superMan = new SuperMan();
           //proxyInstance：代理类的对象
           Human proxyInstance = (Human) proxyFactory.getProxyInstance(superMan);
           //当通过代理类对象调用方法时，会自动的调用被代理类中同名的方法
           String belief = proxyInstance.getBelief();
           System.out.println(belief);
           proxyInstance.eat("四川麻辣烫");
   
           System.out.println("************");
   
           NikeClothFactory nikeClothFactory = new NikeClothFactory();
           ClothFactory proxyInstance1 = (ClothFactory) proxyFactory.getProxyInstance(nikeClothFactory);
           proxyInstance1.produceCloth();
       }
   }
   ```

   

