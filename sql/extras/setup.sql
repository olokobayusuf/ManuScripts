-- MySQL Script generated by MySQL Workbench
-- Fri Apr 28 13:54:22 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema kfarmer_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema kfarmer_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `kfarmer_db` DEFAULT CHARACTER SET utf8 ;
USE `kfarmer_db` ;

-- -----------------------------------------------------
-- Table `messages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `messages` ;

CREATE TABLE IF NOT EXISTS `messages` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `affiliation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `affiliation` ;

CREATE TABLE IF NOT EXISTS `affiliation` (
  `id` INT NOT NULL,
  `institution` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `author` ;

CREATE TABLE IF NOT EXISTS `author` (
  `user_id` INT NOT NULL,
  `address` VARCHAR(254) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `affiliation_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `affiliated_idx` (`affiliation_id` ASC),
  CONSTRAINT `id`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `affiliated`
    FOREIGN KEY (`affiliation_id`)
    REFERENCES `affiliation` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `RICodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `RICodes` ;

CREATE TABLE IF NOT EXISTS `RICodes` (
  `code` INT NOT NULL AUTO_INCREMENT,
  `interest` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `editor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `editor` ;

CREATE TABLE IF NOT EXISTS `editor` (
  `user_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_editor_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_editor_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `manuscript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `manuscript` ;

CREATE TABLE IF NOT EXISTS `manuscript` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `author_id` INT NOT NULL,
  `editor_id` INT NOT NULL,
  `RICodes_code` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `doc` MEDIUMBLOB NOT NULL,
  `status` ENUM('submitted', 'underreview', 'rejected', 'accepted', 'typeset', 'scheduled', 'published') NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `pageCount` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `owner_idx` (`author_id` ASC),
  INDEX `fk_manuscript_RICodes1_idx` (`RICodes_code` ASC),
  INDEX `fk_manuscript_editor1_idx` (`editor_id` ASC),
  CONSTRAINT `owner`
    FOREIGN KEY (`author_id`)
    REFERENCES `author` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manuscript_RICodes1`
    FOREIGN KEY (`RICodes_code`)
    REFERENCES `RICodes` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_manuscript_editor1`
    FOREIGN KEY (`editor_id`)
    REFERENCES `editor` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reviewer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `reviewer` ;

CREATE TABLE IF NOT EXISTS `reviewer` (
  `user_id` INT NOT NULL,
  `email` VARCHAR(254) NOT NULL,
  `affiliation_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `affiliation_idx` (`affiliation_id` ASC),
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `affiliation`
    FOREIGN KEY (`affiliation_id`)
    REFERENCES `affiliation` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `interests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `interests` ;

CREATE TABLE IF NOT EXISTS `interests` (
  `reviewer_id` INT NOT NULL,
  `RICodes_code` INT NOT NULL,
  PRIMARY KEY (`reviewer_id`, `RICodes_code`),
  INDEX `fk_interests_RICodes1_idx` (`RICodes_code` ASC),
  INDEX `fk_interests_reviewer1_idx` (`reviewer_id` ASC),
  CONSTRAINT `fk_interests_RICodes1`
    FOREIGN KEY (`RICodes_code`)
    REFERENCES `RICodes` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interests_reviewer1`
    FOREIGN KEY (`reviewer_id`)
    REFERENCES `reviewer` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `review` ;

CREATE TABLE IF NOT EXISTS `review` (
  `manuscript_id` INT NOT NULL,
  `reviewer_id` INT NOT NULL,
  `dateSent` DATETIME NOT NULL,
  PRIMARY KEY (`manuscript_id`, `reviewer_id`),
  INDEX `manuscript_idx` (`manuscript_id` ASC),
  INDEX `reviewer_idx` (`reviewer_id` ASC),
  CONSTRAINT `manuscript`
    FOREIGN KEY (`manuscript_id`)
    REFERENCES `manuscript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reviewer`
    FOREIGN KEY (`reviewer_id`)
    REFERENCES `reviewer` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `feedback` ;

CREATE TABLE IF NOT EXISTS `feedback` (
  `manuscript_id` INT NOT NULL,
  `reviewer_id` INT NOT NULL,
  `appropriateness` INT NOT NULL,
  `clarity` INT NOT NULL,
  `methodology` INT NOT NULL,
  `contribution` INT NOT NULL,
  `recommendation` BIT(1) NOT NULL,
  `dateReceived` DATETIME NOT NULL,
  PRIMARY KEY (`manuscript_id`, `reviewer_id`),
  INDEX `fk_feedback_review1_idx` (`manuscript_id` ASC, `reviewer_id` ASC),
  CONSTRAINT `fk_feedback_review1`
    FOREIGN KEY (`manuscript_id` , `reviewer_id`)
    REFERENCES `review` (`manuscript_id` , `reviewer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `issue` ;

CREATE TABLE IF NOT EXISTS `issue` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'Volume might be monotonically increasing, in which case, it should be the PK of this table.',
  `year` INT NOT NULL,
  `period` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `acceptance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `acceptance` ;

CREATE TABLE IF NOT EXISTS `acceptance` (
  `manuscript_id` INT NOT NULL,
  `issue_id` INT NOT NULL,
  `position` INT NOT NULL,
  `pageNum` INT NOT NULL,
  PRIMARY KEY (`manuscript_id`),
  INDEX `for_idx` (`manuscript_id` ASC),
  INDEX `published in_idx` (`issue_id` ASC),
  CONSTRAINT `for`
    FOREIGN KEY (`manuscript_id`)
    REFERENCES `manuscript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `published in`
    FOREIGN KEY (`issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `contributors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `contributors` ;

CREATE TABLE IF NOT EXISTS `contributors` (
  `manuscript_id` INT NOT NULL,
  `order` ENUM('1', '2', '3') NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  INDEX `fk_manuscript_has_author_manuscript1_idx` (`manuscript_id` ASC),
  PRIMARY KEY (`manuscript_id`, `order`),
  CONSTRAINT `fk_manuscript_has_author_manuscript1`
    FOREIGN KEY (`manuscript_id`)
    REFERENCES `manuscript` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `publish`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `publish` ;

CREATE TABLE IF NOT EXISTS `publish` (
  `issue_id` INT NOT NULL,
  `publishDate` DATETIME NOT NULL,
  INDEX `fk_publish_issue1_idx` (`issue_id` ASC),
  PRIMARY KEY (`issue_id`),
  CONSTRAINT `fk_publish_issue1`
    FOREIGN KEY (`issue_id`)
    REFERENCES `issue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


INSERT INTO `user` (`fname`,`lname`) VALUES 
("Vielka","Cruz"),
("Palmer","Snow"),
("William","Joyner"),
("Imani","Kirk"),
("Veda","Mcpherson"),
("Dylan","Nash"),
("Dawn","Warner"),
("Hamilton","Hendricks"),
("Shoshana","Shepard"),
("Cleo","Short"),
("Ryder","Henderson"),
("Chandler","Hoover"),
("Branden","Odonnell"),
("Finn","Branch"),
("Dillon","Tran"),
("Travis","Harvey"),
("Shad","Noel"),
("Randall","Wheeler"),
("Samantha","Cote"),
("Charissa","Phillips"),
("Burke","Jackson"),
("Rooney","Solis"),
("Ignacia","Foreman"),
("Courtney","Rhodes"),
("Clio","Moreno"),
("Germaine","Cannon"),
("Brian","Payne"),
("Sophia","Mullins"),
("Georgia","Kelley"),
("Kaseem","Rasmussen");

INSERT INTO `editor` (`user_id`) VALUES 
(1),
(2);
    
INSERT INTO `affiliation` (`id`,`institution`) VALUES 
(1,"Morbi Vehicula Pellentesque LLC"),
(2,"Dolor Donec Industries"),
(3,"Auctor Velit Corp."),
(4,"Morbi Metus LLP"),
(5,"Turpis Nec Mauris Limited"),
(6,"Lorem Company"),
(7,"Aliquam Nisl Corp."),
(8,"Mauris Elit Company"),
(9,"Magna Duis Dignissim Ltd"),
(10,"Curabitur Inc."),
(11,"Vehicula Risus Limited"),
(12,"Blandit Consulting"),
(13,"Sollicitudin Corporation"),
(14,"Purus Company"),
(15,"Ut Foundation"),
(16,"Sem Vitae Aliquam Consulting"),
(17,"Mollis Lectus Pede Corporation"),
(18,"Ac Tellus Corp."),
(19,"At Egestas A Corporation"),
(20,"Rutrum Lorem Inc.");

INSERT INTO `author` (`user_id`,`address`,`email`,`affiliation_id`) VALUES 
(3,"Ap #367-6654 Lorem Rd.","ac.ipsum@libero.edu",3),
(4,"P.O. Box 732, 1502 Arcu. Street","Cras.vehicula@ullamcorper.com",5),
(5,"Ap #618-9798 Eleifend St.","ac.mattis@leoMorbi.edu",4),
(6,"P.O. Box 814, 4043 Velit. Road","sociis.natoque@Mauris.ca",15),
(7,"P.O. Box 318, 791 Lorem Road","vitae.sodales.nisi@egestasligula.net",20),
(8,"Ap #555-8087 Nulla Road","dolor@nequeet.ca",9),
(9,"407-5392 Suspendisse Rd.","Proin.vel@lobortisauguescelerisque.co.uk",4),
(10,"Ap #330-2509 Lorem Street","aliquam.eros.turpis@cursus.com",8),
(11,"Ap #369-3632 Hendrerit Rd.","orci.sem@rhoncusidmollis.ca",4),
(12,"7180 Amet, Street","in.sodales.elit@Phasellusvitaemauris.org",10);

INSERT INTO `reviewer` (`user_id`,`email`,`affiliation_id`) VALUES 
(13,"orci.Phasellus@nequevitaesemper.org",8),
(14,"libero.lacus.varius@lobortisultricesVivamus.edu",1),
(15,"orci@miacmattis.com",19),
(16,"lacus@posuereat.org",4),
(17,"ridiculus@semperauctor.net",14),
(18,"sollicitudin@interdumlibero.edu",13),
(19,"vehicula@posuereenimnisl.ca",1),
(20,"aliquam.eu@a.co.uk",15),
(21,"dolor.vitae@atortorNunc.org",15),
(22,"Etiam@felisorciadipiscing.ca",18),
(23,"mollis.Duis@insodales.org",15),
(24,"Donec@facilisismagnatellus.net",16),
(25,"nec@molestiearcu.ca",16),
(26,"malesuada.id.erat@molestie.com",3),
(27,"Sed.id.risus@libero.org",19),
(28,"nibh.Phasellus@aliquetsemut.org",17),
(29,"non.vestibulum@sapiengravidanon.edu",1),
(30,"eu.arcu@risusa.ca",8);

/* Given to us */
INSERT INTO RICodes (interest) VALUES
('Agricultural engineering'),
('Biochemical engineering'),
('Biomechanical engineering'),
('Ergonomics'),
('Food engineering'),
('Bioprocess engineering'),
('Genetic engineering'),
('Human genetic engineering'),
('Metabolic engineering'),
('Molecular engineering'),
('Neural engineering'),
('Protein engineering'),
('Rehabilitation engineering'),
('Tissue engineering'),
('Aquatic and environmental engineering'),
('Architectural engineering'),
('Civionic engineering'),
('Construction engineering'),
('Earthquake engineering'),
('Earth systems engineering and management'),
('Ecological engineering'),
('Environmental engineering'),
('Geomatics engineering'),
('Geotechnical engineering'),
('Highway engineering'),
('Hydraulic engineering'),
('Landscape engineering'),
('Land development engineering'),
('Pavement engineering'),
('Railway systems engineering'),
('River engineering'),
('Sanitary engineering'),
('Sewage engineering'),
('Structural engineering'),
('Surveying'),
('Traffic engineering'),
('Transportation engineering'),
('Urban engineering'),
('Irrigation and agriculture engineering'),
('Explosives engineering'),
('Biomolecular engineering'),
('Ceramics engineering'),
('Broadcast engineering'),
('Building engineering'),
('Signal Processing'),
('Computer engineering'),
('Power systems engineering'),
('Control engineering'),
('Telecommunications engineering'),
('Electronic engineering'),
('Instrumentation engineering'),
('Network engineering'),
('Neuromorphic engineering'),
('Engineering Technology'),
('Integrated engineering'),
('Value engineering'),
('Cost engineering'),
('Fire protection engineering'),
('Domain engineering'),
('Engineering economics'),
('Engineering management'),
('Engineering psychology'),
('Ergonomics'),
('Facilities Engineering'),
('Logistic engineering'),
('Model-driven engineering'),
('Performance engineering'),
('Process engineering'),
('Product Family Engineering'),
('Quality engineering'),
('Reliability engineering'),
('Safety engineering'),
('Security engineering'),
('Support engineering'),
('Systems engineering'),
('Metallurgical Engineering'),
('Surface Engineering'),
('Biomaterials Engineering'),
('Crystal Engineering'),
('Amorphous Metals'),
('Metal Forming'),
('Ceramic Engineering'),
('Plastics Engineering'),
('Forensic Materials Engineering'),
('Composite Materials'),
('Casting'),
('Electronic Materials'),
('Nano materials'),
('Corrosion Engineering'),
('Vitreous Materials'),
('Welding'),
('Acoustical engineering'),
('Aerospace engineering'),
('Audio engineering'),
('Automotive engineering'),
('Building services engineering'),
('Earthquake engineering'),
('Forensic engineering'),
('Marine engineering'),
('Mechatronics'),
('Nanoengineering'),
('Naval architecture'),
('Sports engineering'),
('Structural engineering'),
('Vacuum engineering'),
('Military engineering'),
('Combat engineering'),
('Offshore engineering'),
('Optical engineering'),
('Geophysical engineering'),
('Mineral engineering'),
('Mining engineering'),
('Reservoir engineering'),
('Climate engineering'),
('Computer-aided engineering'),
('Cryptographic engineering'),
('Information engineering'),
('Knowledge engineering'),
('Language engineering'),
('Release engineering'),
('Teletraffic engineering'),
('Usability engineering'),
('Web engineering'),
('Systems engineering');

INSERT INTO `interests` (`reviewer_id`,`RICodes_code`) VALUES 
(13,3),(13,11),
(14,11),(14,13),(14,16),
(15,13),(15,16),(15,30),
(16,16),(16,32),
(17,30),(17,32),(17,33),
(18,33),(18,39),
(19,33),(19,39),(19,40),
(20,37),(20,40),(20,42),
(21,40),(21,42),(21,44),
(22,42),(22,44),
(23,42),
(24,44),
(25,39),
(26,39),
(27,13),
(28,30),
(29,47),(29,32),
(30,88);

INSERT INTO `manuscript` (`author_id`,`editor_id`,`RICodes_code`,`title`,`status`,`timestamp`,`pageCount`, `doc`) VALUES 
(12,1,16,"ridiculus","submitted","2017-01-14 23:12:52",null,"temp-blob"),
(12,2,39,"Donec tempus, lorem fringilla","typeset","2016-10-06 20:09:21",12,"temp-blob"),
(10,2,11,"turpis Aliquam adipiscing","submitted","2016-11-02 01:00:22",null,"temp-blob"),
(3,2,44,"pretium aliquet,","underreview","2017-01-13 10:53:42",null,"temp-blob"),
(10,1,39,"vulputate, lacus","rejected","2017-02-22 08:29:27",null,"temp-blob"),
(4,2,42,"justo","accepted","2016-12-18 16:12:05",null,"temp-blob"),
(9,2,32,"mollis Phasellus","typeset","2016-11-10 04:11:10",5,"temp-blob"),
(7,2,40,"eget, ipsum Donec","scheduled","2016-12-11 07:02:18",9,"temp-blob"),
(5,1,3,"aliquam","rejected","2017-03-28 06:57:28",null,"temp-blob"),
(8,2,13,"non massa non","accepted","2017-04-11 09:58:30",null,"temp-blob"),
(7,1,30,"diam at","scheduled","2016-07-20 19:23:23",16,"temp-blob"),
(6,2,33,"varius ultrices, mauris","published","2016-09-25 15:56:29",2,"temp-blob"),
(8,2,13,"lorem eu metus In","underreview","2017-01-03 14:29:20",null,"temp-blob"),
(12,2,13,"lorem ultra","published","2016-09-25 15:56:29",4,"temp-blob"),
(3,2,39,"mauris mollis","published","2016-09-25 15:56:29",5,"temp-blob"),
(5,2,33,"Phasellus ipsis","published","2016-09-25 15:56:29",9,"temp-blob");


INSERT INTO `review` (`manuscript_id`,`reviewer_id`,`dateSent`) VALUES 
(2,25,"2016-10-21 12:24:50"),
(2,19,"2016-09-27 01:52:16"),
(2,18,"2017-03-09 05:28:51"),
(4,21,"2017-04-10 05:44:12"),
(4,22,"2016-05-04 16:20:52"),
(4,24,"2016-09-03 11:49:38"),
(6,20,"2016-12-15 16:01:03"),
(6,22,"2017-03-01 09:48:12"),
(6,23,"2016-07-08 03:43:38"),
(7,16,"2016-08-16 18:15:56"),
(7,29,"2016-06-30 04:51:39"),
(7,17,"2016-09-17 13:07:36"),
(8,20,"2017-02-27 18:28:28"),
(8,19,"2016-12-28 17:51:11"),
(8,21,"2017-01-27 05:04:14"),
(10,27,"2016-09-24 21:28:20"),
(10,15,"2017-04-13 03:21:23"),
(10,14,"2016-11-03 22:55:36"),
(11,17,"2016-08-25 09:04:12"),
(11,15,"2017-04-13 19:05:17"),
(11,28,"2016-10-24 12:26:34"),
(12,18,"2016-06-29 08:54:13"),
(12,17,"2016-12-01 17:58:33"),
(12,19,"2016-09-26 23:17:44"),
(13,14,"2016-06-02 02:19:18"),
(13,27,"2017-01-14 13:37:22"),
(13,15,"2016-11-19 16:46:10"),
(14,14,"2016-11-19 16:46:10"),
(14,27,"2016-11-19 16:46:10"),
(14,15,"2016-11-19 16:46:10"),
(15,25,"2016-11-19 16:46:10"),
(15,29,"2016-11-19 16:46:10"),
(15,18,"2016-11-19 16:46:10"),
(16,17,"2016-11-19 16:46:10"),
(16,18,"2016-11-19 16:46:10"),
(16,19,"2016-11-19 16:46:10");


INSERT INTO `feedback` (`manuscript_id`,`reviewer_id`,`appropriateness`,`clarity`,`methodology`,`contribution`,`recommendation`,`dateReceived`) VALUES 
(2,25,2,6,6,8,1,"2016-06-02 07:12:36"),
(2,19,5,2,6,2,0,"2017-03-03 10:13:58"),
(2,18,9,4,7,6,1,"2016-06-16 05:36:12"),
(4,22,10,4,1,3,1,"2016-12-18 22:24:57"),
(6,20,2,8,10,7,1,"2016-10-20 04:38:47"),
(6,22,2,10,8,8,1,"2016-07-09 09:45:03"),
(6,23,5,9,8,6,1,"2016-10-14 12:30:47"),
(7,16,8,1,10,6,0,"2017-04-13 03:08:07"),
(7,29,1,10,9,7,1,"2016-06-16 12:15:23"),
(7,17,1,5,10,5,1,"2016-06-15 18:45:45"),
(8,20,4,3,6,2,1,"2016-05-04 12:41:13"),
(8,19,9,3,8,1,1,"2017-03-11 19:13:24"),
(8,21,4,7,10,4,1,"2016-09-26 20:12:46"),
(10,27,1,6,5,5,1,"2016-12-09 20:51:05"),
(10,15,3,3,7,10,1,"2016-12-20 13:19:55"),
(10,14,3,6,4,10,0,"2016-09-09 19:57:53"),
(11,17,8,7,7,7,1,"2017-04-05 19:58:49"),
(11,15,3,7,10,9,1,"2016-05-25 09:06:30"),
(11,28,1,1,6,4,0,"2017-03-03 19:05:57"),
(12,18,10,1,3,7,1,"2017-01-03 21:15:22"),
(12,17,3,7,2,5,0,"2016-10-26 09:42:36"),
(12,19,2,8,10,2,1,"2017-03-11 20:00:35"),
(13,15,3,6,7,1,0,"2016-10-14 20:27:30");


INSERT INTO `contributors` (`manuscript_id`,`order`,`fname`,`lname`) VALUES 
(1,1,"Victor","Whitley"),
(1,2,"Cleo","Short"),
(3,1,"Mercedes","Heath"),
(4,1,"Kellie","Carr"),
(4,2,"Miranda","May"),
(4,3,"Ryder","Henderson"),
(7,1,"Dylan","Nash"),
(8,1,"Stuart","Sexton"),
(8,2,"Amanda","Kerr"),
(10,1,"Doris","Christensen"),
(10,2,"Alan","Murray"),
(10,3,"Dylan","Nash"),
(11,1,"Reese","Boyd"),
(13,1,"Fulton","Logan"),
(13,2,"Imani","Kirk");


INSERT INTO `issue` (`year`,`period`) VALUES 
(2016,1),
(2016,2),
(2016,3),
(2016,4),
(2017,1),
(2017,2),
(2017,3),
(2017,4),
(2018,1),
(2018,2);

INSERT INTO `acceptance` (`manuscript_id`,`issue_id`,`position`,`pageNum`) VALUE
(8,6,1,1),
(11,7,2,7),
(12,3,13,43),
(14,3,27,89),
(15,4,3,17),
(16,4,7,23);

INSERT INTO `publish` (`issue_id`,`publishDate`) VALUES 
(1,"2016-2-23 17:15:07"),
(2,"2016-6-06 06:25:37"),
(3,"2016-09-25 15:56:29"),
(4,"2016-12-12 18:18:41"),
(5,"2017-03-12 06:30:22");

