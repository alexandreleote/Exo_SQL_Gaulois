/* Exercice 1 */

SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE '%um'

/* Exercice 2 */

SELECT nom_lieu, COUNT(id_personnage) AS nombre_personnages /* On utilise un alias pour faire le tri décroissant */
FROM personnage
INNER JOIN lieu ON lieu.id_lieu = personnage.id_lieu
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

