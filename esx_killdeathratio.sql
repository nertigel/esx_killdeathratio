USE `es_extended`;

CREATE TABLE `kdr` (
	`identifier` VARCHAR(40) NOT NULL,
	`kills` INT(11) NULL DEFAULT 0,
	`deaths` INT(11) NULL DEFAULT 0,

	PRIMARY KEY (`identifier`)
);