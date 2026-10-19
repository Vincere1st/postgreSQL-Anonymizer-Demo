
## 1. Static Masking

Les données sont **remplacées définitivement**.

```sql
SELECT anon.anonymize_table('customer');
```

<!--
Cas : Paul archive son ancienne base et retire les données personnelles.

## paul
```sql
SELECT * FROM customer;
SECURITY LABEL FOR anon ON COLUMN customer.lastname
  IS 'MASKED WITH FUNCTION anon.dummy_last_name()';
SECURITY LABEL FOR anon ON COLUMN customer.phone
  IS 'MASKED WITH FUNCTION anon.partial(phone,2,$$X-XXX-XX$$,2)';
SECURITY LABEL FOR anon ON COLUMN customer.postcode
  IS 'MASKED WITH FUNCTION anon.partial(postcode,2,$$xxx$$,0)';
SELECT anon.anonymize_table('customer');
SELECT * FROM customer;
SELECT postcode, COUNT(id) FROM customer GROUP BY postcode;
```
Dire : les stats par zone restent possibles (90xxx, 04xxx).
-->
