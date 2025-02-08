-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2

-- 🧪 Test Required
USE smart_pkg_db;

-- Disable foreign key checks to avoid constraint issues
SET FOREIGN_KEY_CHECKS = 0;

-- Change delimiter to allow stored procedure creation
DELIMITER $$

-- Create the stored procedure to truncate all tables
CREATE PROCEDURE truncate_all_tables()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tableName VARCHAR(255);
    DECLARE cur CURSOR FOR 
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE table_schema = 'smart_pkg_db' 
        AND table_type = 'BASE TABLE';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO tableName;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET @truncate_stmt = CONCAT('TRUNCATE TABLE ', tableName, ';');
        PREPARE stmt FROM @truncate_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;
    
    CLOSE cur;
END$$

-- Restore the original delimiter
DELIMITER ;

-- Execute the procedure to truncate all tables
CALL truncate_all_tables();

-- Drop the procedure after execution to keep the database clean
DROP PROCEDURE truncate_all_tables;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
