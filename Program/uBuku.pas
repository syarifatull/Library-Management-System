unit uBuku;

interface
    uses uType;

    procedure cari (logStatus : boolean; dBuku : bukuArr);
    { prosedur utama soal Pencarian buku berdasarkan kategori (F03);
    I.S : ada logStatus (status login) dan dBuku (array data buku);
    F.S : menampilkan data buku yang sesuai dengan kategori input;
    }

    function isvalidkategori (category: string): boolean;
    { fungsi yang menyatakan benar salahnya suatu kategori dalam buku;
    menghasilkan True jika kategori input sesuai dengan kategori buku yang ada }

    procedure caritahunterbit (logStatus : boolean; dBuku : bukuArr);
    {prosedur utama soal Pencarian buku berdasarkan tahun terbit (F04);
    I.S : ada logStatus (status login) dan dBuku (array data buku);
    F.S : menampilkan data buku yang sesuai dengan tahun terbit input dan nilai banding tahun inputnya; }

    function bandingtahun (t1: integer; kat: string; t2: integer): boolean;
    { fungsi yang menyatakan ada tidakadanya data buku sesuai dengan nilai banding tahun inputnya dalam buku;
    menghasilkan True jika ada data yang sesuai dengan input nilai banding buku
    Nilai banding berupa: "<" , ">" , ">=" , "<=" , "=" }

implementation

function isvalidkategori(category: string): boolean;
begin
    if (category='sastra') or (category='sains') or (category='manga') or (category='sejarah') or (category='programming') then begin
        isvalidkategori:=True; { menghasilkan true jika kategori inputnya sesuai dengan kelima kategori diatas }
    end
    else begin
        isvalidkategori:=False; { menghasilkan false untuk kategori input lainnya }
    end;
end;

procedure cari(logStatus : boolean; dBuku : bukuArr);
var
    { mendeklarasikan variabel lokal dalam prosedur cari }
    inKat : string;
    arrlen, i : integer;
    available : boolean;
begin
    { menginisiasi variabel lokal ke data yang ada }
    arrlen := dBuku.Neff; { arrlen bernilai panjangnya data buku }
    available := False; { available menunjukkan ada tidaknya data buku yang sesuai input kategori buku }

    if (logStatus = True) then { jika status login adalah True}
    begin
        { menerima input kategori buku sampai valid }
        repeat
            write('Masukkan kategori: ');
            readln(inKat);
            if (isvalidkategori(inKat)=False) then begin
                writeln('Kategori ',inKat,' tidak valid.')
            end
        until IsValidKategori(inKat);

        writeln('');
        writeln('Hasil pencarian:');

        for i := 0 to (arrlen-1) do { mengiterasi masing-masing data di array dBuku }
        begin
            if (dBuku.Tab[i].Kategori = inKat) then
            begin
                available := True;
                writeln(dBuku.Tab[i].ID_Buku,' | ',dBuku.Tab[i].Judul_Buku,' | ',dBuku.Tab[i].Author);
                { menampikan data jika nilai kategori sesuai}
            end;
        end;

        if (not(available)) then
        begin
            writeln('Tidak ada buku dalam kategori ini.'); { menampilkan pesan bahwa tidak ada data yang sesuai kategori input }
        end;
    end else { logStatus = False }
    begin
        writeln(errorMsg); { menampilkan pesan error jika status login adalah False / sedang tidak login }
    end;
end;


function bandingtahun (t1 : integer; kat : string; t2 : integer) : boolean;
begin
    { mengecek dan mengembalikan nilai boolean yang sesuai dengan input nilai banding }
    case kat of
        '=' : begin
            bandingtahun := (t1 = t2);
        end;
        '<' : begin
            bandingtahun := (t1 < t2);
        end;
        '>' : begin
            bandingtahun := (t1 > t2);
        end;
        '>=' : begin
            bandingtahun := (t1 >= t2);
        end;
        '<=' : begin
            bandingtahun := (t1 <= t2);
        end;
    end;
end;


procedure caritahunterbit (logStatus : boolean; dBuku : bukuArr);
var
    { mendeklarasikan variabel lokal }
    inKat : string;
    inTahun, arrlen, i : integer;
    available : boolean;
begin
    { menginisiasi variabel lokal ke data yang ada }
    arrlen := dBuku.Neff; { arrlen menunjukkan banyaknya data array dBuku }
    available := False; { available menunjukkan ada tidaknya data buku yang sesuai input kategori buku }

    if (logStatus = True) then { jika status login adalah True }
    begin
        write('Masukkan tahun: ');
        readln(inTahun);
        write('Masukkan kategori: ');
        readln(inKat);
        writeln('');
        writeln('Buku yang terbit ',inKat,' ',inTahun,':');

        for i := 0 to (arrlen - 1) do { mengiterasi masing-masing data di array dBuku }
            begin
                if bandingTahun(dBuku.Tab[i].Tahun_Penerbit, inKat, inTahun) then
                begin
                    { jika input nilai banding tahun sesuai ada datanya, available menjadi True dan tampilkan data yang sesuai }
                    available := True;
                    writeln(dBuku.Tab[i].ID_Buku, ' | ', dBuku.Tab[i].Judul_Buku, ' | ', dBuku.Tab[i].Author);
                end;
            end;

        if (not(available)) then
        begin
            writeln('Tidak ada buku dalam kategori ini.'); { menampilkan pesan bahwa tidak ada data yang sesuai kategori input }
        end;
    end else { logStatus = False }
    begin
        writeln(errorMsg); { menampilkan pesan error jika status login adalah False / sedang tidak login }
    end;
end;

end.
