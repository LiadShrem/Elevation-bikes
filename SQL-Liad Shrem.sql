--1
-- הצגה של המוצרים בחברה כולל מחירם והרווח
SELECT p.ProductName as 'Name',
       p.ModelName as 'Model',
       p.ProductColor+ ',' +convert(varchar,p.ProductSize)+ ',' +convert(varchar,p.ProductCost) as 'Properties',
       p.ProductPrice as 'Price',
       p.ProductPrice-p.ProductCost as 'NetProfit'
FROM Production.Products as p

--2
-- ארצה לספק לממונה עליי את הרווח של כל מוצר לפי סינון מסויים
SELECT p.ProductName as 'Name',
       p.ModelName as 'Model',
       p.ProductColor+ ',' +convert(varchar,p.ProductSize)+ ',' +convert(varchar,p.ProductCost) as 'Properties',
       p.ProductPrice as 'Price',
       p.ProductPrice-p.ProductCost as 'NetProfit',
       cast (((p.ProductPrice-p.ProductCost)/p.ProductPrice) as DECIMAL(10,2)) as 'ProfitMargin'
FROM Production.Products as p
WHERE p.ProductColor in ('Black','Red','White') or p.ProductSize like 'L'

--3
-- כמה סה"כ יחידות נמכרו בשנת 2016 וכמה הזמנות שונות בוצעו במהלך שנה זו
SELECT sum(s.OrderQuantity) as 'Total_units_sold',COUNT( distinct s.OrderNumber) as 'Total_orders_Made'
from sales.sales as s
where year(s.OrderDate)=2016 and DATEPART(QUARTER,s.OrderDate)>2

--4
select count(distinct p.ProductID) as 'Unsold_Products'
from Production.Products as p left join Sales.Sales as s 
on p.ProductID=s.ProductID
where p.ProductID not in (select s.ProductID
                          from sales.sales as s
                           WHERE year(s.OrderDate)=2017)


--5
select s.Order_Status,COUNT(s.Order_Status) as 'Row_Count'
from sales.sales as s
where s.OrderQuantity>1 and s.Order_Status != 'ok'
group by s.Order_Status

--6
select top 3 p.ProductName,SUM(sr.ReturnQuantity) as 'Total_units_returned'
from Production.Products as p INNER join Sales.[Returns] as sr 
on p.ProductID=sr.ProductID
group by p.ProductName
ORDER by Total_units_returned desc

--7
select sc.EducationLevel,sc.Gender,count(*)
from Sales.Customers as sc
where sc.Gender is not null
group by sc.EducationLevel,sc.Gender 
order by sc.EducationLevel, sc.Gender 

--8
select top 5 ss.FirstName , sum(s.OrderQuantity) as 'Total_units_sold'
from Sales.Staff as ss INNER join Sales.Sales as s
on ss.StaffMemberID=s.SoldBy
GROUP by ss.FirstName
order BY Total_units_sold desc

--9
select top 1 p.ProductColor,sum(s.OrderQuantity) as 'Total_units_sold'
from Production.Products as p inner join sales.Sales as s
on p.ProductID=s.ProductID
where p.ProductColor is not null
group by p.ProductColor
ORDER by Total_units_sold desc

--10
select sc.FirstName+' '+sc.LastName as 'CustomerName',
       cast(sum(ss.OrderQuantity* p.ProductPrice) as decimal(10,2)) 'Total_spent'
from sales.Sales as ss inner join sales.Customers as sc
on ss.CustomerKey=sc.CustomerID
inner join Production.Products as p 
on ss.ProductID=p.ProductID
group by sc.CustomerID,sc.FirstName+' '+sc.LastName
ORDER by Total_spent desc

--11
select pc.CategoryName,round(sum(pp.ProductCost*s.OrderQuantity),0) as 'Total_Cost'
from Production.Categories as pc inner join Production.SubCategories as ps
on pc.CategoryID=ps.CategoryID
inner join Production.Products as pp 
on ps.SubcategoryID =pp.SubcategoryID
inner join Sales.Sales as s
on pp.ProductID=s.ProductID
GROUP by pc.CategoryName
ORDER by Total_Cost desc


--12
select month(s.OrderDate) as 'Order_Month',
       count( distinct s.OrderNumber) as 'Orders_made',
       sum(s.OrderQuantity) as 'Units_sold'
from Production.Categories as pc INNER join Production.SubCategories as ps
on pc.CategoryID=ps.CategoryID
inner join Production.Products as pp 
on ps.SubcategoryID=pp.SubcategoryID 
inner join sales.Sales as s
on pp.ProductID=s.ProductID
where pc.CategoryName like 'clothing'
group by month(s.OrderDate)
ORDER by Order_Month 

