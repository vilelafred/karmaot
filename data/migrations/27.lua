function onUpdateDatabase()
	print("> Updating database to version 27 (fake_players)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `fake_players` (
			`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(64) NOT NULL,
			`vocation` TINYINT UNSIGNED NOT NULL DEFAULT 4,
			`level` INT UNSIGNED NOT NULL DEFAULT 1,
			`experience` BIGINT UNSIGNED NOT NULL DEFAULT 0,
			`gold` INT UNSIGNED NOT NULL DEFAULT 0,
			`state` VARCHAR(16) NOT NULL DEFAULT 'idle',
			`goal` VARCHAR(64) NOT NULL DEFAULT 'hunt_rats',
			`position_x` INT NOT NULL,
			`position_y` INT NOT NULL,
			`position_z` INT NOT NULL,
			`creature_uid` INT UNSIGNED DEFAULT NULL,
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			UNIQUE KEY `name` (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	]])
	return true
end
