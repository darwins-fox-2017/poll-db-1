<!-- Release 1  -->

<!-- 1. Hitung jumlah vote untuk Sen. Olympia Snowe yang memiliki id 524. -->
SELECT COUNT(politician_id)
FROM  votes
WHERE politician_id = 524

<!-- 2. Sekarang lakukan JOIN tanpa menggunakan id `524`. Query kedua tabel votes dan congress_members. -->
SELECT *
FROM votes
JOIN congress_members
ON votes.politician_id  = congress_members.id
WHERE congress_members.name = "Sen. Olympia Snowe"

<!-- 3. Sekarang gimana dengan representative Erik Paulsen? Berapa banyak vote yang dia dapatkan? -->
SELECT COUNT(politician_id)
FROM votes
JOIN congress_members
ON votes.politician_id  = congress_members.id
WHERE congress_members.name = "Rep. Erik Paulsen"


<!-- 4. Buatlah daftar peserta Congress yang mendapatkan vote terbanyak. Jangan sertakan field `created_at` dan `updated_at`. -->
SELECT congress_members.name, congress_members.party, congress_members.location, congress_members.grade_1996, congress_members.grade_current, congress_members.years_in_congress, congress_members.dw1_score,
(SELECT count (politician_id)
FROM votes
WHERE congress_members.id = votes.politician_id) AS vote_count
FROM congress_members
ORDER BY vote_count DESC LIMIT 3


<!-- 5. Sekarang buatlah sebuah daftar semua anggota Congress yang setidaknya mendapatkan beberapa vote dalam urutan dari yang paling sedikit. Dan juga jangan sertakan field-field yang memiliki tipe date. -->
SELECT congress_members.name, congress_members.party, congress_members.location, congress_members.grade_1996, congress_members.grade_current, congress_members.years_in_congress, congress_members.dw1_score,
(SELECT count (politician_id)
FROM votes
WHERE congress_members.id = votes.politician_id) AS vote_count
FROM congress_members
ORDER BY vote_count ASC LIMIT 3

<!-- Release 2  -->

<!-- 1. Siapa anggota Congress yang mendapatkan vote terbanyak? List nama mereka dan jumlah vote-nya. Siapa saja yang memilih politisi tersebut? List nama mereka, dan jenis kelamin mereka. -->
SELECT table_1.total_vote, congress_members.name, ( voters.first_name || " " || voters.last_name ) AS voter_name FROM votes LEFT JOIN ( SELECT count( * ) AS total_vote, votes.politician_id FROM votes GROUP BY votes.politician_id ) AS table_1 ON votes.politician_id = table_1.politician_id JOIN congress_members ON congress_members.id = votes.politician_id JOIN voters ON voters.id = votes.voter_id ORDER BY total_vote, congress_members.name;

<!-- 2. Berapa banyak vote yang diterima anggota Congress yang memiliki grade di bawah 9 (gunakan field `grade_current`)? Ambil nama, lokasi, grade_current dan jumlah vote. -->
 SELECT congress_members.name as "Congress Name", congress_members.location, congress_members.grade_current, COUNT(votes.politician_id) AS "Count Votes" FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.grade_current < 9 GROUP BY votes.politician_id ORDER BY COUNT(votes.politician_id);

<!-- 3. Apa saja 10 negara bagian yang memiliki voters terbanyak? List semua orang yang melakukan vote di negara bagian yang paling populer. (Akan menjadi daftar yang panjang, kamu bisa gunakan hasil dari query pertama untuk menyederhanakan query berikut ini.) -->
SELECT congress_members.name AS "Congress Name", congress_members.location AS "Location Congress", (voters.first_name || ' ' || voters.last_name) AS "Voters Name", voters.gender AS "Voters Gender" FROM voters JOIN votes ON voters.id = votes.voter_id JOIN congress_members ON votes.politician_id = congress_members.id WHERE voters.id = votes.voter_id AND votes.politician_id IN (select votes.politician_id FROM votes GROUP BY votes.politician_id ORDER BY COUNT(votes.politician_id) DESC LIMIT 10) ORDER BY congress_members.id;

<!-- 4. List orang-orang yang vote lebih dari dua kali. Harusnya mereka hanya bisa vote untuk posisi Senator dan satu lagi untuk wakil. Wow, kita dapat si tukang curang! Segera laporkan ke KPK!! -->
SELECT voters.id, (voters.first_name || ' ' || voters.last_name) AS voter_name,
COUNT(votes.id) AS count FROM voters JOIN votes ON votes.voter_id = voters.id
GROUP BY voters.id HAVING count > 2;

<!-- 5. Apakah ada orang yang melakukan vote kepada politisi yang sama dua kali? Siapa namanya dan siapa nama politisinya? -->
SELECT voters.id AS voter_id,
(voters.first_name || ' ' || voters.last_name) AS voter_name,
congress_members.id AS congress_name_id,
congress_members.name AS congress_name,
COUNT(votes.id) AS count FROM voters JOIN votes ON votes.voter_id = voters.id JOIN congress_members ON congress_members.id = votes.politician_id GROUP BY voters.id, congress_members.id HAVING count > 1;
