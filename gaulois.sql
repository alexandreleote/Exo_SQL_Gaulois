/* Exercice 1 */

SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

/* Exercice 2 */

SELECT nom_lieu, COUNT(id_personnage) AS nombre_personnages /* On utilise un alias pour faire le tri décroissant */
FROM personnage
RIGHT JOIN lieu ON lieu.id_lieu = personnage.id_lieu /* RIGHT JOIN pour récupérer l'ensemble des lieux même ceux qui n'ont pas d'habitants */
GROUP BY lieu.nom_lieu
ORDER BY nombre_personnages DESC;

/* Exercice 3 */

SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage
INNER JOIN lieu ON lieu.id_lieu = personnage.id_lieu
INNER JOIN specialite ON specialite.id_specialite = personnage.id_specialite
ORDER BY lieu.id_lieu, personnage.nom_personnage

/* Exercice 4 */

SELECT nom_specialite, COUNT(personnage.id_specialite) AS nombre_personnages
FROM specialite
INNER JOIN personnage ON personnage.id_specialite = specialite.id_specialite
GROUP BY specialite.id_specialite /* On GROUP BY sur l'id car plus sûr */
ORDER BY nombre_personnages DESC;

/* Exercice 5 */

SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d %m %Y"), nom_lieu 
FROM bataille
INNER JOIN lieu ON lieu.id_lieu = bataille.id_lieu
ORDER BY date_bataille DESC;

/* Exercice 6 */

SELECT nom_potion, SUM(composer.qte * ingredient.cout_ingredient) AS prix_realisation
FROM composer
INNER JOIN potion ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON ingredient.id_ingredient = composer.id_ingredient
GROUP BY potion.id_potion
ORDER BY prix_realisation DESC;

/* Exercice 7 */

SELECT  nom_ingredient, cout_ingredient, composer.qte
FROM ingredient
INNER JOIN composer ON composer.id_ingredient = ingredient.id_ingredient
INNER JOIN potion ON potion.id_potion = composer.id_potion
WHERE potion.nom_potion = 'Santé'

/* Exercice 8 */

SELECT nom_personnage, SUM(prendre_casque.qte) AS total_casques
FROM personnage
INNER JOIN prendre_casque ON prendre_casque.id_personnage = personnage.id_personnage
INNER JOIN bataille ON bataille.id_bataille = prendre_casque.id_bataille
WHERE bataille.nom_bataille = 'Bataille du village gaulois'
GROUP BY personnage.id_personnage
HAVING total_casques >= ALL (
	SELECT SUM(prendre_casque.qte)
	FROM prendre_casque
	INNER JOIN bataille ON bataille.id_bataille = prendre_casque.id_bataille
	WHERE bataille.nom_bataille = 'Bataille du village gaulois'
	GROUP BY prendre_casque.id_personnage
)	

/* Exercice 9 */

SELECT nom_personnage, SUM(boire.dose_boire) AS litres
FROM personnage
INNER JOIN boire ON boire.id_personnage = personnage.id_personnage
GROUP BY personnage.id_personnage
ORDER BY litres DESC;

/* Exercice 10 */

SELECT nom_bataille, SUM(prendre_casque.qte) AS total_casques
FROM bataille
INNER JOIN prendre_casque ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY bataille.id_bataille
HAVING total_casques >= ALL (
	SELECT SUM(prendre_casque.qte)
	FROM bataille
	INNER JOIN prendre_casque ON prendre_casque.id_bataille = bataille.id_bataille
	GROUP BY bataille.id_bataille
)

/* Exercice 11 */

SELECT nom_type_casque, COUNT(casque.id_type_casque) AS nb_casques, SUM(casque.cout_casque) AS cout
FROM casque
INNER JOIN type_casque ON type_casque.id_type_casque = casque.id_type_casque
GROUP BY type_casque.id_type_casque
ORDER BY nb_casques DESC, cout;

/* Exercice 12 */

SELECT nom_potion
FROM potion
INNER JOIN composer ON composer.id_potion = potion.id_potion
INNER JOIN ingredient ON ingredient.id_ingredient = composer.id_ingredient
WHERE ingredient.nom_ingredient ='Poisson frais'
GROUP BY potion.id_potion

/* Exercice 13 */

SELECT nom_lieu, COUNT(p.id_lieu) AS habitants
FROM lieu l
INNER JOIN personnage p ON p.id_lieu = l.id_lieu
WHERE nom_lieu != 'Village gaulois'
GROUP BY l.id_lieu
HAVING habitants >= ALL (
	SELECT COUNT(p.id_lieu)
	FROM personnage p
	INNER JOIN lieu l ON l.id_lieu = p.id_lieu
	WHERE nom_lieu != 'Village gaulois'
	GROUP BY p.id_lieu
)

/* Exercice 14 */

SELECT nom_personnage
FROM personnage
WHERE id_personnage NOT IN (
	SELECT id_personnage
	FROM boire
)

/* Exercice 15 */

SELECT nom_personnage
FROM personnage
WHERE id_personnage NOT IN (
	SELECT id_personnage
	FROM autoriser_boire
	INNER JOIN potion ON potion.id_potion = autoriser_boire.id_potion
	WHERE potion.nom_potion = 'Magique'
)

/* Requêtes SQL */

/* A */

INSERT INTO personnage (nom_personnage, adresse_personnage, id_lieu, id_specialite)  
VALUES ('Champbdeblix', 'à la ferme Hantassion', 6, 12)

/* B */

INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES (1, 12)

/* C */

DELETE FROM casque -- On définit la table dans laquelle on supprime un élément
WHERE casque.id_casque IN ( -- On cible l'id de l'élément en question se trouvant DANS
	SELECT casque.id_casque
	FROM casque
	LEFT JOIN prendre_casque ON prendre_casque.id_casque = id_casque -- Pour prendre en compte l'ensemble des casques n'ayant pas été pris et d'origine 'Grec'
	WHERE casque.id_type_casque = (
		SELECT id_type_casque
		FROM type_casque
		WHERE nom_type_casque = 'Grec'
	) -- Fin de la sous-requête permettant de cibler l'élément voulu uniquement
	AND prendre_casque.id_casque IS NULL
)

	/* Corrigé simplifié */
DELETE FROM casque
WHERE id_type_casque = ( -- On cible le type de casque ici Grec
	SELECT id_type_casque
	FROM type_casque
	WHERE nom_type_casque = 'Grec'
)
AND id_casque NOT IN (
	SELECT prendre_casque.id_casque
	FROM prendre_casque
)

/* D */

UPDATE personnage
SET personnage.id_lieu = 9, personnage.adresse_personnage = 'En prison'
WHERE personnage.nom_personnage = 'Zérozérosix'

/* E */

DELETE FROM composer -- On définit la table dans laquelle on retire une donnée (ligne ou colonne)
WHERE id_potion = 9 -- On cherche l'id de la potion 'Soupe' ici 9
AND id_ingredient = 19 -- On cible la ligne comportant l'id de l'ingrédient 'Persil' ici 19

	/* Corrigé plus développé */
DELETE FROM composer
WHERE id_potion = (
	SELECT id_potion
	FROM potion
	WHERE nom_potion = 'Soupe'
)
AND id_ingredient = (
	SELECT id_ingredient
	FROM ingredient
	WHERE nom_ingredient = 'Persil'
)

/* F */

UPDATE prendre_casque
SET id_casque = (
	SELECT casque.id_casque
	FROM casque
	WHERE casque.nom_casque = 'Weisenau'
), qte = 42
WHERE id_personnage = (
	SELECT personnage.id_personnage
	FROM personnage 
	WHERE personnage.nom_personnage = 'Obélix'
)
AND id_bataille = (
	SELECT bataille.id_bataille
	FROM bataille
	WHERE bataille.nom_bataille = 'Attaque de la banque postale'
)