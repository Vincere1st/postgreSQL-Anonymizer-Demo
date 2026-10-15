
## 3. Anonymous Dumps

Un dump fait par un **rôle masqué** est un dump anonyme.

```bash
pg_dump -U anon_dumper boutique --table=website_comment > dump.sql
```

<!--
Cas : l'agence web qui refond le site demande un export. Les commentaires contiennent des infos personnelles dans un JSON libre.
Donnée non structurée = difficile à masquer proprement : on supprime la clé "content" avec la fonction maison de la slide précédente.

## paul
```sql
SECURITY LABEL FOR anon ON COLUMN website_comment.message
  IS 'MASKED WITH FUNCTION my_masks.remove_content(message)';
SECURITY LABEL FOR anon ON ROLE anon_dumper IS 'MASKED';
```
## terminal
```bash
docker compose exec db pg_dump -U anon_dumper boutique --table=website_comment > dump.sql
cat dump.sql
```
Dire : dump anonyme = masquage dynamique + pg_dump. La clé "content" a disparu.
-->
