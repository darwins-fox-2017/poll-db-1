SELECT COUNT(politician_id) FROM votes WHERE politician_id = 524

SELECT * FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name = "Sen. Olympia Snowe"

SELECT COUNT(politician_id) FROM votes JOIN congress_members ON votes.politician_id = congress_members.id WHERE congress_members.name = "Rep. Erik Paulsen"

SELECT congress_members.name, congress_members.party, congress_members.location, congress_members.grade_1996, congress_members.grade_current, congress_members.years_in_congress, congress_members.dw1_score, (SELECT count (politician_id) FROM votes WHERE congress_members.id = votes.politician_id) AS vote_count FROM congress_members ORDER BY vote_count DESC LIMIT 3

SELECT congress_members.name, congress_members.party, congress_members.location, congress_members.grade_1996, congress_members.grade_current, congress_members.years_in_congress, congress_members.dw1_score, (SELECT count (politician_id) FROM votes WHERE congress_members.id = votes.politician_id) AS vote_count FROM congress_members ORDER BY vote_count ASC LIMIT 3
