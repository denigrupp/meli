#1. Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500. 
 

	SELECT cm.email,
		   cm.name,DATE_FORMAT(birth_date, '%m%d') birthday,
		   SUM(CASE WHEN DATE BETWEEN '2020-01-01' AND '2020-01-31' THEN total_value else 0 end ) sell_jan
	FROM SELLER.ORDER c
	INNER JOIN CUSTOMER cm
	ON c.id_CUSTOMER= cm.id_CUSTOMER
	WHERE DATE_FORMAT(birth_date, '%m%d') =  DATE_FORMAT(now(), '%m%d')
	GROUP BY cm.email,cm.name,birth_date
	HAVING SUM(CASE WHEN DATE 
				BETWEEN '2020-01-01' 
					AND '2020-01-31' THEN total_value else 0 end ) > 1500

#2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares. 
#Se requiere el mes y año de análisis, nombre y apellido del vendedor,
#cantidad de ventas realizadas, cantidad de productos vendidos y el monto total transaccionado. 
					
#Criar uma cte com os dados trabalhados para poder rankear					
with cte as (
	SELECT cm.name,
		   cm.last_name,
		   DATE_FORMAT(c.DAte, '%Y%m') month_2020,
	 	   SUM(oi.quantity) qtd,
	 	   SUM(oi.value) value
	FROM SELLER.ORDER c
	INNER JOIN SELLER cm ON c.ID_seller= cm.ID_seller	
	INNER JOIN ORDER_ITEM oi On oi.order_id = c.order_id	
	INNER JOIN ITEM it on oi.id_item = it.id_tem
	LEFT JOIN CATEGORY ct on it.id_category = ct.id_category
	WHERE ct.category = "SMARTPHONE" and c.DAte >= '2020-01-01' and  c.DAte < '2020-02-01'
	GROUP BY cm.name,
		   cm.last_name,
		   DATE_FORMAT(c.DAte, '%Y%m')	
		   
 )
 #Cria um ranking por mes e ano ordenando por valor
 , cte2 as (
 SELECT name,
 		last_name,
 		month_2020,
 		qtd,
 		value,
 		RANK() OVER (PARTITION BY month_2020 order by value desc) ranking
 FROM cte
 )
 SELECT *, qtd*value monto_total FROM cte2 where ranking < 6

#3. Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día.
#Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, 
#vamos a tener únicamente el último estado informado por la PK definida. (Se puede resolver a través de StoredProcedure) 
 
 CREATE TABLE SELLER.price_history
 (
   id MEDIUMINT NOT NULL AUTO_INCREMENT,
   sku CHAR(30) NOT NULL,
   value decimal(20,4) NOT NULL,
   date_price date NOT NULL,
   date_processing datetime NOT NULL,
   PRIMARY KEY (id)
 )
 
 #BEGIN - DELETA SE TIVER DADOS DE HOJE
 CREATE PROCEDURE sp_precio()
BEGIN
 DELETE FROM SELLER.price_history; #WHERE date_price = DATE_FORMAT(now(), '%Y%m%d')
 
 #insert com cte filtrando apenas os ultimos dados de preço por sku
 INSERT INTO SELLER.price_history  (sku,value,date_price,date_processing )
 with cte as (
 SELECT it.sku,
 oi.value,
 DATE_FORMAT(now(), '%Y%m%d') as date_price,
 now()  as date_processing,
 ROW_NUMBER() OVER (PARTITION BY it.sku order by c.date  desc) dedup
 FROM ORDER_ITEM oi
 INNER JOIN ITEM it on oi.id_item = it.id_tem  
 INNER JOIN SELLER.ORDER c ON oi.order_id = c.order_id
 #where c.date = DATE_FORMAT(now(), '%Y%m%d')
 )
SELECT sku,value,date_price,date_processing 
FROM cte where dedup = 1;
END
 
