
## Écrire sa propre fonction

```sql
CREATE SCHEMA my_masks;
SECURITY LABEL FOR anon ON SCHEMA my_masks IS 'TRUSTED';
```

1. `remove_content(jsonb)` : retire une clé d'un JSON
2. `initials(text)` : « Luna Dickens » → « L. D. »

<!--
Un schéma TRUSTED (posé par un superuser) = on autorise l'extension à utiliser les fonctions qui s'y trouvent comme masques.
Une bonne fonction de masque est soit destructive, soit introduit de l'aléa.

## paul
```sql
CREATE SCHEMA IF NOT EXISTS my_masks;
SECURITY LABEL FOR anon ON SCHEMA my_masks IS 'TRUSTED';

CREATE FUNCTION my_masks.remove_content(j JSONB) RETURNS JSONB
AS $func$ SELECT j - 'content' $func$ LANGUAGE SQL;

CREATE FUNCTION my_masks.initials(n TEXT) RETURNS TEXT
AS $func$ SELECT string_agg(left(w,1) || '.', ' ') FROM unnest(string_to_array(n,' ')) w $func$ LANGUAGE SQL;

SELECT my_masks.initials('Luna Dickens');
SELECT id, my_masks.remove_content(message) FROM website_comment;

SECURITY LABEL FOR anon ON COLUMN employee.full_name
  IS 'MASKED WITH FUNCTION my_masks.initials(full_name)';
```
## pierre
```sql
SELECT id, full_name FROM employee;
```
-->