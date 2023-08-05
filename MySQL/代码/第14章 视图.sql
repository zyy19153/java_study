# 第14章 视图

/*
1. 视图的理解

① 视图可以看作是一个虚拟表，本身是不存储数据的。
视图的本质，是存储起来的SElECT语句。

② 视图中SELECT语句中设计到的表，称为基表。

③ 针对视图做DML操作，会影响到对应的基表中的数据。反之亦然。

④ 视图本身的删除，不会导致基表中数据的删除。

⑤ 视图的应用场景：针对于小型项目，不推荐使用视图。
									针对于大型项目，可以考虑使用视图。
									
⑥ 视图的优点：简化查询；控制数据的访问									

*/

# 2. 如何创建视图

# 准备工作

CREATE DATABASE dbtest14;

USE dbtest14;

CREATE TABLE emps
AS 
SELECT * 
FROM atguigudb.employees;

CREATE TABLE depts
AS
SELECT *
FROM atguigudb.departments;

SELECT * FROM emps;

SELECT * FROM depts;

DESC emps;

DESC atguigudb.employees;

# 除了非空约束外的其它约束并没有复制下来

# 针对于单表

# 情况1： 视图中的字段与基表的字段一一对应

CREATE VIEW vu_emp1
AS 
SELECT employee_id,last_name,salary
FROM emps;

SELECT * FROM vu_emp1;

# 确定视图中的字段名方式1：
CREATE VIEW vu_emp2
AS
SELECT employee_id emp_id,last_name lname,salary
# 查询语句中的别名会作为视图中的字段名出现
FROM emps
WHERE salary > 8000;

SELECT * FROM vu_emp2;

# 确定视图中的字段名方式2：
CREATE VIEW vu_emp3(emp_id,name,monthly_sal)
# 小括号内的字段个数与SELECT中的字段个数相同
AS
SELECT employee_id emp_id,last_name lname,salary
FROM emps
WHERE salary > 8000;

SELECT * FROM vu_emp3;

# 情况2： 视图中的字段与基表的字段可能没有对应

CREATE VIEW vu_emp_sal
AS
SELECT department_id,AVG(salary) avg_sal
FROM emps
WHERE department_id IS NOT NULL
GROUP BY department_id;

SELECT * FROM vu_emp_sal;

# 2.2 针对于多表

CREATE VIEW vu_emp_dept
AS
SELECT e.employee_id,e.department_id,d.department_name
FROM emps e 
JOIN depts d
ON e.department_id = d.department_id;

SELECT * FROM vu_emp_dept;

# 利用视图对数据进行格式化

CREATE VIEW vu_emp_dept1
AS
SELECT CONCAT(e.last_name,'(',d.department_name,')') emp_info
FROM emps e 
JOIN depts d
ON e.department_id = d.department_id;

SELECT * FROM vu_emp_dept1;

# 2.3 基于视图来创建视图

CREATE VIEW vu_emp4
AS
SELECT employee_id,last_name
FROM vu_emp1;

SELECT * FROM vu_emp4;

# 3. 查看视图

# 语法1：查看数据库的表对象、视图对象
SHOW TABLES;

# 语法2：查看视图的结构
DESC vu_emp1;

# 语法3：查看视图的属性信息
SHOW TABLE STATUS LIKE 'vu_emp1';

# 语法4：查看视图的详细定义信息
SHOW CREATE VIEW vu_emp1;

# 4. “更新”视图中的数据
# 4.1 一般情况下可以更新数据

SELECT * FROM vu_emp1;

SELECT employee_id,last_name,salary
FROM emps;

#更新视图中的数据，会导致基表中数据的修改
UPDATE vu_emp1
SET salary = 20000
WHERE employee_id = 101;

#同理，修改基表中的数据，也会导致视图中的数据的修改
UPDATE emps
SET salary = 10000
WHERE employee_id = 101;

# 删除视图中的数据也会导致基表中的数据的删除
DELETE FROM vu_emp1
WHERE employee_id = 101;

# 4.2 不能更新数据的情况
SELECT * FROM vu_emp_sal;

# 更新失败
UPDATE vu_emp_sal
SET avg_sal = 5000
WHERE department_id = 30;
# The target table vu_emp_sal of the UPDATE is not updatable

# 删除失败
DELETE FROM vu_emp_sal
WHERE department_id = 30;

# 5. 修改视图
DESC vu_emp1;

# 方式1：
CREATE OR REPLACE VIEW vu_emp1
AS
SELECT employee_id,last_name,salary,email
FROM emps
WHERE salary > 7000;

# 方式2：
ALTER VIEW vu_emp1
AS
SELECT employee_id,last_name,salary,email,hire_date
FROM emps;

# 6. 删除视图
DROP VIEW vu_emp4;

SHOW TABLES;

DROP VIEW IF EXISTS vu_emp2,vu_emp3;




# 第14章 视图的课后练习

# 练习1：

USE dbtest14;

#1. 使用表employees创建视图employee_vu，其中包括姓名(last_name),员工号(employee_id)，部门(department_id)
CREATE OR REPLACE VIEW employee_vu(lname,emp_id,dept_id)
AS
SELECT last_name,employee_id,department_id
FROM emps;

#2. 显示视图的结构
DESC employee_vu;

#3. 查询视图中的全部内容
SELECT * FROM employee_vu;

# 4.将视图中的数据限定在部门号是80的范围内
ALTER VIEW employee_vu
AS
SELECT last_name,employee_id,department_id
FROM emps
WHERE department_id = 80;

# 练习2：
SELECT * FROM emps;
# 1. 创建视图emp_v1，要求查询电话号码以'011'开头的员工姓名和工资、邮箱
CREATE OR REPLACE VIEW emp_v1 
AS 
SELECT last_name,salary,email
FROM emps
WHERE phone_number REGEXP '^011';
# WHERE phone_number LIKE '011%';

# 2.要求将视图emp_v1修改为查询电话号码以'011'开头并且邮箱中包含e字符的员工姓名和邮箱、电话号码
ALTER VIEW emp_v1
AS
SELECT last_name,email,phone_number
FROM emps
WHERE phone_number REGEXP '^011' AND email REGEXP 'e';

# 3.向emp_v1插入一条记录，是否可以？
DESC emps;
INSERT INTO emp_v1
VALUES('Tom','tom@163.com','01012345');
# Field of view 'dbtest14.emp_v1' underlying table doesn't have a default value
# 不可以，emps的其它属性有设置为NOT NULL的

# 4. 修改emp_v1中员工的工资，每人涨薪1000
ALTER VIEW emp_v1
AS SELECT last_name,email,phone_number,salary
FROM emps
WHERE phone_number REGEXP '^011' AND email REGEXP 'e';

UPDATE emp_v1
SET salary = salary + 1000;

SELECT * FROM emp_v1;
# 5. 删除emo_v1中姓名为Olsen的员工
DELETE FROM emp_v1
WHERE last_name = 'Olsen';

# 6. 创建视图emp_v2，要求查询部门的最高工资高于12000的部门的id和其最高工资
CREATE VIEW emp_v2
AS
SELECT department_id,MAX(salary) max_sal
FROM emps
GROUP BY department_id
HAVING max_sal > 12000;

SELECT * FROM emp_v2;

# 7. 向emp_v2中插入一条记录，是否可以？
INSERT INTO emp_v2
VALUES(4000,20000);
# The target table emp_v2 of the INSERT is not insertable-into
# no

# 8. 删除刚刚的emp_v1 & emp_v2
DROP VIEW emp_v1,emp_v2;

SHOW TABLES;

