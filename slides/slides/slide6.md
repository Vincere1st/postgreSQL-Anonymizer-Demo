
## Les fonctions utiles pour le RGPD

| Donnée | Fonction | Nature |
|---|---|---|
| Nom, prénom | `dummy_first_name()`, `dummy_last_name()` | Anonymisation (Faux aléatoire, sans lien avec l'original) |
| Email, tél., IBAN | `partial()`, `partial_email()` | Réduit le risque |
| Même personne = même faux | `seeded_email(login)`, `hash()` | **Pseudonymisation** |
| Salaire, date | `noise(x,0.1)`, `dnoise(d,'2 days')` | Anonymisation (statique) |
| Âge, code postal | `generalize_int4range()`, `generalize_daterange()` | Anonymisation (vues) |
| Clés étrangères | `shuffle_column()`, `pseudo_xor(id)` | Mélange / pseudo |
| Texte libre | `MASKED WITH VALUE 'CONFIDENTIAL'` | Destruction (le plus sûr) |

<!--
Principe : se demander "quelle info dois-je garder pour que la donnée reste utile ?" et ne garder que celle-là.
La destruction est la méthode la plus sûre : si on n'a pas besoin de la donnée, on la supprime.
`dummy_*` sont recommandées (bibliothèque Rust, variantes locales : `dummy_last_name_locale('fr_FR')`). Les `fake_*` sont conservées pour compatibilité.
Piège : `noise()` en masquage dynamique permet de retrouver la vraie valeur en répétant la requête et en faisant un AVG(). Réserver au statique et aux dumps.
Piège : le masquage conditionnel (anon.ternary) peut fuiter (garder les NULL d'une date de décès révèle qui est vivant).
Piège : le partiel (partial) garde des morceaux de la donnée : à évaluer au cas par cas, ce n'est pas toujours anonyme.
-->