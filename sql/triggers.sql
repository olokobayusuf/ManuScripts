/*
 * For CS61 Lab 2d
 * Trigger definitions
 */

USE `kfarmer_db`;

DROP TRIGGER IF EXISTS ricode_trigger;
DROP TRIGGER IF EXISTS on_resign_trigger;
DROP TRIGGER IF EXISTS on_schedule;
DROP TRIGGER IF EXISTS before_publish;
DROP TRIGGER IF EXISTS after_publish;
DROP TRIGGER IF EXISTS new_issue;
DROP TRIGGER IF EXISTS before_status_update;


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
        -- SET message = CONCAT('UserException: Manuscript(s) has less than 3 reviewers, reset to submitted');
		-- INSERT INTO `messages` (`message`) VALUES (message);
    END IF;
    DELETE FROM `interests` where reviewer_id = OLD.user_id;
	DELETE FROM `feedback` where reviewer_id = OLD.user_id;
    DELETE FROM `review` where reviewer_id = OLD.user_id;
	SET SQL_SAFE_UPDATES = 1;
END$$

CREATE TRIGGER on_schedule BEFORE INSERT ON acceptance
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128); 
    IF (
        (SELECT Count(*) from publish WHERE issue_id = new.issue_id) > 0
    ) THEN
        SET message = CONCAT('UserException: That issue has been published');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
    SET @total = (SELECT sum(pageCount) FROM acceptance JOIN manuscript ON manuscript_id = manuscript.id WHERE issue_id = new.issue_id);
    IF (
		 @total + (SELECT pageCount FROM manuscript WHERE id = new.manuscript_id) > 100
	) THEN
		SET message = CONCAT('UserException: An issue cannot have more than 100 pages');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
    
	IF (
        (SELECT status FROM manuscript WHERE id = new.manuscript_id) != "typeset"
    ) THEN
        SET message = CONCAT('UserException: Manuscript must be in typeset state to be scheduled');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
    
    UPDATE manuscript
    SET status = 'scheduled', timestamp = NOW()
    WHERE id = new.manuscript_id;
END$$

CREATE TRIGGER before_publish BEFORE INSERT ON publish
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128); 
    IF (
        (SELECT Count(*) from acceptance WHERE issue_id = new.issue_id) = 0
    ) THEN
        SET message = CONCAT('UserException: There must be at least 1 manuscript in a published issue');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
END$$

CREATE TRIGGER after_publish AFTER INSERT ON publish
FOR EACH ROW
BEGIN
	UPDATE manuscript
    JOIN acceptance ON manuscript.id = manuscript_id
	SET manuscript.status = 'published', manuscript.timestamp = NOW()
	WHERE issue_id = NEW.issue_id;
END$$

CREATE TRIGGER new_issue BEFORE INSERT ON issue
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128); 
    IF (
        (SELECT Count(*) from issue WHERE year = new.year AND period = new.period) > 0
    ) THEN
        SET message = CONCAT('UserException: There is already an issue for that year and period');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
END$$

CREATE TRIGGER before_status_update BEFORE UPDATE ON manuscript
FOR EACH ROW
BEGIN
    DECLARE message VARCHAR(128); 
    IF (
        (NEW.status = "accepted") AND ((SELECT Count(*) FROM feedback WHERE manuscript_id = new.id) < 3)
    ) THEN
        SET message = CONCAT('UserException: There must be three completed reviews in order to accept a manuscript');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;

	IF (
        (NEW.status = "typeset") AND ((SELECT status FROM manuscript WHERE id = new.id) != "accepted")
    ) THEN
        SET message = CONCAT('UserException: Manuscript must be in accepted state to be typeset');
		SIGNAL SQLSTATE '45000' SET message_text = message;
    END IF;
    
    
END$$

DELIMITER ;
