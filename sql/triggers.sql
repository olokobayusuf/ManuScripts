/*
 * For CS61 Lab 2d
 * Trigger definitions
 */

USE `kfarmer_db`;
    
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
DROP TRIGGER IF EXISTS on_resign_trigger;

DELIMITER $$

CREATE TRIGGER ricode_trigger BEFORE INSERT ON manuscript
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128);
    IF (
        (SELECT COUNT(*) FROM interests WHERE interests.RICodes_code = new.RICodes_code) < 3
    ) THEN
        SET message = CONCAT('UserException: Less than 3 reviewers use this RI Code: ', new.RICodes_code);
        -- MySQL doc defines SQLSTATE 45000 as "unhandled user-defined exception."
        SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
END$$

CREATE TRIGGER on_resign_trigger BEFORE DELETE ON reviewer
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128); 
	SET SQL_SAFE_UPDATES = 0;
    IF (
        (SELECT COUNT(*) FROM manuscript_counts WHERE count = 1 AND reviewer_id = OLD.user_id) > 0
    ) THEN
		UPDATE manuscript
		JOIN manuscript_counts ON manuscript.id = manuscript_counts.manuscript_id
		SET manuscript.status = 'submitted'
		WHERE manuscript_counts.count = 1 AND manuscript_counts.reviewer_id = OLD.user_id;
        
        SET message = CONCAT('UserException: Manuscripts have less than 3 reviewers, reset to submitted');
		INSERT INTO `messages` (`message`) VALUES (message);
    END IF;
    DELETE FROM `interests` where reviewer_id = OLD.user_id;
	DELETE FROM `feedback` where reviewer_id = OLD.user_id;
    DELETE FROM `review` where reviewer_id = OLD.user_id;
	SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
