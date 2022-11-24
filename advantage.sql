---Triggers: 

DROP TABLE workers;

CREATE TABLE workers
(
    id NUMBER(5),
    name VARCHAR2(50),
    salary NUMBER(5)
);

INSERT INTO workers VALUES(10001, 'Ali Can', 12000);
INSERT INTO workers VALUES(10002, 'Veli Han', 2000);
INSERT INTO workers VALUES(10003, 'Mary Star', 7000);
INSERT INTO workers VALUES(10004, 'Angie Ocean', 8500);

SELECT * FROM workers;

--TABLE LEVEL + AFTER + DML Trigger
--Create table level and statement level trigger for UPDATE Statement
--When you complete update on the table, it will print update message 
CREATE OR REPLACE TRIGGER workers_trigger AFTER UPDATE ON workers 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Records updated...');
END;

UPDATE workers
SET salary = salary + 500
WHERE salary < 8000;


--RECORD LEVEL + BEFORE + DML Trigger
--Create table level and record level trigger for UPDATE Statement
--When you start update on the table, it will print update message
CREATE OR REPLACE TRIGGER workers_before_update_trigger BEFORE UPDATE ON workers FOR EACH ROW
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Records will be updated...');
END;

UPDATE workers
SET salary = salary - 500
WHERE salary > 7000;

--Create a trigger to be triggered for UPDATE and INSERT Statements
--Increase the salary, print old salary, new salary and the difference on the console
CREATE OR REPLACE TRIGGER workers_update_insert_trigger BEFORE INSERT OR UPDATE ON workers FOR EACH ROW
DECLARE
    salary_difference NUMBER;
    new_salary NUMBER;
    old_salary NUMBER;
BEGIN
    new_salary:= :NEW.salary;
    old_salary:= :OLD.salary;
    salary_difference := new_salary - old_salary;
    DBMS_OUTPUT.PUT_LINE('New Salary: ' || new_salary);
    DBMS_OUTPUT.PUT_LINE('Old Salary: ' || old_salary);
    DBMS_OUTPUT.PUT_LINE('Difference: ' || salary_difference);
END;

INSERT INTO workers VALUES(10005, 'Tom Hanks', 17000);

UPDATE workers
SET salary = salary + 100
WHERE salary > 7000;

--Create a trigger works when you drop a table
CREATE OR REPLACE TRIGGER workers_drop_trigger AFTER DROP ON hr.schema
BEGIN
    DBMS_OUTPUT.PUT_LINE('Table dropped');
END;

DROP TABLE workers;

--We can disable and enable triggers
ALTER TRIGGER workers_trigger DISABLE;
ALTER TRIGGER workers_before_update_trigger DISABLE;

ALTER TRIGGER workers_trigger ENABLE;

SELECT * FROM workers;

--When you update salary of a worker, trigger will store old data in workers_history table
CREATE TABLE workers_history
(
    id NUMBER(5),
    name VARCHAR2(50),
    salary NUMBER(5),
    salary_difference NUMBER(5),
    update_date DATE
);

CREATE OR REPLACE TRIGGER workers_history_trigger BEFORE UPDATE ON workers FOR EACH ROW
BEGIN 
    INSERT INTO workers_history VALUES(:OLD.id, :OLD.name, :OLD.salary, :NEW.salary-:OLD.salary, SYSDATE);
END;

UPDATE workers
SET salary = salary*1.1
WHERE id > 10002;

SELECT * FROM workers_history;

SELECT * FROM workers;

DROP TABLE workers_history;

--In that example, we will make payment to a worker and the Trigger will save, payment amount, payment date, worker id etc.  
--into payment table automatically. And print a message like "200 dollars paid to Ali Can"
--In the payment table create a order number column by using sequence
CREATE SEQUENCE payment_sequence;

CREATE TABLE payments(
    order_number NUMBER(10),
    worker_id NUMBER(5),
    worker_name VARCHAR2(50),
    payment_amount NUMBER(5),
    payment_date DATE
);

CREATE OR REPLACE TRIGGER payment_trigger BEFORE UPDATE ON workers FOR EACH ROW
BEGIN
    INSERT INTO payments VALUES(payment_sequence.NEXTVAL, :NEW.id, :NEW.name, ABS(:OLD.salary-:NEW.salary), SYSDATE);
    DBMS_OUTPUT.PUT_LINE(ABS(:OLD.salary-:NEW.salary) || ' dollars paid to ' || :NEW.name);
END;

SELECT * FROM payments;

UPDATE workers
SET salary = salary*0.8
WHERE id > 10002;

--Create a record level trigger like 
--When you DELETE or INSERT any record it will be triggered
--It will store deleted or inserted records with the statement name into "changes" table
--Use sequence and date in "changes" table
CREATE SEQUENCE change_sequence;

CREATE TABLE changes(
    order_number NUMBER(10),
    worker_id NUMBER(5),
    worker_name VARCHAR2(50),
    statement_name VARCHAR2(50),
    workers_salary NUMBER(5)  
);

CREATE OR REPLACE TRIGGER change_trigger BEFORE DELETE OR INSERT ON workers FOR EACH ROW
BEGIN 
    IF :OLD.id IS NULL THEN
        INSERT INTO changes VALUES(change_sequence.NEXTVAL, :NEW.id, :NEW.name, 'Insert', :NEW.salary);
    ELSE
        INSERT INTO changes VALUES(change_sequence.NEXTVAL, :OLD.id, :OLD.name, 'Delete', :OLD.salary); 
    END IF;
END;

SELECT * FROM changes;

INSERT INTO workers VALUES(10005, 'Xxxx Yyyyyy', 3333);

DELETE FROM workers WHERE id = 10002;


--Cursors:
--I did not use Cursor, because of that I could not get any information about deletion
DECLARE 
    worker_id workers.id%TYPE;
BEGIN
    worker_id := '&id';
    DELETE FROM workers WHERE id = worker_id;
END;


--To get information about deletion, I will use Implicit Cursor
DECLARE 
    worker_id workers.id%TYPE;
BEGIN
    worker_id := '&id';
    DELETE FROM workers WHERE id = worker_id;
    IF(SQL%FOUND) THEN
       DBMS_OUTPUT.PUT_LINE(worker_id || ' is deleted'); 
    ELSE
       DBMS_OUTPUT.PUT_LINE('0 record is deleted'); 
    END IF;
END;
