-- MySQL Script generated by MySQL Workbench
-- Fri Apr 28 00:40:07 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CERTIFICATE
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `CERTIFICATE` ;

-- -----------------------------------------------------
-- Schema CERTIFICATE
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CERTIFICATE` DEFAULT CHARACTER SET utf8 ;
USE `CERTIFICATE` ;

-- -----------------------------------------------------
-- Table `CERTIFICATE`.`GENDER_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`GENDER_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`GENDER_CODE` (
  `CODE` VARCHAR(2) NOT NULL,
  `NAME` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`PERSON`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`PERSON` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`PERSON` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `GENDER_CODE` VARCHAR(2) NOT NULL,
  `RESIDENT_REGISTRATION_NUMBER` VARCHAR(300) NOT NULL,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_PERSON_GENDER_CODE1_idx` (`GENDER_CODE` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_GENDER_CODE1`
    FOREIGN KEY (`GENDER_CODE`)
    REFERENCES `CERTIFICATE`.`GENDER_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`ADDRESS`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`ADDRESS` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`ADDRESS` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `ZIP_CODE` VARCHAR(6) NOT NULL,
  `ADDRESS` TEXT NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`CERTIFICATE_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`CERTIFICATE_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`CERTIFICATE_CODE` (
  `CODE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`CERTIFICATE_ISSUE_LOG`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`CERTIFICATE_ISSUE_LOG` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`CERTIFICATE_ISSUE_LOG` (
  `PRE_ID` CHAR(8) NOT NULL,
  `SUB_ID` CHAR(8) NOT NULL,
  `PERSON_ID` INT NOT NULL,
  `CERTIFICATE_CODE` INT NOT NULL,
  `DATETIME` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`PRE_ID`, `SUB_ID`),
  INDEX `fk_CERTIFICATE_ISSUE_LOG_CERTIFICATE_CODE1_idx` (`CERTIFICATE_CODE` ASC) VISIBLE,
  INDEX `fk_CERTIFICATE_ISSUE_LOG_PERSON1_idx` (`PERSON_ID` ASC) VISIBLE,
  CONSTRAINT `fk_CERTIFICATE_ISSUE_LOG_CERTIFICATE_CODE1`
    FOREIGN KEY (`CERTIFICATE_CODE`)
    REFERENCES `CERTIFICATE`.`CERTIFICATE_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CERTIFICATE_ISSUE_LOG_PERSON1`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`BIRTH_PLACE_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`BIRTH_PLACE_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`BIRTH_PLACE_CODE` (
  `CODE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`HOUSEHOLD_RELATION_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`HOUSEHOLD_RELATION_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`HOUSEHOLD_RELATION_CODE` (
  `CODE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`HOUSEHOLD`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`HOUSEHOLD` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`HOUSEHOLD` (
  `PERSON_ID` INT NOT NULL,
  `HOUSEHOLDER_ID` INT NOT NULL,
  `RELATION_CODE` INT NOT NULL,
  PRIMARY KEY (`PERSON_ID`),
  INDEX `fk_PERSON_has_PERSON_PERSON1_idx` (`PERSON_ID` ASC) VISIBLE,
  INDEX `fk_PERSON_has_PERSON_RELATION_CODE1_idx` (`RELATION_CODE` ASC) VISIBLE,
  INDEX `fk_HOUSEHOLD_PERSON1_idx` (`HOUSEHOLDER_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_has_PERSON_PERSON1`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERSON_has_PERSON_RELATION_CODE1`
    FOREIGN KEY (`RELATION_CODE`)
    REFERENCES `CERTIFICATE`.`HOUSEHOLD_RELATION_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HOUSEHOLD_PERSON1`
    FOREIGN KEY (`HOUSEHOLDER_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`DEATH_PLACE_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`DEATH_PLACE_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`DEATH_PLACE_CODE` (
  `CODE` INT NOT NULL,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`DEATH_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`DEATH_INFO` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`DEATH_INFO` (
  `PERSON_ID` INT NOT NULL,
  `ADDRESS_ID` INT NOT NULL,
  `DEATH_PLACE_CODE` INT NOT NULL,
  `DEATH_DATETIME` DATETIME NOT NULL,
  PRIMARY KEY (`PERSON_ID`),
  INDEX `fk_DEAD_ADDRESS1_idx` (`ADDRESS_ID` ASC) VISIBLE,
  INDEX `fk_DEAD_PERSON1_idx` (`PERSON_ID` ASC) VISIBLE,
  INDEX `fk_DEATH_INFO_DEATH_PLACE_CODE1_idx` (`DEATH_PLACE_CODE` ASC) VISIBLE,
  CONSTRAINT `fk_DEAD_ADDRESS1`
    FOREIGN KEY (`ADDRESS_ID`)
    REFERENCES `CERTIFICATE`.`ADDRESS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DEAD_PERSON1`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DEATH_INFO_DEATH_PLACE_CODE1`
    FOREIGN KEY (`DEATH_PLACE_CODE`)
    REFERENCES `CERTIFICATE`.`DEATH_PLACE_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`BIRTH_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`BIRTH_INFO` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`BIRTH_INFO` (
  `PERSON_ID` INT NOT NULL,
  `ADDRESS_ID` INT NOT NULL,
  `GENDER_CODE` VARCHAR(2) NOT NULL,
  `BIRTH_PLACE_CODE` INT NOT NULL,
  `BIRTH_DATETIME` DATETIME NOT NULL,
  PRIMARY KEY (`PERSON_ID`),
  INDEX `fk_BIRTH_INFO_BIRTH_PLACE_CODE1_idx` (`BIRTH_PLACE_CODE` ASC) VISIBLE,
  INDEX `fk_BIRTH_INFO_ADDRESS1_idx` (`ADDRESS_ID` ASC) VISIBLE,
  INDEX `fk_BIRTH_INFO_GENDER_CODE1_idx` (`GENDER_CODE` ASC) VISIBLE,
  INDEX `fk_BIRTH_INFO_PERSON1_idx` (`PERSON_ID` ASC) VISIBLE,
  CONSTRAINT `fk_BIRTH_INFO_BIRTH_PLACE_CODE1`
    FOREIGN KEY (`BIRTH_PLACE_CODE`)
    REFERENCES `CERTIFICATE`.`BIRTH_PLACE_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BIRTH_INFO_ADDRESS1`
    FOREIGN KEY (`ADDRESS_ID`)
    REFERENCES `CERTIFICATE`.`ADDRESS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BIRTH_INFO_GENDER_CODE1`
    FOREIGN KEY (`GENDER_CODE`)
    REFERENCES `CERTIFICATE`.`GENDER_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_BIRTH_INFO_PERSON1`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`NOTIFY_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`NOTIFY_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`NOTIFY_CODE` (
  `CODE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`QUALIFICATION_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`QUALIFICATION_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`QUALIFICATION_CODE` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NOTIFY_CODE_CODE` INT NOT NULL,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_QUALIFICATION_CODE_NOTIFY_CODE1_idx` (`NOTIFY_CODE_CODE` ASC) VISIBLE,
  CONSTRAINT `fk_QUALIFICATION_CODE_NOTIFY_CODE1`
    FOREIGN KEY (`NOTIFY_CODE_CODE`)
    REFERENCES `CERTIFICATE`.`NOTIFY_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`NOTIFY_INFO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`NOTIFY_INFO` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`NOTIFY_INFO` (
  `PERSON_ID` INT NOT NULL,
  `NOTIFY_CODE` INT NOT NULL,
  `TARGET_PERSON_ID` INT NOT NULL,
  `QUALIFICATION_CODE_ID` INT NOT NULL,
  `EMAIL` VARCHAR(45) NULL,
  `PHONE_NUMBER` VARCHAR(45) NULL,
  `CREATE_DATETIME` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`PERSON_ID`, `NOTIFY_CODE`, `TARGET_PERSON_ID`),
  INDEX `fk_NOTIFY_PERSON_NOTIFY_CODE1_idx` (`NOTIFY_CODE` ASC) VISIBLE,
  INDEX `fk_NOTIFY_PERSON_QUALIFICATION_CODE1_idx` (`QUALIFICATION_CODE_ID` ASC) VISIBLE,
  INDEX `fk_NOTIFY_PERSON_PERSON1_idx` (`TARGET_PERSON_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_INFORMANT_PERSON1`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTIFY_PERSON_NOTIFY_CODE1`
    FOREIGN KEY (`NOTIFY_CODE`)
    REFERENCES `CERTIFICATE`.`NOTIFY_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTIFY_PERSON_QUALIFICATION_CODE1`
    FOREIGN KEY (`QUALIFICATION_CODE_ID`)
    REFERENCES `CERTIFICATE`.`QUALIFICATION_CODE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NOTIFY_PERSON_PERSON1`
    FOREIGN KEY (`TARGET_PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`FAMILY_RELATION_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`FAMILY_RELATION_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`FAMILY_RELATION_CODE` (
  `CODE` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`CODE`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`FAMILY`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`FAMILY` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`FAMILY` (
  `PERSON_ID` INT NOT NULL,
  `TARGET_PERSON_ID` INT NOT NULL,
  `FAMILY_RELATION_CODE` INT NOT NULL,
  PRIMARY KEY (`PERSON_ID`, `TARGET_PERSON_ID`, `FAMILY_RELATION_CODE`),
  INDEX `fk_PERSON_has_PERSON_PERSON2_idx` (`TARGET_PERSON_ID` ASC) VISIBLE,
  INDEX `fk_PERSON_has_PERSON_PERSON1_idx` (`PERSON_ID` ASC) VISIBLE,
  INDEX `fk_FAMILY_FAMILY_RELATION_CODE1_idx` (`FAMILY_RELATION_CODE` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_has_PERSON_PERSON10`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERSON_has_PERSON_PERSON20`
    FOREIGN KEY (`TARGET_PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FAMILY_FAMILY_RELATION_CODE1`
    FOREIGN KEY (`FAMILY_RELATION_CODE`)
    REFERENCES `CERTIFICATE`.`FAMILY_RELATION_CODE` (`CODE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`CHANGE_REASON_CODE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`CHANGE_REASON_CODE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`CHANGE_REASON_CODE` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CERTIFICATE`.`RESIDENCE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CERTIFICATE`.`RESIDENCE` ;

CREATE TABLE IF NOT EXISTS `CERTIFICATE`.`RESIDENCE` (
  `PERSON_ID` INT NOT NULL,
  `ADDRESS_ID` INT NOT NULL,
  `CHANGE_REASON_CODE_ID` INT NOT NULL,
  `CREATE_DATETIME` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`PERSON_ID`, `ADDRESS_ID`),
  INDEX `fk_PERSON_has_ADDRESS_ADDRESS2_idx` (`ADDRESS_ID` ASC) VISIBLE,
  INDEX `fk_PERSON_has_ADDRESS_PERSON2_idx` (`PERSON_ID` ASC) VISIBLE,
  INDEX `fk_PERSON_has_ADDRESS_CHANGE_REASON_CODE1_idx` (`CHANGE_REASON_CODE_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PERSON_has_ADDRESS_PERSON2`
    FOREIGN KEY (`PERSON_ID`)
    REFERENCES `CERTIFICATE`.`PERSON` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERSON_has_ADDRESS_ADDRESS2`
    FOREIGN KEY (`ADDRESS_ID`)
    REFERENCES `CERTIFICATE`.`ADDRESS` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERSON_has_ADDRESS_CHANGE_REASON_CODE1`
    FOREIGN KEY (`CHANGE_REASON_CODE_ID`)
    REFERENCES `CERTIFICATE`.`CHANGE_REASON_CODE` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

