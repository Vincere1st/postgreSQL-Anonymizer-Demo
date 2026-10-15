
## Static Masking : le « singling out »

Même masquée, `customer` laisse isoler **le meilleur client** via `payout`.

```sql
SELECT anon.shuffle_column('payout', 'fk_customer_id', 'id');
```

<!--
## paul
```sql
WITH best_client AS (
  SELECT SUM(amount), fk_customer_id FROM payout
  GROUP BY fk_customer_id ORDER BY 1 DESC LIMIT 1
)
SELECT c.* FROM customer c JOIN best_client b ON c.id = b.fk_customer_id;

SELECT anon.shuffle_column('payout', 'fk_customer_id', 'id');
```
Relancer la première requête : ce n'est plus le même client.
Dire : masquer les colonnes ne suffit pas, il faut penser aux liens entre tables. Limite : le shuffle respecte les clés étrangères mais fausse les liens client/paiement (un rapport BI sur les paiements devient faux).
-->