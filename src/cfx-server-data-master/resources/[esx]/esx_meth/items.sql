CREATE TABLE IF NOT EXISTS `methplants` (
  `owner` varchar(50) NOT NULL,
  `plant` longtext NOT NULL,
  `plantid` bigint(20) NOT NULL
);


INSERT INTO `items` (`name`,`label`,`limit`) VALUES
	('meth100g', 'Methamphetamine [100g]', -1),
	('preparationmeth', 'Preparation of Methamphetamine', -1),
	('ingredients', 'Ingredients of Methamphetamine', -1),
	('purifiedwater', 'Purified Water', -1),	
	('table', 'Preparation table', -1);
