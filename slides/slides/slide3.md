## Pourquoi dans la base ?

- **Privacy by Design** : les règles vivent dans le schéma, versionnées avec lui
- Le développeur connaît le besoin métier, il écrit la règle
- Pas d'outil externe : moins de copies de données qui traînent

<!--
Sans l'extension, on copie la prod puis un script externe nettoie. Entre-temps, une copie complète existe quelque part.
Ici la règle est déclarée une fois et appliquée à chaque usage (accès, dump, réplica).
-->
