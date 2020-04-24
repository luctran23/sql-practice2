USE master
GO
IF (EXISTS(SELECT * FROM sys.sysdatabases WHERE name='QLBanHang'))
DROP DATABASE QLBanHang
go
create database QLBanHang;
GO

USE QLBanHang
GO
create table PXUAT(
	SoPx char(4) PRIMARY KEY,
	NgayXuat Date default getDate(),
	TenKh nvarchar(100) not null,
	)
GO

create table VATTU(
	MaVTu char(4) PRIMARY KEY,
	TenVTu nvarchar(100) not null,
	DvTinh nvarchar(10) not null,
	PhanTram Real,
	)
GO

create table CTPXUAT(
	SoPx char(4),
	CONSTRAINT FK_SoPx FOREIGN KEY(SoPx) REFERENCES PXUAT(SoPx),
	MaVTu char(4),
	CONSTRAINT FK_MaVTu FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu), 
	SlXuat int not null,
	DgXuat Money not null,
	PRIMARY KEY(SoPx, MaVTu),
)
GO

create table TONKHO(
	NamThang char(6),
	MaVTu char(4),
	CONSTRAINT FK_MaVTu_TONKHO FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
	SLDau int not null,
	TongSLN int not null,
	TongSLX int not null,
	SLCuoi int not null,
	PRIMARY KEY(NamThang, MaVTu),
	)
GO

Create table NHACC(
		MaNhaCc char(3) PRIMARY KEY,
		TenNhaCc nvarchar(100) not null,
		DiaChi nvarchar(200) not null,
		DienThoai varchar(20) not null
	)
GO

create table DONDH(
	SoDh char(4) primary key,
	NgayDh datetime,
	MaNhaCc char(3),
	CONSTRAINT FK_MaNhaCc_DONDH FOREIGN KEY(MaNhaCc) REFERENCES NHACC(MaNhaCc),
)
GO

Create table CTDONDH(
	SoDh char(4),
	MaVTu char(4),
	SlDat int not null,
	PRIMARY KEY (SoDH,MaVTu),
	CONSTRAINT FK_SoDh_CTDONDH FOREIGN KEY(SoDh) REFERENCES DONDH(SoDh),
	CONSTRAINT FK_MaVTu_CTDONDH FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
	)
GO

Create table PNHAP(
	SoPn char(4) primary key,
	NgayNhap datetime,
	SoDh char(4),
	CONSTRAINT FK_SoDh_PNHAP FOREIGN KEY(SoDh) REFERENCES DONDH(SoDh),
)
GO

Create table CTPNHAP(
	SoPn char(4),
	MaVTu char(4),
	SlNhap int not null,
	DgNhap Money not null,
	PRIMARY KEY(SoPN, MaVTu),
	CONSTRAINT FK_SoPn_CTPNHAP FOREIGN KEY(SoPn) REFERENCES PNHAP(SoPn),
	CONSTRAINT FK_MaVTu_CTPNHAP FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
)

--cau1
create proc sp_DanhSachNCC  
as
begin
	select NHACC.MaNhaCc, TenNhaCc, sum(SlDat) from NHACC inner join DONDH on NHACC.MaNhaCc = DONDH.MaNhaCc
						inner join CTDONDH on CTDONDH.SoDh = DONDH.SoDh group by NHACC.MaNhaCc, TenNhaCc
end
exec sp_DanhSachNCC 
drop proc sp_DanhSachNCC

--cau2.
create proc  sp_DanhSachHangNhap(@MaVTu char(4) )
as
begin
	select NHACC.MaNhaCc, NgayNhap, SlNhap, DgNhap, SlNhap * DgNhap 
	from NHACC inner join DONDH on NHACC.MaNhaCc = DONDH.MaNhaCc
			   inner join PNHAP on PNHAP.SoDh = DONDH.SoDh
			   inner join CTPNHAP on CTPNHAP.SoPn = PNHAP.SoPn
end
exec sp_DanhSachHangNhap 'DD01'
drop proc sp_DanhSachHangNhap 
--cau3:	Hay tao thu tuc luu tru in ra tong tien vat tu xuat theo nam la bao nhieu
alter proc sp_TongTienVatTuXuat(@NgayXuat char(4), @TongTien float output)
as
begin
	 select sum(SlXuat*DgXuat) from CTPXUAT inner join PXUAT on CTPXUAT.SoPx = PXUAT.SoPx where year(NgayXuat) = @NgayXuat
end
declare @kq float
exec sp_TongTienVatTuXuat '2005', @kq out

--cau4: tao thu tuc 1 nhacc neu mancc hoac tenncc da ton tai thi thong bao
create proc sp_ThemNcc(@MaNhaCc char(3),@TenNhaCc nvarchar(100),@DiaChi nvarchar(200),@DienThoai varchar(20))
as
begin	
	if(exists (select * from NHACC where MaNhaCc = @MaNhaCc or TenNhaCc = @TenNhaCc) )
		begin
			print 'Da ton tai mancc nay roi'
			return
		end
	else 
		insert into NHACC values(@MaNhaCc, @TenNhaCc, @DiaChi, @DienThoai)
end
select * from NHACC
exec sp_ThemNcc 'C01', 'thit', 'hanoi', '011'

--cau5: tim kiem vat tu theo don gia ban 
create proc sp_TimKiemVatTu(@TuDG Money, @DenDG Money ) 
as
begin
	select VATTU.MaVTu, TenVTu, SlXuat, DgXuat from VATTU inner join CTPXUAT on VATTU.MaVTu = CTPXUAT.MaVTu
			 where DgXuat >= @TuDG and DgXuat <= @DenDG
end

exec sp_TimKiemVatTu 1000, 40000000

--cau6: tao thu thong ke ban hang theo ten vat tu: 
create proc sp_ThongKeTienBan( @TenVTu nvarchar(100) )
as
begin
	if(not exists (select * from VATTU where TenVTu = @TenVTu) ) 
		begin
			print 'Ten vat tu khong ton tai'
			return
		end
	else
	select VATTU.MaVTu, TenVTu, sum(SlXuat * DgXuat)as 'tienban' from VATTU inner join CTPXUAT on VATTU.MaVTu = CTPXUAT.MaVTu
															   where TenVTu = @TenVTu group by VATTU.MaVTu, TenVTu
end

exec sp_ThongKeTienBan 'dep 01'

--cau7: Xoa 1 vat tu qua tham so truyen vao la mavttu
create proc sp_XoaVattu(@MaVTu char(4) )
as
begin
	if(exists (select * from CTPNHAP where MaVTu = @MaVTu) or exists (select * from CTPXUAT where MaVTu = @MaVTu)
		or not exists (select * from VATTU where MaVTu = @MaVTu) ) 
		begin
			print 'Khong the xoa VATTU nay'
			return
		end 
	delete from VATTU where MaVTu = @MaVTu	
end
exec sp_XoaVattu 'DD01'

----BAI TAP PHAN HAM---
--cau1
create function fn_TongGtNhap( @x datetime, @y datetime )
returns money
as
begin
	declare @kq money

	select @kq =  sum(SlNhap * DgNhap) from PNHAP inner join CTPNHAP on PNHAP.SoPn = CTPNHAP.SoPn
				where NgayNhap >= @x and NgayNhap <= @y
	return @kq
end
select dbo.fn_TongGtNhap ()
--cau2: 
alter function fn_TongTienNhapNcc(@TenNhaCc nvarchar(100))
returns money
as
begin
	declare @TongTienNhapNcc money
	select @TongTienNhapNcc = sum(SlNhap * DgNhap ) 
	from NHACC inner join DONDH on NHACC.MaNhaCc = DONDH.MaNhaCc
			   inner join PNHAP on PNHAP.SoDh = DONDH.SoDh
			   inner join CTPNHAP on CTPNHAP.SoPn = PNHAP.SoPn
	where TenNhaCc = @TenNhaCc
	return @TongTienNhapNcc
end

select dbo.fn_TongTienNhapNcc ('Hong Phuong')

--cau3: In ra thong tin phieu xuat
create function fxChiTietPhieuXuat(@SoPx char(4) )
returns @CTpx table (SoPx char(4),MaVTu char(4),SlXuat int ,DgXuat Money )
as
begin
	insert into @CTpx 
			select * from CTPXUAT where SoPx = @SoPx	

	return
end
select * from fxChiTietPhieuXuat('01')
