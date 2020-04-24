alter proc sp_themNhanVien(@MaNV nvarchar(4), @MaCV nvarchar(2), @TenNV nvarchar(30), @NgaySinh datetime, @LuongCanBan float,
@NgayCong int, @PhuCap float )
as
begin
	if( exists (select * from tblChucVu where MaCV = @MaCV) )
		begin
			if(@NgayCong <= 30 )
				insert into tblNhanVien values ( @MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap )
			else 
				print('Ngay cong khong hop le')
		end
	else 
		print('Ma cong viec khong hop le');
end

exec sp_themNhanVien 'nv06', 'GD', 'a', '11-11-1999', '10', '31', '1'

select * from tblNhanVien

--THU TUC cap nhat thong tin nhan vien

