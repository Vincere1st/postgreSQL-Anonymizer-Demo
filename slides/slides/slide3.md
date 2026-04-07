<img src="../images/PostgreSQL-Anonymizer_H_couleur.png" alt="PostgreSQL Anonymizer" width="150" height="100" class="float-end">

### Installation

PostgreSQL Anonymizer est une extension PostgreSQL qui peut être installée sur n'importe quelle base de données PostgreSQL.

- **Installation** : `CREATE EXTENSION anon;`

- **Configuration** : `ALTER DATABASE boutique SET session_preload_libraries = 'anon';`

- **Utilisation** : `SELECT anon.mask('email', email) FROM customer;`