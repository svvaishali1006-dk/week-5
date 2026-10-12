USE EcommerceDB;

CREATE TABLE Payment (
    Payment_ID VARCHAR(10) PRIMARY KEY,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL,
    Transaction_Amount DECIMAL(10,2) NOT NULL
        CHECK (Transaction_Amount > 0),

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CHECK (Payment_Mode IN
        ('UPI', 'Credit Card', 'Debit Card',
         'Net Banking', 'Cash on Delivery')),

    CHECK (Payment_Status IN
        ('Success', 'Failed', 'Pending'))
);
INSERT INTO Payment VALUES
('P101', 5001, '2026-10-01', 'UPI', 'Success', 46000),
('P102', 5002, '2026-10-02', 'Credit Card', 'Failed', 20000),
('P103', 5003, '2026-10-03', 'Debit Card', 'Success', 3000),
('P104', 5004, '2026-10-04', 'Net Banking', 'Pending', 10000),
('P105', 5006, '2026-10-11', 'Cash on Delivery', 'Success', 21000);
SELECT * FROM Payment;
UPDATE Payment
SET Payment_Status = 'Success'
WHERE Payment_ID = 'P102';

SELECT *
FROM Payment
WHERE Order_ID = 5001;

SELECT *
FROM Payment
WHERE Payment_Status = 'Success';

SELECT *
FROM Payment
WHERE Payment_Status = 'Failed';

SELECT Payment_Status, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Status;

UPDATE Payment
SET Payment_Status = 'Success'
WHERE Payment_ID = 'P102'
AND Payment_Status = 'Failed';

SELECT *
FROM Payment
WHERE Payment_Status = 'Pending';

SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode;

SELECT COUNT(*) AS UPI_Transactions
FROM Payment
WHERE Payment_Mode = 'UPI';

SELECT COUNT(*) AS Card_Payments
FROM Payment
WHERE Payment_Mode IN ('Credit Card', 'Debit Card');

SELECT Payment_Mode, COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode
HAVING COUNT(*) = (
    SELECT MAX(Mode_Count)
    FROM (
        SELECT COUNT(*) AS Mode_Count
        FROM Payment
        GROUP BY Payment_Mode
    ) AS Payment_Counts
);

SELECT SUM(Transaction_Amount) AS Total_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

SELECT Payment_Mode,
       SUM(Transaction_Amount) AS Revenue
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

SELECT AVG(Transaction_Amount) AS Average_Transaction
FROM Payment;

SELECT C.Customer_Name, O.Order_ID,
       P.Payment_Mode, P.Transaction_Amount,
       P.Payment_Status
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID
ORDER BY O.Order_ID;

SELECT * FROM Payment;