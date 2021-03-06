/*
 * For CS61 Lab 2d
 * Trigger tests
 */
USE `kfarmer_db`;

-- 100 is an unused RI code
INSERT INTO `manuscript` (`RICodes_code`) VALUES (100);

-- 88 is only used by a single reviewer
INSERT INTO `manuscript` (`RICodes_code`) VALUES (88);

-- 11 is only used by two reviewers
INSERT INTO `manuscript` (`RICodes_code`) VALUES (11);


-- Delete reviewer 21 who is reviewing manuscript 4
SELECT * FROM `manuscript` WHERE id = 4;
DELETE FROM `reviewer` WHERE reviewer.user_id = 21;
SELECT * FROM `manuscript` WHERE id = 4;
SELECT * FROM `messages`;

-- Delete reviewer 27 who is reviewing manuscript 13
SELECT * FROM `manuscript` WHERE id = 13;
DELETE FROM `reviewer` WHERE reviewer.user_id = 27;
SELECT * FROM `manuscript` WHERE id = 13;
SELECT * FROM `messages`;

