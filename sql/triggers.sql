/*
 * For CS61 Lab 2d
 * Trigger definitions
 */

USE `yusuf_db`;

/*
* View for finding number of mansucripts
*/
CREATE OR REPLACE VIEW manuscript_counts AS 
    SELECT
    manuscript_id,
    reviewer_id,
    COUNT(*) AS count
    FROM review
    GROUP BY manuscript_id;

DROP TRIGGER IF EXISTS ricode_trigger;
DROP TRIGGER IF EXISTS manuscript_trigger;

DELIMITER $$

CREATE TRIGGER ricode_trigger BEFORE INSERT ON manuscript
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128);
    IF (
        (SELECT COUNT(*) FROM interests WHERE interests.RICodes_code = new.RICodes_code) = 0
    ) THEN
        SET message = CONCAT('UserException: No reviewers review this RI Code: ', new.RICodes_code);
        -- MySQL doc defines SQLSTATE 45000 as "unhandled user-defined exception."
        SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
END$$

CREATE TRIGGER manuscript_trigger BEFORE DELETE ON reviewer
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128);
    IF (
        (SELECT COUNT(*) FROM manuscript_counts WHERE count = 1 AND reviewer_id = OLD.user_id) > 0
    ) THEN
        SET message = CONCAT('UserException: Manuscript has no more reviewers :(');
        -- MySQL doc defines SQLSTATE 45000 as "unhandled user-defined exception."
        SIGNAL SQLSTATE '45000' SET message_text = message;
        -- Update
        UPDATE manuscript
        JOIN manuscript_counts ON mansucript.id = manuscript_counts.manuscript_id
        SET manuscript.status = 'submitted'
        WHERE manuscript_counts.count = 1 AND manuscript_counts.reviewer_id = OLD.user_id;
    END IF;
END$$

DELIMITER ;
