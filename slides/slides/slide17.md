## Quelle méthode pour quel besoin ?

| Besoin | Méthode |
|---|---|
| Archiver, base de test jetable | Static Masking |
| Accès interne, données vivantes | Dynamic Masking |
| Export pour un tiers | Anonymous Dump |
| Analytics continu, loin de la prod | Replica Masking |

**Retenir** : une règle = un `SECURITY LABEL` · pseudonymisation ≠ anonymisation · penser *singling out*, *linkability*, inférence.

<!--
Questions. Ressources : https://postgresql-anonymizer.readthedocs.io/en/latest/ (onglets Masking Functions et Tutorials).
-->
