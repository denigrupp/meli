-- SELLER.CATEGORY definition

CREATE TABLE `CATEGORY` (
  `id_category` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `cod_category` bigint DEFAULT NULL,
  `category` text,
  `type` text
) ENGINE=Inno

-- SELLER.CUSTOMER definition

CREATE TABLE `CUSTOMER` (
  `id_customer` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `email` text,
  `name` text,
  `last_name` text,
  `address` text,
  `birth_date` date,
  `type` bigint DEFAULT NULL,
  `seller_flg` bigint DEFAULT NULL,
  `sexo` text,
	 PRIMARY KEY (id_customer)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- SELLER.ITEM definition

CREATE TABLE `ITEM` (
  `id_tem` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `sku` bigint DEFAULT NULL,
  `product_name` text,
  `start_date` date,
  `close_date` date,
  `active_flg` bigint DEFAULT NULL,
  `id_category` bigint DEFAULT NULL,
	 PRIMARY KEY (id_tem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SELLER.`ORDER` definition

CREATE TABLE `ORDER` (
  `order_id` MEDIUMINT NOT NULL AUTO_INCREMENT
  `order_code` bigint DEFAULT NULL,
  `date` date,
  `status` text,
  `total_value` bigint DEFAULT NULL,
  `taxes` bigint DEFAULT NULL,
  `id_customer` bigint DEFAULT NULL,
  `id_seller` bigint DEFAULT NULL,
	PRIMARY KEY (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- SELLER.ORDER_ITEM definition

CREATE TABLE `ORDER_ITEM` (
  `order_id` INT,
  `id_item` double DEFAULT NULL,
  `quantity` double DEFAULT NULL,
  `value` double DEFAULT NULL,
	PRIMARY KEY (order_id,id_item)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- SELLER.PHONE definition

CREATE TABLE `PHONE` (
  `id_phone` MEDIUMINT NOT NULL AUTO_INCREMENT,
  `number` bigint DEFAULT NULL,
  `type` bigint DEFAULT NULL,
  `customer_id` bigint DEFAULT NULL,
		PRIMARY KEY (id_phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;