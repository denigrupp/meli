-- SELLER.CATEGORY definition

CREATE TABLE CATEGORY (
  id_category int NOT NULL AUTO_INCREMENT,
  cod_category int DEFAULT NULL,
  category int,
  type int
)  

-- SELLER.CUSTOMER definition

CREATE TABLE CUSTOMER (
  id_customer int NOT NULL AUTO_INCREMENT,
  email int,
  name int,
  last_name int,
  address int,
  birth_date date,
  type int DEFAULT NULL,
  seller_flg int DEFAULT NULL,
  sexo int,
	 PRIMARY KEY (id_customer)
)  


-- SELLER.ITEM definition

CREATE TABLE ITEM (
  id_tem int NOT NULL AUTO_INCREMENT,
  sku int DEFAULT NULL,
  product_name int,
  start_date date,
  close_date date,
  active_flg int DEFAULT NULL,
  id_category int DEFAULT NULL,
	 PRIMARY KEY (id_tem)
) 

-- SELLER.ORDER definition

CREATE TABLE ORDER (
  order_id int NOT NULL AUTO_INCREMENT
  order_code int DEFAULT NULL,
  date date,
  status int,
  total_value int DEFAULT NULL,
  taxes int DEFAULT NULL,
  id_customer int DEFAULT NULL,
  id_seller int DEFAULT NULL,
	PRIMARY KEY (order_id)
   cart_id int
)  


-- SELLER.ORDER_ITEM definition

CREATE TABLE ORDER_ITEM (
 order_item_id int NOT NULL AUTO_INCREMENT,	
  order_id INT,
  id_item double DEFAULT NULL,
  quantity double DEFAULT NULL,
  value double DEFAULT NULL,
	PRIMARY KEY (order_id,id_item)
)  


-- SELLER.PHONE definition

CREATE TABLE PHONE (
  id_phone int NOT NULL AUTO_INCREMENT,
  number int DEFAULT NULL,
  type int DEFAULT NULL,
  customer_id int DEFAULT NULL,
		PRIMARY KEY (id_phone)
)  

CREATE TABLE PAYMENT (
	id_payment int  NOT NULL AUTO_INCREMENT,
	payment varchar(299)  NOT NULL 
	)
CREATE TABLE ORDER_PAYMENT (
	id_order_payment int  NOT NULL AUTO_INCREMENT,
	id_order int,
	id_payment int
	)

CREATE TABLE SELLER (
  id_seller int NOT NULL AUTO_INCREMENT,
  email int,
  name int,
  last_name int,
  address int,
  birth_date date,
  type int DEFAULT NULL,
  seller_flg int DEFAULT NULL,
  sexo int,
	 PRIMARY KEY (id_customer)
) 

CREATE TABLE ORDER_ITEM_SHIPPING (
  order_shipping_id int NOT NULL AUTO_INCREMENT,
  order_item_id int,
  expected_date date,
  delivery_date date
)  

CREATE TABLE CART
(
cart_id INT NOT NULL AUTO_INCREMENT,
cart_value decimal(20,4),
status varchar(100))	

CREATE TABLE CART_ITEM
(
cart_id INT NOT NULL AUTO_INCREMENT,
product_id int,
quantity decimal(10,2))	

CREATE TABLE PRODUCT_IMAGE
(
image_id INT NOT NULL AUTO_INCREMENT,
product_id int,
description text)

	
