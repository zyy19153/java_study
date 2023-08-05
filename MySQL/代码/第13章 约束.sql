# 第13章 约束

/*
1. 基础知识
1.1 为什么需要约束？  为了保证数据的完整性

1.2 什么叫约束？ 对表中字段的限制。

1.3 约束的分类：
角度1：约束的字段的个数
单列约束 VS 多列约束

角度2：约束的作用范围
列级约束：将此约束声明在对应字段的后面。
表级约束：在表中所有字段都声明完以后，在所有字段的后面声明的约束。

角度3：约束额作用（或功能）
① not null （非空约束）
② unique （唯一性约束）
③ primary key （主键约束）
④ foreign key （外键约束）
⑤ check （检查约束）
⑥ default （默认值约束）

1.4 如何添加约束？

CREATE TABLE时添加约束

ALTER TABLE时增加约束，删除约束 

*/

# 2. 如何查看表中的约束
#information_schema数据库名（系统库）
#table_constraints表名称（专门存储各个表的约束）
SELECT * FROM information_schema.table_constraints 
WHERE table_name = 'employees';

CREATE DATABASE dbtest13;
USE dbtest13;

# 3. not null （非空约束）
# 3.1 在CREATE TABLE 时添加约束

CREATE TABLE test1(
id INT NOT NULL,
last_name VARCHAR(25) NOT NULL,
email VARCHAR(25),
salary DECIMAL(10,2)
);

DESC test1;

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'test1';

INSERT INTO test1(id,last_name,email,salary)
VALUES (1,'Tom','tom@163.com',3400);

INSERT INTO test1(id,last_name,email,salary)
VALUES (1,NULL,'tom@163.com',3400);
# Column 'last_name' cannot be null

INSERT INTO test1(id,last_name,email,salary)
VALUES (NULL,'Jerry','jerry@163.com',3400);
# Column 'id' cannot be null

INSERT INTO test1(id,email)
VALUES (2,'abc@163.com');
# Field 'last_name' doesn't have a default value
# 这个错误很隐蔽！

UPDATE test1
SET last_name = NULL
WHERE id = 1;
# Column 'last_name' cannot be null

# 3.2 在ALTER TABLE 时添加约束

SELECT * FROM test1;
DESC test1;

UPDATE test1
SET email = NULL
WHERE id = 1;

UPDATE test1
SET email = 'tom@163.com'
WHERE id = 1;

AlTER TABLE test1
MODIFY email VARCHAR(25) NOT NULL;

# 3.3 在ALTER TABLE时删除约束
AlTER TABLE test1
MODIFY email VARCHAR(25) NULL;
# 这里末尾的NULL不写也行。

# 4. unique （唯一性约束）

# 4.1 在CREATE TABLE时添加约束
CREATE TABLE test2(
id INT UNIQUE, # 列级约束
last_name VARCHAR(15),
email VARCHAR(25) UNIQUE,
salary DECIMAL(10,2),

# 表级约束
CONSTRAINT uk_test2_email UNIQUE(email)
);
# 在创建唯一约束时，如果不给唯一约束命名，就默认和列名相同

DESC test2;

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'test2';

INSERT INTO test2(id,last_name,email,salary)
VALUES (1,'Tom','tom@164.com',4500);

SELECT * FROM test2;

INSERT INTO test2(id,last_name,email,salary)
VALUES (1,'Tom1','tom1@164.com',4600);
# Duplicate entry '1' for key 'test2.id'

INSERT INTO test2(id,last_name,email,salary)
VALUES (2,'Tom1','tom@164.com',4600);
# Duplicate entry 'tom@164.com' for key 'test2.email'

# 可以向声明为UNIQUE的字段上添加NULL值，而且可以多次添加NULL值
INSERT INTO test2(id,last_name,email,salary)
VALUES (2,'Tom1',null,4600);

SELECT * FROM test2;

INSERT INTO test2(id,last_name,email,salary)
VALUES (3,'Tom2',null,4600);

# 4.2 在ALTER TABLE时添加约束

DESC test2;

UPDATE test2
SET salary = 5000
WHERE id = 3;

# 方式1：
ALTER TABLE test2 
ADD CONSTRAINT uk_test2_sal UNIQUE(salary);

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'test2';

# 方式2：
ALTER TABLE test2
MODIFY last_name VARCHAR(15) UNIQUE;

# 4.3 复合的唯一性约束
CREATE TABLE USER(
id INT,
`name` VARCHAR(15),
`password` VARCHAR(25),

# 表级约束
CONSTRAINT uk_user_pwd UNIQUE(`name`,`password`)
);

DESC USER;

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'USER';

INSERT INTO USER
VALUES(1,'Tom','abc');

# 可以添加成功
INSERT INTO USER
VALUES(1,'Tom1','abc');

SELECT * FROM USER;

# 案例：复合的唯一性约束

#学生表
create table student(
		sid int,	#学号
    sname varchar(20),			#姓名
    tel char(11) unique key,  #电话
    cardid char(18) unique key #身份证号
);

#课程表
create table course(
		cid int,  #课程编号
    cname varchar(20)     #课程名称
);

#选课表
create table student_course(
    id int,
		sid int,
    cid int,
    score int,
    unique key(sid,cid)  #复合唯一
);

insert into student values(1,'张三','13710011002','101223199012015623');#成功
insert into student values(2,'李四','13710011003','101223199012015624');#成功
insert into course values(1001,'Java'),(1002,'MySQL');#成功

SELECT * FROM student;

SELECT * FROM course;

insert into student_course values
(1, 1, 1001, 89),
(2, 1, 1002, 90),
(3, 2, 1001, 88),
(4, 2, 1002, 56);#成功

SELECT * FROM student_course;

INSERT INTO student_course
VALUES (5,2,1002,67);
# Duplicate entry '2-1002' for key 'student_course.sid'

# 4.4 删除唯一性约束

-- 添加唯一性约束的列上也会自动创建唯一索引。
-- 删除唯一约束只能通过删除唯一索引的方式删除。
-- 删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样。
-- 如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同；如果是组合列，那么默认和()中排在第一个的列名相同。也可以自定义唯一性约束名。

DESC test2;

# 如何删除唯一性索引的问题
SHOW INDEX FROM test2; # 查看表索引

ALTER TABLE test2
DROP INDEX last_name;

ALTER TABLE test2
DROP INDEX uk_test2_sal;

ALTER TABLE test2
DROP INDEX email;

# 5. primary (主键约束)

# 5.1 在CREATE TABLE时添加约束
# 一个表中最多只能有一个主键约束
CREATE TABLE test3(
id INT PRIMARY KEY, # 列级约束
last_name VARCHAR(15) PRIMARY KEY,
salary DECIMAL(10,2),
email VARCHAR(25)
);
# Multiple primary key defined

# 主键约束特征：非空且唯一，用于唯一的标识表中的一条记录。
CREATE TABLE test4(
id INT PRIMARY KEY, # 列级约束
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25)
);

CREATE TABLE test5(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25),
# 表级约束
CONSTRAINT pk_test5_id PRIMARY KEY(id) # 没有必要起名字
);

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'test4';

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'test5';
# mysql的主键名总是PRIMARY，自己命名也没用

INSERT INTO test4(id,last_name,salary,email)
VALUES(1,'Tom',4500,'tom@163.com');

INSERT INTO test4(id,last_name,salary,email)
VALUES(1,'Tom',4500,'tom@163.com');
#  Duplicate entry '1' for key 'test4.PRIMARY'

INSERT INTO test4(id,last_name,salary,email)
VALUES(NULL,'Tom',4500,'tom@163.com');
# Column 'id' cannot be null

SELECT * FROM test4;

CREATE TABLE USER1(
id INT,
`name` VARCHAR(15),
`password` VARCHAR(25),
PRIMARY KEY (`name`,`password`)
);

INSERT INTO USER1
VALUES(1,'Tom','abc');

INSERT INTO USER1
VALUES(1,'Tom1','abc');

SELECT * FROM USER1;

INSERT INTO USER1
VALUES(1,NULL,'abc');
# Column 'name' cannot be null

# 5.2 在ALTER TABLE时添加约束

CREATE TABLE test6(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2),
email VARCHAR(25)
);

DESC test6;

ALTER TABLE test6
ADD PRIMARY KEY (id);

# 5.3 如何删除主键约束(在实际开发中，不会去删除主键约束)
ALTER TABLE test6
DROP PRIMARY KEY;

# 6. 自增长列：AUTO_INCREMENT
# 6.1 在CREATE TABLE中添加
CREATE TABLE test7(
id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(15)
);

# 开发中，一旦主键上的字段声明有AUTO_INCREMENT，则我们在添加数据时，就不要给主键对应的字段赋值。

INSERT INTO test7(last_name)
VALUES('Tom');

SELECT * FROM test7;

INSERT INTO test7(last_name)
VALUES ('Jerry');

# 当我们向主键(含AUTO_INCREMENT)的字段上添加0或NULL时，实际上会自动的往上添加指定的字段的数值。
INSERT INTO test7(id,last_name)
VALUES (0,'Jerry');

INSERT INTO test7(id,last_name)
VALUES (null,'Jerry');

INSERT INTO test7(id,last_name)
VALUES (10,'Jerry');

INSERT INTO test7(id,last_name)
VALUES (-10,'Jerry');

INSERT INTO test7(last_name)
VALUES ('Jerry');

# 6.2 在ALTER TABLE中添加
CREATE TABLE test_8(
id INT PRIMARY KEY,
last_name VARCHAR(15)
);

DESC test_8;

ALTER TABLE test_8
MODIFY id INT AUTO_INCREMENT;

# 6.3 在ALTER TABLE中删除

ALTER TABLE test8
MODIFY id INT;

# 6.4 MySQL8新特性-自增量的持久化

# 在MySQL5.7中演示
CREATE DATABASE dbtest13;
USE dbtest13;
CREATE INTO test1(
id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test1
VALUES(0),(0),(0),(0);

SELECT * FROM test1;

DELETE FROM test1 WHERE id = 4;

INSERT INTO test1 VALUES(0);

SELECT * FROM test1;

DELETE FROM test1 where id=5;

# 重启数据库

INSERT INTO test1 values(0);

SELECT * FROM test1;

# 在MySQL8中演示

CREATE INTO test9(
id INT PRIMARY KEY AUTO_INCREMENT
);

INSERT INTO test9
VALUES(0),(0),(0),(0);

SELECT * FROM test9;

DELETE FROM test9 WHERE id = 4;

INSERT INTO test9 VALUES(0);

SELECT * FROM test9;

DELETE FROM test9 where id=5;

# 重启数据库

INSERT INTO test9 values(0);

SELECT * FROM test9;

# AUTO_INCREMENT持久化到日志中了，非内存里，故重启数据库对其没影响 

# 7. FOREIGN KEY （外键约束）
# 7.1 在CREATE TABLE 时添加

# 主表和从表：父表和从表

# ① 先创建主表
CREATE TABLE dept1(
dept_id INT,
dept_name VARCHAR(15)
);

# ② 再创建从表
CREATE TABLE emp1(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT,

# 表级约束
CONSTRAINT fk_emp1_dept_id FOREIGN KEY (department_id) REFERENCES dept1(dept_id)
);
# Failed to add the foreign key constraint. Missing index for constraint 'fk_emp1_dept_id' in the referenced table 'dept1'
# 上述操作报错，因主表中的dept_id上没有主键约束或唯一性约束

# ③
ALTER TABLE dept1
ADD PRIMARY KEY (dept_id);

DESC dept1;

# ④ 再创建从表
CREATE TABLE emp1(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT,

# 表级约束
CONSTRAINT fk_emp1_dept_id FOREIGN KEY (department_id) REFERENCES dept1(dept_id)
);

DESC emp1;

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'emp1';

# 7.2 演示外键的效果
# 添加失败
INSERT INTO emp1
VALUES (1001,'Tom',10);

# 
INSERT INTO dept1
VALUES(10,'IT');

# 在主表添加了10号部门以后，我们就可以在从表中添加10号部门的员工
INSERT INTO emp1
VALUES (1001,'Tom',10);

# 删除失败
DELETE FROM dept1
WHERE dept_id = 10;

# 更新失败
UPDATE dept1
SET dept_id = 20
WHERE dept_id = 10;

# 7.3 在ALTER TABLE时添加外键约束
CREATE TABLE dept2(
dept_id INT,
dept_name VARCHAR(15)
);

ALTER TABLE dept2
ADD PRIMARY KEY (dept_id);

CREATE TABLE emp2(
emp_id INT PRIMARY KEY AUTO_INCREMENT,
emp_name VARCHAR(15),
department_id INT
);

SELECT * FROM information_schema.table_constraints
WHERE table_name = 'emp2';

ALTER TABLE emp2
ADD CONSTRAINT fk_emp2_dept_id FOREIGN KEY (department_id) REFERENCES dept2(dept_id);

# 7.4 约束等级

-- `Cascade方式`：在父表上update/delete记录时，同步update/delete掉子表的匹配记录 

-- `Set null方式`：在父表上update/delete记录时，将子表上匹配记录的列设为null，但是要注意子表的外键列不能为not null  

-- `No action方式`：如果子表中有匹配的记录，则不允许对父表对应候选键进行update/delete操作  

-- `Restrict方式`：同no action， 都是立即检查外键约束

-- `Set default方式`（在可视化工具SQLyog中可能显示空白）：父表有变更时，子表将外键列设置成一个默认的值，但Innodb不能识别

# 结论：对于外键约束，最好采用：`ON UPDATE CASCADE ON DELETE RESTRICT`的方式

# 7.5 删除外键约束

# 一个表中可以声明多个外键约束

USE atguigudb;
SELECT * FROM information_schema.table_constraints
WHERE table_name = 'employees';

USE dbtest13;
SELECT * FROM information_schema.table_constraints
WHERE table_name = 'emp1';

# 删除外键约束
ALTER TABLE emp1 
DROP FOREIGN KEY fk_emp1_dept_id;

# 手动的删除外键约束对应的普通索引
SHOW INDEX FROM emp1;

ALTER TABLE emp1
DROP INDEX fk_emp1_dept_id;
# 删除的时候按照约束的名字删，而不是列名删

# 8. CHECK约束
CREATE TABLE test10(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) CHECK(salary > 2000)
);

INSERT INTO test10
VALUES(1,'Tom',2500);

# 添加失败(注：在MySQL5.7中这里会添加成功，因为其不支持CHECK约束)
INSERT INTO test10
VALUES(2,'Tom1',1500);
# Check constraint 'test10_chk_1' is violated.

# 9. DEFAULT约束
# 9.1 在CREATE TABLE中添加
CREATE TABLE test11(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) DEFAULT 2000
);

DESC test11;

INSERT INTO test11
VALUES (1,'Tom',3000);

SELECT * FROM test11;

INSERT INTO test11(id,last_name)
VALUES (2,'Jerry');

# 9.2 在ALTER TABLE中添加

CREATE TABLE test12(
id INT,
last_name VARCHAR(15),
salary DECIMAL(10,2) 
);

DESC test12;

ALTER TABLE test12
MODIFY salary DECIMAL(8,2) DEFAULT 2500;

# 9.3 在ALTER TABLE中删除

ALTER TABLE test12
MODIFY salary DECIMAL(8,2);

SHOW CREATE TABLE test12;



# 第13章 约束的课后练习

## 练习1：
CREATE DATABASE test04_emp;

USE test04_emp;

CREATE TABLE emp2(
id INT,
emp_name VARCHAR(15)
);

CREATE TABLE dept2(
id INT,
dept_name VARCHAR(15)
);

## 1.向表emp2的id列中添加PRIMARY KEY
ALTER TABLE emp2
ADD PRIMARY KEY (id);

## 2.向表dept2的id列中添加PRIMARY KEY
ALTER TABLE dept2
ADD PRIMARY KEY (id);

## 3.向表emp2中添加列dept_id，并在其中定义FOREIGN KEY，与之相关联的列时dept2表中的id列
ALTER TABLE emp2
ADD dept_id INT;

ALTER TABLE emp2
ADD CONSTRAINT fk_emp2_dept_id FOREIGN KEY (dept_id) REFERENCES dept2(id);

## 练习2：
# 承接《第11章 数据处理之增删改》的综合案例
USE test01_library;

DESC books;

# 方式1：
ALTER TABLE books
ADD PRIMARY KEY (id);

ALTER TABLE books
MODIFY id INT AUTO_INCREMENT;

# 方式2：
ALTER TABLE books
MODIFY id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE books
MODIFY `name` VARCHAR(50) NOT NULL;

ALTER TABLE books
MODIFY num INT NOT NULL;

ALTER TABLE books
MODIFY `authors` VARCHAR(100) NOT NULL;

ALTER TABLE books
MODIFY price FLOAT NOT NULL;

ALTER TABLE books
MODIFY pubdate YEAR NOT NULL;

# 练习3：
CREATE DATABASE test04_company;

USE test04_company;

CREATE TABLE IF NOT EXISTS offices(
officeCode INT(10) PRIMARY KEY,
city VARCHAR(50) NOT NULL,
address VARCHAR(50),
country VARCHAR(50) NOT NULL,
postalCode VARCHAR(15),
CONSTRAINT uk_off_poscode UNIQUE(postalCode)
);

CREATE TABLE employees(
employeeNumber INT PRIMARY KEY,
lastName VARCHAR(50) NOT NULL,
firstName VARCHAR(50) NOT NULL,
mobile VARCHAR(25),
officeCode INT(10) NOT NULL,
jobTitle VARCHAR(50) NOT NULL,
birth DATETIME NOT NULL,
note VARCHAR(255),
sex VARCHAR(5),
CONSTRAINT uk_emp_firname UNIQUE(mobile),
CONSTRAINT fk_emp_offcode FOREIGN KEY (officeCode) REFERENCES offices(officeCode)
);

DESC offices;
DESC employees;

ALTER TABLE employees
MODIFY mobile VARCHAR(25) AFTER officeCode;

ALTER TABLE employees
CHANGE birth employeeBirth DATETIME;

ALTER TABLE employees
MODIFY sex CHAR(1) NOT NULL;

ALTER TABLE employees
DROP COLUMN note;

ALTER TABLE employees
ADD favourite_activity VARCHAR(100);

RENAME TABLE employees
TO employees_info;

