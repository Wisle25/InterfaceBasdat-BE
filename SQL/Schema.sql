USE kependudukan;

CREATE TABLE kota /* Atau Kabupaten */ (
	NoKota VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	NamaKota VARCHAR(30) NOT NULL,
	NamaProvinsi VARCHAR(30) NOT NULL,
	JumlahKeluarga INT DEFAULT 0 NOT NULL,
	JumlahPenduduk INT DEFAULT 0 NOT NULL,
	UMK MONEY DEFAULT 0 NOT NULL
);

CREATE TABLE kelahiran (
	NoKelahiran VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalLahir DATE NOT NULL,
	Usia TINYINT,
	
	-- Relasi 1:1 -- 
	NoKotaLahir /* Tempat Lahir */ VARCHAR(30) NOT NULL,
	CONSTRAINT fk_kelahiran_kota FOREIGN KEY(NoKotalahir) REFERENCES kota(NoKota) ON DELETE CASCADE,
);

CREATE TABLE penduduk (
	NIK VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	
	-- Nama --
	Nama VARCHAR(60) NOT NULL,
	FNama VARCHAR(20),
	MInit VARCHAR(20),
	LNama VARCHAR(20),
	
	JenisKelamin VARCHAR(9) NOT NULL,
	Agama VARCHAR(9) NOT NULL,
	NoTelp VARCHAR(12) NOT NULL,
	LamaTinggal /*Di Indonesia */ TINYINT NOT NULL,
	GolonganDarah VARCHAR(2) NOT NULL,
	Email VARCHAR(30),
	Kewarganegaraan VARCHAR(3) NOT NULL,
	Status VARCHAR(12) NOT NULL,
	
	-- Relasi 1:1 --
	NoKotaMenetap VARCHAR(30) NOT NULL,
	CONSTRAINT fk_penduduk_menetap_kota FOREIGN KEY(NoKotaMenetap) REFERENCES kota(NoKota) ON DELETE CASCADE,
	
	NoKelahiran VARCHAR(30),
	CONSTRAINT fk_penduduk_kelahiran FOREIGN KEY(NoKelahiran) REFERENCES kelahiran(NoKelahiran)
);

CREATE TABLE kematian (
	NoKematian VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalKematian DATE NOT NULL,
	Penyebab TEXT NOT NULL,
	
	-- Relasi 1:1 --
	NIKPenduduk VARCHAR(30) NOT NULL,
	CONSTRAINT fk_kematian_penduduk FOREIGN KEY(NIKPenduduk) REFERENCES penduduk(NIK)
);

CREATE TABLE pekerjaan (
	NoPekerjaan VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	NamaPekerjaan VARCHAR(30) NOT NULL,
	Bidang VARCHAR(20) NOT NULL
);

CREATE TABLE memiliki_pekerjaan (
	NoPekerjaan VARCHAR(30),
	NIKPenduduk VARCHAR(30),
	
	CONSTRAINT fk_memiliki_pekerjaan FOREIGN KEY(NoPekerjaan) REFERENCES pekerjaan(NoPekerjaan),
	CONSTRAINT fk_penduduk_kerjaan FOREIGN KEY(NIKPenduduk) REFERENCES penduduk(NIK),
	
	PRIMARY KEY(NoPekerjaan, NIKPenduduk),
	
	Status VARCHAR(12) NOT NULL,
	Penghasilan MONEY NOT NULL
);

CREATE TABLE pendidikan (
	NoInstitusi VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	NamaInstitusi VARCHAR(30) NOT NULL,
);

CREATE TABLE menjalani_pendidikan (
	NoInstitusi VARCHAR(30) NOT NULL,
	NIKPenduduk /* yang menjalani */ VARCHAR(30) NOT NULL,
	
	CONSTRAINT fk_menjalani_insitusi FOREIGN KEY(NoInstitusi) REFERENCES pendidikan(NoInstitusi) ON DELETE CASCADE,
	CONSTRAINT fk_penduduk_pendidikan FOREIGN KEY(NIKPenduduk) REFERENCES penduduk(NIK),
	
	CONSTRAINT pk_mejalani_pendidikan PRIMARY KEY(NoInstitusi, NIKPenduduk),
	
	Jenjang VARCHAR(30) NOT NULL,
	Biaya MONEY NOT NULL
);

CREATE TABLE ijazah (
	NPSN VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	Tamatan VARCHAR(20) NOT NULL,
	Pengesah VARCHAR(20) NOT NULL,
	TanggalLulus DATE NOT NULL,
	
	-- Relasi N --
	NoInstitusi VARCHAR(30) NOT NULL,
	CONSTRAINT fk_institusi_ijazah FOREIGN KEY(NoInstitusi) REFERENCES pendidikan(NoInstitusi),
	NIKLulusan VARCHAR(30) NOT NULL,
	CONSTRAINT fk_ijazah_penduduk FOREIGN KEY(NIKLulusan) REFERENCES penduduk(NIK),
);
   
CREATE TABLE kepemilikan (
	NPWP VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalKepemilikan DATE NOT NULL,
	
	NIKPemilik VARCHAR(30),
	CONSTRAINT fk_pemilik FOREIGN KEY(NIKPemilik) REFERENCES penduduk(NIK)
);

CREATE TABLE kepemilikan_kendaraan (
	NPWP VARCHAR(30) FOREIGN KEY REFERENCES kepemilikan(NPWP),
	NamaKendaraan VARCHAR(30) NOT NULL,
	VolumeMesin SMALLINT NOT NULL
);

CREATE TABLE kepemilikan_properti (
	NPWP VARCHAR(30) FOREIGN KEY REFERENCES kepemilikan(NPWP),
	LuasArea SMALLINT NOT NULL,
	TempatProperti VARCHAR(30) NOT NULL
);

CREATE TABLE kepindahan (
	NoKepindahan VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalKepindahan DATE NOT NULL,
	JenisKepindahan VARCHAR(20) NOT NULL,
	Alasan TEXT NOT NULL,
	
	-- Relasi N --
	NoKotaTujuan VARCHAR(30),
	CONSTRAINT fk_kepindahan_tujuan FOREIGN KEY(NoKotaTujuan) REFERENCES kota(NoKota),
	
	NIKPelaku VARCHAR(30),
	CONSTRAINT fk_kepindahan_pelaki FOREIGN KEY(NIKPelaku) REFERENCES penduduk(NIK)
);

CREATE TABLE imigrasi (
	NoKepindahan VARCHAR(30) FOREIGN KEY REFERENCES kepindahan(NoKepindahan),
	DariNegara VARCHAR(20) NOT NULL
);

CREATE TABLE urbanisasi (
	NoKepindahan VARCHAR(30) FOREIGN KEY REFERENCES kepindahan(NoKepindahan),
	
	-- Relasi 1:1 --
	NoKotaDari VARCHAR(30),
	CONSTRAINT fk_urbanisasi_dari FOREIGN KEY(NoKotaDari) REFERENCES kota(NoKota)
);

CREATE TABLE emigrasi (
	NoKepindahan VARCHAR(30) FOREIGN KEY REFERENCES kepindahan(NoKepindahan) ,
	KeNegara VARCHAR(64) NOT NULL,
	
	-- Relasi 1:1 --
	NoKotaDari VARCHAR(30),
	CONSTRAINT fk_emigrasi_dari FOREIGN KEY(NoKotaDari) REFERENCES kota(NoKota)
);

CREATE TABLE perceraian (
	NoPerceraian VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalPerceraian DATE NOT NULL,
	
	-- Relasi N --
	NIKPasangan1 VARCHAR(30) NOT NULL,
	NIKPasangan2 VARCHAR(30) NOT NULL,
	
	CONSTRAINT fk_cerai_pasangan1 FOREIGN KEY(NIKPasangan1) REFERENCES penduduk(NIK),
	CONSTRAINT fk_Cerai_pasangan2 FOREIGN KEY(NIKPasangan2) REFERENCES penduduk(NIK)
);

CREATE TABLE pernikahan (
	NoPernikahan VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	TanggalPernikahan DATE NOT NULL,
	
	-- Relasi N --
	NIKPasangan1 VARCHAR(30) NOT NULL,
	NIKPasangan2 VARCHAR(30) NOT NULL,
	CONSTRAINT fk_menikahi FOREIGN KEY(NIKPasangan1) REFERENCES penduduk(NIK),
	CONSTRAINT fk_dinikahi FOREIGN KEY(NIKPasangan2) REFERENCES penduduk(NIK)
);

CREATE TABLE keluarga (
	NoKeluarga VARCHAR(30) DEFAULT NEWID() PRIMARY KEY,
	MeanPenghasilan MONEY DEFAULT 0 NOT NULL,
	
	-- Relasi 1:1 --
	NIKKepala VARCHAR(30) NOT NULL,
	CONSTRAINT fk_kepala_keluarga FOREIGN KEY(NIKKepala) REFERENCES penduduk(NIK),
	NoKota VARCHAR(30) NOT NULL,
	CONSTRAINT fk_keluarga_kota FOREIGN KEY(NoKota) REFERENCES kota(NoKota),
);

CREATE TABLE anggota_keluarga (
	NoKeluarga VARCHAR(30) NOT NULL,
	NIKAnggota VARCHAR(30) NOT NULL,
	
	CONSTRAINT fk_keluarga FOREIGN KEY(NoKeluarga) REFERENCES keluarga(NoKeluarga) ON DELETE CASCADE,
	CONSTRAINT fk_anggota_keluarga FOREIGN KEY(NIKAnggota) REFERENCES penduduk(NIK),
	
	PRIMARY KEY(NoKeluarga, NIKAnggota),
	
	Hubungan VARCHAR(10) NOT NULL
);

CREATE TABLE layanan (
	NoLayanan VARCHAR(30) PRIMARY KEY,
	NamaLayanan VARCHAR(50) NOT NULL,
	TanggalKadaluarsa DATE NOT NULL,
	
	-- Relasi N --
	NIK VARCHAR(30),
	CONSTRAINT fk_mendapatkan_layanan FOREIGN KEY(NIK) REFERENCES penduduk(NIK)
);

-- INSERT --

INSERT INTO kota (NoKota, NamaKota, NamaProvinsi, JumlahKeluarga, JumlahPenduduk, UMK) VALUES
    ('01171', 'Banda Aceh', 'Aceh', 134074, 268148, 3540555),
    ('01173', 'Lhokseumawe', 'Aceh', 101642, 203284, 3413666),
    ('01276', 'Tebing Tinggi', 'Sumatera Utara', 87162, 174323, 2731150),
    ('01271', 'Medan', 'Sumatera Utara', 124756, 2494512, 3624117),
    ('03372', 'Surakarta', 'Jawa Tengah', 287616, 575231, 2269070),
    ('03173', 'Jakarta Barat', 'DKI Jakarta', 1295000, 2590000, 4901798),
    ('03374', 'Semarang', 'Jawa Tengah', 829988, 1659975, 3243969),
    ('03313', 'Karanganyar', 'Jawa Tengah', 435798, 871596, 2288366),
    ('03402', 'Bantul', 'DI Yogyakarta', 473784, 947568, 2216463),
    ('01272', 'Pematangsiantar', 'Sumatera Utara', 126756, 253511, 2710493),
    ('03216', 'Bekasi', 'Jawa Barat', 771356, 1542000, 5343430),
    ('03201', 'Bogor', 'Jawa Barat', 274251, 548501, 5153041),
    ('03371', 'Magelang', 'Jawa Tengah', 323777, 647554, 2316890),
    ('03471', 'Yogyakarta', 'DI Yogyakarta', 92225, 1844500, 2492997),
    ('05103', 'Badung', 'Bali', 153786, 307573, 3163837),
    ('05171', 'Denpasar', 'Bali', 224328, 448656, 2994646),
    ('07171', 'Manado', 'Sulawesi Utara', 108076, 216151, 3530000),
    ('07571', 'Gorontalo', 'Gorontalo', 52705, 105411, 2989350),
    ('06472', 'Samarinda', 'Kalimantan Timur', 208750, 417501, 3497124),
    ('03671', 'Tangerang', 'Banten', 568545, 1137001, 4760289),
    ('03573', 'Malang', 'Jawa Timur', 221861, 443722, 3309144),
    ('03171', 'Jakarta Pusat', 'DKI Jakarta', 232028, 464055, 4901798),
    ('03175', 'Jakarta Timur', 'DKI Jakarta', 734529, 1469001, 4901798),
    ('02101', 'Batam', 'Kepulauan Riau', 299597, 598001, 4685050),
    ('07371', 'Makassar', 'Sulawesi Selatan', 377123, 754001, 3643321),
    ('08171', 'Ambon', 'Maluku', 92247, 184494, 2811111),
    ('03578', 'Surabaya', 'Jawa Timur', 720586, 1440000, 4725479),
    ('03579', 'Batu', 'Jawa Timur', 24375, 48751, 3030367),
    ('03273', 'Cimahi', 'Jawa Barat', 153576, 307152, 3627880),
    ('06371', 'Banjarmasin', 'Kalimantan Selatan', 175218, 350435, 3379513),
    ('03174', 'Jakarta Selatan', 'DKI Jakarta', 566256, 1132500, 4901798),
    ('01671', 'Palembang', 'Sumatera Selatan', 460763, 921526, 3677591),
    ('06471', 'Balikpapan', 'Kalimantan Timur', 213011, 426023, 3201396),
    ('01371', 'Padang', 'Sumatra Barat', 228743, 457486, 2742476),
    ('01674', 'Prabumulih', 'Sumatera Selatan', 43465, 86929, 3404177),
    ('01376', 'Payakumbuh', 'Sumatra Barat', 34209, 68419, 2742476),
    ('09171', 'Jayapura', 'Papua', 78968, 157936, 3864696),
    ('03509', 'Jember', 'Jawa Timur', 455676, 1536729, 2665392),
    ('03302', 'Banyumas', 'Jawa Tengah', 63665, 249618, 2195690),
    ('01801', 'Lampung Selatan', 'Lampung', 492874, 1031115, 2861097);

INSERT INTO penduduk (NIK, Nama, FNama, MInit, LNama, JenisKelamin, Agama, Kewarganegaraan, LamaTinggal, GolonganDarah, Status, Email, NoTelp, NoKotaMenetap, NoKelahiran)
VALUES
('1171040201760003', 'Andi Pratama', 'Andi', NULL, 'Pratama', 'Laki-laki', 'Islam', 'WNI', 47, 'O', 'Aktif', 'andidianpratama456@gmail.com', '6281281951166', '01171', 'LHR1001'),
('1171074607780012', 'Siti Nurul Hidayah', 'Siti', 'Nurul', 'Hidayah', 'Perempuan', 'Islam', 'WNI', 45, 'B', 'Aktif', 'nurulhidayah789@gmail.com', '6285942084885', '01171', 'LHR1002'),
('1173012303950024', 'Budi Santoso Wibowo', 'Budi', 'Santoso', 'Wibowo', 'Laki-laki', 'Islam', 'WNI', 28, 'AB', 'Aktif', 'budisantoso123@gmail.com', '6282133964470', '01173', 'LHR1003'),
('1276011202970004', 'Agung Pambudi', 'Agung', NULL, 'Pambudi', 'Laki-laki', 'Islam', 'WNI', 26, 'O', 'agungpamm@gmail.com', 'Aktif', '6282133965964', '01276', 'LHR1004'),
('1271014808910007', 'Dannia Firstia', 'Dannia', NULL, 'Firstia', 'Perempuan', 'Kristen', 'WNA', 1, 'A', 'danniafirstt@gmail.com', 'Aktif', '6285784356302', '01271', 'NULL'),
('3372040806890001', 'Elvizto Juan Khresnanda', 'Elvizto', 'Juan', 'Khresnanda', 'Laki-laki', 'Kristen', 'WNI', 34, 'O', 'Aktif', 'elvizto.juan.k@gmail.com', '62895363047103', '03372', 'LHR1006'),
('3173075602160006', 'Alyssa Zalfa Primayudhana', 'Alyssa', 'Zalfa', 'Primayudhana', 'Perempuan', 'Kristen', 'WNI', 7, 'O', 'Tidak Aktif', 'zalfaszaa@gmail.com', '6282133051440', '03173', 'LHR1007'),
('3578086402180009', 'Jessica Jasmine', 'Jessica', NULL, 'Jasmine', 'Perempuan', 'Kristen', 'WNI', 5, 'O', 'Aktif', NULL, NULL, '03578', 'LHR1008'),
('3578190607210002', 'Alex Victorious Turner', 'Alex', 'Victorious', 'Turner', 'Laki-laki', 'Kristen', 'WNI', 2, 'AB', 'Aktif', NULL, NULL, '03578', 'LHR1009'),
('3374110904830003', 'Harits Putra Fistiyan', 'Harits', 'Putra', 'Fistiyan', 'Laki-laki', 'Katholik', 'WNI', 40, 'B', 'Tidak Aktif', 'haritsfistiyan123@gmail.com', '6285830122802', '03374', 'LHR1010'),
('3313124904840011', 'Dana Ariska Rahmawati', 'Dana', 'Ariska', 'Rahmawati', 'Perempuan', 'Konghucu', 'WNI', 39, 'O', 'Aktif', 'dana.arkk12@gmail.com', '6285390238090', '03313', 'LHR1011'),
('3402161205020001', 'Danang Aprilia', 'Danang', NULL, 'Aprilia', 'Laki-laki', 'Islam', 'WNI', 21, 'A', 'Aktif', 'nanangg789@gmail.com', '6282234197842', '03402', 'LHR1012'),
('1272012911970004', 'Ervand Aulia Nasution', 'Ervand', 'Aulia', 'Nasution', 'Laki-laki', 'Islam', 'WNI', 26, 'A', 'Aktif', 'ervandacilok09@gmail.com', '6285768157981', '01272', 'LHR1013'),
('3216075311970009', 'Fakhira Amara Raissa', 'Fakhira', 'Amara', 'Raissa', 'Perempuan', 'Islam', 'WNI', 26, 'AB', 'Aktif', 'raissaamm@gmail.com', '6282130002004', '03216', 'LHR1014'),
('3201131205940010', 'Ibrahim Nur Huda', 'Ibrahim', 'Nur', 'Huda', 'Laki-laki', 'Islam', 'WNA', 4, 'O', 'Aktif', 'ban.banozzz@gmail.com', '6282231775773', '03201', 'NULL'),
('3201131205940010', 'Laufey Permata Cantika', 'Laufey', 'Permata', 'Cantika', 'Perempuan', 'Islam', 'WNA', 4, 'B', 'Aktif', 'laufers0921@gmail.com', '6281391623044', 'NULL', 'LHR1016'),
('3201131205940010', 'Rika Amelia Purnama', 'Rika', 'Amelia', 'Purnama', 'Perempuan', 'Islam', 'WNA', 4, 'A', 'Aktif', NULL, NULL, '03201', 'NULL'),
('3201131205940010', 'Upin Iskandar Huda', 'Upin', 'Iskandar', 'Huda', 'Laki-laki', 'Islam', 'WNA', 4, 'O', 'Aktif', NULL, NULL, '03201', 'NULL'),
('3201131205940010', 'Ipin Iskandar Cantika', 'Ipin', 'Iskandar', 'Cantika', 'Perempuan', 'Islam', 'WNA', 4, 'AB', NULL, NULL, '03201', 'NULL'),
('3372032801680007', 'Gabriello Januar Susanteo', 'Gabriello', 'Januar', 'Susanteo', 'Laki-laki', 'Kristen', 'WNI', 55, 'O', 'Aktif', 'gabriello.susanteo@gmail.com', '6285964126859', '03372', 'LHR1020'),
('3371015808710010', 'Farelly Christina Ariela', 'Farelly', 'Christina', 'Ariela', 'Perempuan', 'Kristen', 'WNI', 52, 'A', 'Tidak Aktif', 'arielll.christ123@gmail.com', '6285854900443', '03371', 'LHR1021'),
('3372014503960020', 'Shallom Febe Marissa', 'Shallom', 'Febe', 'Marissa', 'Perempuan', 'Katholik', 'WNI', 27, 'O', 'Aktif', 'shallomfebee@gmail.com', '6289676491499', '03372', 'LHR1022'),
('3471062101990005', 'Xaverius Zidane', 'Xaverius', NULL, 'Zidane', 'Laki-laki', 'Kristen', 'WNI', 24, 'A', 'Aktif', 'zidane.xaverr22@gmail.com', '6285712025548', '03471', 'LHR1023'),
('5103044107830001', 'Erlysa Maharani', 'Erlysa', NULL, 'Maharani', 'Perempuan', 'Hindu', 'WNI', 40, 'AB', 'Aktif', 'erlysa.mhrnii27@gmail.com', '6281392704209', '05103', 'LHR1024'),
('5103042210810038', 'Gardasvara Mistortoify', 'Gardasvara', NULL, 'Mistortoify', 'Laki-laki', 'Hindu', 'WNA', 42, 'B', 'Aktif', 'gardasvara.toifyy@gmail.com', '6289527150778', '05103', 'NULL'),
('5171026303080006', 'Ketut Ayu Puspitasari', 'Ketut', 'Ayu', 'Puspitasari', 'Perempuan', 'Hindu', 'WNI', 15, 'O', 'Aktif', 'ayuupuspitaasr23@gmail.com', '6282133025207', '05171', 'LHR1026'),
('5171020504100002', 'Bagus Made Laksana', 'Bagus', 'Made', 'Laksana', 'Laki-laki', 'Hindu', 'WNI', 13, 'A', 'Aktif', 'baguss.made57@gmail.com', '6281225910228', '05171', 'LHR1027'),
('5171022511130013', 'Putra Yudha Cakrabuana', 'Putra', 'Yudha', 'Cakrabuana', 'Laki-laki', 'Hindu', 'WNI', 10, 'AB', 'Aktif', NULL, NULL, '05171', 'LHR1028'),
('7171021606950003', 'Eka Putra Meravigliosi', 'Eka', 'Putra', 'Meravigliosi', 'Laki-laki', 'Islam', 'WNI', 28, 'A', 'Aktif', 'ekaputrrr712@gmail.com', '6281225146041', '07171', 'LHR1029'),
('7571016708990014', 'Feranisa Kusuma', 'Feranisa', NULL, 'Kusuma', 'Perempuan', 'Islam', 'WNI', 24, 'O', 'Aktif', 'feraaa12321@gmail.com', '6281227772280', '07571', 'LHR1030'),
('7171042108210002', 'Rafael Putra Meravigliosi', 'Rafael', 'Putra', 'Meravigliosi', 'Laki-laki', 'Islam', 'WNI', 2, 'B', 'Aktif', NULL, NULL, '07171', 'LHR1031'),
('3313121909760013', 'Haidar Dzaky Musyaffa', 'Haidar', 'Dzaky', 'Musyaffa', 'Laki-laki', 'Islam', 'WNI', 42, 'A', 'Tidak Aktif', 'dappp.aqsal12@gmail.com', '6281239052437', '03313', 'LHR1032'),
('3273087103790026', 'Nashwa Zahira', 'Nashwa', NULL, 'Zahira', 'Perempuan', 'Islam', 'WNI', 44, 'B', 'Tidak Aktif', 'chelszzz77@gmail.com', '6281240055640', '03273', 'LHR1033'),
('6472031604030001', 'Angkasa Putra Aqshal', 'Angkasa', 'Putra', 'Aqshal', 'Laki-laki', 'Islam', 'WNI', 20, 'O', 'Aktif', 'skyyysall12@gmail.com', '6281259728359', '06472', 'LHR1034'),
('6472035202060004', 'Fiony Alveria', 'Fiony', NULL, 'Alveria', 'Perempuan', 'Islam', 'WNI', 17, 'B', 'Aktif', 'alveriaa.fiony@gmail.com', '6281259932909', '06472', 'LHR1035'),
('6472030309090011', 'Bima Adipati Madya', 'Bima', 'Adipati', 'Madya', 'Laki-laki', 'Islam', 'WNI', 14, 'A', 'Tidak Aktif', 'bimbimzzz99@gmail.com', '6281290607457', '06472', 'LHR1036'),
('3471096404880009', 'Freya Jayawardana', 'Freya', NULL, 'Jayawardana', 'Perempuan', 'Islam', 'WNI', 35, 'AB', 'Aktif', 'freyyzonionnn@gmail.com', '6281296140276', '03471', 'LHR1037'),
('3471090606860036', 'Muhammad Elzandra Martinelli', 'Muhammad', 'Elzandra', 'Martinelli', 'Laki-laki', 'Islam', 'WNA', 7, 'A', 'Tidak Aktif', 'mhmd.elzandrr@gmail.com', '6281311730714', '03471', 'NULL'),
('3671075505120001', 'Marsha Lenanthea Jayawardana', 'Marsha', 'Lenanthea', 'Jayawardana', 'Perempuan', 'Islam', 'WNI', 11, 'A', 'Aktif', NULL, '6281325820037', '03671', 'LHR1039'),
('2172870707870080', 'Prince Marteen Martinelli', 'Prince', 'Marteen', 'Martinelli', 'Laki-laki', 'Islam', 'WNI', 8, 'O', 'Aktif', NULL, NULL, '03671', 'LHR1040'),
('3573052501950002', 'Fathin Achmad Ashari', 'Fathin', 'Achmad', 'Ashari', 'Laki-laki', 'Islam', 'WNI', 28, 'O', 'Tidak Aktif', 'achhh.azharyy@gmail.com', '6285791411789', '03573', 'LHR1041'),
('3171065708970041', 'Azizi Shafaa Asadel', 'Azizi', 'Shafaa', 'Asadel', 'Perempuan', 'Islam', 'WNA', 28, 'A', 'Aktif', 'urell.mineall@gmail.com', '6281398333799', '03171', 'NULL'),
('3175031311210001', 'Ahmed Mirac Zafeer', 'Ahmed', 'Mirac', 'Zafeer', 'Laki-laki', 'Islam', 'WNI', 2, 'A', 'Aktif', NULL, NULL, '03175', 'LHR1043'),
('1271204707730011', 'Eka Sari Wibowo', 'Eka', 'Sari', 'Wibowo', 'Perempuan', 'Kristen', 'WNI', 50, 'B', 'Aktif', 'eka.sari@gmail.com', '6281388086176', '01271', 'LHR1044'),
('3372030808740001', 'Dimas Fajar Prabowo', 'Dimas', 'Fajar', 'Prabowo', 'Laki-laki', 'Kristen', 'WNI', 49, 'O', 'Aktif', 'dimss.fajar13@gmail.com', '6281389919358', '03372', 'LHR1045'),
('3671065909000005', 'Dina Lestari Wijaya', 'Dina', 'Lestari', 'Wijaya', 'Perempuan', 'Kristen', 'WNI', 23, 'AB', 'Aktif', 'dina.lestari@gmail.com', '6281390325825', '03671', 'LHR1046'),
('2172040104030004', 'Surya Pratama Sari', 'Surya', 'Pratama', 'Sari', 'Laki-laki', 'Kristen', 'WNI', 20, 'O', 'Aktif', 'surya.pratama@gmail.com', 6281393841401, '02101', 'LHR1047'),
('7371026204740006', 'Rina Triana Hakim', 'Rina', 'Triana', 'Hakim', 'Perempuan', 'Katholik', 'WNI', 49, 'A', 'Aktif', 'rina.triana@gmail.com', 6281398045316, '07371', 'LHR1048'),
('8171030307710002', 'Abraham Willem Hersubagyo', 'Abraham', 'Willem', 'Hersubagyo', 'Laki-laki', 'Katholik', 'Aktif', 'WNI', 52, 'B', 'abrahamwillem@gmail.com', 6281398330834, '08171', 'LHR1049'),
('3578065011990014', 'Lina Phoibe Drousilla', 'Lina', 'Phoibe', 'Drousilla', 'Perempuan', 'Katholik', 'WNI', 24, 'O', 'Tidak Aktif', 'linaphoibee@gmail.com', 6281410085207, '03578', 'LHR1050'),
('3579011406010023', 'Nathanael Lucas Jeconiah', 'Nathanael', 'Lucas', 'Jeconiah', 'Laki-laki', 'Katholik', 'WNI', 22, 'B', 'Aktif', 'naellucas.jco@gmail.com', 6281904789035, '03579', 'LHR1051'),
('3578066405040001', 'Serafim Jezebel Bellona', 'Serafim', 'Jezebel', 'Bellona', 'Perempuan', 'Katholik', 'WNI', 19, 'AB', 'Aktif', 'serafim.jezbelll@gmail.com', 6281973318655, '03578', 'LHR1052'),
('3273200406950007', 'Luthfi Halimawan', 'Luthfi', NULL, 'Halimawan', 'Laki-laki', 'Islam', 'WNI', 28, 'A', 'Aktif', 'luciferhalimawann@gmail.com', 6282112271424, '03273', 'LHR1053'),
('3277034307960009', 'Dea Aulia Firdaus', 'Dea', 'Aulia', 'Firdaus', 'Perempuan', 'Islam', 'WNI', 27, 'B', 'Aktif', 'deaaulll33@gmail.com', 6282122892315, '03273', 'LHR1054'),
('1276052603930012', 'Brando Franco Windah', 'Brando', 'Franco', 'Windah', 'Laki-laki', 'Kristen', 'WNI', 30, 'O', 'Aktif', 'windah.basudaraa@gmail.com', 6282123552621, '01276', 'LHR1055'),
('6371025808920004', 'Sesilia Agnes Valencia', 'Sesilia', 'Agnes', 'Valencia', 'Perempuan', 'Kristen', 'WNI', 31, 'A', 'Aktif', 'sylvianess12@gmail.com', 6282132200577, '06371', 'LHR1056'),
('3174011309920021', 'Bimo Putra Dwitya', 'Bimo', 'Putra', 'Dwitya', 'Laki-laki', 'Islam', 'WNI', 31, 'O', 'Aktif', 'pickypikcssz@gmail.com', 6282135303454, '03174', 'LHR1057'),
('1671165909890006', 'Irene Agustine', 'Irene', NULL, 'Agustine', 'Perempuan', 'Kristen', 'WNI', 34, 'A', 'Aktif', 'irene.moiree@gmail.com', 6282135739337, '01671', 'LHR1058'),
('3174012302150027', 'Oliver Putra Moire', 'Oliver', 'Putra', 'Moire', 'Laki-laki', 'Islam', 'WNI', 8, 'B', 'Aktif', 'NULL', 'NULL', '03174', 'LHR1059'),
('3174014801180032', 'Valerie Princess Moire', 'Valerie', 'Princess', 'Moire', 'Perempuan', 'Islam', 'WNI', 5, 'AB', 'Aktif', 'NULL', 'NULL', '03174', 'LHR1060'),
('3372010202520050', 'Dwi Wijaya', 'Dwi', NULL, 'Wijaya', 'Laki-laki', 'Islam', 'WNI', 71, 'O', 'Aktif', 'dwi.prasetya@gmail.com', 6282141213233, '03372', 'LHR1061'),
('6471025303630085', 'Ani Utami', 'Ani', 'Utami', NULL, 'Perempuan', 'Kristen', 'WNI', 60, 'A', 'Aktif', 'ani.cahaya@gmail.com', 6282143994772, '06471', 'LHR1062'),
('3372010404800073', 'Rizki Adi Hakim', 'Rizki', 'Adi', 'Hakim', 'Laki-laki', 'Islam', 'WNI', 43, 'AB', 'Aktif', 'rizki.adi@gmail.com', 6282159358738, '03372', 'LHR1063'),
('3372016006850050', 'Mega Fitriani Purnama', 'Mega', 'Fitriani', 'Purnama', 'Perempuan', 'Islam', 'WNI', 38, 'B', 'Aktif', 'mega.permata@gmail.com', 6282235234390, '03372', 'LHR1064'),
('1371081709740061', 'Adi Wibowo', 'Adi', NULL, 'Wibowo', 'Laki-laki', 'Budha', 'WNI', 49, 'O', 'Aktif', 'adi.santoso@gmail.com', 6282320713928, '01371', 'LHR1065'),
('3372054803770056', 'Yuli Winarsih', 'Yuli', NULL, 'Winarsih', 'Perempuan', 'Islam', 'WNI', 46, 'A', 'Aktif', 'yuli.fitriani@gmail.com', 6282323536542, '03372', 'LHR1066'),
('3372051610950045', 'Agung Wijaya', 'Agung', NULL, 'Wijaya', 'Laki-laki', 'Islam', 'WNI', 28, 'O', 'Aktif', 'agung.pratama@gmail.com', 6282324113780, '03372', 'LHR1067'),
('3372056604990060', 'Dewi Setya Ningsih', 'Dewi', 'Setya', 'Ningsih', 'Perempuan', 'Islam', 'WNI', 24, 'B', 'Aktif', 'dewi.sari@gmail.com', 6282325615528, '03372', 'LHR1068'),
('1271153005830087', 'Digno Prasetyo Nugroho', 'Digno', 'Prasetyo', 'Nugroho', 'Laki-laki', 'Islam', 'WNI', 40, 'A', 'Aktif', 'digno.prasetyo@gmail.com', 6285322549332, '01271', 'LHR1069'),
('1674036101840009', 'Maya Sari', 'Maya', NULL, 'Sari', 'Perempuan', 'Islam', 'WNI', 39, 'A', 'Aktif', 'maya.permata@gmail.com', 6285591416989, '01674', 'LHR1070'),
('1376012006020055', 'Rizal Hakim', 'Rizal', NULL, 'Hakim', 'Laki-laki', 'Islam', 'WNI', 21, 'B', 'Tidak Aktif', 'rizal.adi@gmail.com', 6285602386894, '01376', 'LHR1071'),
('1376015001050078', 'Ika Mutiasari', 'Ika', NULL, 'Mutiasari', 'Perempuan', 'Islam', 'WNI', 18, 'A', 'Aktif', 'ika.lestari@gmail.com', 6285640418382, '01376', 'LHR1072'),
('3372031002560020', 'Aji Wibowo Purnama', 'Aji', 'Wibowo', 'Purnama', 'Laki-laki', 'Katholik', 'WNI', 67, 'O', 'Aktif', 'aji.prasetyo@gmail.com', 6285656293937, '03372', 'LHR1073'),
('9171034507790034', 'Christine Sinta', 'Christine', NULL, 'Sinta', 'Perempuan', 'Kristen', 'WNI', 44, 'B', 'Aktif', 'sinta.fitriani@gmail.com', 6285726888157, '09171', 'LHR1074'),
('9171031504860073', 'Donny Xie Liet', 'Donny', 'Xie', 'Liet', 'Laki-laki', 'Konghucu', 'WNA', 37, 'B', 'Aktif', 'bima.santoso@gmail.com', 6285729456659, '09171', 'NULL');

INSERT INTO kepindahan (NoKepindahan, TanggalKepindahan, Alasan, NoKotaTujuan, NIKPelaku, JenisKepindahan) VALUES
    ('AP101', '08-23-1993', 'Kerja', '01276', '1276052603930012', 'URBANISASI'),
    ('AP201', '05-12-1983', 'Kerja', '03402', '3374110904830003', 'URBANISASI'),
    ('AP302', '10-09-1997', 'Kerja', '00001', '1272012911970004', 'URBANISASI'),
    ('AP403', '01-30-1968', 'Kerja', '03471', '3372032801680007', 'URBANISASI'),
    ('AP504', '01-30-1968', 'Kerja', '07171', '3372032801680007', 'URBANISASI'),
    ('IP101', '11-14-2016', 'Kuliah', NULL, '3573052501950002', 'EMIGRASI'),
    ('IP102', '03-21-2017', 'Kerja', NULL, '3313121909760013', 'EMIGRASI'),
    ('IP103', '07-08-2018', 'Kuliah', NULL, '3471090606860036', 'EMIGRASI'),
    ('IP104', '01-12-1979', 'Kerja', NULL, '3273087103790026', 'EMIGRASI'),
    ('KP101', '09-10-1986', 'Bekerja', '09171', '9171031504860073', 'IMIGRASI'),
    ('KP102', '02-28-2019', 'Kerja', '03201', '3201131205940010', 'IMIGRASI'),
    ('KP103', '04-17-2016', 'IkutOrtu', '03201', '3201134512920001', 'IMIGRASI'),
    ('KP104', '04-17-2016', 'IkutOrtu', '03201', '3201135606210010', 'IMIGRASI'),
    ('KP105', '04-17-2016', 'IkutOrtu', '03201', '3201131707230010', 'IMIGRASI'),
    ('KP106', '04-07-2013', 'Kerja', '03171', '3171065708970041', 'IMIGRASI'),
    ('KP107', '04-17-2016', 'IkutOrtu', '03201', '3201131707230010', 'IMIGRASI'),
    ('KP201', '12-08-2022', 'Kerja', '01271', '1271014808910007', 'IMIGRASI'),
    ('KP303', '12-05-2016', 'Kuliah', '00011', '3471090606860036', 'IMIGRASI'),
    ('KP404', '06-15-1981', 'Kuliah', '05103', '5103042210810038', 'IMIGRASI');

INSERT INTO urbanisasi (NoKepindahan, NoKotaDari) VALUES
    ('AP101', '01276'),
    ('AP201', '03402'),
    ('AP302', '00001'),
    ('AP403', '03471'),
    ('AP504', '07171');

INSERT INTO imigrasi (NoKepindahan, DariNegara) VALUES
    ('KP201', 'Belanda'),
    ('KP303', 'Malaysia'),
    ('KP404', 'SriLanka'),
    ('KP101', 'Qatar'),
    ('KP102', 'Malaysia'),
    ('KP103', 'Malaysia'),
    ('KP104', 'Malaysia'),
    ('KP105', 'Malaysia'),
    ('KP106', 'Australia'),
    ('KP107', 'Malaysia');

-- Menambahkan data ke dalam tabel
INSERT INTO emigrasi (NoKotaDari, NoKepindahan, KeNegara) VALUES
    ('03671', 'IP101', 'Palestine'),
    ('03372', 'IP102', 'Amerika'),
    ('02101', 'IP103', 'Singapura'),
    ('05103', 'IP104', 'Amerika');

INSERT INTO kelahiran (NoKelahiran, TanggalLahir, Usia, NoKotaLahir)
VALUES
  ('LHR1001', '1976-02-01', 47, '01171'),
  ('LHR1002', '1978-06-07', 45, '01171'),
  ('LHR1003', '1995-03-23', 28, '01173'),
  ('LHR1004', '1997-02-12', 26, '01276'),
  ('LHR1005', '1991-08-08', 32, '01271'),
  ('LHR1006', '1989-06-08', 34, '03372'),
  ('LHR1007', '2016-02-16', 7, '03173'),
  ('LHR1008', '2018-02-24', 5, '03578'),
  ('LHR1009', '2021-07-06', 2, '03578'),
  ('LHR1010', '1983-04-09', 40, '03374'),
  ('LHR1011', '1984-04-19', 39, '03313'),
  ('LHR1012', '2002-05-12', 21, '03402'),
  ('LHR1013', '1997-11-29', 26, '01272'),
  ('LHR1014', '1997-11-13', 26, '03216'),
  ('LHR1020', '1968-01-28', 55, '03372'),
  ('LHR1021', '1971-08-18', 52, '03371'),
  ('LHR1022', '1996-03-15', 27, '03372'),
  ('LHR1023', '1999-01-21', 24, '03471'),
  ('LHR1024', '1983-07-01', 40, '05103'),
  ('LHR1025', '1981-10-22', 42, '05103'),
  ('LHR1026', '2008-03-23', 15, '05171'),
  ('LHR1027', '2010-05-04', 13, '05171'),
  ('LHR1028', '2013-11-25', 10, '05171'),
  ('LHR1029', '1995-05-30', 28, '07171'),
  ('LHR1030', '1999-08-27', 24, '07571'),
  ('LHR1031', '2021-08-21', 3, '07171'),
  ('LHR1032', '1976-09-19', 47, '03313'),
  ('LHR1033', '1979-04-16', 44, '04353'),
  ('LHR1034', '2003-04-16', 20, '06472'),
  ('LHR1035', '2006-02-12', 17, '06472'),
  ('LHR1036', '2009-09-03', 14, '06472'),
  ('LHR1037', '1988-04-24', 35, '03471'),
  ('LHR1038', '1986-06-06', 37, '03471'),
  ('LHR1039', '2012-05-15', 11, '03671'),
  ('LHR1040', '2015-02-05', 8, '03671'),
  ('LHR1041', '1995-01-25', 28, '03573'),
  ('LHR1042', '1997-08-17', 26, '03171'),
  ('LHR1043', '2021-11-13', 3, '03175'),
  ('LHR1044', '1973-07-07', 50, '01271'),
  ('LHR1045', '1974-08-08', 49, '03372'),
  ('LHR1046', '2000-09-19', 23, '03671'),
  ('LHR1047', '2003-04-01', 20, '02101'),
  ('LHR1048', '1974-04-22', 49, '07371'),
  ('LHR1049', '1971-07-03', 52, '08171'),
  ('LHR1050', '1999-11-10', 24, '03578'),
  ('LHR1051', '2001-06-14', 22, '03579'),
  ('LHR1052', '2004-05-24', 19, '03578'),
  ('LHR1053', '1995-06-04', 28, '04553'),
  ('LHR1054', '1996-07-03', 27, '03273'),
  ('LHR1055', '1993-03-26', 30, '01276'),
  ('LHR1056', '1992-08-18', 31, '06371'),
  ('LHR1057', '1992-09-13', 31, '03174'),
  ('LHR1058', '1989-09-19', 34, '01671'),
  ('LHR1059', '2015-02-23', 8, '03174'),
  ('LHR1060', '2018-01-08', 5, '03174'),
  ('LHR1061', '1952-02-02', 71, '03372'),
  ('LHR1062', '1963-03-13', 60, '06471'),
  ('LHR1063', '1980-04-04', 43, '03372'),
  ('LHR1064', '1985-06-20', 38, '03372'),
  ('LHR1065', '1974-09-17', 49, '01371'),
  ('LHR1066', '1977-03-08', 52, '03372'),
  ('LHR1067', '1995-10-16', 28, '03372'),
  ('LHR1068', '1999-04-26', 24, '03372'),
  ('LHR1069', '1983-05-30', 40, '01271'),
  ('LHR1070', '1984-01-21', 39, '01674'),
  ('LHR1071', '2002-06-20', 21, '01376'),
  ('LHR1072', '2005-01-10', 18, '01376'),
  ('LHR1073', '1956-02-10', 67, '03372'),
  ('LHR1074', '1979-07-05', 44, '09171'),
  ('LHR1075', '1986-04-15', 37, '09171');

INSERT INTO pernikahan (NoPernikahan, NIKPasangan1, NIKPasangan2, TanggalPernikahan)
VALUES
  ('101/05/V/2022', '1171040201760000', '1171074607780010', '2022-05-21'),
  ('032/32/I/2018', '1271014808910000', '3372040806890000', '2018-01-12'),
  ('154/14/IX/2010', '3313124904840010', '3374110904830000', '2010-09-11'),
  ('003/02/II/2023', '3216075311970000', '1272012911970000', '2023-04-16'),
  ('033/11/IV/2019', '3201134512920000', '3201131205940010', '2019-08-21'),
  ('115/13/V/2004', '3372032801680000', '3371015808710010', '2004-05-21'),
  ('090/22/VI/2017', '5103042210810030', '5103044107830000', '2017-06-14'),
  ('077/02/IV/2015', '7171021606950000', '7571016708990010', '2015-04-18'),
  ('088/13/II/2022', '3313121909760010', '3273087103790020', '2022-02-03'),
  ('123/09/VIII/2017', '3471090606860030', '3471096404880000', '2017-08-19'),
  ('167/12/XII/2020', '3573052501950000', '3171065708970040', '2020-12-27'),
  ('050/03/II/2014', '3372030808740000', '1271204707730010', '2014-02-29'),
  ('111/16/VII/2011', '8171030307710000', '7371026204740000', '2011-07-24'),
  ('091/11/IV/2017', '3273200406950000', '3277034307960000', '2017-11-21'),
  ('064/10/III/2015', '3174011309920020', '1671165909890000', '2015-03-15'),
  ('221/29/XII/2019', '3372010202520050', '6471025303630080', '2019-12-28'),
  ('133/15/IX/2018', '1371081709740060', '3372054803770050', '2018-09-13'),
  ('108/08/XI/2013', '1271153005830080', '3371015808710010', '2013-11-10'),
  ('111/19/XII/2016', '9171031504860070', '9171034507790030', '2016-12-14');

INSERT INTO perceraian (NoPerceraian, TanggalPerceraian, NIKPasangan1, NIKPasangan2)
VALUES
  ('028/04/VII/2014', '2014-06-12', '3313124904840010', '3374110904830000'),
  ('011/12/IV/2018', '2018-07-19', '8171030307710000', '7371026204740000'),
  ('035/02/III/1995', '1995-05-30', '3372031002560020', NULL);


--
INSERT INTO pendidikan (NoInstitusi, NamaInstitusi)
VALUES
  ('11711024', 'SD Negeri 24 Banda Aceh'),
  ('31724001', 'STIP Jakarta'),
  ('13744011', 'ISI Padang Panjang'),
  ('33744006', 'Universitas Diponegoro'),
  ('33744001', 'Akademi Kepolisian'),
  ('35781094', 'SD Gloria 3 Surabaya'),
  ('35784003', 'Institut Teknologi Sepuluh Nopember'),
  ('51024012', 'Bali Culinary Pastry School'),
  ('35784001', 'Universitas Airlangga'),
  ('35734007', 'Universitas Brawijaya'),
  ('31724437', 'Institut Kesenian Jakarta'),
  ('31724237', 'Institut Kesenian Surakarta'),
  ('31724137', 'Institut Kesenian Yogyakarta'),
  ('31724031', 'Telkom University'),
  ('32734022', 'Institut Teknologi Bandung'),
  ('32734032', 'Institut Teknologi Bandung'),
  ('32734016', 'Binus University'),
  ('51714003', 'Universitas Udayana'),
  ('35734009', 'Universitas Negeri Malang'),
  ('51712005', 'SMP Negeri 5 Denpasar'),
  ('51711018', 'SD Saraswati 4 Denpasar'),
  ('32764001', 'Universitas Indonesia'),
  ('33724006', 'Universitas Sebelas Maret'),
  ('33084001', 'Akademi Militer'),
  ('33713015', 'SMA Taruna Nusantara'),
  ('64722002', 'SMP Negeri 2 Samarinda'),
  ('34044001', 'Universitas Gadjah Mada'),
  ('36711135', 'SD IT Insan Kamil Tangerang'),
  ('36734004', 'Universitas Pendidikan Indonesia'),
  ('12714001', 'Universitas Sumatera Utara'),
  ('73713047', 'SMK 6 Makassar'),
  ('81714007', 'Universitas Pattimura'),
  ('35094011', 'Universitas Jember'),
  ('32114001', 'Universitas Padjajaran'),
  ('31743363', 'SMKS Yaspia'),
  ('35784038', 'The Sages Institute'),
  ('31743074', 'SMAN 38 Jakarta'),
  ('31743284', 'SMA Labschool Kebayoran'),
  ('34044023', 'Universitas Islam Indonesia'),
  ('32014019', 'Sekolah Tinggi Intelijen Negara'),
  ('13711052', 'SD Pertiwi 2 Padang'),
  ('33722009', 'SMP Negeri 5 Surakarta'),
  ('33723008', 'SMA Negeri 8 Surakarta'),
  ('18014004', 'Institut Teknologi Sumatera'),
  ('36744031', 'PKN STAN'),
  ('11714001', 'Universitas Andalas'),
  ('32714005', 'Institut Pertanian Bogor'),
  ('32164007', 'Sekolah Tinggi Transportasi Darat');

INSERT INTO menjalani_pendidikan (NIKPenduduk, NoInstitusi, Jenjang, Biaya)
VALUES
  ('1276011202970004', '35784001', 'S2-Magister', 'Rp 4.501.000,-'),
  ('3173075602160006', '35781094', 'SD/MTs', 'Rp 3.895.300,-'),
  ('3402161205020001', '32734002', 'S1-Sarjana', 'Rp 7.750.000,-'),
  ('5171026303080006', '33713015', 'SMP/SLTP', 'Rp 1.729.000,-'),
  ('5171020504100002', '64722002', 'SMP/SLTP', 'Rp 1.729.000,-'),
  ('5171022511130013', '34044001', 'SD/MTs', 'Rp 2.327.000,-'),
  ('6472031604030001', '34044023', 'S1-Sarjana', 'Rp 9.250.000,-'),
  ('6472035202060004', '36734004', 'SMA/SLTA', 'Rp 5.326.000,-'),
  ('6472030309090011', '35784001', 'SMP/SLTP', 'Rp 2.692.000,-'),
  ('3671075505120001', '73713047', 'SD/MTs', 'Rp 3.925.000,-'),
  ('3671070502150008', '81714007', 'SD/MTs', 'Rp 3.865.000,-'),
  ('2172040104030004', '35784038', 'S1-Sarjana', 'Rp 8.235.000,-'),
  ('7371026204740006', '31743074', 'SMA/SLTA', '3925000'),
  ('8171030307710002', '31743284', 'SMA/SLTA', '4394000'),
  ('3579011406010023', '11714001', 'S1-Sarjana', 'Rp 3.201.900,-'),
  ('3578066405040001', '34044001', 'S1-Sarjana', 'Rp 7.502.125,-'),
  ('3372056604990060', '33724006', 'S1-Sarjana', 'Rp 725.000,-'),
  ('1376012006020055', '81714007', 'S1-Sarjana', 'Rp 10.525.900,-'),
  ('1376015001050078', '81714007', 'S1-Sarjana', 'Rp 7.552.250,-');

INSERT INTO kematian (NoKematian, TanggalKematian, Penyebab, NIKPenduduk)
VALUES
  ('KMT1001', '2020-08-01', 'Kecelakaan Tol', '3173075602160006'),
  ('KMT1002', '2004-11-12', 'HIV', '3374110904830003'),
  ('KMT1003', '2000-06-15', 'Kanker', '3371015808710010'),
  ('KMT1004', '2018-05-21', 'Pendarahan', '6472030309090011'),
  ('KMT1005', '2019-07-06', 'Tumor', '3578065011990014'),
  ('KMT1006', '2021-09-14', 'Rabies', '1376012006020055');

INSERT INTO ijazah (NPSN, Pengesah, Tamatan, TanggalLulus, NoInstitusi, NIKLulusan)
VALUES
  ('87456321', 'Dr. Rina Agustina, M.Psi.', 'SD/MTs', '14-06-1989', '11711024', '1171040201760003'),
  ('90785643', 'Prof. Ida Kartini, S.T., M.M.', 'S1-Sarjana', '23-02-2018', '31724001', '1173012303950024'),
  ('21567890', 'Dr. Dewi Susanti, S.Sn., M.Des.', 'S2-Magister', '07-09-2018', '33744006', '1271014808910007'),
  ('76012345', 'Prof. Agus Setiawan, S.H., M.Si.', 'S1-Sarjana', '17-07-2011', '33744001', '3372040806890001'),
  ('77889966', 'Prof. Slamet Riyadi, dr., Sp.PD.', 'S1-Sarjana', '29-07-2008', '51714003', '5103044107830001'),
  ('88990077', 'Dr. Dewi Susilawati, S.Pd., M.Pd.', 'S1-Sarjana', '02-11-2005', '35734009', '5103042210810038'),
  ('33334455', 'Dr. Sari Indah, S.Sn., M.Des.', 'S1-Sarjana', '18-06-2018', '32764001', '7171021606950003'),
  ('44445566', 'Prof. Joko Raharjo, S.H., M.H.', 'S1-Sarjana', '21-03-2022', '33724006', '7571016708990014'),
  ('66667788', 'Dr. Eko Prabowo, S.Kom., M.Eng.', 'S2-Magister', '12-08-2007', '33084001', '3313121909760013'),
  ('77778899', 'Prof. Eko Prasetyo, S.Si., M.Sc.', 'S1-Profesi', '27-05-2008', '33024002', '3273087103790026'),
  ('20002233', 'Dr. Ani Widayanti, S.E., M.H.', 'S1- Sarjana', '26-07-2009', '34044001', '3471096404880009'),
  ('30003344', 'Prof. Slamet Santoso, S.Ked., M.T.', 'S3-Doktor', '23-01-2019', '32734002', '3471090606860036'),
  ('60006677', 'Prof. Eka Rahayu, S.T., M.Si.', 'S1-Sarjana', '22-02-2016', '35734007', '3573052501950002'),
  ('90009900', 'Dr. Nia Santoso, S.H., M.H.', 'S2-Magister', '09-04-2006', '36734004', '1271204707730011'),
  ('10000011', 'Prof. Joko Widi, S.Sn., M.Des.', 'S1-Profesi', '02-12-1998', '35784001', '3372030808740001'),
  ('20000022', 'Dr. Bambang Santoso, S.Kom., M.M.', 'S1-Sarjana', '19-08-2022', '12714001', '3671065909000005'),
  ('40000044', 'Dr. Dedi Setiawan, S.Sn., M.M.', 'SMK', '24-05-1993', '73713047', '7371026204740006'),
    ('50000055', 'Dr. Siti Rahayu, S.Si., M.Sc.', 'S1-Sarjana', '01-11-1994', '81714007', '8171030307710002'),
  ('60000066', 'Dr. Agus Widi, S.Kom., M.Eng.', 'S1-Sarjana', '10-09-2021', '35784003', '3578065011990014'),
  ('90000099', 'Prof. Andi Santoso, S.H., M.H.', 'S1-Sarjana', '21-10-2021', '32114001', '3273200406950007'),
  ('10111213', 'Dr. Rina Widi, S.Pd., M.Si.', 'S1-Sarjana', '17-03-2019', '32114001', '3277034307960009'),
  ('20212223', 'Prof. Slamet Santoso, S.Pd., M.Pd.', 'SMK', '23-12-2012', '31743363', '1276052603930012'),
  ('30313233', 'Dr. Nia Santoso, S.Cul., Ph.D.', 'D3-Diploma', '18-07-2014', '35784038', '6371025808920004'),
  ('40414243', 'Prof. Dedi Santoso, S.Pd., M.Pd.', 'SMA/SLTA', '12-06-2010', '31743074', '3174011309920021'),
  ('50515253', 'Dr. Budi Santoso, S.Sos., M.Si.', 'SMA/SLTA', '30-05-2008', '31743284', '1671165909890006'),
  ('80818293', 'Dr. Slamet Santoso, S.T., M.Cul.', 'S3-Doktor', '04-05-1994', '34044001', '3372010202520050'),
  ('90919303', 'Prof. Arif Setiawan, S.Pd., M.Pd.', 'S1-Sarjana', '28-03-1989', '34044023', '6471025303630085'),
  ('10001011', 'Dr. Rina Widi, S.T., M.Arch.', 'S1-Sarjana', '14-11-2004', '32014019', '3372010404800073'),
  ('20002022', 'Prof. Slamet Santoso, S.P., M.Si.', 'S2-Magister', '01-06-2020', '34044001', '3372016006850050'),
  ('30003033', 'Dr. Nia Santoso, S.Pd., M.Arch.', 'SD/MTs', '19-06-1987', '13711052', '1371081709740061'),
  ('40004044', 'Prof. Joko Widi, S.Sn., M.Des.', 'SMP/SLTP', '27-05-1987', '33722009', '3372054803770056'),
  ('50005055', 'Dr. Bambang Santoso, S.Sn., M.M.', 'SMA/SLTA', '30-04-2014', '33723008', '3372051610950045'),
  ('70007077', 'Dr. Siti Rahayu, S.T., M.Eng.', 'S2-Magister', '06-10-2016', '18014004', '1271153005830087'),
  ('80008088', 'Prof. Slamet Santoso, S.Psi., Ph.D.', 'D4-Sarjana Terapan', '20-07-2008', '36744031', '1674036101840009'),
  ('20222000', 'Prof. Eka Rahayu, S.T., M.Si.', 'D4-Sarjana Terapan', '03-07-1982', '32164007', '3372031002560020'),
  ('30333000', 'Dr. Siti Rahayu, S.Sn., Ph.D.', 'S1-Sarjana', '21-02-2003', '31724037', '9171034507790034');


INSERT INTO layanan (NoLayanan, NamaLayanan, TanggalKadaluarsa, NIK)
VALUES
('LAY1001', 'BPJS', '2021-04-12', '1171040201760003'),
('LAY1002', 'KIS (Kartu Indonesia Sehat)', '2022-07-25', '1171074607780012'),
('LAY1003', 'BST (Bantuan Sosial Tunai)', '2021-05-02', '1271014808910007'),
('LAY1004', 'BOS (Bantuan Operasional Sekolah)', '2020-08-19', '3372040806890001'),
('LAY1005', 'Program Keluarga Berencana', '2023-03-05', '3374110904830003'),
('LAY1006', 'BLBI (Bantuan Likuiditas Bank Indonesia)', '2021-09-11', '3313124904840011'),
('LAY1007', 'Kartu Kuning', '2022-07-07', '1272012911970004'),
('LAY1008', 'Kartu Indonesia Pintar', '2020-12-18', '3216075311970009'),
('LAY1009', 'BPNT (Bantuan Pangan Non Tunai)', '2021-04-29', '3201131205940010'),
('LAY1010', 'KIP (Kartu Indonesia Pintar)', '2020-08-10', '3201131205940010'),
('LAY1011', 'Bantuan Langsung Non Tunai', '2022-03-27', '3372032801680007'),
('LAY1012', 'Kartu Prakerja', '2023-09-09', '3371015808710010'),
('LAY1013', 'Bantuan Likuiditas Bank Indonesia', '2022-09-15', '5103044107830001'),
('LAY1014', 'Kartu Jakarta Pintar', '2023-03-25', '5103042210810038'),
('LAY1015', 'Kartu Indonesia Pintar', '2022-12-19', '5171020504100002'),
('LAY1016', 'Program Keluarga Harapan', '2022-02-24', '7571016708990014'),
('LAY1017', 'Bantuan Sosial Tunai', '2020-11-20', '3313121909760013'),
('LAY1018', 'Bantuan Langsung Non Tunai', '2021-05-01', '3273087103790026'),
('LAY1019', 'Bantuan Likuiditas Bank Indonesia', '2022-12-17', '3471096404880009'),
('LAY1020', 'Kartu Jakarta Pintar', '2021-04-28', '3471090606860036'),
('LAY1021', 'Kartu Indonesia Pintar', '2020-12-21', '3671070502150008'),
('LAY1022', 'Bantuan Pangan Non Tunai', '2023-06-02', '3573052501950002'),
('LAY1023', 'Kartu Indonesia Pintar', '2021-11-15', '3171065708970041'),
('LAY1024', 'Bantuan Langsung Iuran', '2022-07-10', '1271204707730011'),
('LAY1025', 'Bantuan Sosial Tunai', '2020-11-22', '3372030808740001'),
('LAY1026', 'KUR (Kredit Usaha Rakyat)', '2023-02-28', '7371026204740006'),
('LAY1027', 'Program Keluarga Berencana', '2020-08-10', '8171030307710002'),
('LAY1028', 'Kartu Indonesia Pintar', '2021-05-02', '3579011406010023'),
('LAY1029', 'Bantuan Pangan Non Tunai', '2021-08-07', '3277034307960009'),
('LAY1030', 'Program Keluarga Harapan', '2021-04-30', '6371025808920004'),
('LAY1031', 'Bantuan Langsung Iuran', '2022-08-11', '3174011309920021'),
('LAY1032', 'Bantuan Sosial Tunai', '2023-02-24', '1671165909890006'),
('LAY1033', 'KUR (Kredit Usaha Rakyat)', '2022-05-29', '3372010202520050'),
('LAY1034', 'Program Keluarga Berencana', '2023-09-12', '6471025303630085'),
('LAY1035', 'Bantuan Likuiditas Bank Indonesia', '2020-01-23', '3372010404800073'),
('LAY1036', 'Kartu Indonesia Pintar', '2021-05-05', '3372016006850050'),
('LAY1037', 'Bantuan Pangan Non Tunai', '2021-08-09', '3372051610950045'),
('LAY1038', 'Kartu Indonesia Pintar', '2022-12-21', '3372056604990060'),
('LAY1039', 'Program Keluarga Harapan', '2023-06-02', '1271153005830087'),
('LAY1040', 'Bantuan Langsung Iuran', '2021-11-15', '1674036101840009'),
('LAY1041', 'Kartu Prakerja', '2023-02-22', '3372031002560020'),
('LAY1042', 'KUR (Kredit Usaha Rakyat)', '2021-07-03', '9171034507790034'),
('LAY1043', 'Program Keluarga Berencana', '2022-11-16', '9171031504860073');

INSERT INTO anggota_keluarga (NoKeluarga, NIKAnggota, Hubungan) VALUES
    ('1276013003950317', '1171040201760003', 'Ayah'),
    ('1276013003950317', '1171074607780012', 'Ibu'),
    ('1276013003950317', '1173012303950024', 'Anak 1'),
    ('1276013003950317', '1276011202970004', 'Anak 2'),
    ('3578080303180128', '1271014808910007', 'Ibu'),
    ('3578080303180128', '3372040806890001', 'Ayah'),
    ('3578080303180128', '3173075602160006', 'Anak 1'),
    ('3578080303180128', '3578086402180009', 'Anak 2'),
    ('3578080303180128', '3578190607210002', 'Anak 3'),
    ('3402161905010096', '3374110904830003', 'Ayah'),
    ('3402161905010096', '3313124904840011', 'Ibu'),
    ('3402161905010096', '3402161205020001', 'Anak 1'),
    ('3216072008220276', '1272012911970004', 'Ayah'),
    ('3216072008220276', '3216075311970009', 'Ibu'),
    ('3201130411230752', '3201131205940010', 'Ayah'),
    ('3201130411230752', '3201131205940010', 'Ibu'),
    ('3201130411230752', '3201131205940010', 'Anak 1'),
    ('3201130411230752', '3201131205940010', 'Anak 2'),
    ('3201130411230752', '3201131205940010', 'Anak 3'),
    ('3372012203960043', '3372032801680007', 'Ayah'),
    ('3372012203960043', '3371015808710010', 'Ibu'),
    ('3372012203960043', '3372014503960020', 'Anak 1'),
    ('3372012203960043', '3471062101990005', 'Anak 2'),
    ('5171022508070162', '5103044107830001', 'Ibu'),
    ('5171022508070162', '5103042210810038', 'Ayah'),
    ('5171022508070162', '5171026303080006', 'Anak 1'),
    ('5171022508070162', '5171020504100002', 'Anak 2'),
    ('5171022508070162', '5171022511130013', 'Anak 3'),
    ('7171042908210297', '7171021606950003', 'Ayah'),
    ('7171042908210297', '7571016708990014', 'Ibu'),
    ('7171042908210297', '7171042108210002', 'Anak 1'),
    ('6472032301030007', '3313121909760013', 'Ayah'),
    ('6472032301030007', '3273087103790026', 'Ibu'),
    ('6472032301030007', '6472031604030001', 'Anak 1'),
    ('6472032301030007', '6472035202060004', 'Anak 2'),
    ('6472032301030007', '6472030309090011', 'Anak 3'),
    ('3671072205120103', '3471096404880009', 'Ibu'),
    ('3671072205120103', '3471090606860036', 'Ayah'),
    ('3671072205120103', '3671075505120001', 'Anak 1'),
    ('3671072205120103', '3671070502150008', 'Anak 2'),
    ('3175030212210026', '3573052501950002', 'Ayah'),
    ('3175030212210026', '3171065708970041', 'Ibu'),
    ('3175030212210026', '3175031311210001', 'Anak 1'),
    ('2172041405030138', '1271204707730011', 'Ibu'),
    ('2172041405030138', '3372030808740001', 'Ayah'),
    ('2172041405030138', '3671065909000005', 'Anak 1'),
    ('2172041405030138', '2172040104030004', 'Anak 2'),
    ('3578062611990271', '7371026204740006', 'Ibu'),
    ('3578062611990271', '8171030307710002', 'Ayah'),
    ('3578062611990271', '3578065011990014', 'Anak 1'),
    ('3578062611990271', '3579011406010023', 'Anak 2'),
    ('3578062611990271', '3578066405040001', 'Anak 3'),
    ('3273202109210362', '3273200406950007', 'Ayah'),
    ('3273202109210362', '3277034307960009', 'Ibu'),
    ('3174021305220772', '1276052603930012', 'Ayah'),
    ('3174021305220772', '6371025808920004', 'Ibu'),
    ('3174010403150381', '3174011309920021', 'Ayah'),
    ('3174010403150381', '1671165909890006', 'Ibu'),
    ('3174010403150381', '3174012302150027', 'Anak 1'),
    ('3174010403150381', '3174014801180032', 'Anak 2'),
    ('3372011604800042', '3372010202520050', 'Ayah'),
    ('3372011604800042', '6471025303630085', 'Ibu'),
    ('3372011604800042', '3372010404800073', 'Anak 1'),
    ('3372011604800042', '3372016006850050', 'Anak 2'),
    ('3372052910950621', '1371081709740061', 'Ayah'),
    ('3372052910950621', '3372054803770056', 'Ibu'),
    ('3372052910950621', '3372051610950045', 'Anak 1'),
    ('3372052910950621', '3372056604990060', 'Anak 2'),
    ('1376010607020095', '1271153005830087', 'Ayah'),
    ('1376010607020095', '1674036101840009', 'Ibu'),
    ('1376010607020095', '1376012006020055', 'Anak 1'),
    ('1376010607020095', '1376015001050078', 'Anak 2'),
    ('3372031907230026', '3372031002560020', 'Ayah'),
    ('9171031309230091', '9171034507790034', 'Ibu'),
    ('9171031309230091', '9171031504860073', 'Ayah');

INSERT INTO keluarga (NoKeluarga, MeanPenghasilan, NIKKepala, NoKota) VALUES
    ('1276013003950317', 5000000, '1171040201760003', '01276'),
    ('3578080303180128', 2400000, '3372040806890001', '03578'),
    ('3402161905010096', 7000000, '3374110904830003', '03402'),
    ('3216072008220276', 6000000, '1272012911970004', '03216'),
    ('3201130411230752', 3500000, '3201131205940010', '03201'),
    ('3372012203960043', 9000000, '3372032801680007', '03372'),
    ('5171022508070162', 8000000, '5103042210810038', '05171'),
    ('7171042908210297', 3000000, '7171021606950003', '07171'),
    ('6472032301030007', 4500000, '3313121909760013', '06472'),
    ('3671072205120103', 6500000, '3471090606860036', '03671'),
    ('3175030212210026', 5200000, '3573052501950002', '03175'),
    ('2172041405030138', 4800000, '3372030808740001', '02172'),
    ('3578062611990271', 7500000, '8171030307710002', '03578'),
    ('3578062611990271', 7500000, '8171030307710002', '03578'),
    ('3578062611990271', 7500000, '8171030307710002', '03578'),
    ('3273202109210362', 6300000, '3277034307960009', '03273'),
    ('3174021305220772', 3800000, '1276052603930012', '03174'),
    ('3174010403150381', 9200000, '3174011309920021', '03174'),
    ('3372011604800042', 4700000, '3372010202520050', '03372'),
    ('3372052910950621', 6800000, '1371081709740061', '03372'),
    ('1376010607020095', 4800000, '1271153005830087', '01376'),
    ('3372031907230026', 8000000, '3372031002560020', '03372'),
    ('9171031309230091', 8500000, '9171031504860073', '09171');

INSERT INTO pekerjaan (NoPekerjaan, NamaPekerjaan, Bidang) VALUES
    ('149', 'Nelayan', 'Kelautan'),
    ('152', 'Petani Garam', 'Kelautan'),
    ('151', 'Nahkoda', 'Kelautan'),
    ('73', 'Fotografer', 'Seni'),
    ('10', 'Insinyur Kimia', 'Teknik'),
    ('82', 'Polisi', 'Keamanan'),
    ('1', 'Pelajar', '-'),
    ('78', 'Pembalap', 'Olahraga'),
    ('89', 'Executive Chef', 'Hospitality'),
    ('20', 'Dokter Gigi', 'Kesehatan'),
    ('34', 'Auditor', 'Perbankan'),
    ('122', 'DevOps Engineer', 'IT'),
    ('139', 'Account Officer', 'Bisnis'),
    ('115', 'Digital Marketer', 'IT'),
    ('53', 'Penulis', 'Seni'),
    ('6', 'Asisten Sipil', 'Teknik'),
    ('36', 'Akuntan', 'Ekonomi'),
    ('150', 'Penyelam', 'Kelautan'),
    ('3', 'Ibu Rumah Tangga', '-'),
    ('72', 'Animator', 'Seni'),
    ('83', 'Tentara', 'Keamanan'),
    ('20', 'Dokter Spesialis', 'Kesehatan'),
    ('2', 'Mahasiswa', '-'),
    ('57', 'Aktris', 'Seni'),
    ('7', 'Manajer Metalurgi', 'Teknik'),
    ('41', 'Konsultan Pajak', 'Ekonomi'),
    ('113', 'Notaris', 'Hukum'),
    ('44', 'Guru', 'Pendidikan'),
    ('23', 'Ahli Gizi', 'Kesehatan'),
    ('174', 'Pegawai Swasta', 'Ketenagakerjaan'),
    ('124', 'Peternak', 'Peternakan'),
    ('86', 'Head Chef', 'Hospitality'),
    ('88', 'Under Chef', 'Hospitality'),
    ('167', 'Youtuber', 'Profesi Modern'),
    ('168', 'Selebgram', 'Profesi Modern'),
    ('45', 'Dosen', 'Pendidikan'),
    ('136', 'Wirausaha', 'Bisnis'),
    ('81', 'Intelijen', 'Keamanan'),
    ('54', 'Jurnalis', 'Seni'),
    ('126', 'Petani', 'Pertanian'),
    ('105', 'Kondektur', 'Transportasi'),
    ('123', 'AI Engineer', 'IT'),
    ('37', 'Analisis Keuangan', 'Perbankan'),
    ('106', 'Masinis', 'Transportasi'),
    ('52', 'Penari', 'Seni'),
    ('76', 'Atlet Profesional', 'Olahraga');

INSERT INTO kepemilikan (NPWP, TanggalKepemilikan, NIKPemilik) VALUES
    ('54.666.757.9-312.195-001', '04-07-2005', '1171040201760003'),
    ('54.666.757.9-312.196-006', '12-02-2018', '1171074607780012'),
    ('54.666.757.9-312.199-000', '02-03-2008', '1271014808910007'),
    ('54.666.757.9-312.200-007', '21-08-2016', '3372040806890001'),
    ('54.666.757.9-312.204-005', '09-05-2017', '3374110904830003'),
    ('54.666.757.9-312.263-004', '22-10-2006', '3313124904840011'),
    ('54.666.757.9-312.265-003', '10-09-2009', '1272012911970004'),
    ('54.666.757.9-312.266-008', '18-12-2015', '3216075311970009'),
    ('54.666.757.9-312.267-002', '04-07-2005', '3201131205940010'),
    ('54.666.757.9-312.268-007', '12-02-2018', '3201131205940010'),
    ('54.666.757.9-312.210-001', '21-08-2016', '3372032801680007'),
    ('54.666.757.9-312.211-006', '07-12-2012', '3371015808710010'),
    ('54.666.757.9-312.214-009', '09-05-2017', '5103044107830001'),
    ('54.666.757.9-312.215-003', '22-10-2006', '5103042210810038'),
    ('54.666.757.9-312.219-001', '04-07-2005', '7171021606950003'),
    ('54.666.757.9-312.220-006', '12-02-2018', '7571016708990014'),
    ('54.666.757.9-312.222-005', '18-09-2014', '3313121909760013'),
    ('54.666.757.9-312.223-009', '02-03-2008', '3273087103790026'),
    ('54.666.757.9-312.227-007', '28-01-2011', '3471096404880009'),
    ('54.666.757.9-312.228-001', '09-05-2017', '3471090606860036'),
    ('54.666.757.9-312.231-005', '10-09-2009', '3573052501950002'),
    ('54.666.757.9-312.232-009', '18-12-2015', '3171065708970041'),
    ('54.666.757.9-312.234-008', '12-02-2018', '1271204707730011'),
    ('54.666.757.9-312.235-002', '29-11-2010', '3372030808740001'),
    ('54.666.757.9-312.238-006', '21-08-2016', '7371026204740006'),
    ('54.666.757.9-312.239-000', '07-12-2012', '8171030307710002'),
    ('54.666.757.9-312.240-005', '15-06-2019', '3273200406950007'),
    ('54.666.757.9-312.243-008', '22-10-2006', '3277034307960009'),
    ('54.666.757.9-312.244-002', '02-04-2013', '1276052603930012'),
    ('54.666.757.9-312.245-007', '10-09-2009', '6371025808920004'),
    ('54.666.757.9-312.246-001', '18-12-2015', '3174011309920021'),
    ('54.666.757.9-312.247-006', '04-07-2005', '1671165909890006'),
    ('54.666.757.9-312.248-000', '12-02-2018', '3372010202520050'),
    ('54.666.757.9-312.249-005', '02-03-2008', '6471025303630085'),
    ('54.666.757.9-312.249-006', '21-08-2016', '1371081709740061'),
    ('54.666.757.9-312.255-001', '28-01-2011', '3372054803770056'),
    ('54.666.757.9-312.256-006', '09-05-2017', '1271153005830087'),
    ('54.666.757.9-312.259-009', '10-09-2009', '1674036101840009'),
    ('54.666.757.9-312.260-003', '18-12-2015', '3372031002560020'),
    ('54.666.757.9-312.263-007', '20-10-2000', '9171034507790034'),
    ('54.666.757.9-312.264-001', '30-01-1998', '9171031504860073');


INSERT INTO kepemilikan_properti (NPWP, TempatProperti, LuasArea)
VALUES
  ('54.666.757.9-312.196-006', 'Surabaya', 150),
  ('54.666.757.9-312.200-007', 'Yogyakarta', 130),
  ('54.666.757.9-312.204-005', 'Palembang', 110),
  ('54.666.757.9-312.266-008', 'Surabaya', 130),
  ('54.666.757.9-312.268-007', 'Medan', 120),
  ('54.666.757.9-312.211-006', 'Makassar', 80),
  ('54.666.757.9-312.215-003', 'Jakarta', 130),
  ('54.666.757.9-312.220-006', 'Yogyakarta', 110),
  ('54.666.757.9-312.222-005', 'Denpasar', 80),
  ('54.666.757.9-312.231-005', 'Semarang', 140),
  ('54.666.757.9-312.234-008', 'Denpasar', 130),
  ('54.666.757.9-312.238-006', 'Banjarmasin', 160),
  ('54.666.757.9-312.243-008', 'Semarang', 140),
  ('54.666.757.9-312.246-001', 'Denpasar', 130),
  ('54.666.757.9-312.248-000', 'Palembang', 140),
  ('54.666.757.9-312.256-006', 'Yogyakarta', 200),
  ('54.666.757.9-314.264-001', 'Padang', 170);

INSERT INTO kepemilikan_kendaraan (NPWP, JenisKendaraan, KapasitasMesin)
VALUES
  ('54.666.757.9-312.195-001', 'Honda Beat', 110),
  ('54.666.757.9-312.199-000', 'Honda CRV', 1498),
  ('54.666.757.9-312.263-004', 'Honda Jazz', 1498),
  ('54.666.757.9-312.265-003', 'Toyota Rush', 1496),
  ('54.666.757.9-312.267-002', 'Honda Accord', 1498),
  ('54.666.757.9-312.210-001', 'Suzuki Jimny', 1498),
  ('54.666.757.9-312.214-009', 'Suzuki Swift', 1498),
  ('54.666.757.9-312.219-001', 'Honda Brio', 1128),
  ('54.666.757.9-312.223-009', 'Toyota Hilux', 2393),
  ('54.666.757.9-312.227-007', 'Toyota Sienna', 3456),
  ('54.666.757.9-312.228-001', 'Suzuki Baleno', 1373),
  ('54.666.757.9-312.232-009', 'Suzuki Grand Vitara', 2393),
  ('54.666.757.9-312.235-002', 'Toyota Soluna', 1298),
  ('54.666.757.9-312.239-000', 'Suzuki Alto', 998),
  ('54.666.757.9-312.244-002', 'Honda Shadow', 150),
  ('54.666.757.9-312.245-007', 'Yamaha Jupiter MX', 150),
  ('54.666.757.9-312.247-006', 'Toyota Alphard', 3500),
  ('54.666.757.9-312.249-005', 'Honda Vario', 125),
  ('54.666.757.9-312.249-006', 'Toyota Agya', 1298),
  ('54.666.757.9-312.255-001', 'Yamaha Jupiter MX', 150),
  ('54.666.757.9-312.259-009', 'Honda Forza', 350),
  ('54.666.757.9-312.260-003', 'Yamaha R25', 250),
  ('54.666.757.9-312.263-007', 'Yamaha Lexi', 150),
  ('54.666.757.9-312.264-001', 'Toyota Soluna', 1496);