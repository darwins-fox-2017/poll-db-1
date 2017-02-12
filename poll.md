<!-- Release 1  -->

<!-- 1. Hitung jumlah vote untuk Sen. Olympia Snowe yang memiliki id 524. -->
<!-- SELECT COUNT(*), (SELECT name FROM congress_members, votes WHERE congress_members.id=votes.politician_id)  as congres_member_name FROM votes WHERE votes.politician_id=524 -->

<!-- 2. Sekarang lakukan JOIN tanpa menggunakan id `524`. Query kedua tabel votes dan congress_members. -->
<!-- SELECT * FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name = 'Sen. Olympia Snowe' -->

<!-- 3. Sekarang gimana dengan representative Erik Paulsen? Berapa banyak vote yang dia dapatkan? -->
<!-- SELECT COUNT(*) FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name like '%Erik Paulsen' -->

<!-- 4. Buatlah daftar peserta Congress yang mendapatkan vote terbanyak. Jangan sertakan field `created_at` dan `updated_at`. -->
<!-- SELECT name, party, location, grade_1996, grade_current, years_in_congress, dw1_score, (SELECT COUNT(politician_id) FROM votes WHERE votes.politician_id = congress_members.id) as number_of_votes FROM congress_members ORDER BY number_of_votes DESC -->

<!-- 5. Sekarang buatlah sebuah daftar semua anggota Congress yang setidaknya mendapatkan beberapa vote dalam urutan dari yang paling sedikit. Dan juga jangan sertakan field-field yang memiliki tipe date. -->
<!-- SELECT name, party, location, grade_1996, grade_current, years_in_congress, dw1_score, (SELECT COUNT(politician_id) FROM votes WHERE votes.politician_id = congress_members.id) as number_of_votes FROM congress_members ORDER BY number_of_votes ASC -->

<!-- Release 2  -->

<!-- 1. Siapa anggota Congress yang mendapatkan vote terbanyak? List nama mereka dan jumlah vote-nya. Siapa saja yang memilih politisi tersebut? List nama mereka, dan jenis kelamin mereka. -->
<!-- SELECT custom1.number_of_vote, congress_members.name, voters.first_name, voters.last_name, voters.gender
FROM votes LEFT JOIN ( SELECT count( * ) AS number_of_vote, votes.politician_id
FROM votes GROUP BY votes.politician_id ) AS custom1 ON votes.politician_id = custom1.politician_id
JOIN congress_members ON congress_members.id = votes.politician_id
JOIN voters ON voters.id = votes.voter_id ORDER BY number_of_vote, congress_members.name; -->

<!-- 2. Berapa banyak vote yang diterima anggota Congress yang memiliki grade di bawah 9 (gunakan field `grade_current`)? Ambil nama, lokasi, grade_current dan jumlah vote. -->
<!-- SELECT politician_id, name, location, grade_current, count(politician_id) as voting_result
FROM congress_members, votes WHERE congress_members.id = votes.politician_id
AND grade_current<9 GROUP BY congress_members.id ORDER BY name ASC -->

<!-- 3. Apa saja 10 negara bagian yang memiliki voters terbanyak? List semua orang yang melakukan vote di negara bagian yang paling populer. (Akan menjadi daftar yang panjang, kamu bisa gunakan hasil dari query pertama untuk menyederhanakan query berikut ini.) -->
<!-- SELECT congress_members.name, congress_members.location, (voters.first_name || ' ' || voters.last_name) as voter,
voters.gender FROM voters JOIN votes ON voters.id = votes.voter_id
JOIN congress_members ON votes.politician_id = congress_members.id
WHERE voters.id = votes.voter_id AND votes.politician_id IN
(SELECT votes.politician_id FROM votes GROUP BY votes.politician_id ORDER BY count(votes.politician_id)
DESC  LIMIT 10)  ORDER BY congress_members.id; -->


<!-- 4. List orang-orang yang vote lebih dari dua kali. Harusnya mereka hanya bisa vote untuk posisi Senator dan satu lagi untuk wakil. Wow, kita dapat si tukang curang! Segera laporkan ke KPK!! -->
<!-- SELECT  first_name, last_name, cheat_voter, custom2.name as congress_name,  location
FROM (SELECT congress_members.name, party, location, cheat_voter, voter_id
FROM (SELECT *, COUNT(voter_id) as cheat_voter FROM votes GROUP BY voter_id  HAVING COUNT (voter_id) >= 2) as custom1, congress_members
WHERE custom1.politician_id = congress_members.id) AS custom2, voters WHERE custom2.voter_id = voters.id ORDER BY cheat_voter DESC -->


<!-- 5. Apakah ada orang yang melakukan vote kepada politisi yang sama dua kali? Siapa namanya dan siapa nama politisinya? -->
<!-- SELECT  first_name, last_name, cheat_voter, custom2.name as congress_name,  location
FROM (SELECT congress_members.name, party, location, cheat_voter, voter_id
FROM (SELECT *, COUNT(voter_id) as cheat_voter FROM votes GROUP BY voter_id  HAVING COUNT (voter_id) >= 2) as custom1, congress_members
WHERE custom1.politician_id = congress_members.id) AS custom2, voters WHERE custom2.voter_id = voters.id ORDER BY cheat_voter DESC -->
