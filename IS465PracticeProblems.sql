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
select p.productname,od.quantityOrdered,od.priceEach, o.orderDate from 
products p, orderdetails od, orders o where od.productCode = p.productCode 
and od.ordernumber = o.ordernumber and
o.customernumber = (select customernumber from customers 
						 where customerName = 'Herkku Gifts')
order by o.orderdate;
/*Without using a join, get a distinct list of employees who represent customers*/						 
 select concat(firstname,' ',lastname) as EmployeeName from employees where 
 employeenumber in (select distinct salesrepemployeenumber from customers); 
 /*Find the customer who made the highest payment and report their customer ID*/
select customernumber from payments where amount =(select Max(amount)from payments); 
/*Find the customer who made the highest payment, but this time 
project all payment fields, and order payments by amount from highest to lowest.
*/
select * from payments where customernumber in(
select customernumber from payments where amount =(select Max(amount)from payments)
);
/*Find the number of customers that each employee represents. 
The results of your query should be 
(employee number, number of customers that the employee represents).*/
select c.salesrepemployeenumber,count(*) from customers c
group by c.salesrepemployeenumber;
/*How many payments have been made by each customer? 
Show the customer name and the number of payments that customer has made.*/
select c.customername,count(*) numPayments from customers c, payments p
where c.customernumber = p.customernumber
group by customername 
order by numPayments desc;
/*List the total payments earned by each salesperson. 
Show the employee's name and the number of payments earned by them*/
select concat(e.firstname,' ',e.lastname) employeeName,count(*) numPayments, sum(amount) totalEarned
from employees e, payments p, customers c
where c.salesrepemployeenumber = e.employeenumber and c.customernumber = p.customernumber
group by employeeName;
/*Without using joins, find all customers who have shipped orders 
with a total order cost greater than $60,000.*/
Select customername from customers where customernumber in(select
customernumber from orders where ordernumber in (select ordernumber from orderdetails
													group by ordernumber having
													sum(quantityordered * priceEach) >60000));
/*Find the email addresses for employees Tom King and Barry Jones. 
The resulting tuples should be of the form (full name, email address). 
You should use their names in the query itself, i.e., 
don't find out what their IDs are and use the IDs in the query*/
Select concat(firstname,' ',lastname) fullname, email 
from employees where concat(firstname,' ',lastname) ='Tom King' 
or concat(firstname,' ',lastname) ='Barry Jones';
/*Find all orders from April, 2003. The resulting tuples should be of the form 
(order number, order date, status). Sort the tuples from most recent to least recent. */
Select ordernumber,orderDate,status from orders 
where orderdate::text like '2003-04-%'
order by orderdate desc;
/* Find all orders by customer Mini Classics. The resulting tuples should be of the form 
(order number, order date).*/
Select o.ordernumber,o.orderdate from orders o where customernumber = (
select customernumber from customers where customername = 'Mini Classics');
/* Find the number of products in the database that have been bought by at least one foreign customer.
Foreign customers have a country field whose value is not 'USA'. 
The result of your query should be a single number.*/
select count(productcode) numProducts from orderdetails where ordernumber in(
Select ordernumber from orders where customernumber in 
	(select customernumber from customers where country != 'USA'));
/* Find the car product(s) in the database with the lowest MSRP. 
All car products in the database have a product line that is either Classic Cars or Vintage Cars. 
The result(s) of your query should be of the form (product name, product line, MSRP).
*/
Select productname, productline,MSRP from products where productline in ('Classic Cars','Vintage Cars')
and msrp = (select min(msrp) from products);
/*Find all employees in the database who have made at least 25 sales 
(i.e. have been the salesperson for at least 25 customer orders). 
The results of your query should be of the form 
(employee first name, employee last name, number of sales). 
Name the number of sales column numSales. */
Select e.firstname,e.lastname,count(o.ordernumber) numSales
from employees e, customers c, orders o where
e.employeenumber = c.salesrepemployeenumber and 
c.customernumber = o.customernumber
group by e.firstname,e.lastname
having count(o.ordernumber) >=25;
/*For each customer, find the number of products from each product line that they have purchased. 
The results of your tuple should be of the form 
(customer name, product line name, number of products from this product line).*/

Select c.customername,p.productline,count(p.productcode) from 
customers c, orders o, orderdetails od, products p
where c.customernumber = o.customernumber and 
od.ordernumber = o.ordernumber and 
p.productcode = od.productcode
group by c.customername,p.productline
order by c.customername;
/*Find all instances where the same customer placed different orders exactly 7 days apart. 
The results of your query should be of the form 
(customer name, order number 1, order date 1, order number 2, order date 2).*/
select c.customername,o1.orderdate, o1.ordernumber,o2.ordernumber, o2.orderdate
from orders o1, orders o2, customers c where 
c.customernumber = o1.customernumber and
o1.customernumber = o2.customernumber and 
o1.ordernumber != o2.ordernumber and 
o1.orderdate - o2.orderdate = 7;
/* Find all customers who have never bought a product priced more than $70. 
The results should just include the customer name.*/
select customername from customers where customername not in
(select c.customername from customers c, orders o, orderdetails od
where c.customernumber = o.customernumber and
o.ordernumber = od.ordernumber and
od.priceeach >= 70);
/*Find the number of sales made by each employee, including those who have never made a sale 
(e.g. the managers, the president, etc.). 
The results of your query should be of the form (employee ID, number of sales made). */
Select e.employeenumber,count(o.ordernumber) from orders o join customers c 
on o.customernumber = c.customernumber
right join employees e on
c.salesrepemployeenumber = e.employeenumber
group by e.employeenumber;
