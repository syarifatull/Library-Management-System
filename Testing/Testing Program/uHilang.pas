unit uHilang;
{Unit untuk menyimpan fungsi 07 dan 08 yang terkait
dengan buku hilang}

interface
	uses
		uType;
	{FUNGSI DAN PROSEDUR}
	procedure lapor_hilang (login_user : User; var array_hilang : kehilanganArr);
	procedure lihat_laporan(login_user : User; array_hilang : kehilanganArr; array_buku : bukuArr);


implementation
	{FUNGSI DAN PROSEDUR}
	procedure lapor_hilang (login_user : User; var array_hilang : kehilanganArr);
	{ I.S. : pengguna program ManajemenPerpus memasukkan perintah }
    { F.S. : laporan kehilangan tercatat di data kehilangan }
	{KAMUS LOKAL}
	var
		input_judul, input_tanggal : string;
		info_hilang : Kehilangan;
	{ALGORITMA LOKAL}
	begin
		if (login_user.Role = 'pengunjung') then
		begin
			write('Masukkan id buku: ');
			readln(info_hilang.ID_Buku_Hilang);
			write('Masukkan judul buku: ');
			readln(input_judul);
			write('Masukkan tanggal pelaporan: ');
			readln(input_tanggal);
			info_hilang.Tanggal_Laporan := strToTgl(input_tanggal);
			info_hilang.Username := login_user.Username;
			extend(array_hilang);
			array_hilang.Tab[array_hilang.Neff-1] := info_hilang;
			writeln('Laporan berhasil diterima.');
		end else
		begin
			writeln(errorMsg);
		end;
	end;

	procedure lihat_laporan(login_user : User; array_hilang : kehilanganArr; array_buku : bukuArr);
	{ I.S. : pengguna program ManajemenPerpus memasukkan perintah }
    { F.S. : laporan kehilangan ditampilkan di program utama }
	{KAMUS LOKAL}
	var
		i, j : integer;
	{ALGORITMA LOKAL}
	begin
		if (login_user.Role = 'admin') then
		begin
			writeln('Buku yang hilang :');
			for i := 0 to (array_hilang.Neff-1) do
			begin
				j:= 0;
				while (array_hilang.Tab[i].ID_Buku_Hilang <> array_buku.Tab[j].ID_Buku) do
				begin
					j := j + 1;
				end;
				writeln(array_hilang.Tab[i].ID_Buku_Hilang, ' | ', array_buku.Tab[j].Judul_Buku, ' | ', tglToStr(array_hilang.Tab[i].Tanggal_Laporan));
			end;
		end else
		begin
			writeln(errorMsg);
		end;
	end;
end.
