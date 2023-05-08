---- ��X�M�̶Q�����~�P���O���Ҧ����~
--select * from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc);

---- ��X�M�̶Q�����~�P���O�̫K�y�����~
--select top 1 * from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) order by UnitPrice;

---- �p��X�W�����O�̶Q�M�̫K�y����Ӳ��~�����t
--select max(UnitPrice)-min(UnitPrice)  from Products where CategoryID = (select top 1 CategoryID from Products order by UnitPrice desc) ;

---- ��X�S���q�L����ӫ~���Ȥ�Ҧb���������Ҧ��Ȥ�
--select CustomerID from Customers c where not exists (select CustomerID from Orders o where o.CustomerID = c.CustomerID);

-- ��X�� 5 �Q��� 8 �K�y�����~�����~���O
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

-- ��X�ֶR�L�� 5 �Q��� 8 �K�y�����~
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


-- ��X�ֽ�L�� 5 �Q��� 8 �K�y�����~
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


-- ��X 13 ���P�������q�� (�c�]���q��)
--SELECT *,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate

-- ��X�֭q�F�c�]���q��

--SELECT CompanyName,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate
--INNER join Customers c on o1.CustomerID = c.CustomerID  
---- ��X�c�]���q��̦����򲣫~

--SELECT CompanyName,DATEPART(DAY, o1.OrderDate) as day,DATEPART(WEEKDAY, o1.OrderDate) as week
--FROM Orders o1
--INNER JOIN Orders o2 ON DATEPART(DAY, o1.OrderDate) = 13
--AND DATEPART(WEEKDAY, o1.OrderDate) = 5
--AND o1.OrderDate = o2.OrderDate
--INNER join Customers c on o1.CustomerID = c.CustomerID  


-- �C�X�q�ӨS������ (Discount) �X�⪺���~
--SELECT ProductID, MAX(Discount) AS max_discount
--FROM [Order Details]
--GROUP BY ProductID
--HAVING MAX(Discount) = 0;


-- �C�X�ʶR�D���ꪺ���~���Ȥ�
--select distinct c.CustomerID,c.Country,s.Country from Orders o
--inner join Customers c on o.CustomerID = c.CustomerID
--inner join [Order Details] od on o.OrderID = od.OrderID 
--inner join Products p on p.ProductID = od.ProductID
--inner join Suppliers s on p.SupplierID = s.SupplierID
--where c.Country = s.Country

-- �C�X�b�P�ӫ����������q���u�i�H�A�Ȫ��Ȥ�
--select c.CustomerID from Customers c
--full outer join Employees e on c.City = e.City
--where c.City = e.City

-- �C�X���ǲ��~�S���H�R�L
--select * from Products p
--left join [Order Details] od on p.ProductID = od.ProductID
--left outer join Orders o on  od.OrderID = o.OrderID
--where o.OrderDate = null
--order by p.ProductID
-------------------------------------------------------------------- --------------------
-- �C�X�Ҧ��b�C�Ӥ�멳���q��

--select OrderID,OrderDate from Orders 
--group by OrderDate ,OrderID
--having OrderDate = EOMONTH(OrderDate) 
-- �C�X�C�Ӥ�멳��X�����~
--select distinct p.ProductID
--from (
--	select OrderID,OrderDate from Orders 
--	group by OrderDate ,OrderID
--	having OrderDate = EOMONTH(OrderDate) ) as lastday
--	inner join [Order Details] od on lastday.OrderID = od.OrderID
--	inner join Products p on p.ProductID = od.ProductID


-- ��X���ѹL�̶Q���T�Ӳ��~��������@�Ӫ��e�T�Ӥj�Ȥ�
--select c.CustomerID, od.UnitPrice * od.Quantity as total
--from Customers c 
--inner join orders o on c.CustomerID = o.CustomerID
--inner join [Order Details] od on o.OrderID = od.OrderID
--inner join Products p on od.ProductID=p.ProductID
--where p.ProductID in (select ProductID from Products order by UnitPrice desc offset 0 Rows fetch first 3 Rows only)
--order by total desc
--offset 0 Rows fetch first 3 rows only
-- ��X���ѹL�P����B�e�T���Ӳ��~���e�T�Ӥj�Ȥ�
--select o.CustomerID from (select ProductID from [Order Details] group by ProductID order by SUM(UnitPrice * Quantity*(1 - Discount)) desc offset 0 rows fetch first 3 rows only) as hightthree
--inner join [Order Details] od on hightthree.ProductID = od.ProductID
--inner join Orders o on o.OrderID = od.OrderID
--group by o.CustomerID
--order by SUM(od.UnitPrice * od.Quantity*(1 - od.Discount))
--desc offset 0 rows fetch first 3 rows only

-- ��X���ѹL�P����B�e�T���Ӳ��~�������O���e�T�Ӥj�Ȥ�
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

-- �C�X���O�`���B����Ҧ��Ȥᥭ�����O�`���B���Ȥ᪺�W�r�A�H�ΫȤ᪺���O�`���B
--SELECT CustomerID, allcost
--FROM (
--	SELECT o.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS allcost, AVG(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) OVER() AS costavg
--	FROM Orders o 
--	INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
--	GROUP BY o.CustomerID
--) AS CustomerCost
--WHERE allcost > costavg

-- �C�X�̼��P�����~�A�H�γQ�ʶR���`���B
--select p.ProductID,sum(od.Quantity * od.Discount * od.UnitPrice) as allcost
--from Products p
--inner join [Order Details] od on p.ProductID = od.ProductID
--group by p.ProductID
--order by sum(od.Quantity) desc
--offset 0 rows fetch first 1 rows only

-- �C�X�̤֤H�R�����~
--select p.ProductID from Products p
--inner join [Order Details] od on p.ProductID = od.productid 
--inner join Orders o on od.OrderID = o.OrderID 
--inner join Customers c on o.CustomerID = c.CustomerID
--group by p.ProductID
--order by COUNT(c.CustomerID)
--offset 0 rows fetch first 1 rows only

-- �C�X�̨S�H�n�R�����~���O (Categories)
--select cate.CategoryName  from Categories cate
--inner join Products p on cate.CategoryID = p.CategoryID
--inner join [Order Details] od on p.ProductID = od.productid 
--inner join Orders o on od.OrderID = o.OrderID 
--inner join Customers c on o.CustomerID = c.CustomerID
--group by cate.CategoryName
--order by COUNT(c.CustomerID)
--offset 0 rows fetch first 1 rows only

-- �C�X��P��̦n�������ӶR�̦h���B���Ȥ�P�ʶR���B (�t�ʶR�䥦�����Ӫ����~)

-- �C�X��P��̦n�������ӶR�̦h���B���Ȥ�P�ʶR���B (���t�ʶR�䥦�����Ӫ����~)

-- �C�X���ǲ��~�S���H�R�L

-- �C�X�S���ǯu (Fax) ���Ȥ�M�������O�`���B

-- �C�X�C�@�ӫ������O�����~�����ƶq

-- �C�X�ثe�S���w�s�����~�b�L�h�`�@�Q�q�ʪ��ƶq

-- �C�X�ثe�S���w�s�����~�b�L�h���g�Q���ǫȤ�q�ʹL

-- �C�X�C����u���U�ݪ��~�Z�`���B

-- �C�X�C�a�f�B���q�B�e�̦h�����@�ز��~���O�P�`�ƶq
--select sh.ShipperID,p.CategoryID ,COUNT(p.ProductID)as categorirescount
--from Shippers sh
--inner join Orders o  on sh.ShipperID = o.ShipVia
--inner join [Order Details] od on o.OrderID = od.OrderID
--inner join Products p on od.ProductID =p.ProductID
--group by sh.ShipperID,p.CategoryID
--order by sh.ShipperID,p.CategoryID

-- �C�X�C�@�ӫȤ�R�̦h�����~���O�P���B

-- �C�X�C�@�ӫȤ�R�̦h�����@�Ӳ��~�P�ʶR�ƶq

-- ���ӫ��������A��X�C�@�ӫ����̪�@���q�檺�e�f�ɶ�

-- �C�X�ʶR���B�Ĥ��W�P�ĤQ�W���Ȥ�A�H�Ψ�ӫȤ᪺���B�t�Z

