<img src="../images/PostgreSQL-Anonymizer_H_couleur.png" alt="PostgreSQL Anonymizer" width="150" height="100" class="float-end">

## Installation

- `ALTER DATABASE boutique SET session_preload_libraries = 'anon';`

- **Utilisation** : `SELECT anon.mask('email', email) FROM customer;`

Via le terminal

<div style="display: flex; gap: 10px;">
  <Terminal width="50" height="300" compact />
  <Terminal width="50" height="300" compact />
</div>