select customername, concat(employees.firstname,' ',employees.lastname) as "Sales Rep"
from employees, customers
where customers.salesrepemployeenumber = employees.employeenumber;
select customername, concat(employees.firstname,' ',employees.lastname) as "Sales Rep", offices.city as "Sales Rep City",
offices.state as "Sales Rep State"
from employees, customers, offices
where customers.salesrepemployeenumber = employees.employeenumber
and 
employees.officecode = offices.officecode;
/*Find the most expensive model in the classic cars product line*/
select c.customernumber,c.customername, o.ordernumber from customers c left join 
orders o on c.customernumber = o.customernumber;
select productname,buyprice from products 
where productline = 'Classic Cars' and 
buyprice =  (select max(buyprice) from products where productline = 'Classic Cars');
/*find all customers who have never bought classic cars*/
select c.customername from customers c where c.customernumber not in (
select distinct o.customernumber from orderdetails od,orders o, products p where od.ordernumber = o.ordernumber
and od.productcode = p.productcode and p.productline = 'Classic Cars');
/*Connect all the tables together and then specify about the product line and then do a set difference */

select * from orders where orderdate ::text like '%2005%' order by status desc, orderdate;

/*How many customers are there from each country among those countries with more than 5 customers*/
select country,count(customernumber) from customers group by country having count(customernumber) >5;

/*How many orders are there from each office*/
select o.officecode, count(od.ordernumber)
from employees e, customers c, offices o, orders od where 
o.officecode = e.officecode and c.salesrepemployeenumber = e.employeenumber and od.customernumber = c.customernumber
group by o.officecode;
/*Sort all orders by order date*/
select * from orders order by orderdate;
select productname, (msrp - buyprice) as discount from products;
select productname,productcode, buyprice, productline, msrp, msrp * buyprice as "Total" from products where quantityinstock >600;
select concat(e.firstname,' ',e.lastname) as employeeName, e.jobtitle,e.email,c.customername,c.creditlimit
from employees e left join customers c on
e.employeenumber = c.salesrepemployeenumber where c.creditlimit > 20000;
select productvendor, avg(msrp-buyprice) as "Average Vendor Discount" from products group by productvendor;
/*Find the number of customers that each employee represents. 
The results of your query should be 
(employee number, number of customers that the employee represents).*/
Select concat(e.firstname,' ',e.lastname) as employeeName,count(c.customernumber) 
from employees e, customers c 
where e.employeenumber = c.salesrepemployeenumber
group by employeeName;
/*How many payments have been made by each customer? 
Show the customer name and the number of payments that customer has made.
*/
select c.customernumber,c.customername,count(p.customernumber) from customers c, payments p 
where p.customernumber = c.customernumber
group by c.customernumber, c.customername;
/*Find all orders that shipped in December 2004. 
Note: to do string pattern matching against a date column d1, you can do d1::text LIKE 'yyyy-mm-dd' in the WHERE clause. 
The ::text is a type cast that tells SQL to treat the date value as a string.*/
select * from orderdetails;
Select ordernumber, shippeddate from orders where shippeddate::text LIKE '2004-12-%';
/*Find the number, order date, & status of all orders not shipped*/
select ordernumber, orderdate, status from orders where status != 'Shipped';
/*Find the productCode and total price (quantity times price each) of each item in the order details table 
sorted with highest total price at the top.*/
select productcode, (quantityordered * priceeach) as totalPrice
from orderdetails;
/*Find all employees who report to Anthony Bow. List the employees’ full names.
*/
select * from employees;
Select concat(e1.firstname,' ',e1.lastname) as employeeName from employees e1
where e1.reportsto = (select employeenumber from employees where firstname = 'Anthony' 
															   and lastname = 'Bow');
															   
/*Find all payments greater than $100,000 along with the associated customers who made the payments. 
Sort them with the highest payment at the top. 
Display paymentDate, amount, customerName. Use the payments table.
*/
select * from payments;
select c.customername,p.amount,p.paymentdate from customers c, payments p 
where c.customernumber = p.customernumber and amount > 100000 
order by amount desc;
/*List all products ordered by customer Herkku Gifts, sorted by order date.
Display productName, quantityOrdered, priceEach, orderDate*/

