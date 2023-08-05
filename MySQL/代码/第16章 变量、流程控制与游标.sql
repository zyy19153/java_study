# 第16章 变量、流程控制与游标

# 1. 系统变量

# 1.1 变量：系统变量（全局系统变量、会话系统变量） VS 用户自定义变量

# 1.2 查看系统变量

# 查询全局系统变量
SHOW GLOBAL VARIABLES; # 620

# 查询会话系统变量
SHOW SESSION VARIABLES; # 643

SHOW VARIABLES; #默认查询的是会话系统变量

# 查询部分系统变量

SHOW GLOBAL VARIABLES LIKE 'admin_%';

SELECT

# 1.3 查看指定的系统变量

SELECT @@global.max_connections;

# 错误：
SELECT @@session.max_connections;
# Variable 'max_connections' is a GLOBAL variable

SELECT @@global.character_set_client;
SELECT @@session.character_set_client;

SELECT @@session.pseudo_thread_id;

# 错误的：
SELECT @@global.pseudo_thread_id;
# Variable 'pseudo_thread_id' is a SESSION variable

SELECT @@character_set_client; # 先查询会话系统变量，再查询全局系统变量

# 1.4 修改系统变量的值

# 方式1：
SET @@global.max_connections = 161;

# 方式2：
SET GLOBAL max_connections = 171;

# 全局系统变量：针对当前的数据库实例是有效的，一旦重启mysql服务，就失效了

# 会话系统变量
# 方式1：
SET @@session.character_set_client = 'gbk';

# 方式2：
SET SESSION character_set_client = 'gbk';

# 会话系统变量：针对于当前的会话是有效的，一旦重新建立新的会话，就失效了

# 1.5 用户变量
/*

① 用户变量 ： 会话用户变量 VS 局部变量

② 会话用户变量 ： 使用 “@”开头，作用域为当前会话

③ 局部变量：只能使用在存储过程和存储函数中

*/

# 1.6 会话用户变量
/*
#方式1：“=”或“:=”
SET @用户变量 = 值;
SET @用户变量 := 值;

#方式2：“:=” 或 INTO关键字
SELECT @用户变量 := 表达式 [FROM 等子句];
SELECT 表达式 INTO @用户变量  [FROM 等子句];

#使用：
SELECT @变量名

*/
# 测试方式1：
SET @m1 = 1;
SET @m2 = 2;
SET @sum = @m1 + @m2;
SELECT @sum;


# 测试方式2：
# 准备工作
CREATE DATABASE dbtest16;

USE dbtest16;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE departments
AS
SELECT * FROM atguigudb.departments;

SELECT * FROM departments;
SELECT * FROM employees;

SELECT @count := COUNT(*) FROM employees;

SELECT @count;

SELECT AVG(salary) INTO @avg_sal FROM employees;

SELECT @avg_sal;

# 1.7 局部变量
/*
1. 局部变量必须：
① 使用DECLARE声明 ② 声明并使用在BEGIN ... END 中（使用在存储过程和存储函数中） ③ DECLARE的方式声明的局部变量必须声明在BEGIN中的首行的位置

2. 声明格式
DECLARE 变量名2,变量名3,... 变量数据类型 [DEFAULT 变量默认值];

3. 变量赋值
方式1：
SET 变量名=值;
SET 变量名:=值; 

4. 使用
SELECT 局部变量名;

*/

# 举例：
DELIMITER $
CREATE PROCEDURE test_var()
BEGIN
		# 1. 声明局部变量
		DECLARE a INT DEFAULT 0;
		DECLARE b INT;
		# DECLARE a,b INT DEFAULT 0;
		DECLARE emp_name VARCHAR(25);
		
		# 2. 赋值
		SET a = 1;
		SET b := 2;
		
		SELECT last_name INTO emp_name FROM employees WHERE employee_id = 101;
		
		# 3. 使用
		SELECT a,b,emp_name;
		
END $
DELIMITER ;

CALL test_var();

# 举例1：声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary

DELIMITER $
CREATE PROCEDURE test_pro()
BEGIN
		# 声明
		DECLARE emp_name VARCHAR(25);
		DECLARE sal DOUBLE(10,2) DEFAULT 0.0;
		# 赋值
		SELECT last_name,salary INTO emp_name,sal
		FROM employees
		WHERE employee_id = 102;
		# 使用
		SELECT emp_name,sal;
END $
DELIMITER ;

CALL test_pro();

# 举例2：声明两个变量，求和并打印 （分别使用会话用户变量、局部变量的方式实现）

# 方式1：
SET @v1 = 10;
SET @v2 = 20;
SET @ans = @v1 + @v2;
SELECT @ans;

# 方式2:
DELIMITER $
CREATE PROCEDURE add_value()
BEGIN
		# 声明
		DECLARE value1,value2,sumval INT;
		# 赋值
		SET value1 = 10;
		SET value2 := 20;
		
		SET sumval = value1 + value2;
		
		# 使用
		SELECT sumval;
END $
DELIMITER ;

CALL add_value();

# 举例3：创建存储过程“different_salary”查询某员工和他领导的薪资差距，并用IN参数emp_id接收员工id，用OUT参数dif_salary输出薪资差距结果。

DELIMITER $
CREATE PROCEDURE different_salary(IN emp_id INT,OUT dif_salary DOUBLE)
BEGIN 
		# 分析：查询出emp_id的工资；查询出emp_id的员工的管理者的id；查询出管理者id的工资；计算出两者的差值
		
		# 声明变量
		DECLARE emp_sal DOUBLE DEFAULT 0.0;
		DECLARE mgr_sal DOUBLE DEFAULT 0.0;
		DECLARE mgr_id INT DEFAULT 0;
		
		# 赋值
		SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
		
		SELECT manager_id INTO mgr_id FROM employees WHERE employee_id = emp_id;
		
		SELECT salary INTO mgr_sal FROM employees WHERE employee_id = mgr_id;
		
		SET dif_salary = mgr_sal - emp_sal;
END $
DELIMITER ;

SET @emp_id = 102;
CALL different_salary(@emp_id,@dif_sal);
SELECT @dif_sal;



# 2. 定义条件和处理程序

# 2.1 错误演示
# 1364 - Field 'email' doesn't have a default value
INSERT INTO employees(last_name)
VALUES('Tom');

DESC employees;

# 2.2 
DELIMITER //

CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //

DELIMITER ;

# 错误代码：1048 - Column 'email' cannot be null
CALL UpdateDataNoCondition();
SELECT @x; # 可以看到程序运行到哪一步了 

# 2.2 定义条件

# 举例1：定义“Field_Not_Be_NULL”错误名与MySQL中违反非空约束的错误类型是“ERROR 1048 (23000)”对应。

# 方式1：使用MySQL_error_code
DECLARE Field_Not_Be_NULL CONDITION FOR 1048;

# 方式2：使用sqlstate_value
DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';

# 举例2：定义"ERROR 1148(42000)"错误，名称为command_not_allowed。
DECLARE command_not_allowed CONDITION FOR 1148;
DECLARE command_not_allowed CONDITION FOR SQLSTATE '42000';

# 2.3 定义处理程序

#方法1：捕获sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';

#方法2：捕获mysql_error_value
DECLARE CONTINUE HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';

#方法3：先定义条件，再调用
DECLARE no_such_table CONDITION FOR 1146;
DECLARE CONTINUE HANDLER FOR NO_SUCH_TABLE SET @info = 'NO_SUCH_TABLE';

#方法4：使用SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info = 'ERROR';

#方法5：使用NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';

#方法6：使用SQLEXCEPTION
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';

# 2.4 案例的解决：
DROP PROCEDURE UpdateDataNoCondition;

# 重新定义存储过程，体现错误的处理程序
DELIMITER //
CREATE PROCEDURE UpdateDataNoCondition()
	BEGIN
-- 		# 声明处理程序
-- 		# 处理的方式1：
		DECLARE CONTINUE HANDLER FOR 1048 SET @prc_value = -1;
		
-- 		# 处理的方式2:
-- 		DECLARE CONDITION HANDLER FOR SQLSTATE '23000' SET @prc_value = -1;
		
		SET @x = 1;
		UPDATE employees SET email = NULL WHERE last_name = 'Abel';
		SET @x = 2;
		UPDATE employees SET email = 'aabbel' WHERE last_name = 'Abel';
		SET @x = 3;
	END //
DELIMITER ;

# 调用存储过程：
CALL UpdateDataNoCondition();

# 查看变量
SELECT @x,@prc_value;

# 2.5 举例3：创建一个名称为“InsertDataWithCondition”的存储过程
#准备工作
ALTER TABLE departments
ADD CONSTRAINT uk_dept_name UNIQUE(department_id);

DESC departments;

ALTER TABLE departments
ADD CONSTRAINT uk_dept_name UNIQUE(department_id);


# 定义存储过程
DELIMITER //

CREATE PROCEDURE InsertDataWithCondition()
	BEGIN
-- 		DECLARE duplicate_entry CONDITION FOR SQLSTATE '23000' ;
-- 		DECLARE EXIT HANDLER FOR duplicate_entry SET @proc_value = -1;
		
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //

DELIMITER ;

SELECT * FROM departments;
DROP PROCEDURE InsertDataWithCondition;

CALL InsertDataWithCondition();
SELECT @x;

# 删除此存储过程
DROP PROCEDURE InsertDataWithCondition;

# 重新定义存储过程（考虑到错误的处理程序）

DELIMITER //

CREATE PROCEDURE InsertDataWithCondition()
	BEGIN
	# 处理程序
		# 方式1：
		DECLARE duplicate_entry CONDITION FOR SQLSTATE '23000' ;
		DECLARE EXIT HANDLER FOR duplicate_entry SET @proc_value = -1;
		# 方式2：
-- 		DECLARE EXIT HANDLER FOR 1062 SET @proc_value = -1;
		# 方式3：
-- 		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET @proc_value = -1;
		
		SET @x = 1;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 2;
		INSERT INTO departments(department_name) VALUES('测试');
		SET @x = 3;
	END //

DELIMITER ;

DELETE FROM departments 
WHERE department_id = 0;

CALL InsertDataWithCondition();

SELECT @x,@proc_value;

# 3.流程控制
# 3.1 分支结构之IF
# 举例1：

DELIMITER $
CREATE PROCEDURE test_if()

BEGIN 
-- 		# 情况1：
-- 		# 声明局部变量
-- 		DECLARE stu_name VARCHAR(15);
-- 		IF stu_name IS NULL
-- 			THEN SELECT 'stu_name is null';
-- 			END IF;

-- 			# 情况2：二选一
-- 			DECLARE email VARCHAR(25);
-- 			IF email IS NULL
-- 				THEN SELECT 'email is null';
-- 			ELSE 
-- 				SELECT 'email is not null';
-- 			END IF;
			
			# 情况3：多选一
			DECLARE age INT DEFAULT 20;
			IF age > 40
				THEN SELECT '中老年';
			ELSEIF age > 18
				THEN SELECT '青壮年';
			ELSEIF age > 8
				THEN SELECT '青少年';
			ELSE
				SELECT '婴幼儿';
			END IF;
END $

DELIMITER ;

DROP PROCEDURE test_if;
# 调用
CALL test_if();


# 举例2：声明存储过程“update_salary_by_eid1”，定义IN参数emp_id，输入员工编号。判断该员工薪资如果低于8000元并且入职时间超过5年，就涨薪500元；否则就不变。

DELIMITER $
CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN 
		# 声明局部变量
		DECLARE emp_sal DOUBLE; # 记录员工的工资
		DECLARE hire_year DOUBLE; # 记录员工进入公司的年限
		
		# 赋值
		SELECT salary INTO emp_sal FROM employees
		WHERE employee_id = emp_id;
		
		SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employees
		WHERE employee_id = emp_id;
		
		# 判断
		IF emp_sal < 8000 AND hire_year > 5
			THEN UPDATE employees SET salary = salary + 5000 WHERE employee_id = emp_id;
		END IF;
END $
DELIMITER ;

DROP PROCEDURE update_salary_by_eid1;

CALL update_salary_by_eid1(104);


SELECT DATEDIFF(CURDATE(),hire_date)/365,employee_id,salary
FROM employees
#WHERE salary < 8000 AND DATEDIFF(CURDATE(),hire_date)/365 >= 5;
WHERE employee_id = 104;


# 举例3：声明存储过程“update_salary_by_eid2”，定义IN参数emp_id，输入员工编号。判断该员工薪资如果低于9000元并且入职时间超过5年，就涨薪500元；否则就涨薪100元。

DELIMITER $
CREATE PROCEDURE update_salary_by_eid2(IN emp_id INT)
BEGIN 
		# 声明局部变量
		DECLARE emp_sal DOUBLE; # 记录员工的工资
		DECLARE hire_year DOUBLE; # 记录员工进入公司的年限
		
		# 赋值
		SELECT salary INTO emp_sal FROM employees
		WHERE employee_id = emp_id;
		
		SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employees
		WHERE employee_id = emp_id;
		
		# 判断
		IF emp_sal < 9000 AND hire_year >= 5
			THEN UPDATE employees SET salary = salary + 500 WHERE employee_id = emp_id;
		ELSE 
			UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
		END IF;
END $
DELIMITER ;

CALL update_salary_by_eid2(103);

SELECT *
FROM employees WHERE employee_id = 103;

# 举例4：声明存储过程“update_salary_by_eid3”，定义IN参数emp_id，输入员工编号。判断该员工薪资如果低于9000元，就更新薪资为9000元；薪资如果大于等于9000元且低于10000的，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。

DELIMITER $
CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
BEGIN 
		# 声明变量
		DECLARE emp_sal DOUBLE;
		DECLARE bonus DOUBLE;
		
		# 赋值
		SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
		SELECT commission_pct INTO bonus FROM employees WHERE employee_id = emp_id;
		
		# 判断
		IF emp_sal < 9000 
			THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
		ELSEIF emp_sal < 10000 AND bonus IS NULL
			THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
		ELSE 
			UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
		END IF;

END $
DELIMITER ;

UPDATE employees SET salary = 7000 WHERE employee_id = 104;

CALL update_salary_by_eid3(102);
CALL update_salary_by_eid3(103);
CALL update_salary_by_eid3(104);

SELECT * FROM employees WHERE employee_id IN (102,103,104);

# 3.2 分支结构之CASE
# 举例：
DELIMITER $
CREATE PROCEDURE test_case()
BEGIN
-- 		# 演示1：case ... when ... then ...
-- 		DECLARE var INT DEFAULT 2;
-- 		
-- 		CASE var 
-- 		WHEN 1 THEN SELECT 'var = 1';
-- 		WHEN 2 THEN SELECT 'var = 2';
-- 		WHEN 3 THEN SELECT 'var = 3';
-- 		ELSE SELECT 'other value';
-- 		END CASE;

		# 演示2：case when ... then ...
		DECLARE var1 INT DEFAULT 10;
		CASE 
				 WHEN var1 >= 100 THEN SELECT 'var >= 100';
		     WHEN var1 >= 10 THEN SELECT 'var >= 10';
				 ELSE SELECT 'var1 < 10';
		END CASE;
END $
DELIMITER ;

DROP PROCEDURE test_case;

CALL test_case();

# 举例2：声明存储过程“update_salary_by_eid4”，定义IN参数emp_id，输入员工编号。判断该员工薪资如果低于9000元，就更新薪资为9000元；薪资大于等于9000元且低于10000的，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。

DELIMITER $ 
CREATE PROCEDURE update_salary_by_eid4(IN emp_id INT)
BEGIN 
		# 局部变量的声明
		DECLARE emp_sal DOUBLE; #员工的工资
		DECLARE bonus DOUBLE; # 奖金率
		
		# 局部变量的赋值
		SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
		SELECT commission_pct INTO bonus FROM employees WHERE employee_id = emp_id;
		
		CASE 
		WHEN emp_sal < 9000 THEN UPDATE EMPLOYEES SET salary = 9000 WHERE employee_id = emp_id;
		WHEN emp_sal < 10000 AND bonus IS NULL THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
		ELSE UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
		END CASE;
END $
DELIMITER ;

CALL update_salary_by_eid4(103);
CALL update_salary_by_eid4(104);
CALL update_salary_by_eid4(105);

SELECT * FROM employees WHERE employee_id IN (103,104,105);

# 举例3：声明存储过程update_salary_by_eid5，定义IN参数emp_id，输入员工编号。判断该员工的入职年限，如果是0年，薪资涨50；如果是1年，薪资涨100；如果是2年，薪资涨200；如果是3年，薪资涨300；如果是4年，薪资涨400；其他的涨薪500。

DELIMITER $
CREATE PROCEDURE update_salary_by_eid5(IN emp_id INT)
BEGIN 
		# 声明局部变量
		DECLARE hire_year INT;# 记录员工入职的年限
		
		# 赋值
		SELECT TRUNCATE(DATEDIFF(CURDATE(),hire_date)/365,0) INTO hire_year FROM employees WHERE employee_id = emp_id;
		
		# 判断
		CASE hire_year
		WHEN 0 THEN UPDATE employees SET salary = salary + 50 WHERE employee_id = emp_id;
		WHEN 1 THEN UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
		WHEN 2 THEN UPDATE employees SET salary = salary + 200 WHERE employee_id = emp_id;
		WHEN 3 THEN UPDATE employees SET salary = salary + 300 WHERE employee_id = emp_id;
		WHEN 4 THEN UPDATE employees SET salary = salary + 400 WHERE employee_id = emp_id;
		ELSE UPDATE employees SET salary = salary + 500 WHERE employee_id = emp_id;
		END CASE;
END $
DELIMITER ;

CALL update_salary_by_eid5(101);

SELECT * FROM employees;


# 4.1 循环结构之LOOP
/*
[loop_label:] LOOP
	循环执行的语句
END LOOP [loop_label]
*/
# 举例1：

DELIMITER $
CREATE PROCEDURE test_loop()
BEGIN
		# 声明局部变量
		DECLARE num INT DEFAULT 1;
		
		loop_label:LOOP
			# 重新赋值
				SET num = num + 1;
				IF num >= 10 THEN LEAVE loop_label;
				END IF;
		END LOOP loop_label; 
		
		# 查看num
		SELECT num;
END $
DELIMITER ;

# 调用
CALL test_loop();

# 举例2：当市场环境变好时，公司为了奖励大家，决定给大家涨工资。声明存储过程“update_salary_loop()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家涨薪，薪资涨为原来的1.1倍。直到全公司的平均薪资达到12000结束。并统计循环次数。

DELIMITER $
CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN
		# 声明变量
		DECLARE avg_sal DOUBLE;# 记录员工的平均工资
		DECLARE loop_count INT DEFAULT 0;# 记录循环次数
		
		# 获取员工的平均工资
		SELECT AVG(salary) INTO avg_sal FROM employees; 
		
		loop_label:LOOP
			# 结束循环的条件
			IF avg_sal >= 12000 THEN LEAVE loop_label;
			END IF;
			
			#如果低于12000，更新员工的工资
			UPDATE employees SET salary = salary * 1.2;  
			
			# 更新avg_sal 的值
			SELECT AVG(salary) INTO avg_sal FROM employees;
			
			# 记录循环的次数
			SET loop_count = loop_count + 1;
		END LOOP loop_label;
		
		# 给num赋值
		SET num = loop_count;
		
END $
DELIMITER ;

CALL update_salary_loop(@num);
SELECT @num;
SELECT AVG(salary) FROM employees;

#4.2 循环结构之WHILE
/*
[while_label:] WHILE 循环条件  DO
	循环体
END WHILE [while_label];
*/



/*
凡是循环结构，一定具备4个要素：
1. 初始化条件
2. 循环条件
3. 循环体
4. 迭代条件
*/

# 举例1：
DELIMITER $
CREATE PROCEDURE test_while()
BEGIN
		DECLARE num INT DEFAULT 1;
		WHILE num <= 10 DO
		
		SET num = num + 1;
		END WHILE;
		SELECT num;
END $
DELIMITER ;
DROP PROCEDURE test_while;

CALL test_while();

# 举例2：市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。声明存储过程“update_salary_while()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家降薪，薪资降为原来的90%。直到全公司的平均薪资达到5000结束。并统计循环次数。

DELIMITER $
CREATE PROCEDURE update_salary_while(OUT num INT)
BEGIN
		# 声明变量
		DECLARE avg_sal DOUBLE;# 记录平均工资
		DECLARE while_count INT DEFAULT 0;# 记录循环次数
		
		# 赋值
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
		WHILE avg_sal > 5000 DO
		UPDATE employees SET salary = salary * 0.9;
		SET while_count = while_count + 1;
		SELECT AVG(salary) INTO avg_sal FROM employees;
		END WHILE;
		
		SET num = while_count;
END $
DELIMITER ;

CALL update_salary_while(@num);
SELECT @num;
SELECT AVG(salary) FROM employees;

# 4.3 循环结构之REPEAT
/*
[repeat_label:] REPEAT
　　　　循环体的语句
UNTIL 结束循环的条件表达式
END REPEAT [repeat_label]
*/

# 举例1：
DELIMITER $
CREATE PROCEDURE test_repeat()
BEGIN 
		# 声明变量
		DECLARE num INT DEFAULT 1;
		
		REPEAT 
			SET num = num + 1;
		UNTIL num >= 10  # 注意，until后面的句子没有分号结尾
		END REPEAT;
		SELECT num;
END $
DELIMITER ;

CALL test_repeat();

# 举例2：当市场环境变好时，公司为了奖励大家，决定给大家涨工资。声明存储过程“update_salary_repeat()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家涨薪，薪资涨为原来的1.15倍。直到全公司的平均薪资达到13000结束。并统计循环次数。

DELIMITER $
CREATE PROCEDURE update_salary_repeat(OUT num INT)
BEGIN
		# 声明变量
		DECLARE avg_sal DOUBLE;# 记录平均工资
		DECLARE repeat_count INT DEFAULT 0;# 记录循环次数
		
		# 赋值
		SELECT AVG(salary) INTO avg_sal FROM employees;
		
		REPEAT 
			UPDATE employees SET salary = salary * 1.15;
			SET repeat_count = repeat_count + 1;
			SELECT AVG(salary) INTO avg_sal FROM employees;
			UNTIL avg_sal >= 13000
		END REPEAT;
		
		SET num = repeat_count;
END $
DELIMITER ;

CALL update_salary_repeat(@num);
SELECT @num;

SELECT AVG(salary) FROM employees;

# 5.1 LEAVE的使用
/*
创建存储过程 “leave_begin()”，声明INT类型的IN参数num。给BEGIN...END加标记名，并在BEGIN...END中使用IF语句判断num参数的值。

- 如果num<=0，则使用LEAVE语句退出BEGIN...END；
- 如果num=1，则查询“employees”表的平均薪资；
- 如果num=2，则查询“employees”表的最低薪资；
- 如果num>2，则查询“employees”表的最高薪资。

IF语句结束后查询“employees”表的总人数。
*/
DELIMITER $
CREATE PROCEDURE leave_begin(IN num INT)
begin_label:BEGIN 
		IF num <= 0 THEN LEAVE begin_label;
		ELSEIF num = 1 THEN SELECT AVG(salary) FROM employees;
		ELSEIF num = 2 THEN SELECT MIN(salary) FROM employees;
		ELSE SELECT MAX(salary) FROM employees;
		END IF;
		# 查询总人数
		SELECT COUNT(*) FROM employees;
		END $
DELIMITER ;

# 调用
CALL leave_begin(1);


# 举例2：当市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。声明存储过程“leave_while()”，声明OUT参数num，输出循环次数，存储过程中使用WHILE循环给大家降低薪资为原来薪资的90%，直到全公司的平均薪资小于等于10000，并统计循环次数。

DELIMITER $
CREATE PROCEDURE leave_while(OUT num INT)
BEGIN 
		DECLARE avg_sal DOUBLE;#记录平均工资
		DECLARE while_count INT DEFAULT 0;#记录循环的次数
		SELECT AVG(salary) INTO avg_sal FROM employees;
		while_label:WHILE TRUE DO
		IF avg_sal <= 10000 THEN LEAVE while_label;
		END IF; 
		UPDATE employees SET salary = salary * 0.9;
		SET while_count = while_count + 1;
		SELECT AVG(salary) INTO avg_sal FROM employees;
		END WHILE;
		SET num = while_count;
END $
DELIMITER ;

CALL leave_while(@num);
SELECT @num;

SELECT AVG(salary) FROM employees;

# 5.2 ITERATE的使用
/*
定义局部变量num，初始值为0。循环结构中执行num + 1操作。

- 如果num < 10，则继续执行循环；
- 如果num > 15，则退出循环结构；
*/

DELIMITER $
CREATE PROCEDURE test_iterate()
BEGIN
		DECLARE num INT DEFAULT 0;
		
		loop_label:LOOP
		# 赋值
		SET num = num + 1;
		IF num < 10 THEN iterate loop_label;
		ELSEIF num > 15 THEN LEAVE loop_label;
		END IF;
		SELECT '尚硅谷，让天下没有难学的技术'; 
		END LOOP;
END $
DELIMITER ;

CALL test_iterate();

SELECT * FROM employees;


 
# 6. 游标的使用
/*
游标的使用步骤
1. 声明游标
2. 打开游标
3. 使用游标（从游标中获取数据）
4. 关闭游标
*/

# 举例1：创建存储过程“get_count_by_limit_total_salary()”，声明IN参数 limit_total_salary，DOUBLE类型；声明OUT参数total_count，INT类型。函数的功能可以实现累加薪资最高的几个员工的薪资值，直到薪资总和达到limit_total_salary参数的值，返回累加的人数给total_count。

DELIMITER $
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN 
		# 声明局部变量
		DECLARE sum_sal DOUBLE DEFAULT 0.0;# 记录累加的工资总和
		DECLARE emp_sal DOUBLE;#记录每一个员工的工资
		DECLARE emp_count INT DEFAULT 0;# 记录迭代的次数
		
		# 声明游标
		DECLARE emp_cursor CURSOR FOR SELECT salary FROM employees ORDER BY salary DESC;
		
		# 打开游标
		OPEN emp_cursor;
		
		REPEAT 
		# 使用游标
		FETCH emp_cursor INTO emp_sal;
		SET sum_sal = sum_sal + emp_sal;
		SET emp_count = emp_count + 1;
		UNTIL sum_sal >= limit_total_salary
		END REPEAT;
		
		SET total_count = emp_count;
		
		# 关闭游标
		CLOSE emp_cursor;
END $
DELIMITER ;

CALL get_count_by_limit_total_salary(200000,@count);
SELECT @count;



# 第16章 变量、流程控制与游标的课后练习

# 练习1：测试变量的使用

/*
变量：
	系统变量（全局系统变量、会话系统变量）
	
	用户自定义变量（会话用户变量、局部变量）
*/
CREATE DATABASE test16_var_cursor;
USE test16_var_cursor;

CREATE TABLE employees
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE departments
AS 
SELECT * FROM atguigudb.departments;

# 无参数返回
# 1. 创建函数get_count()，返回公司员工的个数
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $
CREATE FUNCTION get_count()
RETURNS INT
BEGIN 
		# 声明局部变量
		DECLARE emp_count INT;
		
		# 赋值
		SELECT COUNT(*) INTO emp_count FROM employees;
		
		RETURN emp_count;
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
		# 声明变量
		SET @sal = 0;# 定义了一个会话用户变量
		
		# 赋值
		SELECT salary INTO @sal FROM employees WHERE last_name = name;
		
		RETURN @sal;
END $ 
DELIMITER ;

SET @name = 'Abel';
SELECT ename_salary(@name);

# 3. 创建函数dept_sal()，根据部门名，返回该部门的平均工资

DELIMITER $
CREATE FUNCTION dept_sal(i_department_name VARCHAR(30))
RETURNS DOUBLE

BEGIN
		DECLARE avg_sal DOUBLE;
		SELECT AVG(salary) INTO avg_sal FROM employees e JOIN departments d 
		ON e.department_id = d.department_id WHERE d.department_name = i_department_name;
		
		RETURN avg_sal;
END $
DELIMITER ;

SELECT dept_sal('Marketing');

# 4. 创建函数add_float()，实现传入两个float,返回二者之和

DELIMITER $
CREATE FUNCTION add_float(val1 FLOAT,val2 FLOAT)
RETURNS FLOAT
BEGIN
		# 声明
		DECLARE sum FLOAT;
		
		# 
		SET sum = val1 + val2;
		
		RETURN sum;
END $
DELIMITER ;

SET @val1 = 1;
SET @val2 = 2;
SELECT add_float(@val1,@val2);

# 2. 流程控制

/*
分支：if \ case ... when \ case when ...
循环：loop \ while \ repeat
其它：leave \ iterate 

*/

# 1. 创建函数test_if_case()，传入成绩，如果成绩大于90，返回A，如果成绩大于80，返回B，如果成绩大于60，返回C，否则返回D

# 方式1：
DELIMITER $
CREATE FUNCTION test_if_case(score DOUBLE)
RETURNS CHAR
BEGIN
		#
		DECLARE score_level CHAR;
		IF score > 90
		THEN SET score_level = 'A';
		ELSEIF score > 80
		THEN SET score_level = 'B';
		ELSEIF score > 60
		THEN SET score_level = 'C';
		ELSE 
		SET score_level = 'D';
		END IF;
		
		RETURN score_level;
END $
DELIMITER ;

SELECT test_if_case(56);

# 方式2：case when ...
DELIMITER $
CREATE FUNCTION test_if_case2(score DOUBLE)
RETURNS CHAR
BEGIN
		#
		DECLARE score_level CHAR;
		CASE 
		WHEN score > 90 THEN SET score_level = 'A';
		WHEN score > 80 THEN SET score_level = 'B';
		WHEN score > 60 THEN SET score_level = 'C';
		ELSE SET score_level = 'D';
		END CASE;
		
		RETURN score_level;
END $
DELIMITER ;

SELECT test_if_case2(76);

# 2. 创建存储过程test_if_pro()，传入工资值，如果工资制小于3000，则删除工资为此值的员工，如果3000小于等于工资制小于等于5000，则修改此工资值的员工薪资涨薪1000，否则涨工资500

DELIMITER $
CREATE PROCEDURE test_if_pro(IN i_salary DOUBLE)
BEGIN
		IF i_salary < 3000 THEN DELETE FROM employees WHERE salary = i_salary;
		ELSEIF i_salary <= 5000 THEN UPDATE employees SET salary = salary + 1000 WHERE salary = i_salary;
		ELSE UPDATE employees SET salary = salary + 500 WHERE salary = i_salary;
		END IF;
END $
DELIMITER ;

CALL test_if_pro(24000);

SELECT * FROM employees;

# 3.创建存储过程insert_data()，传入参数为IN的INT类型变量insert_count，实现向admin表中批量插入insert_count条记录
CREATE TABLE admin(
id INT PRIMARY KEY AUTO_INCREMENT,
user_name VARCHAR(25) NOT NULL,
user_pwd VARCHAR(35) NOT NULL
);

SELECT * FROM admin;

DELIMITER $ 
CREATE PROCEDURE insert_date(IN insert_count INT)
BEGIN
		DECLARE init_count INT DEFAULT 1; # 初始化条件
		WHILE  init_count <= insert_count DO # 循环条件
		INSERT INTO admin(user_name,user_pwd) VALUES (CONCAT('atguigu-',init_count),ROUND(RAND()*1000000));# 循环体
		SET init_count = init_count + 1;# 迭代条件
		END WHILE; 
END $
DELIMITER ;

CALL insert_date(100);

SELECT * FROM admin;

# 3.游标的使用
# 创建存储过程update_salary()，参数1为IN的INT类型变量dept_id，标识部门id，参数2为IN change_sal_count INT,表示要调整薪资的员工个数。查询指定id部门的员工信息，按照salary的升序排列，更具hire_date的情况，调整前change_sal_count个员工的薪资，详情如下：

DELIMITER $
CREATE PROCEDURE update_salry(IN dept_id INT,IN change_sal_count INT)
BEGIN 
		# 声明变量
		DECLARE emp_id INT ;#记录员工id
		DECLARE emp_hire_date DATE;#记录员工的入职时间
		
		DECLARE init_count INT DEFAULT 1;# 用于循环的初始化条件
		DECLARE add_sal_rate DOUBLE;# 记录涨薪的比例
		# 声明游标
		DECLARE emp_cursor CURSOR FOR SELECT employee_id,hire_date FROM employees WHERE department_id = dept_id ORDER BY salary ASC;
		# 打开游标
		OPEN emp_cursor;
		
		WHILE init_count <= change_sal_count DO
		# 使用游标
		FETCH emp_cursor INTO emp_id,emp_hire_date;
		IF (YEAR(emp_hire_date) < 1995)
		THEN SET add_sal_rate = 1.2;
		ELSEIF(YEAR(emp_hire_date) < 1998)
		THEN SET add_sal_rate = 1.15;
		ELSEIF(YEAR(emp_hire_date) < 2001)
		THEN SET add_sal_rate = 1.10;
		ELSE SET add_sal_rate = 1.05;
		END IF;# 取涨薪率
		UPDATE employees SET salary = salary * add_sal_rate WHERE employee_id = emp_id;
		SET init_count = init_count + 1;# 记得加上迭代条件
		END WHILE;
		
		# 关闭游标
		CLOSE emp_cursor;
END $
DELIMITER ;

CALL update_salry(50,3)

SELECT employee_id,salary,hire_date FROM employees WHERE department_id = 50 ORDER BY salary ASC;














