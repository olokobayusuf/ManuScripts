/*
 * For CS61 Lab 2d
 * Trigger tests
 */

SET SQL_SAFE_UPDATES = 0;

-- 100 is an unused RI code
INSERT INTO `manuscript` (`RICodes_code`) VALUES (100)
-- Delete reviewer 21 who is the only reviewer for his manuscript
DELETE FROM `reviewer` WHERE reviewer.user_id = 21;
-- Delete reviewer 22 who is not the only reviewer for his manuscript
DELETE FROM `reviewer` WHERE reviewer.user_id = 22;

SET SQL_SAFE_UPDATES = 1;
