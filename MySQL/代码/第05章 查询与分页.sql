# 第05章 排序与分页

# 1. 排序

# 1.1 基本的使用
# 如果没有使用排序操作，默认情况下查询返回的数据是按照添加的顺序显示的
SELECT * FROM employees;

# 练习：按照salary从高到低的顺序显示员工信息

#使用ORDER BY 对查询到的数据进行操作
#升序：ASC（ascend）
#降序：DESC（descend）
SELECT employee_id,last_name,salary
FROM employees
ORDER BY salary DESC;

SELECT employee_id,last_name,salary
FROM employees
ORDER BY salary; # 如果在ORDER BY后没有显示的指明排序的方式，则默认是升序排序

# 2. 我们可以使用列的别名，进行排序
SELECT employee_id,salary,salary * 12 annual_sal
FROM employees
ORDER BY annual_sal ;

# 列的别名只能在ORDER BY中使用，不能在WHERE中使用
# 如下的操作会报错
SELECT employee_id,salary,salary * 12 annual_sal
FROM employees
WHERE annual_sal > 81600;

# 3. 强调格式：WHERE需要声明在FROM后，ORDER BY之前
SELECT employee_id,salary
FROM employees
WHERE department_id IN (50,60,70)
ORDER BY department_id DESC;

# 4. 二级排序

# 练习：显示员工信息，按照department_id的降序排列，再按照salary的升序排列
SELECT employee_id,salary,department_id
FROM employees
ORDER BY department_id DESC,salary ASC;

# 2. 分页
# 2.1 mysql使用limit实现数据的分页显示

# 需求1：每页显示20条记录，此时显示第一页
SELECT employee_id,last_name
FROM employees
LIMIT 0,20;

# 需求2：每页显示20条记录，此时显示第二页
SELECT employee_id,last_name
FROM employees
LIMIT 20,20;

# 需求3：每页显示20条记录，此时显示第三页
SELECT employee_id,last_name
FROM employees
LIMIT 40,20;

# 需求：每页显示pageSize条记录，此时显示第pageNo页
# 公式：LIMIT (pageNo - 1) * PageSize,pageSize

# 2.2 WHERE和ORDER BY和LIMIT的声明顺序如下

# LIMIT的格式：严格来说：LIMIT 位置偏移量，条目数
# 结构："LIMIT 0,条目数" 等价于 "LIMIT 条目数"
SELECT employee_id,last_name,salary
FROM employees
WHERE salary > 6000 
ORDER BY salary DESC
#LIMIT 0,10;
LIMIT 10;

# 练习：表中有107条数据，我们只想要显示第32，33条数据？
SELECT employee_id,last_name
FROM employees
LIMIT 31,2;

# 2.3 MySQL8.0新特性：LIMIT ... OFFSET ...
#练习：表中有107条数据，我们只想要显示第32，33条数据？
SELECT employee_id,last_name
FROM employees
LIMIT 2 OFFSET 31;

# 练习：查询员工表中工资最高的员工信息
SELECT employee_id,last_name,salary
FROM employees
ORDER BY salary DESC
#LIMIT 0,1;
LIMIT 1;

# 2.4 LIMIT可以使用在 MySQL、PostgreSQL、MariaDB 和 SQLite 中，不能使用在SQL Server,DB2,Oracle



# 第05章 排序与分页的课后练习

## 1.查询员工的姓名和部门号和年薪，按年薪降序，按姓名升序显示
SELECT last_name,department_id,salary * 12 * (1 + IFNULL(commission_pct,0))
FROM employees
ORDER BY salary * 12 * (1 + IFNULL(commission_pct,0)) DESC,last_name ASC;

## 2.选择工资不在8000到17000的员工的姓名和工资，按工资降序，显示第21到40位置的数据
SELECT last_name,salary
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC
LIMIT 20,20;

## 3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT * 
FROM employees
WHERE email REGEXP 'e'
ORDER BY LENGTH(email) DESC,department_id ASC;