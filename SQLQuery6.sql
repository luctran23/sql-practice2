create table Students (
	StudentID nvarchar(12) primary key,
	StudentName nvarchar(25) not null,
	DateofBirth Datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	Class nvarchar(10)
);

create table Subjects (
	SubjectID nvarchar(10) primary key,
	SubjectName nvarchar(25) not null
);

create table Mark (
	StudentID nvarchar(12),
	SubjectID nvarchar(10),
	Date Datetime,
	Theory integer,
	Practical integer
);

-- Insert data into the tables that you've created above
-- table STUDENT
insert into Students values
('AV005', 'Mai Trung Hieu', '11/10/1989', 'trunghieu@yahoo.com', '0904115006', 'AV1'),
('AV006', 'Nguyen Quy Hung', '2/12/1988', 'quyhung@yahoo.com', '00904115007','AV2'),
('AV007', 'Do Dac Huynh', '1/2/1988', 'fuckyou@yahoo.com', '00904115008','AV2'),
('AV009', 'An Dang Khue', '2/12/1988', 'dangkhue@yahoo.com', '00904115010', 'AV1'),
('AV010', 'Nguyen Tuyet Lan', '2/12/1988', 'tuyetlan@yahoo.com', '00904115011', 'AV2');
insert into Students values('AV011', 'Dinh Van Long', '2/12/1988', 'vanlong@yahoo.com', '00904115009', 'AV1'),
('AV012', 'Nguyen Tuan Nam', '2/12/1988', 'tuannam@yahoo.com', '00904115009', 'AV1');

--table Subjects
insert into Subjects values 
('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page');

--table Mark
insert into Mark values 
--bi nham
--studID, SubId, date, theory, practical
	('AV005', 'S001', 8, 25, 6/5/2008),
	('AV006', 'S001', 8, 25, 6/5/2011),
	('AV007', 'S001', 8, 25, 6/5/2009),
	('AV009', 'S001', 8, 25, 6/5/2012),
	('AV010', 'S001', 8, 25, 6/5/2011),
	('AV011', 'S001', 8, 25, 6/5/2013),
	('AV012', 'S001', 8, 25, 6/5/2014),
	('AV009', 'S001', 8, 25, 6/5/2015),
	('AV006', 'S001', 8, 25, 6/5/2016),
	('AV011', 'S001', 8, 25, 6/5/2017);

-- thuc hien truy van tren co sow du lieu
--1.hien thi noi dung bang Students
select * from Students;

--2.Hien thi noi dung danh sach sinh vien lop AV1
select * from Students 
where Class = 'AV1';

--3.Su dung UPDATE de chuyen sinh vien cos ma AV012 sang lop AV2
-- KHONG NHO-> FINISH LATER

--4.Tinh tong so sinh vien cua tung lop
select count(*) as 'tong sv' from Students
group by Class;

--5.Hien thi danh sach sinh vien lop AV2 duoc sap xep tang dan theo StudentName
select * from Students
where Class = 'AV2' 
order by StudentName;

--6.hien thi danh sach sinh vien khong dat ly thuyet mon S001(theory < 10) thi ngay 6/5/2008
select * from Mark
where theory > 10 and SubjectID = 'S001' and Practical = 6/5/2008;

--7.Hien thi tong so sinh vien khong dat ly thuyet so mon s001.(theory <10) 
--vi la truyen du lieu sai nen cho where sai, phai la Theory < 10
select count(*) as 'not ok' 
from Mark
where Date < 10;

--8.Hien thi danh sach sinh vien hoc lop AV1 va sinh sau ngay 1/1/1980
(select * from Students
where Class  = 'AV1')
-- KHONG nho phep giao la gi
(select * from Mark 
where Practical = 6/5/2008);

--9.Xoa sinh vien co ma AV011
delete from Students where StudentID = 'AV011';

--10.Hien thi danh sach sinh vien du thi mon S001 ngay 6/5/2008 bao gom cac truong sau: StudentId, StudentName, SubjectName, Theory, Practical, Date


Students(StudentID, StudentName, DateofBirth, Email, Phone, Class)
Subjects(StudentID, SubjectName)
Mark(StudentID, SubjectID, Date, Theory, Practical)

--THU TUC KHONG CO OUTPUT
--vidu: Viet thu tuc nhap du lieu cho bang sinh vien voi cac tham bien truyen vao la StudentID, StudentName, DateofBirth,
--Email, Phone, Class. Hay kiem tra xem StudentID da co trong bang Mark chua. Neu chua co thi thong bao

Create proc sp_themsv(@StudentID  nvarchar(12), @StudentName nvarchar(25), @DateofBirth Datetime, @Email nvarchar(40), @Phone nvarchar(12),
@Class nvarchar(10))
as
begin
	declare @dem int
	set @dem = (select count(*) from Mark where StudentID = @StudentID )
	if(@dem = 0)
		print(N'there are no student with this StudentID')
	else if(not exists (select * from Students where StudentID = @StudentID) )
		insert into Students values (@StudentID, @StudentName , @DateofBirth , @Email , @Phone,@Class)
		else 
			print('This student is already existed')
end

select * from Students
select * from Mark
exec sp_themsv 'AV005', 'Johnny Dang', '1989-11-10', 'Johnnydang@gmail.com', '0912339494', 'AV0' 