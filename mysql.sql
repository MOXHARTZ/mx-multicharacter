CREATE TABLE `user_slots` (
	`identifier` VARCHAR(75) NOT NULL COLLATE 'utf8mb4_general_ci',
	`slots` TEXT NOT NULL DEFAULT '{"slot2":false,"slot3":false,"slot4":false}' COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

ALTER TABLE `users` ADD `citizenid` VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE `users` ADD `queue` INT(11) NOT NULL;