<img src="../images/PostgreSQL-Anonymizer_H_couleur.png" alt="PostgreSQL Anonymizer" width="150" height="100" class="float-end">

### Installation

PostgreSQL Anonymizer est une extension PostgreSQL qui peut être installée sur n'importe quelle base de données PostgreSQL.
Différente installation existe, selon l'os utilisé. Lien vers la doc d'installation: https://postgresql-anonymizer.readthedocs.io/en/stable/INSTALL/

- `CREATE EXTENSION anon;`

- `SELECT anon.init();`

- `ALTER DATABASE foo SET session_preload_libraries = 'anon';`

