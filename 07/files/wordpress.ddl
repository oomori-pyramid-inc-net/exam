-- database
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- user
GRANT ALL ON wordpress.* to wordpress@'%' IDENTIFIED BY 'wordpress';

