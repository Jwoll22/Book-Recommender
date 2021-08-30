USE book_db;

ALTER DATABASE book_db
	CHARACTER SET latin1;

SELECT * FROM book;

drop database localtest1;

SELECT * FROM book
WHERE book_overall_maturity < 5;

/*alter table review_content ADD(
example1 VARCHAR(25) DEFAULT "text"
example2 VARCHAR(25)*/

ALTER TABLE review_content 
	MODIFY review_content_text TINYTEXT;

-- EXPLAIN
SELECT 
	b.book_id,
    b.title,
    AVG(m.rating) avg_maturity,
	COUNT(b.book_id) num_votes
FROM user_has_book ub
JOIN maturity m USING (maturity_id)
JOIN book b USING (book_id)
    GROUP BY b.book_id
	ORDER BY avg_maturity DESC;

SHOW STATUS LIKE 'last_query_cost';

-- ALTER is to change a table's attributes, foreign keys, etc
-- MODIFY is to make a specific change to an attribute
-- UPDATE is to change data within a table
-- INSERT INTO is to create new data entries
-- DELETE FROM is to remove data values

INSERT INTO book (title)
	VALUES ('Hunger Games');
INSERT INTO preference
	VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO user
	VALUES (DEFAULT, '1998-09-22', 'Joshua', 'Wollenweber', 'wollenweberjosh@gmail.com', 'riolu', ' ', 1, 1);
INSERT INTO user
	VALUES (DEFAULT, '1997-12-23', 'Robert', 'Brosh', 'robert_brosh@aol.com', 'Frogg', ' ', 1, 1);
INSERT INTO user_has_book (maturity_id, book_id, user_id, preference_id, role_id)
	VALUES (7, 2, 1, (SELECT preference_id FROM user WHERE user_id = 1), (SELECT role_id FROM user WHERE user_id = 1));
DELETE FROM user_has_book
	WHERE preference_id = 2;
INSERT INTO user_has_friend
	VALUES (2,1);
INSERT INTO role
	VALUES (DEFAULT, 'Developer');
UPDATE user
	SET role_id = 1
	WHERE user_id = 2;
INSERT INTO user_has_book (book_id, maturity_id)
	Values (1, 1);
    
ALTER TABLE user_has_book AUTO_INCREMENT = 0;
