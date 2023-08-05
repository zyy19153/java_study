# 第08章 聚合函数

# 1. 常见的几个聚合函数

# 1.1 AVG/SUM：只适用于数值类型的字段（或变量）
SELECT AVG(salary),SUM(salary)
FROM employees;

# 如下的操作是没有意义的
SELECT SUM(last_name),AVG(last_name),SUM(hire_date)
FROM employees;

# 1.2 MAX/MIN：适用于数值类型、字符串类型、日期时间类型的字段
SELECT MAX(salary),MIN(salary)
FROM employees;

SELECT MAX(last_name),MIN(last_name),MAX(hire_date)
FROM employees;

# 1.3 COUNT
# ① 作用：计算指定字段在查询结果中出现的次数（不包含NULL值）
SELECT COUNT(employee_id),COUNT(salary),COUNT(1),COUNT(2),COUNT(*)
FROM employees;

SELECT * FROM employees;

# 如果要计算表中有多少条记录，如何实现？
# 方式1：COUNT(*)
# 方式2：COUNT(1)
# 方式3：COUNT(具体字段)：不一定对！

# ② 注意：计算指定字段出现的个数时，是不计算NULL值的
SELECT COUNT(commission_pct)
FROM employees

# ③ 公式：AVG = SUM / COUNT
SELECT AVG(salary),SUM(salary)/COUNT(salary),
AVG(commission_pct),SUM(commission_pct)/COUNT(commission_pct),SUM(commission_pct)/107
FROM employees;

# 需求：查询公司中平均奖金率
# 错误的！
SELECT AVG(commission_pct)
FROM employees;

# 正确的！
SELECT SUM(commission_pct)/COUNT(IFNULL(commission_pct,0)),AVG(IFNULL(commission_pct,0))
FROM employees;

# 如果需要统计表中的记录数，使用COUNT(*),COUNT(1),COUNT(具体字段)，哪个效率更高呢？
# 使用的是MyISAM存储引擎，则三者效率相同，都是O(1)
# 使用的是InnoDB存储引擎，则三者效率：COUNT(*) = COUNT(1) > COUNT(具体字段)

# 其他：方差、标准差、中位数

# 2. GROUP BY 的使用
# 需求：查询各个部门的平均工资、最高工资
SELECT AVG(salary),department_id,SUM(salary)
FROM employees
GROUP BY department_id

SELECT job_id,AVG(salary)
FROM employees
GROUP BY job_id

SELECT job_id,department_id,AVG(salary)
FROM employees
GROUP BY job_id,department_id

SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY department_id,job_id

# 注意：如下写法是错误的，虽然mysql没有报错
SELECT department_id,job_id,AVG(salary)
FROM employees
GROUP BY department_id
# 结论1：SELECT中出现的非组函数的字段必须声明在GROUP BY中，反之，GROUP BY中声明的字段可以不出现在SELECT中

# 结论2：GROUP BY声明在FROM后面、WHERE后面、ORDER BY前面、LIMIT前面

# 结论3：MySQL中GROUP BY中使用WITH ROLLUP
SELECT department_id,AVG(salary)
FROM employees
GROUP BY department_id WITH ROLLUP;

# 正确的：查询各个部门的平均工资并升序排列
SELECT department_id,AVG(salary) avg_sal
FROM employees
GROUP BY department_id
ORDER BY avg_sal ASC

# 错误的：
# 当使用ROLLUP时，不能同时使用ORDER BY子句进行结果排序，即ROLLUP和ORDER BY是互相排斥的。
SELECT department_id,AVG(salary) avg_sal
FROM employees
GROUP BY department_id WITH ROLLUP
ORDER BY avg_sal ASC


# 3. HAVING的使用：用来过滤数据的
# 练习：查询各个部门中最高工资比10000高的部门信息
# 错误的：(WHERE中不能写聚合函数)
SELECT department_id,MAX(salary)
FROM employees
WHERE MAX(salary) > 10000
GROUP BY department_id

# 正确的：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000

# 要求1：如果过滤条件中使用了聚合函数，则必须使用HAVING来替换WHERE。否则，报错

#要求2：HAVING必须声明在GROUP BY的后面

# 开发中，我们使用HAVING的前提是SQL中使用了GROUP BY

# 练习：查询部门id为10，20，30，40这四个部门中最高工资比10000高的部门信息
# 方式1：推荐，执行效率高于方式2
SELECT department_id,MAX(salary)
FROM employees
WHERE department_id IN (10,20,30,40)
GROUP BY department_id
HAVING MAX(salary) > 10000

# 方式2：
SELECT department_id,MAX(salary)
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 10000 AND department_id IN (10,20,30,40)

# 结论：当过滤条件中有聚合函数时，则此过滤条件必须声明在HAVING中。当过滤条件中没有聚合函数时，则此过滤条件声明在WHERE或HAVING中都可以，但（强烈）建议声明在WHERE中

/*
WHERE 和 HAVING 的对比
1. 从适用范围上讲，HAVING的适用范围更广
2. 如果过滤条件中没有聚合函数：这种条件下，WHERE的执行效率高于HAVING
*/


# 4. SQL底层执行原理

# 4.1 SELECT语句的完整结构
/*
sql92语法
SELECT ...,...,...(存在聚合函数)
FROM ...,...,...
WHERE 多表的连接条件 AND 不包含聚合函数的过滤条件
GROUP BY ...,...
HAVING 包含聚合函数的过滤条件
ORDER BY ...,...(ASC/DESC)
LIMIT ...,...

sql99语法
SELECT ...,...,...(存在聚合函数)
FROM ...,...,...
(LEFT/RIGHT)JOIN ... ON 多表的连接条件
WHERE 不包含聚合函数的过滤条件
GROUP BY ...,...
HAVING 包含聚合函数的过滤条件
ORDER BY ...,...(ASC/DESC)
LIMIT ...,...
*/

# 4.2 sql语句的执行过程
# FROM ...,... -> ON -> (LEFT/RIGHT JOIN) -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT



# 第08章 聚合函数的章节练习

## 1.where子句可否适用组函数进行过滤
# No!

## 2.查询员工工资的最大值、最小值、平均值、总和
SELECT MAX(salary),MIN(salary),AVG(salary),SUM(salary)
FROM employees;

## 3.查询各job_id的最大值、最小值、平均值、总和
SELECT job_id,MAX(salary),MIN(salary),AVG(salary),SUM(salary)
FROM employees
GROUP BY job_id;

## 4.选择具有各个job_id的员工人数
SELECT job_id,COUNT(1) employee_numbers
FROM employees
GROUP BY job_id;

## 5.查询员工最高工资和最低工资的差距(DIFFERENCE)
SELECT (MAX(salary) - MIN(salary)) DIFFERENCE
FROM employees;

## 6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计入其内
SELECT manager_id,MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;

## 7.查询所有部门的名字，location_id，员工数和平均工资，并按平均工资降序排列
SELECT d.department_name,d.location_id,COUNT(employee_id),AVG(e.salary)
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name,d.location_id
ORDER BY AVG(e.salary) DESC; # 注意：这里COUNT要选择具体的字段，否则人数会不对

## 分析一下：
SELECT employee_id,salary,d.department_name,d.location_id,e.department_id,d.department_id
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id

## 8.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT job_id,d.department_name,MIN(e.salary)
FROM employees e
RIGHT JOIN departments d 
ON e.department_id = d.department_id 
GROUP BY job_id,department_name;