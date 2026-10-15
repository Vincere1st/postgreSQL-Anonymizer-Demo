## Installation

```bash
docker compose up -d --wait
docker compose exec db psql -U postgres -d postgres -f /reset.sql
```
- Image Docker officielle de l'extension
- `boutique_ref` = base de référence, `boutique` = la base de démo
- Reset en une seconde entre deux démos

<!--
Hors Docker : `ALTER DATABASE boutique SET session_preload_libraries = 'anon'; CREATE EXTENSION anon; SELECT anon.init();` (superuser). 

Doc : https://postgresql-anonymizer.readthedocs.io/en/stable/INSTALL/

anon.init() charge les jeux de fausses données (noms, villes, IBAN...) utilisés par les fonctions de faking.

## Commandes
```bash
# reset rapide (recrée boutique depuis boutique_ref)
docker compose exec db psql -U postgres -d postgres -f /reset.sql
# reset total
docker compose down -v && docker compose up -d --wait
```
Après un reset : dans DBeaver, clic droit sur la connexion > Invalidate/Reconnect.
-->
