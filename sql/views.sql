/*
 * For CS61 Lab 2c
 * Creates views necessary for our application
 */

USE `kfarmer_db`;

DROP VIEW IF EXISTS LeadAuthorManuscripts;
CREATE VIEW LeadAuthorManuscripts AS
    SELECT user.id as user_id, fname, lname, address, email, manuscript.id AS manuscript_id, title, status, timestamp
    FROM user, author, manuscript
    WHERE user.id = author.user_id AND author.user_id = manuscript.author_id
    ORDER BY lname, timestamp;

DROP VIEW IF EXISTS AnyAuthorManuscripts;
CREATE VIEW AnyAuthorManuscripts AS
    (
        SELECT contributors.fname, contributors.lname, manuscript.title, manuscript.status, manuscript.timestamp
        FROM contributors, manuscript
        WHERE contributors.manuscript_id = manuscript.id
    )
    UNION
    SELECT fname, lname, title, status, timestamp FROM LeadAuthorManuscripts;

DROP VIEW IF EXISTS PublishedIssues;
CREATE VIEW PublishedIssues AS
    SELECT year, period, title, pageNum
    FROM publish, issue, acceptance, manuscript
    WHERE
        publish.issue_id = issue.id AND
        issue.id = acceptance.issue_id AND
        acceptance.manuscript_id = manuscript.id
    ORDER BY year, period, pageNum;

DROP VIEW IF EXISTS ReviewQueue;
CREATE VIEW ReviewQueue AS
    SELECT manuscript.id, author.fname, author.lname, reviewer.fname AS rfname, reviewer.lname AS rlname, timestamp
    FROM manuscript, user author, user reviewer, review
    WHERE 
        manuscript.status = 'underreview' AND 
        manuscript.id = review.manuscript_id AND
        manuscript.author_id = author.id AND
        review.reviewer_id = reviewer.id
    ORDER BY timestamp;

DROP VIEW IF EXISTS WhatsLeft;
CREATE VIEW WhatsLeft AS 
	SELECT id AS manuscript_id, status, 
		CASE
			WHEN status = 'submitted' THEN 'underreview -> rejected or accepted -> typeset -> scheduled -> published'
            WHEN status = 'underreview' THEN 'rejected or accepted -> typeset -> scheduled -> published'
            WHEN status = 'accepted' THEN 'typeset -> scheduled -> published'
            WHEN status = 'typeset' THEN 'scheduled -> published'
            WHEN status = 'scheduled' THEN 'published'
			ELSE '(Nothing)'
		END AS remaining
    FROM manuscript;

DROP VIEW IF EXISTS ReviewStatus;
CREATE VIEW ReviewStatus AS 
    SELECT reviewer.user_id, manuscript.id AS manuscript_id, manuscript.title, review.dateSent, feedback.appropriateness, feedback.clarity, feedback.methodology, feedback.contribution, feedback.recommendation
    FROM manuscript, reviewer, review
	LEFT JOIN feedback ON review.manuscript_id = feedback.manuscript_id AND review.reviewer_id = feedback.reviewer_id
    WHERE
        manuscript.id = review.manuscript_id AND
        review.reviewer_id = reviewer.user_id
    ORDER BY reviewer.user_id, review.dateSent;
