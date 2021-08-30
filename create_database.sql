-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema book_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema book_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `book_db` DEFAULT CHARACTER SET latin1 ;
USE `book_db` ;

-- -----------------------------------------------------
-- Table `book_db`.`author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`author` ;

CREATE TABLE IF NOT EXISTS `book_db`.`author` (
  `author_id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `dob` DATE NULL DEFAULT NULL,
  `full_name` VARCHAR(55) NOT NULL COMMENT 'Include author\'s full name',
  PRIMARY KEY (`author_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`book` ;

CREATE TABLE IF NOT EXISTS `book_db`.`book` (
  `book_id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `published` DATE NULL DEFAULT NULL COMMENT 'When did this book get published',
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When was this book added to the database',
  `modfiied` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`book_id`),
  FULLTEXT INDEX `idx_title` (`title`) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`book_has_author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`book_has_author` ;

CREATE TABLE IF NOT EXISTS `book_db`.`book_has_author` (
  `book_id` MEDIUMINT NOT NULL,
  `author_id` MEDIUMINT NOT NULL,
  PRIMARY KEY (`book_id`, `author_id`),
  INDEX `fk_book_has_author_author_idx` (`author_id` ASC) VISIBLE,
  INDEX `fk_book_has_author_book_idx` (`book_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_author_author`
    FOREIGN KEY (`author_id`)
    REFERENCES `book_db`.`author` (`author_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_book_has_author_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `book_db`.`book` (`book_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`review` ;

CREATE TABLE IF NOT EXISTS `book_db`.`review` (
  `review_id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `rating` TINYINT NOT NULL,
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When was the review added to the website',
  `modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Leave option open to edit review',
  `edited` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Outputs 1 if this review has been edited and 0 otherwise\\\\\\\\nIf it has been edited, show this on the front end',
  PRIMARY KEY (`review_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`preference`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`preference` ;

CREATE TABLE IF NOT EXISTS `book_db`.`preference` (
  `preference_id` TINYINT NOT NULL AUTO_INCREMENT,
  `display_name` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Display real name if 1, don\'t otherwise',
  `remember_login` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'If 1, remember login information at login screen so they don\'t have to type it out',
  `maturity_cap` TINYINT NOT NULL DEFAULT '10' COMMENT 'Implement a block on books that are above this maturity cap\\\\nThe cap is defaulted to the maximum maturity',
  PRIMARY KEY (`preference_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`role` ;

CREATE TABLE IF NOT EXISTS `book_db`.`role` (
  `role_id` TINYINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'SELECT FROM\\\\nDeveloper (someone with full access)\\\\nAdministrator (someone trusted to handle problems with the website)\\\\nCurator (someone who can freely add or edit books)\\\\nTrusted (like verified user)\\\\nUser',
  PRIMARY KEY (`role_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`user` ;

CREATE TABLE IF NOT EXISTS `book_db`.`user` (
  `user_id` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `dob` DATE NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL COMMENT 'Backend ensure values are unique',
  `username` VARCHAR(45) NOT NULL COMMENT 'Backend ensure values are unique',
  `password` VARCHAR(45) NOT NULL,
  `created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `preference_id` TINYINT NOT NULL DEFAULT '1' COMMENT 'DEFAULT to preference setting DEFAULT',
  `role_id` TINYINT NOT NULL DEFAULT '5' COMMENT 'DEFAULT to role USER',
  PRIMARY KEY (`user_id`, `preference_id`, `role_id`),
  INDEX `fk_user_preference_idx` (`preference_id` ASC) VISIBLE,
  INDEX `fk_user_role_idx` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_preference`
    FOREIGN KEY (`preference_id`)
    REFERENCES `book_db`.`preference` (`preference_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `book_db`.`role` (`role_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3
COMMENT = '	';


-- -----------------------------------------------------
-- Table `book_db`.`user_has_friend`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`user_has_friend` ;

CREATE TABLE IF NOT EXISTS `book_db`.`user_has_friend` (
  `user_id` MEDIUMINT NOT NULL,
  `friend_id` MEDIUMINT NOT NULL,
  PRIMARY KEY (`user_id`, `friend_id`),
  INDEX `fk_user_has_friend_user_idx` (`friend_id` ASC) VISIBLE,
  INDEX `fk_user_has_friend_friend_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_friend_friend`
    FOREIGN KEY (`friend_id`)
    REFERENCES `book_db`.`user` (`user_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_friend_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `book_db`.`user` (`user_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`comment` ;

CREATE TABLE IF NOT EXISTS `book_db`.`comment` (
  `comment_id` INT NOT NULL,
  `body` TINYTEXT NOT NULL,
  `is_DM` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'If 1, it\'s a direct message\\nOtherwise, it\'s a comment on a review from user_id',
  `review_id` MEDIUMINT NOT NULL,
  `user_id` MEDIUMINT NOT NULL,
  `friend_id` MEDIUMINT NOT NULL,
  PRIMARY KEY (`comment_id`, `review_id`, `user_id`, `friend_id`),
  INDEX `fk_comment_review1_idx` (`review_id` ASC) VISIBLE,
  INDEX `fk_comment_user_has_friend1_idx` (`user_id` ASC, `friend_id` ASC) VISIBLE,
  CONSTRAINT `fk_comment_review1`
    FOREIGN KEY (`review_id`)
    REFERENCES `book_db`.`review` (`review_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_user_has_friend1`
    FOREIGN KEY (`user_id` , `friend_id`)
    REFERENCES `book_db`.`user_has_friend` (`user_id` , `friend_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `book_db`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`genre` ;

CREATE TABLE IF NOT EXISTS `book_db`.`genre` (
  `genre_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL COMMENT 'primary genre',
  PRIMARY KEY (`genre_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`maturity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`maturity` ;

CREATE TABLE IF NOT EXISTS `book_db`.`maturity` (
  `maturity_id` TINYINT NOT NULL AUTO_INCREMENT,
  `rating` TINYINT NOT NULL COMMENT 'One maturity rating vote per user per book',
  PRIMARY KEY (`maturity_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`review_content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`review_content` ;

CREATE TABLE IF NOT EXISTS `book_db`.`review_content` (
  `review_content_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `body` TINYTEXT NOT NULL,
  `start` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Set to 1 if this tinytext is the beginning of the review content',
  `end` BIT(1) NOT NULL DEFAULT b'0' COMMENT 'Set to 1 if this tinytext is the end of the review content',
  `review_id` MEDIUMINT NOT NULL,
  PRIMARY KEY (`review_content_id`, `review_id`),
  INDEX `fk_review_content_review_idx` (`review_id` ASC) VISIBLE,
  FULLTEXT INDEX `idx_title_body` (`title`, `body`) INVISIBLE,
  CONSTRAINT `fk_review_content_review`
    FOREIGN KEY (`review_id`)
    REFERENCES `book_db`.`review` (`review_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`tag` ;

CREATE TABLE IF NOT EXISTS `book_db`.`tag` (
  `tag_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Search for tags from users and add them up to tally votes',
  PRIMARY KEY (`tag_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`user_has_book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`user_has_book` ;

CREATE TABLE IF NOT EXISTS `book_db`.`user_has_book` (
  `user_has_book_id` INT NOT NULL AUTO_INCREMENT,
  `review_id` MEDIUMINT NULL DEFAULT NULL,
  `maturity_id` TINYINT NULL DEFAULT NULL,
  `book_id` MEDIUMINT NOT NULL,
  `user_id` MEDIUMINT NOT NULL,
  `preference_id` TINYINT NOT NULL,
  `role_id` TINYINT NOT NULL,
  PRIMARY KEY (`user_has_book_id`, `book_id`, `user_id`, `preference_id`, `role_id`),
  INDEX `fk_user_has_book_review_idx` (`review_id` ASC) VISIBLE,
  INDEX `fk_user_has_book_maturity_idx` (`maturity_id` ASC) VISIBLE,
  INDEX `fk_user_has_book_book_idx` (`book_id` ASC) VISIBLE,
  INDEX `fk_user_has_book_user_idx` (`user_id` ASC, `preference_id` ASC, `role_id` ASC) INVISIBLE,
  CONSTRAINT `fk_user_has_book_book`
    FOREIGN KEY (`book_id`)
    REFERENCES `book_db`.`book` (`book_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_book_maturity`
    FOREIGN KEY (`maturity_id`)
    REFERENCES `book_db`.`maturity` (`maturity_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_book_review`
    FOREIGN KEY (`review_id`)
    REFERENCES `book_db`.`review` (`review_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_book_user`
    FOREIGN KEY (`user_id` , `preference_id` , `role_id`)
    REFERENCES `book_db`.`user` (`user_id` , `preference_id` , `role_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`user_has_book_has_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`user_has_book_has_genre` ;

CREATE TABLE IF NOT EXISTS `book_db`.`user_has_book_has_genre` (
  `user_has_book_id` INT NOT NULL,
  `genre_id` SMALLINT NOT NULL,
  PRIMARY KEY (`user_has_book_id`, `genre_id`),
  INDEX `fk_user_has_book_has_genre_genre_idx` (`genre_id` ASC) VISIBLE,
  INDEX `fk_user_has_book_has_genre_user_has_book_idx` (`user_has_book_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_book_has_genre_genre`
    FOREIGN KEY (`genre_id`)
    REFERENCES `book_db`.`genre` (`genre_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_book_has_genre_user_has_book`
    FOREIGN KEY (`user_has_book_id`)
    REFERENCES `book_db`.`user_has_book` (`user_has_book_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `book_db`.`user_has_book_has_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `book_db`.`user_has_book_has_tag` ;

CREATE TABLE IF NOT EXISTS `book_db`.`user_has_book_has_tag` (
  `user_has_book_id` INT NOT NULL,
  `tag_id` SMALLINT NOT NULL,
  PRIMARY KEY (`user_has_book_id`, `tag_id`),
  INDEX `fk_user_has_book_has_tag_tag_idx` (`tag_id` ASC) VISIBLE,
  INDEX `fk_user_has_book_has_tag_user_has_book_idx` (`user_has_book_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_book_has_tag_tag`
    FOREIGN KEY (`tag_id`)
    REFERENCES `book_db`.`tag` (`tag_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_book_has_tag_user_has_book`
    FOREIGN KEY (`user_has_book_id`)
    REFERENCES `book_db`.`user_has_book` (`user_has_book_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
