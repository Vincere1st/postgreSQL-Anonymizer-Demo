--  creation des personnes qui vont se connecter à la base de données
CREATE ROLE paul LOGIN SUPERUSER PASSWORD 'CHANGEME';
CREATE ROLE pierre LOGIN PASSWORD 'CHANGEME';
CREATE ROLE jack LOGIN PASSWORD 'CHANGEME';
GRANT pg_read_all_data TO jack;
GRANT pg_write_all_data TO jack;

-- Création de la boutique
CREATE DATABASE boutique OWNER paul;

--  Activation de l'extension sur la base boutique
ALTER DATABASE boutique
  SET session_preload_libraries = 'anon';

-- Initialisation de la base boutique
\c boutique
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS payout CASCADE;