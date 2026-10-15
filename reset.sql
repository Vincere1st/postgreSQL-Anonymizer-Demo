-- Remet "boutique" a l'etat de "boutique_ref" (lancer depuis la base postgres)
DROP DATABASE IF EXISTS boutique WITH (FORCE);
CREATE DATABASE boutique TEMPLATE boutique_ref OWNER paul;
-- Les reglages de base ne sont pas copies par le template
ALTER DATABASE boutique SET session_preload_libraries = 'anon';
ALTER DATABASE boutique SET anon.transparent_dynamic_masking TO true;
-- Les labels de ROLE sont globaux au cluster : on les efface
\c boutique
SECURITY LABEL FOR anon ON ROLE pierre IS NULL;
SECURITY LABEL FOR anon ON ROLE anon_dumper IS NULL;
