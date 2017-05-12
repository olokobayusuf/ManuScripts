USE cs61;

-- cleanup first
DROP TABLE IF EXISTS trigger_exception;
DROP TRIGGER IF EXISTS trigger_exception_test ;

CREATE TABLE trigger_exception
(
    id INT NOT NULL
);

-- change delimiter to protect ;'s within the trigger
DELIMITER /

CREATE TRIGGER trigger_exception_test BEFORE INSERT ON trigger_exception
FOR EACH ROW
BEGIN
    DECLARE signal_message VARCHAR(128);
    IF new.id < 0 THEN
        SET signal_message = CONCAT('UserException: negative value received as id: ', CAST(new.id AS CHAR));

        -- MySQL doc defines SQLSTATE 45000 as "unhandled user-defined exception."
        SIGNAL SQLSTATE '45000' SET message_text = signal_message;
    END IF;
END
/

-- restore delimiter
DELIMITER ;

-- this statement fails due to one error out of three inserts
INSERT INTO trigger_exception VALUES (1), (2), (-2);
-- nothing in table
SELECT * FROM trigger_exception;
-- this one works
INSERT INTO trigger_exception VALUES (3);
-- try the border case
INSERT INTO trigger_exception VALUES (0);
-- try a strange border case, but SQL ignores signs on zero
INSERT INTO trigger_exception VALUES (-0);
-- this one fails
INSERT INTO trigger_exception VALUES (-3);
-- only three entries, 3, 0, and 0,in table
SELECT * FROM trigger_exception;
