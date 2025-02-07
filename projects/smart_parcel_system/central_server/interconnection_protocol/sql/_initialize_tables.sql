-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2


USE smart_pkg_db;

SET SESSION group_concat_max_len = 1000000;
SET FOREIGN_KEY_CHECKS = 0;

SET @sql = (
    SELECT GROUP_CONCAT('TRUNCATE TABLE `', table_name, '`;' SEPARATOR ' ')
    FROM information_schema.tables 
    WHERE table_schema = DATABASE()
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;