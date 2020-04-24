create table Department (
	DepartmentNo integer primary key,
	DepartmentName char(25) not null,
	Location char(25) not null
);
create table Employee (
	EmpNo integer primary key,
	Fname varchar(15) not null,
	Lname varchar(15) not null,
	Job varchar(15) not null,
	HireDate DateTime not null,
	Salary numeric not null,
	Commision numeric,
	DepartmentNo integer not null,
	constraint fk_DepartmentNo foreign key(DepartmentNo) references Department(DepartmentNo)
);

--Insert data into the tables that you've created above

insert into Department values (10, 'd1', 'california'),
(11, 'd2', 'las vegas'),
(12, 'd3', 'Ohio'),
(13, 'd4', 'New Orland');

insert into Employee values 
 (1, 'chen', 'robert', 'senior','1/12/2020', 1400, 100, 11),
(2, 'chen1', 'robert1', 'senior1','2/12/2020', 1100, 200, 12),
(3, 'chen2', 'robert2', 'senior2','3/12/2020', 1200, 300, 13),
(4 ,'chen3', 'robert3', 'senior3','4/12/2020', 1300, 400, 11);
delete from Employee where EmpNo = 5;


--1.hien thi noi dung bang department
select * from Department;

--2. hien thi noi dung bang Employee
select * from Employee;

--3.hien thi employee number, employee fname = 'Chen', lastname

select EmpNo, Fname, Lname from Employee
where Fname = 'chen';

--4.hien thi ghep 2 truong Fname va Lname thanh truong full name va truong Salary = 10% Salary ban dau
select  'Full name' = Fname + Lname, 'New Salary' = Salary + 0.1 * Salary from Employee;

--5. Hien thi Fname, Lname, HiereDate cho tat ca cac Employee co HireDate = 1981, sap xep theo thu tu tang dan cua Lname
select Fname, Lname, HireDate from Employee
where year(HireDate) = 2020
order by Lname asc;

--6.Hien thi trung binh, max, in luong cua tung phong ban trong bang Employee.
select MAX(Salary) as 'luong cao that', MIN(Salary) as 'luong thap nhat', AVG(Salary) as 'luong trung binh'
from Employee
group by DepartmentNo;

--7.Hien thi DepartmentNo va so nguoi co trong tung phong ban trong bang Employee
select DepartmentNo,count(DepartmentNo) as 'Number of Employees'
from Employee
group by DepartmentNo;

--8.Hien thi DepartmentNo, DepartmentName, FullName (Fname, Lname), Salary trong bang Department,  Employee
select Department.DepartmentNo, Department.DepartmentName, 'Full name' = Employee.Fname +' '+ Employee.Lname, Employee.Salary
from Department INNER JOIN Employee on Department.DepartmentNo =  Employee.DepartmentNo;

--9.Hien thi DeartmentNo, DepartmentName, Location va so nguoi co trong tung phong ban cua bang Department va bang Employee
-- Hints: tao 1 bang phu SoNguoi, sau do ket noi voi bang Department
select count(*) as 'so nhan vien', Employee.DepartmentNo into SoNguoi
from Employee
group by Employee.DepartmentNo;

select *
from SoNguoi INNER JOIN Department on SoNguoi.DepartmentNo = Department.DepartmentNo;

