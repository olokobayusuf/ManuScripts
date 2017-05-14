/* Tests to check for constraints, etc in the database 
 * Run after running insert.sql
 */
 
 USE `kfarmer_db`;
 
 /* User id must be unique */
INSERT INTO `user` (`id`) VALUES (3);

/* Cannot create a tuple in a role without corresponding user */
INSERT INTO `editor` (`user_id`) VALUES  (600);
INSERT INTO `author` (`user_id`) VALUES  (600);
INSERT INTO `reviewer` (`user_id`) VALUES (600);

/* Cannot insert with a non-existing affiliation */
INSERT INTO `author` (`user_id`,`affiliation_id`) VALUES (17,300);
INSERT INTO `reviewer` (`user_id`,`affiliation_id`) VALUES (11,300);

/* Cannot create manuscript with an invalid/nonexistant author_id */
INSERT INTO `manuscript` (`author_id`,`editor_id`,`RICodes_code`,`title`,`status`,`timestamp`,`pageCount`, `doc`) VALUES 
(27,1,16,"ridiculus","submitted","2017-01-14 23:12:52",null,"temp-blob");

/* Cannot create manuscript with an invalid/nonexistant editor_id */
INSERT INTO `manuscript` (`author_id`,`editor_id`,`RICodes_code`,`title`,`status`,`timestamp`,`pageCount`, `doc`) VALUES 
(12,7,16,"ridiculus","submitted","2017-01-14 23:12:52",null,"temp-blob");

/* Cannot create manuscript with an invalid/nonexistant RICode */
INSERT INTO `manuscript` (`author_id`,`editor_id`,`RICodes_code`,`title`,`status`,`timestamp`,`pageCount`, `doc`) VALUES 
(12,1,1000,"ridiculus","submitted","2017-01-14 23:12:52",null,"temp-blob");

/* Cannot add a contributor on a non-existant manuscript */
INSERT INTO `contributors` (`manuscript_id`,`order`,`fname`,`lname`) VALUES (27,1,"Victor","Whitley");

/* Cannot add interest for non-existant reviewer */
INSERT INTO `interests` (`reviewer_id`,`RICodes_code`) VALUES (47,3);

/* Cannot add interest for non-existant RICode */
INSERT INTO `interests` (`reviewer_id`,`RICodes_code`) VALUES (17,333);

/* Cannot accept a manuscript that doesn't exist */
INSERT INTO `acceptance` (`manuscript_id`,`issue_id`,`position`,`pageNum`) VALUE (80,6,1,1);

/* Cannot place a manuscript in an issue that doesn't exist */
INSERT INTO `acceptance` (`manuscript_id`,`issue_id`,`position`,`pageNum`) VALUE (8,60,1,1);

/* Cannot publish an issue that doesn't exist */
INSERT INTO `publish` (`issue_id`,`publishDate`) VALUES (27,"2016-2-23 17:15:07");

/* Cannot review a manuscript that doesn't exist */
INSERT INTO `review` (`manuscript_id`,`reviewer_id`,`dateSent`) VALUES (200,25,"2016-10-21 12:24:50");

/* Cannot assign a review to a reviewer that doesn't exist */
INSERT INTO `review` (`manuscript_id`,`reviewer_id`,`dateSent`) VALUES (2,45,"2016-10-21 12:24:50");

/* Cannot create feedback for a (`manuscript_id`,`reviewer_id`) pair without a review */
INSERT INTO `feedback` (`manuscript_id`,`reviewer_id`) VALUES (2,26);






