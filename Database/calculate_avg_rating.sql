SELECT *,
    AVG(r.rating) avg_rating
FROM user_has_book ub
JOIN review m
	ON ub.review_id = m.review_id
    GROUP BY ub.book_id
	ORDER BY avg_rating DESC;