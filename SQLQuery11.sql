---- 找出和最貴的產品同類別的所有產品
--select * from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc);

---- 找出和最貴的產品同類別最便宜的產品
--select top 1 * from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) order by UnitPrice;

---- 計算出上面類別最貴和最便宜的兩個產品的價差
--select max(UnitPrice)-min(UnitPrice)  from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) ;

---- 找出沒有訂過任何商品的客戶所在的城市的所有客戶
--select CustomerID from Customers c where not exists (select CustomerID from Orders o where o.CustomerID = c.CustomerID);

-- 找出第 5 貴跟第 8 便宜的產品的產品類別
--select ProductID , ProductName ,CategoryName  from (
--(select * from (SELECT ProductID,ProductName, CategoryID FROM Products ORDER BY UnitPrice DESC OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY) as fivecheap
--UNION ALL 
--select * from(SELECT ProductID,ProductName, CategoryID FROM Products ORDER BY UnitPrice OFFSET 7 ROWS FETCH NEXT 1 ROWS ONLY) as eightpoor) o
--inner join Categories c on o.CategoryID = c.CategoryID
--)


--select ProductID, CategoryName 
--from (
--	select UnitPrice,CategoryName,ProductID,
--	ROW_NUMBER() over (Order by unitprice desc ) as expensive,
--	ROW_NUMBER() over (Order by unitprice asc ) as cheap
--	from Products p 
--	inner join Categories c on p.CategoryID = c.CategoryID
--)AS subquerry
--where expensive = 5 or cheap = 8

-- 找出誰買過第 5 貴跟第 8 便宜的產品
--select DISTINCT c.CustomerID
--from (
--	select ProductID,UnitPrice,CategoryName,
--	ROW_NUMBER() over (Order by unitprice desc ) as expensive,
--	ROW_NUMBER() over (Order by unitprice asc ) as cheap
--	from Products p 
--	inner join Categories c on p.CategoryID = c.CategoryID
--)AS subquerry
--inner join [Order Details] od on subquerry.ProductID = od.ProductID
--inner join Orders o on od.OrderID = o.OrderID
--inner join Customers c on o.CustomerID = c.CustomerID 
--where expensive = 5 or cheap = 8


-- 找出誰賣過第 5 貴跟第 8 便宜的產品
--select DISTINCT e.EmployeeID
--from (
--	select ProductID,UnitPrice,CategoryName,
--	ROW_NUMBER() over (Order by unitprice desc ) as expensive,
--	ROW_NUMBER() over (Order by unitprice asc ) as cheap
--	from Products p 
--	inner join Categories c on p.CategoryID = c.CategoryID
--)AS subquerry 
--inner join [Order Details] od on subquerry.ProductID = od.ProductID
--inner join Orders o on od.OrderID = o.OrderID
--inner join Employees e on o.EmployeeID = e.EmployeeID 
--where expensive = 5 or cheap = 8


-- 找出 13 號星期五的訂單 (惡魔的訂單)
--SELECT *,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate

-- 找出誰訂了惡魔的訂單

--SELECT CompanyName,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate
--INNER join Customers c on o1.CustomerID = c.CustomerID  
---- 找出惡魔的訂單裡有什麼產品

--SELECT CompanyName,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate
--INNER join Customers c on o1.CustomerID = c.CustomerID  


-- 列出從來沒有打折 (Discount) 出售的產品
--SELECT ProductID, MAX(Discount) AS max_discount
--FROM [Order Details]
--GROUP BY ProductID
--HAVING MAX(Discount) = 0;


-- 列出購買非本國的產品的客戶
--select distinct c.CustomerID,c.Country,s.Country from Orders o
--inner join Customers c on o.CustomerID = c.CustomerID
--inner join [Order Details] od on o.OrderID = od.OrderID 
--inner join Products p on p.ProductID = od.ProductID
--inner join Suppliers s on p.SupplierID = s.SupplierID
--where c.Country = s.Country

-- 列出在同個城市中有公司員工可以服務的客戶
--select c.CustomerID from Customers c
--full outer join Employees e on c.City = e.City
--where c.City = e.City

-- 列出那些產品沒有人買過
--select * from Products p
--left join [Order Details] od on p.ProductID = od.ProductID
--left outer join Orders o on  od.OrderID = o.OrderID
--where o.OrderDate = null
--order by p.ProductID
-------------------------------------------------------------------- --------------------
-- 列出所有在每個月月底的訂單

--select OrderID,OrderDate from Orders 
--group by OrderDate ,OrderID
--having OrderDate = EOMONTH(OrderDate) 
-- 列出每個月月底售出的產品
--select distinct p.ProductID
--from (
--	select OrderID,OrderDate from Orders 
--	group by OrderDate ,OrderID
--	having OrderDate = EOMONTH(OrderDate) ) as lastday
--	inner join [Order Details] od on lastday.OrderID = od.OrderID
--	inner join Products p on p.ProductID = od.ProductID


-- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶
--select c.CustomerID, od.UnitPrice * od.Quantity as total
--from Customers c 
--inner join orders o on c.CustomerID = o.CustomerID
--inner join [Order Details] od on o.OrderID = od.OrderID
--inner join Products p on od.ProductID=p.ProductID
--where p.ProductID in (select ProductID from Products order by UnitPrice desc offset 0 Rows fetch first 3 Rows only)
--order by total desc
--offset 0 Rows fetch first 3 rows only
-- 找出有敗過銷售金額前三高個產品的前三個大客戶
--select o.CustomerID from (select ProductID from [Order Details] group by ProductID order by SUM(UnitPrice * Quantity*(1 - Discount)) desc offset 0 rows fetch first 3 rows only) as hightthree
--inner join [Order Details] od on hightthree.ProductID = od.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--group by o.CustomerID
--order by SUM(od.UnitPrice * od.Quantity*(1 - od.Discount))
--desc offset 0 rows fetch first 3 rows only

-- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶
--SELECT o.CustomerID
--FROM Products p 
--INNER JOIN (
--	SELECT p.CategoryID
--	FROM [Order Details] od
--	INNER JOIN Products p ON p.ProductID = od.ProductID
--	GROUP BY p.CategoryID
--	ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC
--	OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY
--) AS highthree on p.CategoryID = highthree.CategoryID 
--inner join [Order Details] od on p.ProductID = od.ProductID
--inner join Orders o on od.OrderID = o.OrderID
--group by o.CustomerID
--order by SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC
--OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY

-- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額
--SELECT CustomerID, allcost
--FROM (
--	SELECT o.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS allcost, AVG(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) OVER() AS costavg
--	FROM Orders o 
--	INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
--	GROUP BY o.CustomerID
--) AS CustomerCost
--WHERE allcost > costavg

-- 列出最熱銷的產品，以及被購買的總金額
--select p.ProductID,sum(od.Quantity * od.Discount * od.UnitPrice) as allcost
--from Products p
--inner join [Order Details] od on p.ProductID = od.ProductID
--group by p.ProductID
--order by sum(od.Quantity) desc
--offset 0 rows fetch first 1 rows only

-- 列出最少人買的產品
--select p.ProductID from Products p
--inner join [Order Details] od on p.ProductID = od.productid 
--inner join Orders o on od.OrderID = o.OrderID 
--inner join Customers c on o.CustomerID = c.CustomerID
--group by p.ProductID
--order by COUNT(c.CustomerID)
--offset 0 rows fetch first 1 rows only

-- 列出最沒人要買的產品類別 (Categories)
--select cate.CategoryName  from Categories cate
--inner join Products p on cate.CategoryID = p.CategoryID
--inner join [Order Details] od on p.ProductID = od.productid 
--inner join Orders o on od.OrderID = o.OrderID 
--inner join Customers c on o.CustomerID = c.CustomerID
--group by cate.CategoryName
--order by COUNT(c.CustomerID)
--offset 0 rows fetch first 1 rows only

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)

-- 列出那些產品沒有人買過

-- 列出沒有傳真 (Fax) 的客戶和它的消費總金額

-- 列出每一個城市消費的產品種類數量

-- 列出目前沒有庫存的產品在過去總共被訂購的數量

-- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過

-- 列出每位員工的下屬的業績總金額

-- 列出每家貨運公司運送最多的那一種產品類別與總數量
--select sh.ShipperID,p.CategoryID ,COUNT(p.ProductID)as categorirescount
--from Shippers sh
--inner join Orders o  on sh.ShipperID = o.ShipVia
--inner join [Order Details] od on o.OrderID = od.OrderID
--inner join Products p on od.ProductID =p.ProductID
--group by sh.ShipperID,p.CategoryID
--order by sh.ShipperID,p.CategoryID

-- 列出每一個客戶買最多的產品類別與金額

-- 列出每一個客戶買最多的那一個產品與購買數量

-- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間

-- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距

