
## Les méthodes de masquage

| Méthode | Usage | Démo |
|---|---|---|
| Static Masking | Remplace les données **définitivement** | ✅ |
| Dynamic Masking | Masque à la volée selon le rôle | ✅ |
| Anonymous Dumps | `pg_dump` avec données masquées | ✅ |
| Replica Masking | Réplica toujours anonymisé | ✅ |
| Masking Views | Vues dédiées | |
| Masking Data Wrappers | Masque des sources externes | |

<!--
Les mêmes règles servent à toutes les méthodes.
Views et Data Wrappers : je les cite, je ne les détaille pas aujourd'hui.
Extras : fonctions de détection des colonnes sensibles (anon.detect), voir la doc "Detecting Identifiers".
-->
