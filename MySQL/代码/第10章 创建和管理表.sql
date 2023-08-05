# 第10章 创建和管理表

# 1. 创建和管理数据库

# 1.1 如何创建数据库
# 方式1
CREATE DATABASE mytest1; # 创建的此数据库使用的是默认的字符集
SHOW CREATE DATABASE mytest1;

# 方式2：显示指明了要创建的数据库的字符集
CREATE DATABASE mytest2 CHARACTER SET 'gbk';

# 方式3（推荐）：如果要创建的数据库已经存在，则创建不成功，但不会存在
CREATE DATABASE IF NOT EXISTS mytest2 CHARACTER SET 'utf8';
# 查看创建数据库的结构
SHOW CREATE DATABASE mytest2;
#如果要创建的数据库不存在，则创建成功
CREATE DATABASE IF NOT EXISTS mytest3 CHARACTER SET 'utf8';
SHOW DATABASES;

# 1.2 管理数据库
# 查看当前连接的数据库都有哪些
SHOW DATABASES;

# 切换数据库
USE atguigudb;

# 查看当前数据库中保存的数据表
SHOW TABLES;  

# 查看当前使用的数据库
USE mytest2;
SELECT DATABASE() FROM DUAL;

# 查看指定的数据库下保存的数据表
SHOW TABLES FROM mysql;

# 1.3 修改数据库的操作
# 更改数据库的字符集
SHOW CREATE DATABASE mytest2;
ALTER DATABASE mytest2 CHARACTER SET 'utf8';

# 1.4 删除数据库
# 方式1：如果删除的数据库存在，则删除成功。如果不存在，就会报错
DROP DATABASE mytest1;

SHOW DATABASES;

# 方式2(推荐)如果删除的数据库存在，则删除成功。如果不存在，则默默结束，不会报错
DROP DATABASE IF EXISTS mytest1;

# 2. 如何创建数据表
USE atguigudb;
SHOW CREATE DATABASE atguigudb; # 默认使用的是utf8mb3

SHOW TABLES; 
# 方式1："白手起家"的方式
CREATE TABLE IF NOT EXISTS myemp1( # 需要用户具备创建表的权限
id int,
emp_name VARCHAR(15), # 使用VARCHAR来定义字符串，必须指定其长度
hire_date DATE
);

# 查看表结构
DESC myemp1;

SHOW CREATE TABLE myemp1; # 如果创建表时没有指明使用的字符集，则默认使用表所在数据库的字符集

SELECT * FROM myemp1;

# 方式2：基于现有的表创建新的表，同时导入数据
CREATE TABLE myemp2 
AS 
SELECT employee_id,last_name,salary
FROM employees;

DESC myemp2;
DESC employees;

SELECT * FROM myemp2;

# 查询语句中字段的别名，可以作为新创建的表的字段的别名
# 此时的查询语句可以结构比较丰富，使用前面章节讲过的各种SELECT
CREATE TABLE myemp3
AS
SELECT e.employee_id emp_id,e.last_name lname,d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;

SELECT * FROM myemp3;

DESC myemp3;

# 练习1：创建一个表employee_copy,实现对employees表的复制，包括表数据
CREATE TABLE employee_copy
AS
SELECT * 
FROM employees;

SELECT * FROM employee_copy;

# 练习2：创建一个表employee_blank,实现对employees表的复制，不包括表数据
CREATE TABLE employee_blank
AS
SELECT *
FROM employees 
#WHERE department_id > 10000
WHERE 1 = 2; # 山无棱，天地合，乃敢与君绝。

SELECT * FROM employee_blank;

# 3.修改表 -> ALTER TABLE 
DESC myemp1;
# 3.1 添加一个字段
ALTER TABLE myemp1
ADD salary DOUBLE(10,2); # 默认添加到表的最后一个字段的位置

ALTER TABLE myemp1
ADD phone_number VARCHAR(20) FIRST;

ALTER TABLE myemp1
ADD email VARCHAR(45) AFTER emp_name;

# 3.2 修改一个字段：数据类型、长度、默认值
ALTER TABLE myemp1
MODIFY emp_name VARCHAR(25);

ALTER TABLE myemp1
MODIFY emp_name VARCHAR(35) DEFAULT 'aaa';

DESC myemp1;
ALTER TABLE myemp1
MODIFY emp_name VARCHAR(35) AFTER ...;
# 3.3 重命名一个字段
ALTER TABLE myemp1
CHANGE salary monthly_salary DOUBLE (10,2);

ALTER TABLE myemp1
CHANGE email my_email VARCHAR(50);

# 3.4 删除一个字段
ALTER TABLE myemp1
DROP COLUMN my_email;

# 4.重命名表
# 方式1：
RENAME TABLE myemp1
TO myemp11;

DESC myemp11;

# 方式2：
ALTER TABLE myemp2
RENAME TO myemp12;

# 5.删除表
# 不光是表结构删除掉了，同时表中的数据也删除掉了，释放表空间
DROP TABLE IF EXISTS myemp12;

# 6.清空表
# 清空表中的所有数据，但是表结构保留
SELECT * FROM employee_copy;

TRUNCATE TABLE employee_copy;

SELECT * FROM employee_copy;
DESC employee_copy;

# 7.DCL中COMMIT和ROLLBACK
# COMMIT：提交数据。一旦执行COMMIT，则数据就被永久的保存在了数据库中，意味着数据不能回滚。
# ROLLBACK：回滚数据。一旦执行ROLLBACK，则可以实现数据的回滚，回滚到最近的一次COMMIT之后。

# 8.对比TRUNCATE TABLE和DELETE FROM
# 相同点：都可以实现对表中所有数据的删除，同时保留表结构
# 不同点：
# TRUNCATE TABLE：一旦执行此操作，表数据全部清除，同时，数据是不可以回滚的。
# DELETE FROM：一旦执行此操作，表数据可以全部清除（不带WHERE）。同时，数据是可以实现回滚的。

/*
9. DDL和DML的说明：
① DDL的操作一旦执行，就不可以回滚。指令SET autocommit = FALSE对DDL失效。因为在执行完DDL操作后，一定会执行一次COMMIT。而此COMMIT操作不受SET autocommit = FALSE影响。
② DML的操作默认情况下，一旦执行，也是不能回滚的。但是，如果在执行DML之前，执行了SET autocommit = FALSE，则执行的DML操作就可以回滚了。


*/

# 演示：DELETE FROM
# 1)
COMMIT;
# 2)
SELECT * FROM myemp3;
# 3)
SET autocommit = FALSE;
# 4)
DELETE FROM myemp3;
# 5)
SELECT * FROM myemp3;
# 6)
ROLLBACK;
# 7)
SELECT * FROM myemp3;

# 演示：TRUNCATE TABLE 
# 1)
COMMIT;
# 2) 
SELECT * FROM myemp3;
# 3)
SET autocommit = FALSE;
# 4)
TRUNCATE TABLE myemp3;
# 5)
SELECT * FROM myemp3;
# 6)
ROLLBACK;
# 7)
SELECT * FROM myemp3;


#########################
# 9.测试MySQl8.0的新特性：DDL的原子化
CREATE DATABASE mytest;

USE mytest;

CREATE TABLE book1(
book_id INT ,
book_name VARCHAR(255)
);

SHOW TABLES;

DROP TABLE book1,book2;

SHOW TABLES;



# 第10章 创建和管理表的课后练习

## 1.创建数据库test01_office，指明字符集为utf8，并在此数据库下执行下属操作
CREATE DATABASE IF NOT EXISTS test01_office CHARACTER SET 'utf8';
USE test01_office;

## 2.创建表dept01
/*
字段 					类型
id   					INT(7)
NAME 					VARCHAR(25)
*/
CREATE TABLE IF NOT EXISTS dept01(
id INT(7),
`name` VARCHAR(25)
);

## 3.将departments中的数据插入到新表dept02中
CREATE TABLE dept02
AS
SELECT *
FROM atguigudb.departments;

## 4.创建表emp01
/*
字段						类型  
id 							INT(7)
first_name 			VARCHAR(25)
last_name 			VARCHAR(25)
dept_id 				INT(7)
*/
CREATE TABLE IF NOT EXISTS emp01(
id INT(7),
first_name VARCHAR(25),
last_name VARCHAR(25),
dept_id INT(7)
);

## 5.将列last_name的长度增加到50
ALTER TABLE emp01
MODIFY last_name VARCHAR(50);

## 6.根据表employees创建emp02
CREATE TABLE emp02
AS
SELECT *
FROM atguigudb.employees
WHERE 1 = 2;

SHOW TABLES;

## 7.删除表emp01
DROP TABLE IF EXISTS emp01;

## 8.将表emp02重命名为emp01
RENAME TABLE emp02
TO emp01;

# 方式2：
ALTER TABLE emp02
RENAME TO emp02;

## 9.在表dept02和emp01中添加新列test_column，并检查所作的操作
ALTER TABLE emp01
ADD test_column VARCHAR(10);
ALTER TABLE dept02
ADD test_column VARCHAR(10);
DESC emp01;
DESC dept02;

## 10.直接删除表emp01中的列department_id
ALTER TABLE emp01
DROP COLUMN department_id;

# 练习2：
CREATE DATABASE IF NOT EXISTS test02_market CHARACTER SET 'utf8';
USE test02_market;
SHOW CREATE DATABASE test02_market;

CREATE TABLE customers(
c_num INT,
c_name VARCHAR(50),
c_contact VARCHAR(50),
c_city VARCHAR(50),
c_birth DATE
);

DESC customers;
ALTER TABLE customers
MODIFY c_contact VARCHAR(50) AFTER c_birth;

ALTER TABLE customers
MODIFY c_name VARCHAR(70)

ALTER TABLE customers
CHANGE c_contact c_phone VARCHAR(50);

ALTER TABLE customers
ADD c_gender CHAR(1) AFTER c_name;

RENAME TABLE customers
TO customers_info;

ALTER TABLE customers_info
DROP COLUMN c_city;

# 练习3：
CREATE DATABASE test03_company CHARACTER SET 'utf8';
USE test03_company;

CREATE TABLE offices(
officeCode INT,
city VARCHAR(30),
address VARCHAR(50),
country VARCHAR(50),
postalCode VARCHAR(25)
);

DESC offices;

CREATE TABLE employees(
empNum INT,
lastName VARCHAR(50),
firstName VARCHAR(50),
mobile VARCHAR(25),
`code` INT,
jobTitle VARCHAR(50),
birth DATE,
note VARCHAR(255), 
sex VARCHAR(5)
);

DESC employees;

ALTER TABLE employees
MODIFY mobile VARCHAR(25) AFTER `code`;

ALTER TABLE employees
CHANGE birth birthday DATE;

ALTER TABLE employees 
MODIFY sex CHAR(1);

ALTER TABLE employees
DROP COLUMN note;

ALTER TABLE employees
ADD favoriate_activity VARCHAR(100);

RENAME TABLE employees
TO employee_info;

DESC employee_info;