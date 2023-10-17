#Q1. Print product, price, sum of quantity more than 5 sold during all three months.  
SELECT 
    Product, Price, SUM(Quantity) as total
FROM
    assignment1.bank_inventory_pricing
GROUP BY product,price
HAVING total > '5';

#Q2.Print product, quantity , month and count of records for which estimated_sale_price is less than purchase_cost
SELECT 
    product, quantity, month, COUNT(*) AS record_count
FROM
    assignment1.bank_inventory_pricing
WHERE
    estimated_sale_price < purchase_cost
GROUP BY product , quantity , month;

#Q3. Extarct the 3rd highest value of column Estimated_sale_price from bank_inventory_pricing dataset
SELECT DISTINCT
    Estimated_sale_price
FROM
    bank_inventory_pricing
ORDER BY Estimated_sale_price DESC
LIMIT 2 , 1;

#Q4. Count all duplicate values of column Product from table bank_inventory_pricing
SELECT 
    Product, COUNT(*) AS Duplicate_Count
FROM
    bank_inventory_pricing
GROUP BY Product
HAVING Duplicate_Count > 1;

#Q5. Create a view 'bank_details' for the product 'PayPoints' and Quantity is greater than 2 
CREATE VIEW bank_details AS
    SELECT 
        *
    FROM
        bank_inventory_pricing
    WHERE
        Product = 'PayPoints' AND Quantity > 2;

#Q6 Update view bank_details1 and add new record in bank_details1.
-- --example(Producct=PayPoints, Quantity=3, Price=410.67)
INSERT INTO bank_details (Product, Quantity, Price)
VALUES ('PayPoints', 3, 410.67);

#Q7.Real Profit = revenue - cost  Find for which products, branch level real profit is more than the estimated_profit in Bank_branch_PL.
SELECT 
    Product
FROM
    Bank_branch_PL
WHERE
    (revenue - cost) > estimated_profit;

#Q8.Find the least calculated profit earned during all 3 periods
SELECT 
    month, MIN(estimated_profit) AS Least_Calculated_Profit
FROM
    Bank_branch_PL
GROUP BY month;

#Q9. In Bank_Inventory_pricing, 
-- a) convert Quantity data type from numeric to character 
ALTER TABLE Bank_Inventory_pricing
MODIFY COLUMN Quantity CHAR(255);

-- b) Add then, add zeros before the Quantity field.  
UPDATE Bank_Inventory_pricing 
SET 
    Quantity = LPAD(Quantity, 2, '0');

#Q10. Write a MySQL Query to print first_name , last_name of the titanic_ds whose first_name Contains ‘U’
SELECT 
    first_name, last_name
FROM
    titanic_ds
WHERE
    first_name LIKE '%U%';

#Q11.Reduce 30% of the cost for all the products and print the products whose  calculated profit at branch is exceeding estimated_profit .
SELECT 
    b.Product
FROM
    Bank_branch_PL b
        JOIN
    bank_inventory_pricing p ON b.Product = p.Product
WHERE
    ((b.cost * 0.7) - p.purchase_cost) > b.estimated_profit;

#Q12.Write a MySQL query to print the observations from the Bank_Inventory_pricing table excluding the values “BusiCard” And “SuperSave” from the column Product
SELECT 
    *
FROM
    Bank_Inventory_pricing
WHERE
    Product NOT IN ('BusiCard' , 'SuperSave');

#Q13. Extract all the columns from Bank_Inventory_pricing where price between 220 and 300
SELECT 
    *
FROM
    Bank_Inventory_pricing
WHERE
    price BETWEEN 220 AND 300;

#Q14. Display all the non duplicate fields in the Product form Bank_Inventory_pricing table and display first 5 records.
SELECT 
    Product
FROM
    Bank_Inventory_pricing
GROUP BY product
HAVING COUNT(product) < '2'
LIMIT 5;

#Q15.Update price column of Bank_Inventory_pricing with an increase of 15%  when the quantity is more than 3.
UPDATE Bank_Inventory_pricing 
SET 
    price = price * 1.15
WHERE
    Quantity > 3;

#Q16. Show Round off values of the price without displaying decimal scale from Bank_Inventory_pricing
SELECT 
    ROUND(price) AS Rounded_Price
FROM
    Bank_Inventory_pricing;

#Q17.Increase the length of Product size by 30 characters from Bank_Inventory_pricing.
ALTER TABLE Bank_Inventory_pricing
MODIFY COLUMN Product VARCHAR(80);

#Q18. Add '100' in column price where quantity is greater than 3 and dsiplay that column as 'new_price' 
SELECT 
    Product, Quantity, price + 100 AS new_price
FROM
    Bank_Inventory_pricing
WHERE
    Quantity > 3;

#Q19. Display all saving account holders have “Add-on Credit Cards" and “Credit cards" 
SELECT 
    b.*
FROM
    bank_account_relationship_details a
        JOIN
    bank_account_details d ON a.Customer_id = d.Customer_id
WHERE
    d.account_type IN ('Add-on Credit Card' , 'Credit card')
        AND a.account_type = 'Savings';


#Q20.
# a) Display records of All Accounts , their Account_types, the transaction amount.

SELECT 
    a.Account_number, a.Account_type, b.transaction_amount
FROM
    bank_account_transaction b
        JOIN
    bank_account_details a ON a.Account_number = b.Account_number;

# b) Along with first step, Display other columns with corresponding linking account number, account types 
SELECT 
    a.Account_number,
    a.Account_type,
    a.Linking_account_number,
    b.Account_type AS Linked_Account_Type
FROM
    bank_account_relationship_details a
        JOIN
    bank_account_details b ON a.Linking_account_number = b.Account_number;

# c) After retrieving all records of accounts and their linked accounts, display the  transaction amount of accounts appeared  in another column.
SELECT 
    a.Account_number,
    a.Account_type,
    a.Linking_account_number,
    b.Account_type AS Linked_Account_Type,
    c.Transaction_amount
FROM
    bank_account_relationship_details a
        JOIN
    bank_account_details b ON a.Linking_account_number = b.Account_number
        JOIN
    bank_account_transaction c ON b.account_number = c.Account_number;

#Q21.Display all type of “Credit cards”  accounts including linked “Add-on Credit Cards" 
# type accounts with their respective aggregate sum of transaction amount. 
# Ref: Check linking relationship in bank_transaction_relationship_details.
# Check transaction_amount in bank_account_transaction. 
SELECT 
    b.Account_type,
    SUM(c.transaction_amount) AS total_transaction_amount
FROM
    bank_account_relationship_details b
        JOIN
    bank_account_transaction c ON b.account_number = c.Account_number
WHERE
    b.Account_type IN ('Credit card' , 'Add-on Credit Card')
GROUP BY b.Account_type;

#Q22. Compare the aggregate transaction amount of current month versus aggregate transaction with previous months.
# Display account_number, transaction_amount , 
-- sum of current month transaction amount ,
-- current month transaction date , 
-- sum of previous month transaction amount , 
-- previous month transaction date.
SELECT 
    a.Account_number,
    b.transaction_amount,
    SUM(CASE
        WHEN MONTH(b.Transaction_date) = MONTH('2020-04-24') THEN b.transaction_amount
        ELSE 0
    END) AS current_month_transaction_amount,
    MAX(CASE
        WHEN MONTH(b.Transaction_date) = MONTH('2020-04-24') THEN b.Transaction_date
    END) AS current_month_transaction_date,
    SUM(CASE
        WHEN MONTH(b.Transaction_date) = MONTH('2020-04-24') - 1 THEN b.transaction_amount
        ELSE 0
    END) AS previous_month_transaction_amount,
    MAX(CASE
        WHEN MONTH(b.Transaction_date) = MONTH('2020-04-24') - 1 THEN b.Transaction_date
    END) AS previous_month_transaction_date
FROM
    bank_account_details a
        JOIN
    bank_account_transaction b ON a.Account_number = b.Account_number
GROUP BY a.Account_number , b.transaction_amount;

#Q23.Display individual accounts absolute transaction of every next  month is greater than the previous months .
SELECT 
    a.Account_number,
    ABS(b.transaction_amount) as current_month_transaction_amount,
    LAG(ABS(b.transaction_amount), 1) OVER (PARTITION BY a.Account_number ORDER BY b.Transaction_date) as previous_month_transaction_amount
FROM bank_account_details a
JOIN bank_account_transaction b ON a.Account_number = b.Account_number;


#Q24. Find the no. of transactions of credit cards including add-on Credit Cards
SELECT 
    COUNT(*) AS total_transaction
FROM
    bank_account_relationship_details b
        JOIN
    bank_account_transaction c ON b.account_number = c.Account_number
WHERE
    b.Account_type IN ('Credit card' , 'Add-on Credit Card');

#Q25.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where department_name is Contracting (Note
#Department_id of employee_details table must be other than the list within IN operator
 
SELECT 
    employee_id,
    first_name,
    last_name,
    phone_number,
    salary,
    job_id
FROM
    employee_details
WHERE
    department_id NOT IN (SELECT 
            department_id
        FROM
            department_details
        WHERE
            department_name = 'Contracting');

   
#Q26. Display savings accounts and its corresponding Recurring deposits transactions are more than 4 times.
SELECT 
    a.Account_number, a.Account_type, b.transaction_amount
FROM
    bank_account_details a
        JOIN
    bank_account_transaction b ON a.Account_number = b.Account_number
WHERE
    a.Account_type IN ('Savings' , 'Recurring deposits')
GROUP BY a.Account_number , a.Account_type , b.transaction_amount
HAVING COUNT(*) > 4;

#Q27. From employee_details fetch only employee_id, ,first_name, last_name , phone_number ,email, job_id where job_id should not be IT_PROG.
SELECT 
    employee_id,
    first_name,
    last_name,
    phone_number,
    email,
    job_id
FROM
    employee_details
WHERE
    job_id != 'IT_PROG';

#Q29.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where manager_id is '60' (Note
#Department_id of employee_details table must be other than the list within IN operator.
SELECT 
    employee_id,
    first_name,
    last_name,
    phone_number,
    salary,
    job_id
FROM
    employee_details
WHERE
    department_id NOT IN (SELECT 
            DEPARTMENT_ID
        FROM
            department_details
        WHERE
            manager_id = '60');

#Q30.Create a new table as emp_dept and insert the result obtained after performing inner join on the two tables employee_details and department_details.
CREATE TABLE emp_dept AS SELECT * FROM
    employee_details
        INNER JOIN
    department_details ON employee_details.department_id = department_details.department_id;
