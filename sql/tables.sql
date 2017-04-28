-- MySQL Script generated by MySQL Workbench
-- Fri Apr 28 13:18:34 2017
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
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL,
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
