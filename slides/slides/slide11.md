
## 2. Dynamic Masking : même base, deux vues

```sql
SECURITY LABEL FOR anon ON ROLE pierre IS 'MASKED';
SECURITY LABEL FOR anon ON COLUMN supplier.contact
  IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';
```

<div style="display: flex; gap: 10px;">
  <Terminal width="50" height="400" compact />
  <Terminal width="50" height="400" compact />
</div>

<!--
Terminal gauche = pierre, droit = jack (ou deux onglets DBeaver). Les données ne sont pas modifiées : seul le résultat est masqué. Aucun changement côté application.
Le setup a déjà activé anon.transparent_dynamic_masking sur la base.

## paul
```sql
SECURITY LABEL FOR anon ON ROLE pierre IS 'MASKED';
```
## pierre puis jack
```sql
SELECT * FROM supplier;
```
(tout visible : aucune règle sur les colonnes)
## paul
```sql
SECURITY LABEL FOR anon ON COLUMN supplier.contact
  IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';
```
## pierre puis jack
```sql
SELECT * FROM supplier;
```
-->