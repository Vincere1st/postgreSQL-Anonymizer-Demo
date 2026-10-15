## 4. Généralisation et k-anonymity

« Né le 25/07/1989 » → « né dans les années 80 » : **vrai, mais moins précis**.

```sql
SELECT anon.k_anonymity('v_asthma_eyes');  -- k = 1
```

<!--
Anecdote : sur 3 employés, les yeux bleus "causent" l'asthme (100 % contre 0 %). Petit échantillon = personnes identifiables (inférence).
k-anonymity : chaque combinaison de quasi-identifiants doit apparaître au moins k fois. k = 1 veut dire qu'une personne est unique.

## paul
```sql
CREATE MATERIALIZED VIEW v_asthma_eyes AS SELECT eyes, asthma FROM employee;
SELECT eyes, 100*COUNT(1) FILTER (WHERE asthma)/COUNT(1) AS asthma_rate
FROM v_asthma_eyes GROUP BY eyes;

SECURITY LABEL FOR k_anonymity ON COLUMN v_asthma_eyes.eyes IS 'INDIRECT IDENTIFIER';
SECURITY LABEL FOR k_anonymity ON COLUMN v_asthma_eyes.asthma IS 'INDIRECT IDENTIFIER';
SELECT anon.k_anonymity('v_asthma_eyes');

CREATE MATERIALIZED VIEW v_staff_per_month AS
SELECT anon.generalize_daterange(first_day,'month') AS first_day,
       anon.generalize_daterange(last_day,'month') AS last_day
FROM employee;
SELECT * FROM v_staff_per_month;
```
Remarque : `k_anonymity` est un autre fournisseur de labels (FOR k_anonymity), même mécanisme que FOR anon.
-->