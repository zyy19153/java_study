# 第11章 数据处理之增删改

# 0.储备工作
USE atguigudb;

CREATE TABLE IF NOT EXISTS emp1(
id INT,
name VARCHAR(15),
hire_date DATE,
salary DOUBLE(10,2)
);

DESC emp1;

SELECT * FROM emp1;
# 1.添加数据

# 方式1：一条一条的添加数据

# ① 没有指明添加的字段 
# 正确的：
INSERT INTO emp1
VALUES (
1,'Tom','2000-12-21',3400
); # 注意：一定要按照声明的字段的先后顺序添加
# 错误的：
INSERT INTO emp1
VALUES (
1,3400,'2000-12-21','Jerry'
);

# ② 指明要添加的字段（推荐）
INSERT INTO emp1(id,hire_date,salary,`name`)
VALUES (2,'1999-09-09',4000,'Jerry');
# 说明：没有进行赋值的hire_date的值为NULL
INSERT INTO emp1(id,salary,`name`)
VALUES (3,4500,'shk');

# ③ 同时插入多条记录
INSERT INTO emp1(id,`name`,salary)
VALUES 
(4,'Jim',5000),
(5,'张俊杰',5500);


# 方式2：将查询的结果插入到表中

SELECT * FROM emp1;

INSERT INTO emp1(id,`name`,salary,hire_date)
# 查询语句
SELECT employee_id,last_name,salary,hire_date # 查询的字段一定要与添加到的表的字段一一对应
FROM employees 
WHERE department_id IN (70,60);

DESC emp1;
DESC employees;

# 说明：emp1表中要添加的数据的字段的长度不能低于employees表中查询的字段的长度。
# 如果emp1表中要添加的数据的字段的长度低于employees表中查询的字段的长度的话，就有添加不成功的风险。

# VALUES也可以写成VALUE，但VALUES更规范。

# 2.更新数据（或修改数据）
# UPDATE ... SET ... WHERE ...
# 可以实现批量修改数据

UPDATE emp1
SET hire_date = CURDATE()
WHERE id = 5;

SELECT * FROM emp1;

# 同时修改一条数据的多个字段
UPDATE emp1
SET hire_date = CURDATE(),salary = 6000
WHERE id = 4;

# 题目：将表中姓名中包含字母‘a’的提醒20percent
UPDATE emp1
SET salary = salary * 1.2
WHERE name LIKE '%a%';

# 修改数据时是可能存在不成功的情况的。可能是由于约束的影响造成的。
UPDATE employees 
SET department_id = 10000
WHERE employee_id = 102;

# 3. 删除数据 DELETE　FROM　... WHERE ...

DELETE FROM emp1
WHERE id = 1;
# 在删除数据时，也有可能因为约束的影响，导致删除失败。
DELETE FROM departments 
WHERE department_id = 50;

# 小结：DML操作默认情况下，执行完以后都会自动提交数据。如果希望执行完以后不自动提交数据，则需要使用SET autocommit = FALSE

# 4.MySQL8的新特性：计算列
USE atguigudb;
CREATE TABLE test1(
a INT,
b INT,
c INT GENERATED ALWAYS AS (a + b) VIRTUAL # 字段c即为计算列
);

INSERT INTO test1(a,b)
VALUES (10,20);

SELECT * FROM test1;

UPDATE test1
SET a = 100;

# 5.综合案例
CREATE DATABASE IF NOT EXISTS test01_library CHARACTER SET 'utf8';

USE test01_library;

CREATE TABLE IF NOT EXISTS books(
id INT,
`name` VARCHAR(50),
`authors` VARCHAR(100),
price FLOAT,
pubdate YEAR,
note VARCHAR(100),
num INT
);

DESC books;
SELECT * FROM books;

INSERT INTO books
VALUES (1,'Tal of AAA','Dickes',23,'1995','novel',11);

INSERT INTO books(id,`name`,`authors`,price,pubdate,note,num)
VALUE (2,'EmmaT','Jane lura',35,'1993','joke',22);

INSERT INTO books
VALUES 
(3,'Story of Jane','Jane Tim',40,'2001','novel',0),
#(4,'Lovey Day','George Byron',20,'2005','novel',30),
(5,'Old land','Honore Blade',30,'2010','law',0),
#(6,'The battle','Upton Sara',30,'1999','medicine',40),
#(7,'Rose Hood','Richard haggard',28,'2008','cartoon',28);

UPDATE books
SET price = price + 5
WHERE note = 'novel'; 

UPDATE books
SET price = 40,note = 'drama'
WHERE `name` = 'EmmaT';

DELETE FROM books
WHERE num = 0;

SELECT * 
FROM books
WHERE `name` LIKE '%a%';

SELECT * FROM books;

SELECT COUNT(*),SUM(num)
FROM books
WHERE `name` REGEXP 'a';

SELECT *
FROM books
WHERE note = 'novel'
ORDER BY price DESC;

SELECT *
FROM books
ORDER BY num DESC,note ASC;

SELECT note,COUNT(*)
FROM books
GROUP BY note;

SELECT SUM(num) sum_num,note
FROM books
GROUP BY note
HAVING sum_num > 30;

SELECT *
FROM books 
LIMIT 5,5;

SELECT note,SUM(num)
FROM books
GROUP BY note
HAVING SUM(num)
ORDER BY SUM(num) DESC
LIMIT 0,1;

SElECT CHAR_LENGTH(REPLACE(`name`,' ',''))
FROM books
WHERE 10 <= (CHAR_LENGTH(REPLACE(`name`,' ','')));

SELECT `name`,note,CASE note WHEN 'novel' THEN '小说'
												WHEN 'law' THEN '法律'
												WHEN 'medicine' THEN '医药'
												END note_chinese_name
FROM books; 

SELECT `name` AS "书名",num AS "库存",CASE WHEN num > 30 THEN '滞销'
											 WHEN num > 0 AND num < 10 THEN '畅销'
											 WHEN num = 0 THEN '无货'
											 END sales_state
FROM books;											 

SELECT IFNULL(note,'合计库存总量') AS note,SUM(num)
FROM books
GROUP BY note WITH ROLLUP;

SELECT IFNULL(note,'合计总量') AS note,COUNT(*)
FROM books
GROUP BY note WITH ROLLUP;

SELECT note,SUM(num)
FROM books
GROUP BY note
ORDER BY SUM(num) DESC
LIMIT 0,3;

SELECT * FROM books

SELECT *
FROM books
WHERE pubdate = (
								SELECT MIN(pubdate)
								FROM books
								);


SELECT *
FROM books
WHERE price = (
							SELECT MAX(price)
							FROM books
							);

SELECT *
FROM books
WHERE CHAR_LENGTH(REPLACE(`name`,' ','')) = (
																						SELECT MAX(CHAR_LENGTH(REPLACE(`name`,' ','')))
																						FROM books
																						);
 



# 第11张 数据处理之增删改的课后练习

## 练习1
CREATE DATABASE IF NOT EXISTS dbtest11 CHARACTER SET 'utf8';

USE dbtest11;

CREATE TABLE my_employees(
id INT(10),
first_name VARCHAR(10),
last_name VARCHAR(10),
userid VARCHAR(10),
salary DOUBLE(10,2)
);

CREATE TABLE users(
id INT,
userid VARCHAR(10),
department_id INT
);

DESC my_employees;

DESC users;

##################################
##################################
##################################
# 新的插入表中数据的方法
INSERT INTO my_employees
SELECT 1,'patel','Ralph','Rpatel',895 UNION ALL
SELECT 2,'Dancs','Betty','Bdancs',860 UNION ALL
SELECT 3,'Biri','Ben','Bbiri',1100;

# 新的删除两个表中数据的方法
DELETE m,u
FROM my_employees m
JOIN users u
ON m.userid = u.userid
WHERE m.userid = 'Bbiri';

###################################
###################################
###################################









