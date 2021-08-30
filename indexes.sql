ANALYZE TABLE book;

SHOW INDEXES IN book;

SELECT *
FROM review_content;

CREATE FULLTEXT INDEX idx_title_body ON review_content (title, body);
CREATE FULLTEXT INDEX idx_title ON book (title);

-- Future Implementation of Backend Maturity Evaluation
SELECT *, MATCH(title, body) AGAINST('murder rape blood riot abuse assault harrassment') AS maturity_strength
FROM review_content
WHERE MATCH(title, body) AGAINST('murder rape blood riot abuse assault harrassment');

-- KEYWORDS and SHORTCUTS
/*
IN BOOLEAN MODE allows the following shortcuts
-word indicates that the result must not include said word
+word indicates that the result must include said word
*/

-- COMPOSITE INDEXES
/*
CREATE INDEX idx_lastname_username ON user (last_name, username);
The first column on user is how the composite index is grouped by
The second column contains rows of values that share the same first column
Depending on performance critical queries, it depends on which order is more efficient
*/