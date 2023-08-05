# 第15章 存储过程与存储函数

# 0. 准备过程
CREATE DATABASE dbtest15;

USE dbtest15;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.`employees`;

CREATE TABLE departments
AS
SELECT *
FROM atguigudb.`departments`;

SELECT * FROM employees;
SELECT * FROM departments;

# 1.创建存储过程

# 举例1：创建存储过程select_all_data()，查看employees表的所有数据

DELIMITER $

CREATE PROCEDURE select_all_data()
BEGIN
		SELECT * FROM employees;
END $

DELIMITER ;

# 2. 存储过程的调用

CALL select_all_data();

# 举例2：创建存储过程avg_employee_salary()，返回所有员工的平均工资
DELIMITER //
CREATE PROCEDURE avg_employee_salary()
BEGIN 
		SELECT AVG(salary) FROM employees;
END //
DELIMITER ;

# 调用
CALL avg_employee_salary();

# 举例3：创建存储过程show_max_salary()，用来查看“emps”表的最高薪资值。
DELIMITER //
CREATE PROCEDURE show_max_salary()
BEGIN
		SELECT MAX(salary)
		FROM employees;
END //
DELIMITER ;

# 调用
CALL show_max_salary();

# 类型2：带OUT
# 举例4：创建存储过程show_min_salary()，查看“emps”表的最低薪资值。并将最低薪资通过OUT参数“ms”输出
DESC employees;
DELIMITER //
CREATE PROCEDURE show_min_salary(OUT ms DOUBLE)
BEGIN
		SELECT MIN(salary) INTO ms
		FROM employees;
END //
DELIMITER ;

# 调用
CALL show_min_salary(@ms);

# 查看变量值
SELECT @ms;

# 类型3：带IN
# 举例5：创建存储过程show_someone_salary()，查看“emps”表的某个员工的薪资，并用IN参数empname输入员工姓名。

DELIMITER //
CREATE PROCEDURE show_someone_salary(IN empname VARCHAR(20))
BEGIN 
		SELECT salary FROM employees
		WHERE last_name = empname;
END //
DELIMITER ;

# 调用方式1：
CALL show_someone_salary('Abel');

SELECT * FROM employees
WHERE last_name = 'Abel';

# 调用方式2：
SET @empname = 'Abel';
-- SET @empname := 'Abel';
CALL show_someone_salary(@empname);

# 类型4：带IN和OUT
# 举例6：创建存储过程show_someone_salary2()，查看“emps”表的某个员工的薪资，并用IN参数empname输入员工姓名，用OUT参数empsalary输出员工薪资。

DELIMITER //
CREATE PROCEDURE show_someone_salary2(IN empname VARCHAR(20),OUT empsalary DECIMAL(10,2))
BEGIN 
		SELECT salary INTO empsalary
		FROM employees
		WHERE last_name = empname;
END //
DELIMITER ;

# 调用
SET @empname = 'Abel';
CALL show_someone_salary2(@empname,@empsalary);
SELECT @empsalary;

# 类型5：带INOUT
# 举例7：创建存储过程show_mgr_name()，查询某个员工领导的姓名，并用INOUT参数“empname”输入员工姓名，输出领导的姓名。
DESC employees;
DELIMITER $
CREATE PROCEDURE show_mgr_name(INOUT empname VARCHAR(25))
BEGIN
		SELECT last_name 
		FROM employees
		WHERE employee_id = (
												SELECT manager_id 
												FROM employees
												WHERE last_name = empname
												);
END $
DELIMITER ;

# 调用
SET @empname = 'Abel';
CALL show_mgr_name(@empname);
SELECT @empname;


# 2.存储函数
# 举例1：创建存储函数，名称为email_by_name()，参数定义为空，该函数查询Abel的email，并返回，数据类型为字符串型。

DELIMITER $
CREATE FUNCTION email_by_name()
RETURNS VARCHAR(25)
DETERMINISTIC 
CONTAINS SQL
READS SQL DATA
BEGIN
		RETURN (SELECT email FROM employees WHERE last_name = 'Abel');
END $ 
DELIMITER ;

# 调用
SELECT email_by_name();

# 举例2：创建存储函数，名称为email_by_id()，参数传入emp_id，该函数查询emp_id的email，并返回，数据类型为字符串型。

# 创建函数前执行此语句，保证函数的创建会成功
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $
CREATE FUNCTION email_by_id(emp_id INT)
RETURNS VARCHAR(25)
BEGIN
		RETURN (
		SELECT email
		FROM employees
		WHERE employee_id = emp_id);
END $
DELIMITER ;

# 调用
SELECT email_by_id(100);

SET @emp_id = 102;
SELECT email_by_id(@emp_id);

# 举例3：创建存储函数count_by_id()，参数传入dept_id，该函数查询dept_id部门的员工人数，并返回，数据类型为整型。
SET log_bin_trust_function_creators = 1;
DELIMITER $
CREATE FUNCTION count_by_id(dept_id INT)
RETURNS INT
BEGIN
		RETURN (
		SELECT COUNT(*)
		FROM employees
		WHERE department_id = dept_id
		);
END $
DELIMITER ;

# 调用
SET @dept_id = 30;
SELECT count_by_id(@dept_id);


# 3.存储过程、存储函数的查看
# 3.1 使用SHOW CREATE语句查看存储过程和函数的创建信息**

SHOW CREATE PROCEDURE show_mgr_name;

SHOW CREATE FUNCTION count_by_id;

# 3.2 使用SHOW STATUS语句查看存储过程和函数的状态信息

SHOW PROCEDURE STATUS;

SHOW PROCEDURE STATUS LIKE 'show_max_salary';

SHOW FUNCTION STATUS LIKE 'email_by_id';
# 3.3 从information_schema.Routines表中查看存储过程和函数的信息

SELECT *
FROM information_schema.Routines
WHERE ROUTINE_NAME = 'email_by_id' AND ROUTINE_TYPE = 'FUNCTION';# 这里的function必须是大写！

# 3.4 存储过程和存储函数的修改
ALTER PROCEDURE show_max_salary
SQL SECURITY INVOKER
COMMENT '查询最高工资';

# 3.5 删除存储过程和存储函数

DROP FUNCTION IF EXISTS count_by_id;

DROP PROCEDURE IF EXISTS show_min_salary;



# 第15章 存储过程和存储函数的课后练习

## 0.准备工作
CREATE DATABASE test15_pro_func;
USE test15_pro_func;

CREATE TABLE admin(
id INT PRIMARY KEY AUTO_INCREMENT,
user_name VARCHAR(15) NOT NULL,
pwd VARCHAR(25) NOT NULL
);

## 1.创建存储过程insert_user()，实现传入用户名和密码，插入到admin中
DELIMITER $
CREATE PROCEDURE insert_user(IN username VARCHAR(15),IN `password` VARCHAR(25))
BEGIN
		INSERT INTO admin(user_name,pwd)
		VALUES (username,`password`); 
END $ 
DELIMITER ;
# 调用

CALL insert_user('Tom','abc123');

SELECT * FROM admin;


## 2.创建存储过程get_phone()，实现传入女神编号，返回女神姓名和电话
CREATE TABLE beauty(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(15) NOT NULL,
phone VARCHAR(15) UNIQUE,
birth DATE 
);

INSERT INTO beauty(name,phone,birth)
VALUES
('朱茵1','1111111','1991-01-01'),
('朱茵2','2222222','1991-02-02'),
('朱茵3','3333333','1991-03-03'),
('朱茵4','4444444','1991-04-04'),
('朱茵5','5555555','1991-05-05'),
('朱茵6','6666666','1991-06-06');

DELIMITER $ 
CREATE PROCEDURE get_phone(IN i_id INT,OUT o_name VARCHAR(15),OUT o_phone VARCHAR(15))
BEGIN
		SELECT name,phone INTO o_name,o_phone 
		FROM beauty
		WHERE i_id = id;
END $
DELIMITER ;

# 调用
CALL get_phone(1,@o_name,@o_phone);

SELECT @o_name,@o_phone;

## 3. 创建存储过程date_diff()，实现传入两个女神的生日，返回日期间隔大小
DELIMITER $ 
CREATE PROCEDURE date_diff(IN i_birth1 DATE,IN i_birth2 DATE,OUT o_diff INT)
BEGIN 
		SELECT DATEDIFF(i_birth1,i_birth2) INTO o_diff
		FROM DUAL;
END $
DELIMITER ;

SET @i_birth2 = '1999-07-25';
SET @i_birth1 = '2021-12-23';
CALL date_diff(@i_birth1,@i_birth2,@o_diff);
SELECT @o_diff;

## 4. 创建存储过程formal_date()，实现传入一个日期，格式化为xx年xx月xx日兵返回
DELIMITER $ 
CREATE PROCEDURE formal_date(IN i_date DATE,OUT o_date VARCHAR(25))
BEGIN
		SELECT DATE_FORMAT(i_date,'%y年%m月%d日') INTO o_date
		FROM DUAL;
END $
DELIMITER ;

SET @i_date = '1998-07-25';
CALL formal_date(@i_date,@o_date);
SELECT @o_date;

## 5. 创建存储过程beauty_limit(),根据传入的起始索引和条目数，查询女神的记录
DELIMITER $
CREATE PROCEDURE beauty_limit(IN `index` INT,IN num INT)
BEGIN 
		SELECT *
		FROM beauty
		LIMIT `index`,num;
END $
DELIMITER ;

CALL beauty_limit(0,1);

# 创建带INOUT模式参数的存储过程
## 6. 传入a和b两个值，最终a和b都翻倍兵返回
DELIMITER $
CREATE PROCEDURE double_input(INOUT a INT,INOUT b INT)
BEGIN 
		SELECT a * 2,b * 2 INTO a,b
		FROM DUAL;
		#SET a = a * 2;
		#SET b = b * 2; 可以取代一二行
END $
DELIMITER ;

SET @a = 1;
SET @b = 2;
CALL double_input(@a,@b);
SELECT @a,@b;

DROP PROCEDURE double_input;

## 7. 删除题目5的存储过程
DROP PROCEDURE beauty_limit;

## 8. 查看题目6的存储过程的信息
SELECT * FROM information_schema.Routines
WHERE ROUTINE_NAME = 'double_input';

SHOW CREATE PROCEDURE double_input;

SHOW PROCEDURE STATUS LIKE 'double_input';


#存储函数的练习
USE test15_pro_func;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE departments
AS 
SELECT * FROM atguigudb.departments;

# 无参数返回
# 1. 创建函数get_count()，返回公司员工的个数
DELIMITER $
CREATE FUNCTION get_count()
RETURNS INT
BEGIN 
		RETURN (SELECT COUNT(*) FROM employees);
END $
DELIMITER ;

SELECT get_count();


# 有参数返回
# 2. 创建函数ename_salary()，根据员工的姓名，返回他们的工资
DESC employees;
SELECT * FROM employees;
DELIMITER $
CREATE FUNCTION ename_salary(name VARCHAR(25))
RETURNS DOUBLE(8,2)
BEGIN 
		RETURN (
		SELECT salary 
		FROM employees
		WHERE last_name = name
		);
END $
DELIMITER ;

SET @name = 'Kochhar';
SELECT ename_salary(@name);

# 3. 创建函数dept_sal()，根据部门名，返回该部门的平均工资
DESC departments;
SELECT * FROM departments;

##########################################
######这题我写的有问题，目前不知道为啥#####
###########################################
DELIMITER $
CREATE FUNCTION dept_sal(i_department_name VARCHAR(30))
RETURNS DECIMAL
DETERMINISTIC 
CONTAINS SQL
READS SQL DATA
BEGIN
		DECLARE name VARCHAR(30);
		SET name = i_department_name;
		RETURN (
		SELECT AVG(salary)
		FROM employees 
-- 		WHERE department_id = 60
		WHERE department_id = (
														SELECT department_id
														FROM departments 
														WHERE department_name = 'IT'#i_department_name
														)
		GROUP BY department_id
		);
END $
DELIMITER ;

SET @i_department_name = 'IT';
SELECT ename_salary('IT');

DROP FUNCTION dept_sal;

# 
SELECT AVG(salary)
FROM employees e
WHERE e.department_id = (
												 SELECT d.department_id
												 FROM departments d
												 WHERE d.department_name = 'IT'
												 )
GROUP BY department_id;
DESC employees;
SELECT * FROM employees;