
--1
SELECT *
FROM software_houses
WHERE country = 'United States';

--2
SELECT *
FROM players
WHERE city = 'Rogahnland';

--3
SELECT *
FROM players
WHERE name LIKE '%a'; --% si usa per cercare solo un carattere o parola in una stringa

--4
SELECT *
FROM reviews
WHERE player_id = 800;

--5
SELECT *
FROM tournaments
WHERE year = 2015;

--6
SELECT *
FROM awards
WHERE description LIKE '%facere%';

--7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), 
--mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6

--8
SELECT *
FROM reviews
WHERE rating >= 2 AND rating <= 4;

--9
SELECT *
FROM videogames
WHERE release_date LIKE '2020%';

--10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id --DISTINCT (si usa in select per ritornare solo differenti valori di una colonna)
FROM reviews
WHERE rating = 5
ORDER BY videogame_id


----- GROUP BY

--1
SELECT COUNT(id)
FROM software_houses
GROUP BY country;

--2
SELECT COUNT(videogame_id)
FROM reviews
GROUP BY videogame_id;

--3
SELECT COUNT(videogame_id)
FROM pegi_label_videogame
GROUP BY pegi_label_id;

--4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT COUNT(*)
FROM videogames 
GROUP BY YEAR(release_date)

--5
SELECT COUNT(videogame_id)
FROM device_videogame
GROUP BY device_id;

--6
SELECT AVG(rating)
FROM reviews
GROUP BY videogame_id
ORDER BY videogame_id;

----

--INNER JOIN 

--1
SELECT DISTINCT players.*
FROM reviews
INNER JOIN players --INNER JOIN (mette in relazione due tabelle) ON (mette in relazione due colonne)
ON players.id = reviews.player_id;

--2
SELECT DISTINCT videogame_id 
FROM tournament_videogame
INNER JOIN tournaments
	ON tournaments.id = tournament_videogame.tournament_id
WHERE year = '2016';

--3
SELECT categories.*, videogame_id
FROM categories
INNER JOIN category_videogame
	ON category_videogame.category_id = categories.id;

--4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM videogames
INNER JOIN software_houses
	ON software_houses.id = videogames.software_house_id
WHERE YEAR(videogames.release_date) > 2020; --YEAR() estrae l'anno da una data stringaq1

--5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT awards.name, software_houses.name
FROM awards
INNER JOIN award_videogame
	ON award_videogame.award_id = awards.id
INNER JOIN videogames
	ON videogames.id = award_videogame.videogame_id
INNER JOIN software_houses
	ON software_houses.id = videogames.software_house_id
ORDER BY software_houses.name;

--6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
-- ...
SELECT DISTINCT categories.name, pegi_labels.name, reviews.rating
FROM videogames
INNER JOIN category_videogame
	ON category_videogame.videogame_id = videogames.id
INNER JOIN categories
	ON categories.id = category_videogame.category_id 
INNER JOIN pegi_label_videogame
	ON pegi_label_videogame.videogame_id = videogames.id
INNER JOIN pegi_labels
	ON pegi_labels.id = pegi_label_videogame.pegi_label_id  
INNER JOIN reviews
	ON reviews.videogame_id = videogames.id
WHERE reviews.rating BETWEEN 4 AND 5;

--7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
-- ...
SELECT videogames.name, players.name
FROM players

INNER JOIN player_tournament
	ON player_tournament.player_id = players.id
	
INNER JOIN tournaments
	ON tournaments.id = player_tournament.tournament_id

INNER JOIN tournament_videogame
	ON tournament_videogame.tournament_id = tournaments.id

INNER JOIN videogames
	ON videogames.id = tournament_videogame.videogame_id

WHERE players.name = 'S%';


--8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (63)
SELECT tournaments.city, awards.name, tournaments.year
FROM tournaments

INNER JOIN tournament_videogame
	ON tournament_videogame.tournament_id = tournaments.id
	
INNER JOIN videogames
	ON videogames.id = tournament_videogame.videogame_id

INNER JOIN award_videogame
	ON award_videogame.videogame_id = videogames.id

INNER JOIN awards
	ON awards.id = award_videogame.award_id

WHERE tournaments.year = '2018' AND awards.name LIKE 'Gioco dell%anno';