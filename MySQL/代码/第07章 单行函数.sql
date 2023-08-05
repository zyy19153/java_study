# 第07章 单行函数

# 1. 数值函数

# 基本的操作
SELECT ABS(-123),ABS(32),SIGN(-23),SIGN(43),PI(),CEIL(32.32),CEILING(-43.23),FLOOR(32.32),FLOOR(-43.23),MOD(12,5)
FROM DUAL;

# 取随机数
SELECT RAND(),RAND(),RAND(10),RAND(10),RAND(-1),RAND(-1)
FROM DUAL;

# 四舍五入，截断操作
SELECT ROUND(12.33),ROUND(12.343,2),ROUND(12.324,-1),TRUNCATE(12.66,1),TRUNCATE(12.66,-1)
FROM DUAL;

# 单行函数可以嵌套
SELECT TRUNCATE(ROUND(123.456,2),0)
FROM DUAL

# 角度和弧度的转换
SELECT RADIANS(30),RADIANS(45),RADIANS(60),RADIANS(90),DEGREES(PI()/2),DEGREES(RADIANS(60))
FROM DUAL;

# 三角函数
SELECT SIN(PI()/6),DEGREES(ASIN(1)),TAN(RADIANS(45)),DEGREES(ATAN(1))
FROM DUAL;

# 指数和对数
SELECT POW(2,5),POWER(2,4),EXP(2)
FROM DUAL;

SELECT LN(EXP(2)),LOG10(100),LOG2(4)
FROM DUAL

# 进制间转换
SELECT BIN(10),HEX(10),OCT(10),CONV(10,10,8)
FROM DUAL;

# 2. 字符串函数

SELECT ASCII('ABCabc'),CHAR_LENGTH('hello'),CHAR_LENGTH('我们'),LENGTH('hello'),LENGTH('我们')
FROM DUAL; # UTF-8中，一个汉字用三个字节表示

# xxx worked for yyy
SELECT CONCAT(emp.last_name,' worked for ',mgr.last_name)
FROM employees emp JOIN employees mgr
WHERE emp.manager_id = mgr.employee_id;

SELECT CONCAT_WS('-','hello','world','beijing')
FROM DUAL;

# 字符串的索引是从1开始的！
SELECT INSERT('helloworld',2,3,'aaaa'),REPLACE('hello','ll','mmm')
FROM DUAL;

SELECT UPPER('hello'),LOWER('HellLo')
FROM DUAL

SELECT last_name,salary
FROM employees
WHERE last_name = 'King';

SELECT LEFT('hello',2),RIGHT('hello',13)
FROM DUAL

# LPAD：实现右对齐的效果
# RPAD：实现左对齐的效果
SELECT employee_id,last_name,LPAD(salary,10,'*')
FROM employees

SELECT CONCAT('---',RTRIM(' h  e  l lo '),'***'),
TRIM('o' FROM 'oohelloo')
FROM DUAL

SELECT LENGTH(SPACE(5)),STRCMP('abc','abd')
FROM DUAL 

SELECT SUBSTR('hello',2,2),LOCATE('lll','hello')
FROM DUAL

SELECT ELT(2,'a','b','c','d'),FIELD('mm','gg','jj','mm','dd','mm'),FIND_IN_SET('mm','gg,mm,jj,dd,mm,gg')
FROM DUAL

SELECT employee_id,NULLIF(LENGTH(first_name),LENGTH(last_name))
FROM employees

# 数值 字符串 日期时间 数据库中最重要的三种数据类型

# 3. 日期二号时间函数

# 3.1 获取日期和时间
SELECT CURDATE(),CURRENT_DATE(),CURTIME(),NOW(),SYSDATE(),
UTC_DATE(),UTC_TIME()
FROM DUAL

# 3.2 日期与时间戳的转换
SELECT UNIX_TIMESTAMP(),UNIX_TIMESTAMP('2021-12-10 20:52:30'),FROM_UNIXTIME(1639140750),FROM_UNIXTIME(1639140750)
FROM DUAL

# 3.3 获取月份、星期、星期数、天数等函数
SELECT YEAR(CURDATE()),MONTH(CURDATE()),DAY(CURDATE()),
HOUR(CURTIME()),MINUTE(NOW()),SECOND(SYSDATE())
FROM DUAL;

SELECT MONTHNAME('2021-10-26'),DAYNAME('2021-10-26'),WEEKDAY('2021-10-26'),
QUARTER(CURDATE()),WEEK(CURDATE()),DAYOFYEAR(NOW()),
DAYOFMONTH(NOW()),DAYOFWEEK(NOW())
FROM DUAL;

# 3.4 日期的操作函数
SELECT EXTRACT(SECOND FROM NOW())
FROM DUAL

# 3.5 时间和秒数的转换
SELECT TIME_TO_SEC(CURTIME()),
SEC_TO_TIME(75964)
FROM DUAL;

# 3.6 计算日期和时间的函数
SELECT DATE_ADD(NOW(),INTERVAL 1 YEAR),
DATE_ADD(NOW(),INTERVAL -1 YEAR),
DATE_SUB(NOW(),INTERVAL 1 YEAR)
FROM DUAL

SELECT ADDTIME(NOW(),20),SUBTIME(NOW(),30),SUBTIME(NOW(),'1:1:3'),DATEDIFF(NOW(),'2021-10-01'),
TIMEDIFF(NOW(),'2021-10-25 22:10:10'),FROM_DAYS(366),TO_DAYS('0000-12-25'),
LAST_DAY(NOW()),MAKEDATE(YEAR(NOW()),12),MAKETIME(10,21,23),PERIOD_ADD(20200101010101,10)
FROM DUAL;

# 3.7 日期和时间的格式化和解析
# 格式化：日期 -> 字符串
# 解析 ： 字符串 -> 日期

# 此时我们谈的是日期的显示格式化和解析
# 之前，我们接触过隐式的格式化和解析
SELECT * 
FROM employees 
WHERE hire_date = '1990-01-03';

# 格式化：
SELECT DATE_FORMAT(CURDATE(),'%Y-%M-%D'),
DATE_FORMAT(NOW(),'%Y-%m-%d'),TIME_FORMAT(CURTIME(),'%H:%i:%S'),
DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%S %W %w %T %r')
FROM DUAL

# 解析：格式化的逆过程
SELECT STR_TO_DATE('2021-12-10 21:32:59 Friday 5 21:32:59','%Y-%m-%d %H:%i:%S %W %w %T')

SELECT GET_FORMAT(DATE,'USA')
FROM DUAL

SELECT DATE_FORMAT(CURDATE(),GET_FORMAT(DATE,'USA'))
FROM DUAL

# 4. 流程控制函数
# IF(VALUE,VALUE1,VALUE2)

SELECT last_name,salary,IF(salary >= 6000,'高工资','低工资') "details"
FROM employees;

SELECT last_name,commission_pct,IF(commission_pct IS NOT NULL,commission_pct,0) "details"
FROM employees

# IFNULL(VALUE1,VALUE2)：看作是IF(VALUE,VALUE1,VALUE2)的特殊情况
SELECT last_name,commission_pct,IFNULL(commission_pct,0) "details"
FROM employees

# 4.3 CASE WHEN ... THEN ...WHEN ... THEN ... ELSE ... END 
# 类似于java的if ... else if ... else if ... else ... 
SELECT last_name,salary,CASE WHEN salary >= 15000 THEN '白骨精'
														 WHEN salary >= 10000 THEN '潜力股'
													   WHEN salary >= 8000 THEN '小屌丝'
														 ELSE '草根' END "details",department_id
FROM employees 

SELECT last_name,salary,CASE WHEN salary >= 15000 THEN '白骨精'
														 WHEN salary >= 10000 THEN '潜力股'
													   WHEN salary >= 8000 THEN '小屌丝'
														 END "details",department_id
FROM employees 

# 4.4 CASE ... WHEN ... THEN ... WHEN ... THEN ... ELSE ... END 
# 类似于java中的switch ... case ...
/*
练习1：查询部门号为 10,20, 30 的员工信息, 若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 则打印其工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数,其他部门打印其工资的1.4倍
*/
SELECT employee_id,last_name,department_id,salary,CASE department_id WHEN 10 THEN salary * 1.1
						  WHEN 20 THEN salary * 1.2 
							WHEN 30 THEN salary * 1.3 
							ELSE salary * 1.4 END "details"
FROM employees;							

/*
练习2：查询部门号为 10,20, 30 的员工信息, 若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 则打印其工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数
*/
SELECT employee_id,last_name,department_id,salary,CASE department_id WHEN 10 THEN salary * 1.1
						  WHEN 20 THEN salary * 1.2 
							WHEN 30 THEN salary * 1.3 
							END "details"
FROM employees
WHERE department_id IN (10,20,30);							

# 5. 加密与解密的函数
# PASSWORD()在mysql8.0中被弃用了
SELECT MD5('mysql'),SHA('mysql')
FROM DUAL 
# ENCODE(),DECODE()在mysql8.0中被弃用了
SELECT ENCODE('atguigu','mysql'),DECODE(ENCODE('atguigu','mysql'),'mysql')
FROM DUAL

# 6. MySQL信息函数
SELECT VERSION(),CONNECTION_ID(),DATABASE(),SCHEMA(),USER(),CURRENT_USER(),CHARSET('尚硅谷'),COLLATION('尚硅谷')
FROM DUAL

# 7. 其他函数
# 如果n的值小于等于0，则保留整数位
SELECT FORMAT(123.123,2)
FROM DUAL

SELECT CONV(16,10,2),CONV(8888,10,16)
FROM DUAL

SELECT INET_ATON('192.168.1.100'),INET_NTOA(3232235876)
FROM DUAL

# BENCHMARK()用于测试表达式的执行效率
SELECT BENCHMARK(100000,MD5('mysql'))
FROM DUAL
# CONVERT()可以实现字符集的转换
SELECT CHARSET('atguigu'),CHARSET(CONVERT('atguigu' USING 'utf8mb3'))
FROM DUAL



# 第07章 单行函数的课后练习

## 1.显示系统时间（注：日期+时间）
SELECT NOW()
FROM DUAL;

## 2.查询员工号，姓名，工资以及工资提高20percent后的结果
SELECT employee_id,last_name,salary,salary * 1.2 "new salary"
FROM employees;

## 3.将员工的姓名按首字母排序，并写出姓名的长度
SELECT last_name,LENGTH(last_name) "name_length"
FROM employees
ORDER BY last_name;

## 4.查询员工的id,last_name,salary,并作为一个列输出，别名为OUT_PUT
SELECT CONCAT_WS('_',employee_id,last_name,salary) "OUT_PUT" 
FROM employees;

## 5.查询公司各员工工作的年数、工作的天数、并按工作年数的降序排序
SELECT TRUNCATE((DATEDIFF(NOW(),hire_date) / 365),0) "work_years",DATEDIFF(NOW(),hire_date) "work_days"
FROM employees
ORDER BY work_days DESC

## 6.查询员工姓名，hire_date,department_id,满足以下条件：雇佣时间在1997年之后，department_id为80或90或110，commission_pct不为空
SELECT last_name,hire_date,department_id
FROM employees
WHERE DATEDIFF(hire_date,'1997-1-1') > 0 
# DATE_FORMAT(hire_date,'%Y-%m-%d') >= '1997-01-01'
# hire_date >= STR_TO_DATE('1997-01-01','%Y-%m-%d')
AND department_id IN (80,90,110)
AND commission_pct IS NOT NULL;

## 7.查询公司中入职超过10000天的员工姓名、入职时间
SELECT last_name,hire_date
FROM employees
WHERE DATEDIFF(NOW(),hire_date) > 10000

## 8.做一个查询，产生下面的结果<last_name> earns <salary> monthly but wants <salary*3>
SELECT CONCAT('<',last_name,'> earns <',TRUNCATE(salary,0),'> monthly but wants <',TRUNCATE(salary * 3,'>'),0) "dream_salary"
FROM employees 

## 9. 
SELECT * FROM employees 
SELECT job_id "job",CASE WHEN job_id = 'AD_PRES' THEN 'A'
									       WHEN job_id = 'ST_MAN' THEN 'B'
												 WHEN job_id = 'IT_PROG' THEN 'C'
												 WHEN job_id = 'SA_REP' THEN 'D'
												 WHEN job_id = 'ST_CLERK' THEN 'E' 
												 END "grade"
FROM employees

SELECT job_id "job",CASE job_id WHEN 'AD_PRES' THEN 'A'
															  WHEN 'ST_MAN' THEN 'B'
																WHEN 'IT_PROG' THEN 'C'
																WHEN 'SA_REP' THEN 'D'
																WHEN 'ST_CLERK' THEN 'E' 
																ELSE 'undefined' END "grade"
FROM employees