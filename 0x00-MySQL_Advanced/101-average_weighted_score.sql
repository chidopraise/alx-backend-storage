-- Drop the procedure if it exists
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

-- Set the delimiter to handle multiple statements
DELIMITER //

-- Create a procedure to compute the average weighted score for a single user
CREATE PROCEDURE ComputeAverageWeightedScoreForUser (IN user_id INT)
BEGIN
    UPDATE users
    SET average_score = (
        SELECT SUM(score * (SELECT weight FROM projects WHERE id = corrections.project_id)) 
               / (SELECT SUM(weight) FROM projects)
        FROM corrections 
        WHERE corrections.user_id = user_id
    )
    WHERE id = user_id;
END//

-- Create a procedure to compute the average weighted score for all users
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE user_id INT;

    -- Declare a cursor to iterate through all user IDs
    DECLARE curid CURSOR FOR SELECT id FROM users;

    -- Declare a handler to manage the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Open the cursor
    OPEN curid;

    -- Start the loop to fetch user IDs one by one
    getid: LOOP
        -- Fetch the next user ID into the user_id variable
        FETCH curid INTO user_id;
        
        -- If no more rows, exit the loop
        IF finished = 1 THEN
            LEAVE getid;
        END IF;
        
        -- Call the procedure to compute the score for the current user
        CALL ComputeAverageWeightedScoreForUser(user_id);
    END LOOP getid;

    -- Close the cursor
    CLOSE curid;
END//

-- Reset the delimiter
DELIMITER ;
