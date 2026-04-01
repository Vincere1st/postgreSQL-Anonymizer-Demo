#!/bin/bash

# Fonction pour afficher et exécuter une commande
run_command() {
    echo "$1"
    read -p "Appuyez sur Entrée pour exécuter la commande..."
    docker compose exec -i db1 psql -U postgres -d boutique -c "$2"
}

run_command "Création de la table des clients" "CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    firstname TEXT,
    lastname TEXT,
    phone TEXT,
    birth DATE,
    postcode TEXT
);"

run_command "Insertion des clients dans la base boutique" "INSERT INTO customer VALUES 
    (107,'Sarah','Conor','060-911-0911', '1965-10-10', '90016'),
    (258,'Luke', 'Skywalker', NULL, '1951-09-25', '90120'),
    (341,'Don', 'Draper','347-515-3423', '1926-06-01', '04520')
;"

run_command "Création de la table Payout" "CREATE TABLE payout (
    id SERIAL PRIMARY KEY,
    fk_customer_id INT REFERENCES customer(id),
    order_date DATE,
    payment_date DATE,
    amount INT
);"

run_command "Insertion des payouts dans la base boutique"  "INSERT INTO payout VALUES
(1,107,'2021-10-01','2021-10-01', '7'),
(2,258,'2021-10-02','2021-10-03', '20'),
(3,341,'2021-10-02','2021-10-02', '543'),
(4,258,'2021-10-05','2021-10-05', '12'),
(5,258,'2021-10-06','2021-10-06', '92')
;"

run_command "On veut cacher les noms et le numéro de téléphone des clients, en utilisant la fonction dummy_last_name() et partial() pour le numéro de téléphone" "SECURITY LABEL FOR anon ON COLUMN customer.lastname
  IS 'MASKED WITH FUNCTION anon.dummy_last_name()'; SECURITY LABEL FOR anon ON COLUMN customer.phone IS 'MASKED WITH FUNCTION anon.partial(phone,2,$\$X-XXX-XX\$\$,2)';"