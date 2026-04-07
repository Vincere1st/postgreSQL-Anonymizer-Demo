<img src="../images/PostgreSQL-Anonymizer_H_couleur.png" alt="PostgreSQL Anonymizer" width="150" height="100" class="float-end">

### Les méthodes de masquage:

Il existe 6 méthodes de masquage

Anonymous Dumps: Créer un dump de la base de données avec les données masquées.

Static Masking: Masquer les données dans la base de données elle-même.

Dynamic Masking: Masquer les données à la volée lors de l'exécution des requêtes.

Replica Masking: Créer une réplique de la base de données avec les données masquées.

Masking Views: Créer des vues dédiés pour les utisateurs qui n'ont pas besoin de voir les données réelles.

Masquing Data Wrapper: Applique les règles de masquages sur des données externes.

### En supplément

L'extension fournit des fonctions de masquage (randomisation, fausses données, masquage partiel). Mais vous pouvez aussi créer vos propres fonctions de masquage.

L'extension fournit également des fonctions de détection qui peuvent pour aider à trouver les colonnes ayant besoin d'être anonymisées.


