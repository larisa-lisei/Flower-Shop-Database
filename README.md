# Flower Shop Database

Relational database for managing the operations of a flower shop, implemented using **Oracle SQL and PL/SQL**.

The database manages customers, orders, bouquets and their flower components, flower inventory, suppliers, and purchases.

It includes database constraints, sequences, **PL/SQL functions and procedures**, and **triggers** for:
- calculating bouquet and order prices;
- validating flower availability before placing an order;
- automatically updating stock when orders are placed, cancelled, or supplier purchases are made;
- creating new flowers from supplier purchases when they are not already available;
- preventing empty or duplicate bouquets.

## Database Tables

`tip_floare`, `floare`, `buchet`, `componenta`, `comanda`, `client`, `furnizor`, `produs`, `achizitie`, `produse_achizitie`

## Files

- `schema.ddl` – database schema and PL/SQL logic
- `tests.sql` – sample data and tests for functions, procedures, and triggers