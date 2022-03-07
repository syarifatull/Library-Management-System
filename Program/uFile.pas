unit uFile;


interface
    uses uType;
    { PROSEDUR }
    procedure load (
                    var dBuku : bukuArr;
                    var dUser : userArr;
                    var dPeminjaman : peminjamanArr;
                    var dPengembalian : pengembalianArr;
                    var dKehilangan : kehilanganArr
                   );
    procedure save (
                    dBuku : bukuArr;
                    dUser : userArr;
                    dPeminjaman : peminjamanArr;
                    dPengembalian : pengembalianArr;
                    dKehilangan : kehilanganArr
                   );
    procedure exit (
                    var loop : boolean;
                    dBuku : bukuArr;
                    dUser : userArr;
                    dPeminjaman : peminjamanArr;
                    dPengembalian : pengembalianArr;
                    dKehilangan : kehilanganArr
                   );

implementation
    uses CSVtools;
    { PROSEDUR }
    procedure load ( { Menggunakan array-array data sebagai parameter,
                       pass by reference }
                    var dBuku : bukuArr;
                    var dUser : userArr;
                    var dPeminjaman : peminjamanArr;
                    var dPengembalian : pengembalianArr;
                    var dKehilangan : kehilanganArr
                   );
   { I.S. : database pada program utama kosong }
   { F.S. : database pada program utama terisi dengan data dari file-file CSV }
    var
        { Filename masing-masing data }
        fBuku, fUser, fPeminjaman, fPengembalian, fKehilangan : string;
    begin
        { Meminta input dari pengguna }
        write('Masukkan nama File Buku: ');
        readln(fBuku);
        write('Masukkan nama File User: ');
        readln(fUser);
        write('Masukkan nama File Peminjaman: ');
        readln(fPeminjaman);
        write('Masukkan nama File Pengembalian: ');
        readln(fPengembalian);
        write('Masukkan nama File Kehilangan: ');
        readln(fKehilangan);
        { Memasukkan data ke file CSV masing-masing }
        ctRead(dBuku, fBuku);
        ctRead(dUser, fUser);
        ctRead(dPeminjaman, fPeminjaman);
        ctRead(dPengembalian, fPengembalian);
        ctRead(dKehilangan, fKehilangan);
        writeln();
        writeln('File perpustakaan berhasil dimuat!');
    end;

    procedure save ( { Menggunakan array-array data sebagai parameter,
                       pass by value }
                    dBuku : bukuArr;
                    dUser : userArr;
                    dPeminjaman : peminjamanArr;
                    dPengembalian : pengembalianArr;
                    dKehilangan : kehilanganArr
                   );
   { I.S. : file-file database CSV dengan data lama }
   { F.S. : file-file database CSV telah diisi dengan data baru dari program }
    var
        { Filename masing-masing data }
        fBuku, fUser, fPeminjaman, fPengembalian, fKehilangan : string;
    begin
        { Meminta input dari pengguna }
        write('Masukkan nama File Buku: ');
        readln(fBuku);
        write('Masukkan nama File User: ');
        readln(fUser);
        write('Masukkan nama File Peminjaman: ');
        readln(fPeminjaman);
        write('Masukkan nama File Pengembalian: ');
        readln(fPengembalian);
        write('Masukkan nama File Kehilangan: ');
        readln(fKehilangan);
        { Memasukkan data ke file CSV masing-masing }
        ctWrite(dBuku, fBuku);
        ctWrite(dUser, fUser);
        ctWrite(dPeminjaman, fPeminjaman);
        ctWrite(dPengembalian, fPengembalian);
        ctWrite(dKehilangan, fKehilangan);
        writeln();
        writeln('Data berhasil disimpan!');
    end;

    procedure exit (
                    var loop : boolean; { variabel menuloop yang akan diubah }
                    { Menggunakan array-array data sebagai parameter,
                      pass by value }
                    dBuku : bukuArr;
                    dUser : userArr;
                    dPeminjaman : peminjamanArr;
                    dPengembalian : pengembalianArr;
                    dKehilangan : kehilanganArr
                   );
    var
        opsi : string; { opsi Y/N yang akan dipilih pengguna }
    begin
        write('Apakah anda mau melakukan penyimpanan file yang sudah dilakukan (Y/N) ? ');
        readln(opsi); { membaca pilihan pengguna }
        if opsi = 'Y' then
        begin
            save(dBuku, dUser, dPeminjaman, dPengembalian, dKehilangan);
        end;
        loop := false;
    end;

end.
