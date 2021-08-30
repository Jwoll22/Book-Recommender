SELECT *,
    AVG(m.rating) avg_rating
FROM user_has_book ub
JOIN maturity m
	ON ub.maturity_id = m.maturity_id
    GROUP BY ub.book_id
	ORDER BY avg_rating DESC;