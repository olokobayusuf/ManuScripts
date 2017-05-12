/*
 * For CS61 Lab 2d
 * Trigger definitions
 */

USE `yusuf_db`;

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
        (SELECT Count(*) from manuscript 
			JOIN (SELECT * FROM review WHERE reviewer_id = OLD.user_id) AS reviews ON reviews.manuscript_id = manuscript.id 
            WHERE status = 'underreview') > 0
    ) THEN
		UPDATE manuscript
		JOIN (SELECT * FROM review WHERE reviewer_id = OLD.user_id) AS reviews ON reviews.manuscript_id = manuscript.id
        SET manuscript.status = 'submitted'
        WHERE status = 'underreview';
        SET message = CONCAT('UserException: Manuscript(s) has less than 3 reviewers, reset to submitted');
		INSERT INTO `messages` (`message`) VALUES (message);
    END IF;
    DELETE FROM `interests` where reviewer_id = OLD.user_id;
	DELETE FROM `feedback` where reviewer_id = OLD.user_id;
    DELETE FROM `review` where reviewer_id = OLD.user_id;
	SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
