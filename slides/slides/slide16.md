
## 5. Réplica anonymisé

Réplication logique : les données sont masquées **à l'arrivée**.

⚠️ Règles **avant** la subscription · ne **jamais masquer** les clés primaires

<!--
Démo lourde : je la montre en captures ou pré-enregistrée. wal_level=logical est déjà réglé par le compose.
Même instance, deux bases (boutique = source, boutique_replica = réplica).
Les lignes d'activation du masquage côté réplica sont à recopier du tutoriel officiel, chapitre 5 (Anonymized Replica).

## paul, sur boutique (source)
```sql
CREATE PUBLICATION pub_boutique FOR TABLE company, supplier;
SELECT pg_create_logical_replication_slot('sub_boutique','pgoutput');
```
## paul, sur postgres
```sql
CREATE DATABASE boutique_replica OWNER paul;
```
## paul, sur boutique_replica
```sql
CREATE EXTENSION anon;
SELECT anon.init();
CREATE TABLE company (id INT PRIMARY KEY, name TEXT, vat_id TEXT UNIQUE);
CREATE TABLE supplier (id INT PRIMARY KEY, fk_company_id INT, contact TEXT, phone TEXT, job_title TEXT);
SECURITY LABEL FOR anon ON COLUMN company.name IS 'MASKED WITH FUNCTION anon.dummy_company_name()';
SECURITY LABEL FOR anon ON COLUMN supplier.contact IS 'MASKED WITH VALUE $$CONFIDENTIAL$$';
-- activer le masquage de réplica (tutoriel chap. 5), puis :
CREATE SUBSCRIPTION sub_boutique CONNECTION 'dbname=boutique user=paul'
  PUBLICATION pub_boutique WITH (create_slot = false, slot_name = 'sub_boutique');
SELECT * FROM supplier;
```
Piège : une règle ajoutée après coup ne masque que les nouvelles lignes (rattrapage avec anon.anonymize_table()).
-->
