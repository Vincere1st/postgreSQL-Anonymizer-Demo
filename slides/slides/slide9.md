
## 1. Static Masking

Les données sont **remplacées définitivement**.

```sql
SELECT anon.anonymize_table('customer');
```

⚠️ Destructif : à faire sur une copie, jamais sur la prod.

<iframe src="https://giphy.com/embed/jUwpNzg9IcyrK" width="480" height="360" style="" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/the-simpsons-scared-homer-simpson-jUwpNzg9IcyrK">via GIPHY</a></p>
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
