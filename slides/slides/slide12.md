
## Dynamic Masking : la « linkability »

Pierre **recoupe** `supplier` et `company` et retrouve le PDG de « Johnny's Shoe Store ».

→ masquer aussi `company`, en **pseudonymisant** pour garder des valeurs stables.

<!--
## pierre
```sql
SELECT s.id, s.contact, s.job_title, c.name
FROM supplier s JOIN company c ON s.fk_company_id = c.id;
```
## paul : faux aléatoire (change à chaque lecture)
```sql
SECURITY LABEL FOR anon ON COLUMN company.name IS 'MASKED WITH FUNCTION anon.dummy_company_name()';
SECURITY LABEL FOR anon ON COLUMN company.vat_id IS 'MASKED WITH FUNCTION anon.random_string(10)';
```
## pierre (deux fois : valeurs différentes)
```sql
SELECT * FROM company;
```
## paul : pseudonymisation (stable)
```sql
SECURITY LABEL FOR anon ON COLUMN company.name IS 'MASKED WITH FUNCTION anon.seeded_company(id)';
SECURITY LABEL FOR anon ON COLUMN company.vat_id IS 'MASKED WITH FUNCTION anon.left(anon.hash(vat_id),10)';
```
Si seeded_company n'existe pas (version plus ancienne de l'extension) : `anon.pseudo_company(id)`.
## pierre (deux fois : mêmes valeurs)
```sql
SELECT * FROM company;
```
Rappel slide 2 : c'est de la **pseudonymisation**. Avec le sel (`anon.salt`) on peut retrouver les valeurs.
-->
