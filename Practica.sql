--El != significa diferente de mexico, entonces mostrara todos los datos diferente a mexico
SELECT *
FROM Customers
WHERE Country != "Mexico"

--Consultammos rangos con el AND
SELECT *
FROM Products
WHERE Price >= 20 and Price <= 30

--Pero hay otra forma de hacerlo pero mas optimo, con BETWEEN define los rangos que requerimos 
SELECT *
FROM Products
WHERE Price BETWEEN 20 and 30

--Colocamos los rangos con BETWEEN y ademas que sea de la categotia 3
SELECT *
FROM Products
WHERE Price BETWEEN 20 and 30 and CategoryID = 3

--Definimos que no de todos, pero no queremos los que estan entre el 20 y 30
SELECT *
FROM Products
WHERE Price NOT BETWEEN 20 and 30

-------------------COMODINES CON EL LIKE------------------------

--like es un buscador o como si fuera el =, en este caso debemos de buscarlo tal como esta guardado la palabra
--no debe de tener espacios no otro caracter
SELECT *
FROM Employees
WHERE FirstName like "Nancy"

--Pero con el like podemos poner comodines, uno seria el %, esto funciona para buscar si es que hay otros cacateres antes
SELECT *
FROM Employees
WHERE FirstName like "%ancy"
--Podemos buscar con que termines cierto carater
SELECT *
FROM Employees
WHERE FirstName like "%y"
--O que empiece con cierto caracter
SELECT *
FROM Employees
WHERE FirstName like "N%"
--Incluso letras que esten dentro de la palabra
SELECT *
FROM Employees
WHERE FirstName like "%an%"

--El otro comodin es el ____, es como si fuera el juego del ahorcado, tenemos que saber EXACTAMENTE la cantidad de letras
--que contine la palabra para poder buscarlo, de lo contrario no funciona.
--Por ejeplo aqui busque que me regrese el primer nombre con nancy, tiene 5 letras, pongo la primera n
SELECT *
FROM Employees
WHERE FirstName like "N____"
--Podemos poner la letra en la posision que quieramos, oviamente si sabemos exactamente en donde va
SELECT *
FROM Employees
WHERE FirstName like "___c_"

-------------------IS NULL, NOT NULL-----------------------------

--El is null muestra todos los cambos que estan vacios, mientras que el is NOT NULL muestra los que no estan vacios (los que tienen datos)
SELECT *
FROM Employees
WHERE FirstName is NULL
SELECT *
FROM Employees
WHERE FirstName is not NULL

--------------------IN, NOT IN-----------------------------------

--El IN funciona como el = pero para que no este uno colocando uno por 1 lo que queremos buscar se coloca el IN y ()
SELECT *
FROM Products
WHERE ProductID IN (1,2,3,6)
SELECT *
FROM Products
WHERE Price IN (22,13,11,33,12)
SELECT *
FROM Products
WHERE ProductName IN ("Chais","Tofu")

--El NOT IN es para decir a lo contrario de IN, muestrame todo menos lo que te indico
SELECT *
FROM Products
WHERE ProductName NOT IN ("Chais","Tofu")

--El count cuenta la cantidades 
SELECT count(ProductName) as total_de_productos
FROM Products

-- el sum es para sumar 
SELECT sum(Price) AS TOTAL_DE_PRODUCTOS
FROM Products

--Con el round redondea el numero con decimales
SELECT round(sum(Price)) as total_suma_entero
FROM Products

--Muestra el precio mas bajo de los productos
SELECT min(Price) as precio_minimo
FROM Products

--Muestra el precio mas alto de los productos
SELECT max(Price) as precio_maximo
FROM Products

------------------EXCERSICE----------------------

---Dime el total de la cantidad de los productos junto con su ID
SELECT ProductID, sum(Quantity)
FROM OrderDetails

---Dime el total de la cantidad de los productos junto con su ID, Pero ahora solo dime el total por cada prodcuto
--En este caso entonces tenemos agruparlos por el ID de cada producto
SELECT ProductID, sum(Quantity) as TOTAL
FROM OrderDetails
GROUP BY ProductID

---Dime el total de la cantidad de los productos junto con su ID, Pero ahora solo dime el total por cada prodcuto
--En este caso entonces tenemos agruparlos por el ID de cada producto.
--Pero tambien quiero que me los agrupes por los totales(catidades) de los productos que se vendieron.
--En este caso como es la funcion sum(Quantity), pero tiene un alias, entonces solo ponemos el alias
SELECT ProductID, sum(Quantity) as TOTAL
FROM OrderDetails
GROUP BY ProductID
ORDER BY TOTAL

---Dime el total de la cantidad de los productos junto con su ID, Pero ahora solo dime el total por cada prodcuto
--En este caso entonces tenemos agruparlos por el ID de cada producto.
--Pero tambien quiero que me los agrupes por los totales(catidades) de los productos que se vendieron.
--En este caso como es la funcion sum(Quantity), pero tiene un alias, entonces solo ponemos el alias.
--Pero solo quiero que me muestre solo unos, quiero que me digas los que tienes menos cantidades vendidas, los 19 menores
SELECT ProductID, sum(Quantity) as TOTAL
FROM OrderDetails
GROUP BY ProductID
HAVING TOTAL < 19
ORDER BY TOTAL


---Dime el total de la cantidad de los productos junto con su ID, Pero ahora solo dime el total por cada prodcuto
--En este caso entonces tenemos agruparlos por el ID de cada producto.
--Pero tambien quiero que me los agrupes por los totales(catidades) de los productos que se vendieron.
--En este caso como es la funcion sum(Quantity), pero tiene un alias, entonces solo ponemos el alias.
--Pero solo quiero que me muestre solo unos, quiero que me digas los que tienes menos cantidades vendidas, los 19 menores
--Y en dado caso que solo quiero un solo entonces con el LIMIT
SELECT ProductID, sum(Quantity) as TOTAL
FROM OrderDetails
GROUP BY ProductID
HAVING TOTAL < 19
ORDER BY TOTAL
LIMIT 1

--Dime el total de la cantidad de los productos junto con su ID, Pero ahora solo dime el total por cada prodcuto
--En este caso entonces tenemos agruparlos por el ID de cada producto.
--Pero tambien quiero que me los agrupes por los totales(catidades) de los productos que se vendieron.
--En este caso como es la funcion sum(Quantity), pero tiene un alias, entonces solo ponemos el alias.
--Pero solo quiero que me muestre solo unos, quiero que me digas los que tienes mayor 40 y menor a 80
SELECT ProductID,
    sum(Quantity) as TOTAL FROM OrderDetails 
GROUP BY ProductID
HAVING TOTAL BETWEEN 40 and 80
ORDER BY TOTAL

----------------------------------Subconsultas-------------------------------
--Queremos saber la cantidad vendida por daca producto y sus nombres
--Pero tambien queremos la cantidad recaudada por cada producto, entonces vamos hacer una oprecion con la consulta
SELECT ProductID,
    (SELECT ProductName
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Nombre,
    sum(Quantity) as Cantidad_Vedida,
    (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Precio,
    sum(Quantity) * (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Cantidad_recaudada
FROM OrderDetails
GROUP by ProductID
ORDER by Cantidad_Vedida DESC

--Ahora quiero que me muestre arriba de 5000 las cantidades recaudadas para saber que recaudo mas
--Pero como contiene funciones de sum no puedo usar el WHERE para condiones, entonces usaremos HAVING con su alias
SELECT ProductID,
    (SELECT ProductName
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Nombre,
    sum(Quantity) as Cantidad_Vedida,
    (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Precio,
    sum(Quantity) * (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Cantidad_recaudada
FROM OrderDetails
GROUP by ProductID
HAVING Cantidad_recaudada >=5000
ORDER by Cantidad_Vedida DESC

--Que pasa si no quiero mostrar el precio pero quiero hacer una condicion con ese campo y esta en otra tabla
--Colocamos el WHERE con una consulta.
SELECT ProductID,
    (SELECT ProductName
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) as Nombre,
    sum(Quantity) as Cantidad_Vedida,
    round(sum(Quantity) * (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID)) as Cantidad_recaudada
FROM OrderDetails
WHERE (SELECT Price
FROM Products
WHERE ProductID = OrderDetails.ProductID) < 10
GROUP by ProductID
ORDER by Cantidad_Vedida DESC

--Podemos hacer consultas dentro de otras consultas para hacer sonsultas especificas y mas pequeñas
--Y podemos hacer condiciones al final
SELECT Nombre, Cantidad_Vedida
FROM(
SELECT ProductID,
        (SELECT ProductName
		FROM Products
        WHERE ProductID = OrderDetails.ProductID) as Nombre,
        sum(Quantity) as Cantidad_Vedida,
        round(sum(Quantity) * (SELECT Price
        FROM Products
        WHERE ProductID = OrderDetails.ProductID)) as Cantidad_recaudada
    FROM OrderDetails
    WHERE (SELECT Price
    FROM Products
    WHERE ProductID = OrderDetails.ProductID) < 10
    GROUP by ProductID
    ORDER by Cantidad_Vedida DESC
	)
WHERE Cantidad_Vedida > 100

------------------------------------EXCERSICE---------------------------------------
--Dime que empleados lograron vender mas unidades que otros
--En este ejercicio vamos a tener que unir 3 tablas, Employees,Orders,OrderDetails
--Cantidades estan en OrderDetails
--Empleados esta en Employees
--Y Orders es el puente donde tenemos que pasar y comparar para unir los datos
SELECT EmployeeID, FirstName,
		(
		SELECT sum(OrderDetails.Quantity) FROM Orders, OrderDetails --Colocamos la tablas por que las usaremos
		WHERE Orders.EmployeeID = Employees.EmployeeID and Orders.OrderID = OrderDetails.OrderID
		) as Unidades_Vendidas
		FROM Employees
		ORDER bY Unidades_Vendidas DESC
		
---------------------------------------INNER JOIN ----------------------------------------------
--Dime las ordesnes de los empleados, en las fechas
--El INNER JOIN es por decir que se unen las dos tablas 

SELECT OrderID, FirstName, OrderDate FROM Employees INNER JOIN Orders
				ON Employees.EmployeeID = Orders.EmployeeID


--Creacion de una tabla
CREATE TABLE "Rewards" (
"RewarsID" INTEGER,
"EmployeeID" INTEGER,
"Rewars" INTEGER,
"Month" TEXT,
PRIMARY KEY ("RewarsID" AUTOINCREMENT)
)

--iNSERTA DATOS 
INSERT INTO Rewards 
	(EmployeeID, Rewars, Month) VALUES
	(3,200,"Junuary"),
	(2,180,"Febrary"),
	(5,250,"March"),
	(1,280,"April"),
	(8,160,"May"),
	(NULL,NULL,NULL)
	

SELECT * FROM Rewards
--Muestrame los empreados que ganaron recompensas este año, el nombre, mes, y cuanto ganaron
--Para eso hay que unir la tabla de empleados y la de recompesas	
--Para que me muestre solo los datos de una sola tabla y un aparte de la otra tablas usamos inner JOIN			
SELECT FirstName, Rewars as recompesas, Month FROM Employees INNER JOIN Rewards
				ON Rewards.EmployeeID = Employees.EmployeeID
				
				
--Con el LEFT JOIN muestra todos los datos de ambas tablas aun que esten o no con datos
SELECT FirstName, Rewars as recompesas, Month FROM Employees LEFT JOIN Rewards
				ON Rewards.EmployeeID = Employees.EmployeeID
				
UNION --El UNION funciona para unir dos consultas
				
--Exite el RIGHT JOIN pero en sql lite no se encuentra la palabra.
--Pero para esto solo hay que invertir los nombres de las tablas para que los leaa arrebes			
SELECT FirstName, Rewars as recompesas, Month FROM Rewards LEFT JOIN Employees
				ON Rewards.EmployeeID = Employees.EmployeeID
				
-----------------------INDICES--------------------------

--Con el index lo que hace es hacer las busquedas mas rapidas
CREATE INDEX name on Employees (FirstName,LastName)

--Con el UNIQUE INDEX hace que el nombre y el apellido no se repitan, si pero debe se ser diferente uno del otro
CREATE UNIQUE INDEX Apellido on Employees (FirstName,LastName)
SELECT * FROM Employees

--Para eliminar los indices ocupamos DROP
DROP INDEX name
DROP INDEX Apellido

------------------------------------VISTAS---------------------------------------
---Hcemos una consulta y de ahi creamos una vista
CREATE VIEW Productos_simplificados AS

SELECT ProductID, ProductName, Price FROM Products
WHERE ProductID <20
ORDER by ProductID DESC

SELECT * FROM Productos_simplificados

--Para eliminar una vista es con DROP o IF EXISTS

DROP VIEW Productos_simplificados
DROP VIEW IF EXISTS Productos_simplificados --Hace dos pasos y ocupa mas rendimiento, primero verifica si existe la vista

