CREATE ROLE paul LOGIN SUPERUSER PASSWORD 'paul';
CREATE ROLE pierre LOGIN PASSWORD 'pierre';
CREATE ROLE jack LOGIN PASSWORD 'jack';
CREATE ROLE anon_dumper LOGIN PASSWORD 'dumper';
GRANT pg_read_all_data TO pierre, jack, anon_dumper;
GRANT pg_write_all_data TO jack;

CREATE DATABASE boutique_ref OWNER paul;
ALTER DATABASE boutique_ref SET session_preload_libraries = 'anon';
\c boutique_ref
CREATE EXTENSION anon;
SELECT anon.init();
ALTER ROLE anon_dumper SET anon.transparent_dynamic_masking TO TRUE;

CREATE TABLE customer (id SERIAL PRIMARY KEY, firstname TEXT, lastname TEXT, phone TEXT, birth DATE, postcode TEXT);
INSERT INTO customer VALUES
(107,'Sarah','Conor','060-911-0911','1965-10-10','90016'),
(258,'Luke','Skywalker',NULL,'1951-09-25','90120'),
(341,'Don','Draper','347-515-3423','1926-06-01','04520');
CREATE TABLE payout (id SERIAL PRIMARY KEY, fk_customer_id INT REFERENCES customer(id), order_date DATE, payment_date DATE, amount INT);
INSERT INTO payout VALUES (1,107,'2021-10-01','2021-10-01',7),(2,258,'2021-10-02','2021-10-03',20),
(3,341,'2021-10-02','2021-10-02',543),(4,258,'2021-10-05','2021-10-05',12),(5,258,'2021-10-06','2021-10-06',92);
CREATE TABLE company (id SERIAL PRIMARY KEY, name TEXT, vat_id TEXT UNIQUE);
INSERT INTO company VALUES (952,'Shadrach','FR62684255667'),(194,'Johnny''s Shoe Store','CHE670945644'),(346,'Capitol Records','GB663829617823');
CREATE TABLE supplier (id SERIAL PRIMARY KEY, fk_company_id INT REFERENCES company(id), contact TEXT, phone TEXT, job_title TEXT);
INSERT INTO supplier VALUES (299,194,'Johnny Ryall','597-500-569','CEO'),(157,346,'George Clinton','131-002-530','Sales manager');
CREATE TABLE website_comment (id SERIAL PRIMARY KEY, message JSONB);
INSERT INTO website_comment VALUES
(1, '{"meta":{"name":"Lee Perry","ip_addr":"40.87.29.113"},"content":"Hello Nasty!"}'),
(2, '{"meta":{"name":"","email":"biz@bizmarkie.com"},"content":"Great Shop"}'),
(3, '{"meta":{"name":"Jimmy"},"content":"Hi ! This is me, Jimmy James"}');
CREATE TABLE employee (id INT PRIMARY KEY, full_name TEXT, first_day DATE, last_day DATE, height INT, hair TEXT, eyes TEXT, size TEXT, asthma BOOLEAN);
INSERT INTO employee VALUES
(1,'Luna Dickens','2018-07-22','2018-12-15',180,'blond','blue','L',TRUE),
(2,'Paul Wolf','2020-01-15',NULL,177,'bald','brown','M',FALSE),
(3,'Rowan Hoeger','2018-12-01','2018-12-15',202,'dark','blue','XXL',TRUE);

\c postgres
CREATE DATABASE boutique TEMPLATE boutique_ref OWNER paul;
ALTER DATABASE boutique SET session_preload_libraries = 'anon';
ALTER DATABASE boutique SET anon.transparent_dynamic_masking TO true;
