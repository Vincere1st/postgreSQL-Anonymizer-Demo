## Avant tout : pseudonymiser ≠ anonymiser

| | Pseudonymisation | Anonymisation |
|---|---|---|
| Réversible ? | Oui, avec une info en plus (sel, table) | Non |
| RGPD | **Reste une donnée personnelle** | Sort du champ du RGPD |
| Exemples | hash + sel, `seeded_*` | `noise`, généralisation, destruction |

<!--
Le RGPD (considérant 26) : une donnée pseudonymisée reste une donnée personnelle, car elle peut être re-liée à la personne.
Exemple parlant : un hash de numéro de sécu se retrouve par brute force ou dictionnaire. Le sel doit être protégé comme la donnée.
Test d'une vraie anonymisation (critères du G29) : peut-on encore
1. isoler un individu (singling out) ?
2. relier deux jeux de données sur la même personne (linkability) ?
3. déduire une information sur lui (inférence) ?
Je dirai pour chaque fonction de quel côté elle se situe. Les démos 2 et 4 illustrent ces risques.
-->
