unit uPinjam;


interface
    uses uType;
    { FUNGSI }
    function isKabisat (y : integer) : boolean;
    function besok (tgl : tanggal) : tanggal;
    function tambahHari (tgl : tanggal; hari : integer) : tanggal;
    function tglValue (t : tanggal) : integer;
    function selisihHari (tA, tB : tanggal) : integer;
    { PROSEDUR }
    procedure pinjam_buku (
                    logInfo : User; var dPeminjaman : peminjamanArr; var dbuku : bukuArr
                   );
    procedure kembalikan_buku (
                    logInfo : User; var dPengembalian : pengembalianArr; var dPeminjaman : peminjamanArr; var dbuku : bukuArr
                   );
    procedure riwayat (
                    logInfo : User;
                    dPeminjaman : peminjamanArr;
                    dbuku : bukuArr
                  );

implementation
    { FUNGSI }
    function isKabisat (y : integer) : boolean;
    { Memeriksa apakah sebuah tahun (dalam integer) merupakan tahun kabisat }
    begin
        isKabisat := (((y mod 4) = 0) and ((y mod 100) <> 0)) or ((y mod 400) = 0);
    end;

    function besok (tgl : tanggal) : tanggal;
    { Mengembalikan nilai tanggal sehari setelah tanggal input pada parameter }
    var
        res : tanggal;
    begin
        res.d := tgl.d + 1;
        res.m := tgl.m;
        res.y := tgl.y;
        if (tgl.d = 31) then
        begin
            res.d := 1;
            res.m := tgl.m + 1;
            if (tgl.m = 12) then
            begin
                res.m := 1;
                res.y := tgl.y + 1;
            end;
        end else if (tgl.d = 30) and ((tgl.m = 4) or (tgl.m = 6) or (tgl.m = 9) or (tgl.m = 11)) then
        begin
            res.d := 1;
            res.m := tgl.m + 1;
        end else if (tgl.d = 29) and (tgl.m = 2) then
        begin
            res.d := 1;
            res.m := tgl.m + 1;
        end else if (tgl.d = 28) and (tgl.m = 2) and (not(isKabisat(tgl.y))) then
        begin
            res.d := 1;
            res.m := tgl.m + 1;
        end;
        besok := res;
    end;

    function tambahHari (tgl : tanggal; hari : integer) : tanggal;
    { Mengembalikan nilai tanggal dengan jumlah hari tertentu setelah tanggal input pada parameter }
    var
        res : tanggal;
        i : integer;
    begin
        res := tgl;
        for i := 1 to hari do
        begin
            res := besok(res);
        end;
        tambahHari := res;
    end;

    function tglValue (t : tanggal) : integer;
    { Mengonversi sebuah tanggal menjadi numerik yang mempresentasikan banyaknya
      hari yang terlewat sejak 30/01/0000 (asumsi tidak ada modifikasi Julian-Gregorian) }
    { CATATAN: Fungsi ini sebenarnya dapat dilakukan dengan menjalankan looping dengan
               function 'besok', namun cara ini lebih matematis dan lebih cepat }
    var
        thn, kab4, kab100, kab400, bln, bln31, tgl : integer;
    begin
        { Menggunakan sistem bulan Maret = 1, April = 2, ...
          Januari = 11, Februari = 12 pada tahun sebelumnya. }
        if (t.m = 1) or (t.m = 2) then
        begin
            t.m := t.m + 10;
            t.y := t.y - 1;
        end else
        begin
            t.m := t.m - 2;
        end;
        { Perhitungan hari-hari yang terlewati sesuai Gregorian Calendar }
        thn := 365 * t.y;
        kab4 := t.y div 4;
        kab100 := t.y div 100;
        kab400 := t.y div 400;
        bln := 30 * t.m;
        bln31 := round(0.6 * (t.m - 1));
        tgl := t.d;
        tglValue := thn + kab4 - kab100 + kab400 + bln + bln31 + tgl;
    end;

    function selisihHari (tA, tB : tanggal) : integer;
    { Menerima masukan dua buah tanggal tA dan tB lalu mengembalikan
      integer yang menyatakan banyak hari yang terlewati dari tA ke tB }
    { CATATAN: Fungsi ini sebenarnya dapat dilakukan dengan menjalankan looping dengan
               function 'besok', namun cara ini lebih matematis dan lebih cepat }
    var
        subs : integer;
    begin
        { Menurunkan nilai tahun pada kedua tanggal dengan tahun yang serupa }
        subs := tA.y mod 400;
        tB.y := tB.y - (tA.y - subs);
        tA.y := subs;
        { Menggunakan fungsi 'tglValue' dan mencari selisihnya }
        selisihHari := tglValue(tB) - tglValue(tA);
    end;

    { FPROSEDUR }

    procedure pinjam_buku (logInfo : User; var dPeminjaman : peminjamanArr; var dbuku : bukuArr);
    { I.S. : pengguna program ManajemenPerpus memasukkan perintah }
    { F.S. : transaksi peminjaman tercatat di data peminjaman,
             jumlah buku di data buku berkurang }
    var
        i, lenPeminjaman : integer;
        fId, fTglPinjam : string;

    begin
        {cek login}
        if logInfo.Role = 'pengunjung' then
        begin
            {Meminta input dari pengguna }
            write('Masukkan id buku yang ingin dipinjam: ');
            readln(fId);
            write('Masukkan tanggal hari ini: ');
            readln(fTglPinjam);
            {cari indeks buku di array buku}
            {cek jumlah buku > 0}
            i := 0;
            while (dbuku.Tab[i].ID_Buku <> fId) do
            begin
                i := i + 1;
            end;
            if (dbuku.Tab[i].Jumlah_buku > 0) then
            begin
                dbuku.Tab[i].Jumlah_buku := dbuku.Tab[i].Jumlah_buku - 1;
                lenPeminjaman := dPeminjaman.Neff;
                extend(dPeminjaman);
                dPeminjaman.Tab[lenPeminjaman].Username := logInfo.Username;
                dPeminjaman.Tab[lenPeminjaman].ID_Buku := fId;
                dPeminjaman.Tab[lenPeminjaman].Tanggal_Peminjaman := strToTgl(fTglPinjam);
                dPeminjaman.Tab[lenPeminjaman].Tanggal_Batas_Pengembalian := tambahHari(strToTgl(fTglPinjam), 7);
                dPeminjaman.Tab[lenPeminjaman].Status_Pengembalian := False;
                writeln('Buku ', dBuku.Tab[i].Judul_Buku, ' berhasil dipinjam!');
                writeln('Tersisa ', dBuku.Tab[i].Jumlah_buku, ' buku ', dBuku.Tab[i].Judul_Buku, '.');
                writeln('Terima kasih sudah meminjam.');
            end else
            begin
                writeln('Buku ', dBuku.Tab[i].Judul_Buku, ' sedang habis!');
                writeln('Coba lain kali.')
            end;
        end else
        begin
            writeln(errorMsg);
        end;
    end;

    procedure kembalikan_buku (logInfo : User; var dPengembalian : pengembalianArr; var dPeminjaman : peminjamanArr; var dbuku : bukuArr);
    { I.S. : pengguna program ManajemenPerpus memasukkan perintah }
    { F.S. : transaksi pengembalian tercatat di data peminjaman dan data pengembalian,
             jumlah buku pada data buku bertambah kembali }
    var
        { Filename masing-masing data }
        fTelat, arrlen, iPinjam, iBuku : integer;
        fHariIni, fId : string;
    begin
        {cek login}
        if logInfo.Role = 'pengunjung' then
        begin
            { Meminta input dari pengguna }
            write('Masukkan id buku yang dikembalikan: ');
            readln(fId);
            writeln('Data peminjaman:');
            writeln('Username: ', logInfo.Username);
            iBuku := 0;
            while (dbuku.Tab[iBuku].ID_Buku <> fId) do
            begin
                iBuku := iBuku + 1;
            end;
            iPinjam := 0;
            while ((dPeminjaman.Tab[iPinjam].ID_Buku <> fId) or (dPeminjaman.Tab[iPinjam].Username <> logInfo.Username)) do
            begin
                iPinjam := iPinjam + 1;
            end;
            writeln('Judul buku: ', dBuku.Tab[iBuku].Judul_Buku);
            writeln('Tanggal peminjaman: ', tglToStr(dPeminjaman.Tab[iPinjam].Tanggal_Peminjaman));
            writeln('Tanggal batas pengembalian: ', tglToStr(dPeminjaman.Tab[iPinjam].Tanggal_Batas_Pengembalian));
            writeln();
            write('Masukkan tanggal hari ini: ');
            readln(fHariIni);
            arrlen:= dPengembalian.Neff;
            extend(dPengembalian);
            dPengembalian.Tab[arrlen].Username := logInfo.Username;
            dPengembalian.Tab[arrlen].Tanggal_Pengembalian := strToTgl(fHariIni);
            dPengembalian.Tab[arrlen].ID_Buku := fId;
            dPeminjaman.Tab[iPinjam].Status_Pengembalian := True;
            dbuku.Tab[iBuku].Jumlah_buku := dbuku.Tab[iBuku].Jumlah_buku + 1;
            fTelat := selisihHari(dPeminjaman.Tab[iPinjam].Tanggal_Batas_Pengembalian, strToTgl(fHariIni));
            if (fTelat <= 0) then
            begin
                writeln('Terima kasih sudah meminjam.');
            end else
            begin
                writeln('Anda terlambat mengembalikan buku.');
                writeln('Anda terkena denda ', 2000*fTelat, '.');
            end;
        end else
        begin
            writeln(errorMsg);
        end;
    end;

    procedure riwayat (logInfo : User; dPeminjaman : peminjamanArr; dbuku : bukuArr);
    { I.S. : pengguna program ManajemenPerpus memasukkan perintah }
    { F.S. : ditampilkan data riwayat pada program utama }
    var
        i, iBuku : integer;
        fUser : string;
        fPeminjam : boolean;
    begin
        {cek login}
        if logInfo.Role = 'admin' then
        begin
            write('Masukkan username pengunjung: ');
            readln(fUser);
            fPeminjam := False;
            writeln('Riwayat:');
            for i := 0 to (dPeminjaman.Neff - 1) do
            begin
                if dPeminjaman.Tab[i].Username = fUser then
                begin
                    fPeminjam := True;
                    iBuku := 0;
                    while (dbuku.Tab[iBuku].ID_Buku <> dPeminjaman.Tab[i].ID_Buku) do
                    begin
                        iBuku := iBuku + 1;
                    end;
                    writeln( tglToStr(dPeminjaman.Tab[i].Tanggal_Peminjaman), ' | ', dPeminjaman.Tab[i].ID_Buku, ' | ', dBuku.Tab[iBuku].Judul_Buku);
                end;
            end;
            if not(fPeminjam) then
                begin
                    writeln('Tidak ada buku yang dipinjam oleh user ini.');
                    end;
        end else
        begin
            writeln(errorMsg);
        end;
    end;

end.
