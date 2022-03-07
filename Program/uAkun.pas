unit uAkun;

interface
	uses uType, uHash;
	{ PROSEDUR }
	procedure genTab;
	procedure register	(var logininfo : User; var dUser : userArr);
	procedure login	(var logininfo : User; var loginstatus : boolean; dUser : userArr);

implementation
	{ KAMUS }
	var
		gTA, gTB : groupTab; { tabel grup untuk keperluan hashing }

	{ PROSEDUR }
	procedure genTab;
	{ I.S. : tabel gTA dan gTB belum terinisialisasi }
	{ F.S. : tabel gTA dan gTB sudah terisi dengan tabel-tabel hashing }
	begin
		generate(gTA, gTB);
	end;

	procedure register	(var logininfo : User; var dUser : userArr);
	{ I.S. : pengguna program ManajemenPerpus memasukkan perintah }
	{ F.S. : seorang pengguna baru terdaftar ke data user }
	var
		i : integer;
		inPass : string;
	begin
		if logininfo.Role = 'admin' then
		begin
			{ Meminta input dari pengguna }
			i := dUser.Neff;
			extend(dUser);
			write('Masukkan nama pengunjung: ');
			readln(dUser.Tab[i].Nama);
			write('Masukkan alamat pengunjung: ');
			readln(dUser.Tab[i].Alamat);
			write('Masukkan username pengunjung: ');
			readln(dUser.Tab[i].Username);
			write('Masukkan password pengunjung: ');
			readln(inPass);
			dUser.Tab[i].Password := secure(inPass, gTA, gTB);
			dUser.Tab[i].Role := 'pengunjung';
			writeln();
			writeln('Pengunjung ', dUser.Tab[i].Nama, ' berhasil terdaftar sebagai user.');
		end else
		begin
			writeln(errorMsg);
		end;
	end;

	procedure login	(var logininfo : User; var loginstatus : boolean; dUser : userArr);
	{ I.S. : seorang pengguna program ManajemenPerpus memasukkan perintah }
	{ F.S. : info login pada program utama dimasukkan dengan data login yang valid }
	var
		inUser, inPassword, sPass : string;
		found : boolean;
		i : integer;

	begin
		if (loginstatus = false) then
		begin
			{ Meminta input dari pengguna }
			write('Masukkan nama Username: ');
			readln(inUser);
			write('Masukkan password: ');
			readln(inPassword);
			sPass := secure(inPassword, gTA, gTB);
			{Memeriksa kesamaan username dan password}
			found:=false;
			i:=0;
			while (i<dUser.Neff) and (not(found)) do
			begin
				if (dUser.Tab[i].Username=inUser) then
					found:=true
				else
					i:=i+1;
			end;
			writeln();
			if found and (dUser.Tab[i].Password=sPass) then
			begin
				writeln('Selamat datang ',dUser.Tab[i].Nama,'!');
				{ Memasukkan data ke logininfo }
				logininfo.Nama := dUser.Tab[i].Nama;
				logininfo.Alamat := dUser.Tab[i].Alamat;
				logininfo.Username := dUser.Tab[i].Username;
				logininfo.Password := dUser.Tab[i].Password;
				logininfo.Role := dUser.Tab[i].Role;
				loginstatus := true;
			end else
			begin
				writeln('Username / password salah! Silakan coba lagi.');
			end;
		end else
		begin
			writeln(loginErrMsg);
		end;
	end;
end.
