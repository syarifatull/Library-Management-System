unit uStat;

interface

    uses uType;

    procedure statistik (logInfo: User; dUser: userArr; dBuku: bukuArr);
    { prosedur utama soal Statistik (F12);
    I.S : ada logInfo ( record mengenai user yang sedang login ),dUser ( array user ) dan dBuku ( array buku )
    F.S : menampilkan statistik banyaknya data user per role dan buku per kategori }

    procedure cari_anggota (logInfo: User; dUser: userArr);
    { prosedur utama soal Pencarian Anggota (F15);
    I.S : ada logInfo ( record mengenai user yang sedang login ) dan dUser ( array user )
    F.S : menampilkan data anggota berupa nama dan alamat yang sesuai dengan username input }

implementation

procedure statistik (logInfo : User; dUser : userArr; dBuku : bukuArr);
var
    { mendeklarasikan variabel lokal dalam prosedur statistik }
    nAdmin, nPengunjung, nSastra, nSains, nManga, nSejarah, nProgramming, arrlenU, arrlenB, i : integer;
begin
    { menginisasi variabel lokal ke data yang ada }
    arrlenU := dUser.Neff; { arrlenU merepresentasi panjang data user }
    arrlenB := dBuku.Neff; { arrlenB merepresentasi panjang data buku }
    { n berarti banyaknya / jumlah }
    nAdmin := 0; nPengunjung := 0; nSastra := 0; nSains := 0; nManga := 0; nSejarah := 0; nProgramming := 0; { memberi nilai awal 0 }


    if (logInfo.Role = 'admin') then { jika user yang sedang login adalah admin }
    begin
        for i := 0 to (arrlenU - 1) do { mengiterasi data user }
        begin
            if (dUser.Tab[i].Role = 'admin') then
            begin
                nAdmin := nAdmin + 1;   { menambahkan 1 ke nAdmin untuk setiap data user yang memiliki role admin }
            end else { dUser[i].Role := 'pengunjung' }
            begin
                nPengunjung := nPengunjung + 1; { menambahkan 1 ke nPengunjung untuk setiap data user yang memiliki role pengunjung }
            end;
        end;
        for i := 0 to (arrlenB - 1) do { mengiterasi data buku }
        begin
            if (dBuku.Tab[i].Kategori = 'sastra') then
            begin
                nSastra := nSastra + 1; { menambahkan 1 ke nSastra untuk setiap data buku yang memiliki kategori sastra }
            end
            else if (dBuku.Tab[i].Kategori = 'sains') then
            begin
                nSains := nSains + 1; { menambahkan 1 ke nSains untuk setiap data buku yang memiliki kategori sains }
            end
            else if (dBuku.Tab[i].Kategori = 'manga') then
            begin
                nManga := nManga + 1; { menambahkan 1 ke nManga untuk setiap data buku yang memiliki kategori manga }
            end
            else if (dBuku.Tab[i].Kategori = 'sejarah') then
            begin
                nSejarah := nSejarah + 1; { menambahkan 1 ke nSejarah untuk setiap data buku yang memiliki kategori sejarah }
            end
            else if (dBuku.Tab[i].Kategori = 'programming') then
            begin
                nProgramming := nProgramming + 1; { menambahkan 1 ke nProgramming untuk setiap data buku yang memiliki kategori programming }
            end else { data buku memiliki kategori yang bukan kelima diatas }
            begin
                writeln('Ada data buku yang tidak valid');  { meluncurkan pesan bahwa kategori data buku ada yang tidak valid }
            end;
        end;

        { menulis masing-masing data ke layar}
        writeln('Pengguna:');
        writeln('Admin | ', nAdmin);
        writeln('Pengunjung | ', nPengunjung);
        writeln('Total | ', nAdmin + nPengunjung);
        writeln('Buku:');
        writeln('sastra | ', nSastra);
        writeln('sains | ', nSains);
        writeln('manga | ', nManga);
        writeln('sejarah | ', nSejarah);
        writeln('programming | ', nProgramming);
        writeln('Total | ', (nSastra + nSains + nManga + nSejarah + nProgramming));
    end else { logInfo.Role = 'pengguna' }
    begin
        writeln(errorMsg); { menampilkan pesan error jika yang sedang login bukan admin ( user ) }
    end;
end;

procedure cari_anggota (logInfo : User; dUser : userArr);
var
    { mendeklarasikan variabel lokal dalam prosedur statistik }
    inUsername: string;
    arrlen, i: integer;
    found: boolean;
begin
    { menginisasi variabel lokal ke data yang ada }
    arrlen:= dUser.Neff; { arrlen merepresentasi panjang data anggota }
    found:= False; { found menunjukkan ada tidaknya data anggota yang sesuai input username }

    if (logInfo.Role='admin') then { jika anggota yang sedang login adalah admin }
    begin
        write('Masukkan username: ');
        readln(inUsername); { menerima username yang akan dicek }
        i:=0; { menginiasi nilai awal 0 untuk diiterasi }

        while (i < arrlen) and (not(found)) do { mengiterasi dari nilai 0 sampai banyaknya data anggota selama found bernilai False }
        begin
            if (dUser.Tab[i].Username = inUsername) then
            begin
                found:=True;  { mengubah nilai found menjadi True saat ada username yang sama dengan username input }
            end else { username input berbeda dengan data pada baris ke i+1 }
            begin
                i := i + 1; { menambah nilai iteran (i) agar iterasi dapat berlanjut }
            end;
        end;
        if (found = True) then { jika nilai Found sudah True, maka tampilkan data nama dan alamat anggota tersebut }
        begin
            writeln('Nama Anggota: ',dUser.Tab[i].Nama);
            writeln('Alamat anggota: ', dUser.Tab[i].Alamat);
        end else
        begin
            writeln('Anggota tidak ditemukan.'); { menampilkan pesan tidak ditemukannya anggota jika found tetap bernilai False sampai akhir iterasi }
        end;
    end else
    begin
        writeln(errorMsg); { menampilkan error message jika anggota yang sedang login bukan admin ( user )}
    end;
end;

end.
