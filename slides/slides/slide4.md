
## Comment ça marche : `SECURITY LABEL`

```sql
SECURITY LABEL FOR anon
  ON COLUMN customer.phone
  IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$X-XXX-XX$$,2)';
```

- `FOR anon` : **qui** interprète l'étiquette
- `ON COLUMN ...` : **sur quoi** (colonne, rôle, schéma)
- `IS '...'` : **la règle** (texte libre pour PostgreSQL)

<!--
## Explication simple
SECURITY LABEL est une commande native de PostgreSQL : elle colle une étiquette (un simple texte) sur un objet (table, colonne, rôle, schéma).
PostgreSQL ne comprend pas ce texte : il se contente de le stocker. Elle existait pour SELinux, et d'autres extensions peuvent l'utiliser.
`FOR anon` désigne le "fournisseur" de l'étiquette. C'est l'extension anon qui lit et interprète le texte (MASKED WITH FUNCTION...).
D'où `session_preload_libraries = 'anon'` : l'extension doit être chargée dans chaque session pour valider et appliquer les étiquettes.
Ensuite, ce sont les méthodes (statique, dynamique, dump, réplica) qui décident QUAND la règle est appliquée. La règle, elle, est écrite une seule fois.

## À montrer (paul)
```sql
SECURITY LABEL FOR anon ON COLUMN customer.phone
  IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$X-XXX-XX$$,2)';
SELECT * FROM pg_seclabels WHERE provider = 'anon';
SELECT * FROM anon.pg_masking_rules;
SECURITY LABEL FOR anon ON COLUMN customer.phone IS NULL;
SELECT * FROM anon.pg_masking_rules;
```
Dire : IS NULL supprime la règle. Il faut être propriétaire de l'objet (ou superuser) pour poser une étiquette.
-->
