create table ton (
	mavt char(5) primary key,
	tenvt char(20) not null,
	soluong int not null
)
create table nhap (
	soHdN char(5) primary key,
	mavt char(5),
	soLuongN int not null,
	donGiaN int not null,
	ngayNhap date,
	constraint fk_mavt_nhap foreign key (mavt) references ton (mavt)
)
create table xuat (
	soHdX char(5) primary key,
	mavt char(5),
	soLuongX int not null,
	donGiaX int not null,
	ngayXuat date,
	constraint fk_mavt_xuat foreign key (mavt) references ton (mavt)
)
--nhap du lieu vao cho bang
insert into ton values
('VT001', 'TIVI', 210),
('VT002', 'TULANH', 220),
('VT003', 'DIEUHOA', 230),
('VT004', 'MAYGIAT', 240)
insert into ton values ('VT004', 'MAYGIAT', 240)

insert into nhap values
('HDN01', 'VT001', 100, 1000, '02-02-2020'),
('HDN02', 'VT002', 110, 1000, '02-02-2020'),
('HDN03', 'VT003', 120, 1000, '02-02-2020')

insert into xuat values
('HDX01', 'VT001', 10, 100, '02-03-2020'),
('HDX02', 'VT002', 10, 100, '02-03-2020'),
('HDX03', 'VT001', 10, 100, '02-03-2020')
--cau 2
create function fn_TongBan(@ngayXuat date, @mavt char(5) )
returns @bang table (mavt char(5), tenvt char(20), tongban int)
as
begin
	insert into @bang
				select ton.mavt, tenvt, sum(soLuongX * donGiaX) from ton inner join xuat on ton.mavt = xuat.mavt
																where ngayXuat = @ngayXuat and ton.mavt = @mavt
																group by ton.mavt, tenvt
	return
end
select * from fn_TongBan('02-03-2020', 'VT002')
--cau 3: 
create proc sp_Xoa(@mavt char(5) )
as
begin
	if(exists (select * from nhap where mavt = @mavt) and exists (select * from xuat where mavt = @mavt))
		begin
			print 'Khong the xoa vat tu nay o bang ton'
			return
		end
	delete from ton where mavt = @mavt
end
exec sp_Xoa 'VT004'
select * from ton
--cau4:
create trigger tg_nhap
on nhap
for insert
as
begin
	if(not exists (select * from ton inner join inserted on ton.mavt = inserted.mavt))
		begin
			raiserror ('Ma vat tu chua co trong bang ton', 16, 1)
			rollback tran
		end
	update ton set soluong = soluong + inserted.soLuongN from ton inner join inserted on ton.mavt = inserted.mavt
end
alter table nhap nocheck constraint all
insert into nhap values('HDN05', 'VT002', 120, 1000, '02-02-2020')