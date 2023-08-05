#第17章 触发器

# 0. 准备工作
CREATE DATABASE dbtest17;

USE dbtest17;
# 1. 如何创建触发器

# 举例1：

# ① 创建数据表
CREATE TABLE test_trigger (
id INT PRIMARY KEY AUTO_INCREMENT,
t_note VARCHAR(30)
);


CREATE TABLE test_trigger_log (
id INT PRIMARY KEY AUTO_INCREMENT,
t_log VARCHAR(30)
);

# ② 查看表数据
SELECT * FROM test_trigger;

SELECT * FROM test_trigger_log;

# ③ 创建触发器

DELIMITER $
CREATE TRIGGER before_insert_test_tri BEFORE INSERT ON test_trigger
FOR EACH ROW
BEGIN
		INSERT INTO test_trigger_log(t_log)
		VALUES ('before_insert');
END $
DELIMITER ;

INSERT INTO test_trigger(t_note) VALUES ('Tom');


# 举例2：
DELIMITER $
CREATE TRIGGER after_insert_test_tri 
AFTER INSERT ON test_trigger
FOR EACH ROW 
BEGIN
		INSERT INTO test_trigger_log(t_log)
		VALUES ('after_insert');
END $
DELIMITER ;

INSERT INTO test_trigger(t_note) VALUES ('Jerry');

# 举例3：

# 准备工作
CREATE TABLE employees
AS
SELECT * FROM atguigudb.employees;
 
CREATE TABLE departments
AS
SELECT * FROM atguigudb.departments;

# 创建触发器
DELIMITER $
CREATE TRIGGER salary_check_trigger 
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
		#查询到要添加的manager的薪资
		DECLARE mgr_sal DOUBLE;
		SELECT salary INTO mgr_sal FROM employees WHERE employee_id = NEW.manager_id; 
		IF NEW.salary > mgr_sal THEN SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导的薪资错误';
		END IF;
END $
DELIMITER ;

# 测试
DESC employees;

# 添加成功：依然触发了触发器的执行
INSERT INTO employees(employee_id,last_name,email,hire_date,job_id,salary,manager_id) VALUES (300,'Tom','tom@163.com',CURDATE(),'AD_VP',8000,103);

# 添加失败
INSERT INTO employees(employee_id,last_name,email,hire_date,job_id,salary,manager_id) VALUES (301,'Tom1','tom@163.com',CURDATE(),'AD_VP',10000,103);

SELECT * FROM employees;

# 2. 查看触发器
# ① 查看当前数据库的所有触发器的定义
SHOW TRIGGERS;

# ② 查看当前数据库中某个触发器的定义
SHOW CREATE TRIGGER salary_check_trigger;

# ③ 从系统库information_schema的TRIGGERS表中查询“salary_check_trigger”触发器的信息。
SELECT * FROM information_schema.TRIGGERS;

# 3. 删除触发器
DROP TRIGGER IF EXISTS after_insert_test_tri;

SHOW TRIGGERS;


# 第17章 触发器的课后练习

#练习1：

# 0. 准备工作
CREATE DATABASE test17_trigger;
USE test17_trigger;
CREATE TABLE emps
AS
SELECT employee_id,last_name,salary
FROM atguigudb.employees;

# 1. 复制一张emps表的空表emps_back，只有表结构，不包含任何数据
CREATE TABLE emps_back
AS
SELECT * FROM emps
WHERE 1 = 2;

# 2. 查询emps_back表中的数据
SELECT * FROM emps_back;

# 3. 创建触发器emps_insert_trigger，每当向emps表中添加一条记录时，同步将这条记录添加到emps_back表中
DELIMITER $
CREATE TRIGGER emps_insert_trigger AFTER INSERT ON emps 
FOR EACH ROW 
BEGIN 
		INSERT INTO emps_back (employee_id,last_name,salary)
		VALUES (NEW.employee_id,NEW.last_name,NEW.salary);
END $
DELIMITER ;

SHOW TRIGGERS;

# 4. 验证触发器是否有效
SELECT * FROM emps;
SELECT * FROM emps_back;
INSERT INTO emps(employee_id,last_name,salary)
VALUES(300,'Tom',3400);


# 练习2：

# 0. 准备工作：使用练习1中emps表

# 1. 复制一张emps表的空表emps_back1，只有表结构，不包含任何数据

# 2. 查询emps_back1表中的数据

# 3. 创建触发器emps_del_trigger,每当向emps表中删除一条记录时，同步将删除的这条记录添加到emps_back1表中
DELIMITER $
CREATE TRIGGER emps_del_trigger 
BEFORE DELETE ON emps
FOR EACH ROW 
BEGIN 
		INSERT INTO emps_back1(employee_id,last_name,salary)
		VALUES (OLD.employee_id,OLD.last_name,OLD.salary);
END $
DELIMITER ;
# 4. 验证触发器是否有效








