create table pxuat (
	soHd char(4) primary key,
	ngayNhap date not null,
	ghiChu nvarchar(20) not null
)
create table vattu (	
	mavt char(4) primary key,
	tenvt char(20) not null,
	soLuongT int not null
)
create table ctpxuat (
	soHd char(4),
	mavt char(4),
	soLuongX int not null,
	donGiaX int not null,
	constraint pk_soHd_mavt primary key (soHd, mavt),
	constraint fk_soHd_ctpxuat foreign key (soHd) references pxuat (soHd),
	constraint fk_mavt_ctpxuat foreign key (mavt) references vattu (mavt)
)
-- nhap du lieu vao bang
insert into pxuat values
('hd01', '02-02-2020', 'ghi chu 1'),
('hd02', '02-02-2020', 'ghi chu 2'),
('hd03', '02-02-2020', 'ghi chu 3')
insert into vattu values
('vt01', 'tivi', 20),
('vt02', 'tulanh', 20),
('vt03', 'dieuhoa', 20)
insert into ctpxuat values
('hd01', 'vt01', 10, 200),
('hd02', 'vt01', 20, 210),
('hd01', 'vt02', 30, 220),
('hd03', 'vt01', 40, 230),
('hd02', 'vt03', 50, 240)
--cau 2
create proc sp_cau2 (@tenvt char(20) )
as
begin
	if(not exists (select * from vattu where tenvt = @tenvt) )
		begin
			print 'Ten vat tu khong ton tai'
			return
		end
	select * from vattu where tenvt = @tenvt
end
exec sp_cau2 'ok'
--cau 3: 
create function fn_cau3 (@mavt char(4), @ngayNhap date)
returns int
as
begin
	declare @tongXuat int
	select @tongXuat = sum(soLuongX * donGiaX) from ctpxuat inner join pxuat on ctpxuat.soHd = pxuat.soHd
											   where mavt = @mavt and ngayNhap = @ngayNhap
	return @tongXuat
end
select *  from ctpxuat inner join pxuat on ctpxuat.soHd = pxuat.soHd where mavt = 'vt01'
select dbo.fn_cau3('vt01', '02-02-2020') as 'tong xuat'

--cau 4:
create trigger tg_cau4
on ctpxuat
for insert
as
begin
	if(not exists (select * from vattu inner join inserted on vattu.mavt = inserted.mavt))
		begin
			raiserror ('Kiem tra lai ma vat tu', 16, 1)
			rollback tran
		end
	declare @slx int, @slt int
	select @slx = soLuongX from inserted
	select @slt = soLuongT from vattu where mavt = (select mavt from inserted)
	if(@slx > @slt)
		begin
			raiserror('Kiem tra lai so luong xuat', 16, 1)
			rollback tran
		end
end
alter table ctpxuat nocheck constraint all
insert into ctpxuat values('hd02', 'vt02', 15, 240)