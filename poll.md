<!-- Release 1  -->

<!-- 1. Hitung jumlah vote untuk Sen. Olympia Snowe yang memiliki id 524. -->
SELECT COUNT (politician_id) FROM votes WHERE politician_id = 524;

<!-- 2. Sekarang lakukan JOIN tanpa menggunakan id `524`. Query kedua tabel votes dan congress_members. -->
 SELECT * FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name  = 'Sen. Olympia Snowe';

<!-- 3. Sekarang gimana dengan representative Erik Paulsen? Berapa banyak vote yang dia dapatkan? -->
  SELECT COUNT(politician_id) FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name  = 'Rep. Erik Paulsen';

<!-- 4. Buatlah daftar peserta Congress yang mendapatkan vote terbanyak. Jangan sertakan field `created_at` dan `updated_at`. -->
  SELECT name, party, location, grade_1996, grade_current,years_in_congress, dw1_score, COUNT(politician_id) AS numbers_in_vote FROM congress_members, votes WHERE congress_members.id = votes.politician_id GROUP BY congress_members.id ORDER BY numbers_in_vote DESC LIMIT 3;

<!-- 5. Sekarang buatlah sebuah daftar semua anggota Congress yang setidaknya mendapatkan beberapa vote dalam urutan dari yang paling sedikit. Dan juga jangan sertakan field-field yang memiliki tipe date. -->
  SELECT name, party, location, grade_1996, grade_current,years_in_congress, dw1_score, COUNT(politician_id) AS numbers_in_vote FROM congress_members, votes WHERE congress_members.id = votes.politician_id GROUP BY congress_members.id ORDER BY numbers_in_vote ASC LIMIT 3;

<!-- Release 2  -->

<!-- 1. Siapa anggota Congress yang mendapatkan vote terbanyak? List nama mereka dan jumlah vote-nya. Siapa saja yang memilih politisi tersebut? List nama mereka, dan jenis kelamin mereka. -->
  SELECT table_1.total_vote, congress_members.name, ( voters.first_name || " " || voters.last_name ) as voter_name FROM votes LEFT JOIN ( SELECT count( * ) AS total_vote, votes.politician_id FROM votes GROUP BY votes.politician_id ) AS table_1 ON votes.politician_id = table_1.politician_id JOIN congress_members ON congress_members.id = votes.politician_id JOIN voters ON voters.id = votes.voter_id ORDER BY total_vote, congress_members.name;

<!-- 2. Berapa banyak vote yang diterima anggota Congress yang memiliki grade di bawah 9 (gunakan field `grade_current`)? Ambil nama, lokasi, grade_current dan jumlah vote. -->
  select congress_members.name as "Congress Name", congress_members.location, congress_members.grade_current, count(votes.politician_id) as "Count Votes" from votes join congress_members on votes.politician_id = congress_members.id where congress_members.grade_current < 9 group by votes.politician_id order by count(votes.politician_id);

<!-- 3. Apa saja 10 negara bagian yang memiliki voters terbanyak? List semua orang yang melakukan vote di negara bagian yang paling populer. (Akan menjadi daftar yang panjang, kamu bisa gunakan hasil dari query pertama untuk menyederhanakan query berikut ini.) -->
  select congress_members.name as "Congress Name", congress_members.location as "Location Congress", (voters.first_name || ' ' || voters.last_name) as "Voters Name", voters.gender as "Voters Gender" from voters join votes on voters.id = votes.voter_id join congress_members on votes.politician_id = congress_members.id where voters.id = votes.voter_id and votes.politician_id in (select votes.politician_id from votes group by votes.politician_id order by count(votes.politician_id) desc limit 10) order by congress_members.id;

<!-- 4. List orang-orang yang vote lebih dari dua kali. Harusnya mereka hanya bisa vote untuk posisi Senator dan satu lagi untuk wakil. Wow, kita dapat si tukang curang! Segera laporkan ke KPK!! -->
  SELECT voters.id, (voters.first_name || ' ' || voters.last_name) as voter_name, COUNT(votes.id) AS count FROM voters JOIN votes ON votes.voter_id = voters.id GROUP BY voters.id HAVING count > 2;
