-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2

-- SHOW DATABASES;
-- SELECT user, host FROM mysql.user;
-- SELECT USER();

USE smart_parcel;


SELECT
  TABLE_NAME,
  COLUMN_NAME,
  DATA_TYPE,
  IS_NULLABLE,
  COLUMN_KEY,
  EXTRA,
  COLUMN_COMMENT
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_SCHEMA = 'smart_parcel'
ORDER BY
  TABLE_NAME,
  ORDINAL_POSITION;