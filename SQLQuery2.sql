create table Nhap(
	soHdn char(4) not null,
	maVT char(4) not null,
	soluongN int not null,
	dongiaN float not null,
	ngayN datetime not null,
	constraint pk_Nhap primary key(soHdn, maVT)
)
create table Xuat (
	soHdx char(4) not null,
	maVT char(4) not null,
	soluongX int not null,
	dongiaX float not null,
	ngayX datetime not null,
	constraint pk_Xuat primary key(soHdx, maVT)
)
create table Ton (
	maVT char(4) not null primary key,
	tenVT nvarchar(25) not null,
	soluongT int not null
)

-- Insert data into the tables
-- table Nhap
 
 insert into Nhap values
 ('hdn1', 'vt01', 11, 2.0, 2/2/2020);
 insert into Nhap values 
 ('hdn2', 'vt02', 12, 3, '1/2/2020'),
 ('hdn3', 'vt03', 12, 3, '1/3/2020');

 -- table Xuat 

 insert into Xuat values 
 ('hdx1', 'vt01', 11, 3, '1/4/2020'),
 ('hdx2', 'vt02', 24, 4, '2/4/2020'),
 ('hdx3', 'vt03', 13, 5, '3/4/2020');

-- table Ton

insert into Ton values 
('vt01', 'dao', 11),
('vt02', 'keo', 12),
('vt03', 'kim', 13),
('vt04', 'xeng', 14),
('vt05', 'quoc', 15);


-- 1. Thong ke tien ban theo ma vat tu gom maVT, tenVT, TienBan (TienBan = soluongX * dongiaX)
