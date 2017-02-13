<!-- Release 1  -->

<!-- 1. Hitung jumlah vote untuk Sen. Olympia Snowe yang memiliki id 524. -->
```select congress_members.id, congress_members.name ,(select count(*)  from votes t2 where t2.politician_id=congress_members.id) as count from congress_members  where congress_members.id=524
```
<!-- 2. Sekarang lakukan JOIN tanpa menggunakan id `524`. Query kedua tabel votes dan congress_members. -->
<!-- dengan menggunakan subquerys -->
```select  * from  congress_members join votes on congress_members.id = votes.politician_id where congress_members.name='Sen. Olympia Snowe'
```
<!-- menggunakan join -->
```
select congress_members.id,congress_members.name,count(*) as vote from congress_members  left join votes on congress_members.id=votes.politician_id where congress_members.name="Sen. Olympia Snowe"
```
<!-- 3. Sekarang gimana dengan representative Erik Paulsen? Berapa banyak vote yang dia dapatkan? -->
```
select congress_members.id, congress_members.name ,(select count(*)  from votes t2 where t2.politician_id=congress_members.id) as count from congress_members where  congress_members.name like "%Erik%"

```

<!-- 4. Buatlah daftar peserta Congress yang mendapatkan vote terbanyak. Jangan sertakan field `created_at` dan `updated_at`. -->
```
select congress_members.id, congress_members.name ,congress_members.party, congress_members.location,congress_members.grade_1996,congress_members.grade_current,congress_members.years_in_congress ,(select count(*)  from votes t2 where t2.politician_id=congress_members.id) as vote from congress_members order by vote  desc limit 3
```

<!-- 5. Sekarang buatlah sebuah daftar semua anggota Congress yang setidaknya mendapatkan beberapa vote dalam urutan dari yang paling sedikit. Dan juga jangan sertakan field-field yang memiliki tipe date. -->
```select congress_members.id, congress_members.name ,congress_members.party, congress_members.location,congress_members.grade_1996,congress_members.grade_current,congress_members.years_in_congress  ,(select count(*)  from votes t2 where t2.politician_id=congress_members.id) as count from congress_members order by count  asc limit 3
```

<!-- Release 2  -->

<!-- 1. Siapa anggota Congress yang mendapatkan vote terbanyak? List nama mereka dan jumlah vote-nya. Siapa saja yang memilih politisi tersebut? List nama mereka, dan jenis kelamin mereka. -->

Congress dengan vote terbanyak
```
select congress_members.id, congress_members.name ,(select count(*)  from votes t2 where t2.politician_id=congress_members.id) as count from congress_members order by count  desc limit 3
```

list orang yang memilih politisi tersebut
```select * from voters ,(select votes.politician_id as id ,count(votes.politician_id) from votes left join congress_members on votes.politician_id=congress_members.id  group by votes.politician_id) as costum left join votes on voters.id = votes.voter_id where votes.politician_id=costum.id
```

<!-- 2. Berapa banyak vote yang diterima anggota Congress yang memiliki grade di bawah 9 (gunakan field `grade_current`)? Ambil nama, lokasi, grade_current dan jumlah vote. -->
```
select congress_members.name, congress_members.grade_current, congress_members.location, (select count(*)  from votes t2 where t2.politician_id=congress_members.id) as count from  congress_members where grade_current < 9
```
<!-- 3. Apa saja 10 negara bagian yang memiliki voters terbanyak? List semua orang yang melakukan vote di negara bagian yang paling populer. (Akan menjadi daftar yang panjang, kamu bisa gunakan hasil dari query pertama untuk menyederhanakan query berikut ini.) -->
```
select voters.first_name || voters.last_name as name, voters.gender,costum.politisian_id,costum.politisian_name, costum.location , costum.vote from voters,
(select congress_members.id as politisian_id,congress_members.name politisian_name ,congress_members.location as location, count(votes.politician_id) as vote from congress_members left join votes on congress_members.id = votes.politician_id group by votes.politician_id) as costum
left join votes on voters.id =votes.voter_id where votes.politician_id = costum.politisian_id order by costum.vote desc 
```
<!-- 4. List orang-orang yang vote lebih dari dua kali. Harusnya mereka hanya bisa vote untuk posisi Senator dan satu lagi untuk wakil. Wow, kita dapat si tukang curang! Segera laporkan ke KPK!! -->
```
select voters.id,voters.first_name,voters.last_name, tabel.vote from voters, (select  voters.id as id ,voters.first_name ,voters.last_name ,votes.politician_id ,count(*)as vote  from voters join votes on voters.id = votes.voter_id group by voters.id) as tabel where tabel.id=voters.id and vote >1
```

<!-- 5. Apakah ada orang yang melakukan vote kepada politisi yang sama dua kali? Siapa namanya dan siapa nama politisinya? -->
