SET SERVEROUTPUT ON;

-- tipuri flori
INSERT INTO tip_floare VALUES ('Trandafir', 'Rosu');
INSERT INTO tip_floare VALUES ('Lalea', 'Galben');
INSERT INTO tip_floare VALUES ('Crin', 'Alb');
INSERT INTO tip_floare VALUES ('Trandafir', 'Alb');
INSERT INTO tip_floare VALUES ('Bujor', 'Roz');

-- furnizori
INSERT INTO furnizor(nume, telefon, email)
VALUES ('FloraLux', '0723456789', 'flora@lux.ro');
INSERT INTO Furnizor (Nume, Telefon, Email)
VALUES ('RoseGarden', '0734567890', 'rosegarden@gmail.com');

-- client
INSERT INTO client(nume, prenume, telefon, email)
VALUES ('Popescu', 'Ana', '0734567890', 'ana@gmail.com');
COMMIT;


-- produse furnizori
INSERT INTO produs(id_furnizor, nume, culoare, pret, cantitate)
VALUES (5000, 'Trandafir', 'Rosu', 10, 100);

INSERT INTO produs(id_furnizor, nume, culoare, pret, cantitate)
VALUES (5000, 'Lalea', 'Galben', 8, 50);

INSERT INTO produs(id_furnizor, nume, culoare, pret, cantitate)
VALUES (5000, 'Crin', 'Alb', 15, 30);

INSERT INTO produs(id_furnizor, nume, culoare, pret, cantitate)
VALUES (5001, 'Trandafir', 'Alb', 8, 150);

INSERT INTO produs(id_furnizor, nume, culoare, pret, cantitate)
VALUES (5001, 'Bujor', 'Roz', 30, 50);
COMMIT;


-- TEST FUNCTIE get_pret_produs
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pret trandafir rosu: ' || 
        get_pret_produs(5000, 'Trandafir', 'Rosu')
    );
    
    -- asteptat 0
    DBMS_OUTPUT.PUT_LINE(
        'Pret produs inexistent: ' ||
        get_pret_produs(5000, 'Orhidee', 'Mov')
    );
END;
/
select * from produs;


-- TEST FUNCTIE get_stoc_produs
BEGIN
    DBMS_OUTPUT.PUT_LINE('Stoc lalea galbena: ' ||
        get_stoc_produs(5000, 'Lalea', 'Galben')
    );
    
    -- asteptat 0
    DBMS_OUTPUT.PUT_LINE(
        'Stoc produs inexistent: ' ||
        get_stoc_produs(5000, 'Orhidee', 'Mov')
    );
END;
/
select * from produs;


-- TEST decrementare_stoc_produs
BEGIN
    -- produs inexistent
    decrementare_stoc_produs(5000, 'Orhidee', 'Mov', 10);
END;
/


-- TEST PROCEDURA efectueaza_achizitie + trigger trg_update_stoc_la_achizitie
DECLARE
    v_lista pachet_produse.prod_table_type;
BEGIN
    v_lista(1) := pachet_produse.prod_record_type('Trandafir', 'Rosu', 20);
    v_lista(2) := pachet_produse.prod_record_type('Lalea', 'Galben', 10);
    efectueaza_achizitie(5000, v_lista);
    
    -- asteptat: stoc insuficient
    v_lista(1) := pachet_produse.prod_record_type('Trandafir', 'Rosu', 300);
    v_lista(2) := pachet_produse.prod_record_type('Lalea', 'Galben', 10);
    efectueaza_achizitie(5000, v_lista);
END;
/

SELECT * FROM produs;
SELECT * FROM floare;
SELECT * FROM produse_achizitie;
SELECT * FROM achizitie;

DECLARE
    v_lista pachet_produse.prod_table_type;
BEGIN
    -- asteptat: stoc insuficient
    v_lista(1) := pachet_produse.prod_record_type('Trandafir', 'Rosu', 300);
    v_lista(2) := pachet_produse.prod_record_type('Lalea', 'Galben', 10);
    efectueaza_achizitie(5000, v_lista);
END;
/


-- TEST calculeaza_pret_buchet
DECLARE
    v_lista pachet_buchete.t_lista_componente;
    v_pret NUMBER;
BEGIN
    v_lista(1) := pachet_buchete.t_componenta_rec('Trandafir', 'Rosu', 5);
    v_lista(2) := pachet_buchete.t_componenta_rec('Lalea', 'Galben', 3);
    v_pret := calculeaza_pret_buchet(v_lista, 1);
    DBMS_OUTPUT.PUT_LINE('Pret buchet: ' || v_pret);
END;
/

select * from floare;

DECLARE
    v_lista pachet_buchete.t_lista_componente;
    v_pret NUMBER;
BEGIN
    -- Buchetul trebuie sa aiba cel putin o componenta
    v_pret := calculeaza_pret_buchet(v_lista, 1);
    DBMS_OUTPUT.PUT_LINE(v_pret);
END;
/

DECLARE
    v_lista pachet_buchete.t_lista_componente;
    v_pret NUMBER;
BEGIN
    -- Floare inexistenta
    v_lista(3) := pachet_buchete.t_componenta_rec('Orhidee', 'Mov', 3);
    v_pret := calculeaza_pret_buchet(v_lista, 1);
    DBMS_OUTPUT.PUT_LINE('Pret buchet: ' || v_pret);
END;
/

-- TEST creeaza_buchet
DECLARE
    v_lista pachet_buchete.t_lista_componente;
    v_id_buchet NUMBER;
    v_pret NUMBER;
BEGIN
    v_lista(1) := pachet_buchete.t_componenta_rec('Trandafir', 'Rosu', 5);
    v_lista(2) := pachet_buchete.t_componenta_rec('Lalea', 'Galben', 3);
    v_pret := calculeaza_pret_buchet(v_lista, 1);
    
    creeaza_buchet(1, v_pret, v_lista, v_id_buchet);
    DBMS_OUTPUT.PUT_LINE('Buchet creat cu ID: ' || v_id_buchet);
END;
/

SELECT * FROM buchet;
SELECT * FROM componenta;
SELECT * FROM floare;


-- TEST verifica_stoc_pentru_comanda
DECLARE
    v_rez NUMBER;
BEGIN
    -- nu exista buchet
    v_rez := verifica_stoc_pentru_comanda(501, 999);
    DBMS_OUTPUT.PUT_LINE('Rezultat: ' || v_rez);
END;

DECLARE
    v_rez NUMBER;
BEGIN
    -- nu exista buchet
    v_rez := verifica_stoc_pentru_comanda(500, 40);
    DBMS_OUTPUT.PUT_LINE('Rezultat: ' || v_rez);
END;
select * from floare;
select * from buchet;


-- TEST plaseaza_comanda + trigger trg_actualizare_stoc_dupa_comanda
DECLARE
    v_lista pachet_buchete.t_lista_componente;
BEGIN
    v_lista(1) := pachet_buchete.t_componenta_rec('Trandafir', 'Rosu', 2);
    v_lista(2) := pachet_buchete.t_componenta_rec('Lalea', 'Galben', 1);

    plaseaza_comanda(2000, 1, v_lista, 2, SYSDATE + 1);
END;
/

DECLARE
    v_lista pachet_buchete.t_lista_componente;
BEGIN
    v_lista(1) := pachet_buchete.t_componenta_rec('Trandafir', 'Rosu', 5);
    v_lista(2) := pachet_buchete.t_componenta_rec('Lalea', 'Galben', 3);

    plaseaza_comanda(2000, 1, v_lista, 1, SYSDATE + 1);
END;
/

SELECT * FROM comanda;
SELECT * FROM buchet;
SELECT * FROM floare;

DECLARE
    v_lista pachet_buchete.t_lista_componente;
BEGIN
    -- stoc insuficient
    v_lista(1) := pachet_buchete.t_componenta_rec('Trandafir', 'Rosu', 100);
    plaseaza_comanda(2000, 1, v_lista, 10, SYSDATE + 1);
END;
/


-- TEST trigger anulare comanda
UPDATE comanda
SET status = 'Anulata'
WHERE id_comanda = 1000;
COMMIT;

select * from comanda;
select * from componenta;
SELECT * FROM floare;

-- Buchetul ramane asamblat in florarie, nu se modifica stocul florilor
UPDATE comanda
SET status = 'Finalizata'
WHERE id_comanda = 1001;
COMMIT;

UPDATE comanda
SET status = 'Anulata'
WHERE id_comanda = 1001;
COMMIT;

select * from comanda;
SELECT * FROM floare;


-- TEST trigger update pret buchet
UPDATE floare
SET pret = 20
WHERE nume = 'Trandafir'
AND culoare = 'Rosu';
COMMIT;

select * from floare;
select * from componenta;
SELECT * FROM buchet;


-- TEST trigger validare data comanda
BEGIN
    INSERT INTO comanda(id_client, id_buchet, numar_buchete, data_comenzii, pret, status)
    VALUES(2000, 500, 1, SYSDATE - 1, 100, 'Plasata');
END;
/


-- TEST trigger validare data achizitie
BEGIN
    INSERT INTO achizitie(id_furnizor, data_achizitie, pret_total)
    VALUES(5000, SYSDATE + 1, 100);
END;
/