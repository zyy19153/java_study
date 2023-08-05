# 第4章 运算符
# 1. 算数运算符：+ - * / div % mod

SELECT 100,100 + 0,100 - 0,100 + 50,100 + 50 - 30,100 + 35.5,100- 35.5
FROM DUAL;

SELECT 100 + '1' # 在Java中，结果是1001 。在SQL中，+没有连接的作用，就表示加法运算。此时，会将字符串转换为数值（隐式转换）
FROM DUAL;

SELECT 100 + 'a' # 此时将'a'看做0处理
FROM DUAL;

SELECT 100 + NULL
FROM DUAL;

SELECT 100,100 * 1,100 * 1.0,100 / 1.0,100 / 2,
100 + 2 * 5 / 2,100 / 3,100 DIV 0 # 分母如果为0，结果就为NULL
FROM DUAL;

# 取模运算 ： %
SELECT 12 % 3,12 % 5,12 MOD -5,-12 % 5,-12 % -5
FROM DUAL;

# 练习：查询员工id为偶数的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE employee_id % 2 = 0;

# 2. 比较运算符
# 2.1 =  <=> <> != < <= > >=

SELECT 1 = 2,1 != 2,1 = '1',1 = 'a',0 = 'a' # 字符串存在隐式转化。如果转换数值不成功，则看作0
FROM DUAL;

SELECT 'a' = 'a','ab' = 'ab','a' = 'b' # 两边都是字符串的话，则按照ANSI的比较规则进行比较
FROM DUAL;

SELECT 1 = NULL,NULL = NULL # 只要有NULL参与判断，结果就为NULL
FROM DUAL;

SELECT last_name,salary,commission_pct 
FROM employees
#WHERE salary = 6000;
WHERE commission_pct = NULL; # 此时执行不会有任何的结果

# <=>：安全等于。记忆技巧：为NULL而生。
# 练习：查询表中commission_pct为NULL的数据
SELECT last_name,salary,commission_pct 
FROM employees
WHERE commission_pct <=> NULL;

SELECT 3 <> 2,'4' <> NULL,'' != NULL,NULL != NULL
FROM DUAL;

# 2.2 
# ① IS NULL \ IS NOT NULL \ ISNULL
SELECT last_name,salary,commission_pct 
FROM employees
WHERE ISNULL(commission_pct);

# 练习：查询表中commission_pct不为NULL的数据
SELECT last_name,salary,commission_pct 
FROM employees
WHERE commission_pct IS NOT NULL;

SELECT last_name,salary,commission_pct 
FROM employees
WHERE NOT commission_pct <=> NULL;

# ② LEAST() \ GREATEST
SELECT LEAST('g','b','t','m'),GREATEST('g','b','t','m')
FROM DUAL;

SELECT LEAST(first_name,last_name),LEAST(LENGTH(first_name),LENGTH(last_name))
FROM employees;
# ③ BETWEEN 条件下界1 AND 条件上界2 （查询条件1和条件2范围内的数据，包含边界）
# 查询工资在6000到8000的员工信息
SELECT employee_id,last_name,salary
FROM employees
#WHERE salary BETWEEN 6000 AND 8000;
WHERE salary >= 6000 && salary <= 8000;

# 交换6000和8000之后，查询不到数据
SELECT employee_id,last_name,salary
FROM employees
WHERE salary BETWEEN 8000 AND 6000;

# 查询工资不在6000到8000的员工信息
SELECT employee_id,last_name,salary
FROM employees
WHERE salary < 6000 OR salary > 8000;

SELECT employee_id,last_name,salary
FROM employees
WHERE salary NOT BETWEEN 6000 AND 8000;

# ④ IN (SET) \ NOT IN (SET)

# 练习：查询部门为10，20，30部门的员工信息
SELECT last_name,salary,department_id
FROM employees
#WHERE department_id = 10 OR department_id = 20 OR department_id = 30;
WHERE department_id IN (10,20,30);

# 练习：查询工资不是6000，7000，8000的员工信息
SELECT last_name,salary,department_id
FROM employees
WHERE salary NOT IN (6000,7000,8000);

# ⑤ LIKE：模糊查询
# 练习：查询last_name中包含字符'a'的员工信息
# %：代表不确定个数的字符(0个，1个，或多个）
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%';

# 练习：查询last_name中以字符'a'开头的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE 'a%';

# 练习：查询last_name中包含字符'a'和'e'的员工信息
#写法1
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%' ;
#写法2
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%' ;

# 练习：查询第3个字符是'a'的员工信息
# _：代表一个不确定的字符
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';# __指两个下划线

# 练习：查询第2个字符是_且第3个字符是'a'的员工信息
# 需要使用转义符：\
SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%';
#或者
SELECT last_name
FROM employees
WHERE last_name LIKE '_$_a%' ESCAPE '$';

# ⑥ REGEXP \ RLIKE：正则表达式

SELECT 'shkstart' REGEXP '^shk','shkstart' REGEXP 't$','shkstart' REGEXP 'hk'
FROM DUAL;

SELECT 'atguigu' REGEXP 'gu.gu','atguigu' REGEXP '[ab]'
FROM DUAL;

# 3. 逻辑运算符： OR || AND && NOT ! XOR
# OR AND 
SELECT last_name,salary,department_id
FROM employees
#WHERE department_id = 10 OR department_id = 20; 
#WHERE department_id = 10 AND department_id = 20; 
WHERE department_id = 50 AND salary > 6000;

# NOT
SELECT employee_id,last_name,salary
FROM employees
WHERE salary NOT BETWEEN 6000 AND 8000;

# XOR：追求的“异”
SELECT last_name,salary,department_id
FROM employees
WHERE department_id = 50 XOR salary > 6000;

# 注意：AND的优先级高于OR

# 4. 位运算符：& | ^ ~ >> << 
SELECT 12 & 5, 12 | 5,12 ^ 5 
FROM DUAL;

SELECT 10 & ~1
FROM DUAL;

# 在一定范围内，每向左移动一位，相当于乘以2，每向右移动一位，相当于除以2
SELECT 4 << 1,8 >> 1
FROM DUAL;


# 第04章 运算符课后练习

## 1.选择工资不在5000到12000的员工的姓名和工资
SELECT first_name,last_name,salary
FROM employees
#WHERE salary < 5000 || salary > 12000;
WHERE salary NOT BETWEEN 5000 AND 12000;

## 2.选择在20或50号部门工作的员工姓名和部门号
SELECT first_name,last_name,department_id
FROM employees
WHERE department_id IN (20,50);

## 3.选择公司中没有管理者的员工姓名及job_id
SELECT first_name,last_name,job_id
FROM employees
WHERE manager_id IS NULL;

## 4.选择公司中有奖金的员工姓名、工资和奖金级别
SELECT first_name,last_name,salary,commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;

## 5.选择员工姓名的第三个字母是a的员工姓名
SELECT first_name,last_name
FROM employees
WHERE last_name LIKE '__a%';

## 6.选择姓名中有字母a和k的员工姓名
SELECT first_name,last_name
FROM employees
WHERE last_name LIKE '%a%k%' OR last_name LIKE '%k%a%';

## 7.显示出表employees表中first_name以'e'结尾的员工信息
SELECT * 
FROM employees
WHERE first_name REGEXP 'e$';

## 8.显示出表employees部门编号在80-100之间的姓名、工种
SELECT first_name,last_name,job_id
FROM employees
WHERE department_id >= 80 AND department_id <= 100;

## 9.显示出表employees的manager_id是100，101，110的员工姓名、工资、管理者id
SELECT first_name,last_name,salary,manager_id
FROM employees
WHERE employee_id IN (100,101,110);
