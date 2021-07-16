-- SQL Query

-- Ranked order of Vendors by purchase amount $
SELECT DISTINCT VendorID, PV.Name, TotalDue AS PurchaseAmt,
	ROW_NUMBER() OVER( ORDER BY TotalDue DESC) AS AmtRank
FROM Purchasing.PurchaseOrderHeader PH
JOIN Purchasing.Vendor PV
ON PV.BusinessEntityID = PH.VendorID
GROUP BY VendorID, PV.Name, TotalDue
ORDER BY AmtRank

-- Ranked order of products purchased by amount $
SELECT DISTINCT PV.ProductID, PP.Name,
	LineTotal AS ProductPurchaseAmt,
	RANK() OVER( ORDER BY LineTotal DESC) AS ProductRank
FROM Purchasing.ProductVendor PV
JOIN Purchasing.PurchaseOrderDetail PD
ON PV.ProductID = PD.ProductID
JOIN Production.Product PP
ON PP.ProductID = PV.ProductID
GROUP BY PV.ProductID, PP.Name, LineTotal
ORDER BY ProductRank


-- Ranked order of products purchased By subcategory
SELECT *,
	RANK() OVER( ORDER BY #OfPurchased DESC) AS ProductRank
FROM(
SELECT DISTINCT PD.ProductID, PP.Name,
	PS.Name AS Category,
	COUNT(*) OVER(PARTITION BY PS.Name) AS #OfPurchased
FROM Purchasing.ProductVendor PV
JOIN Purchasing.PurchaseOrderDetail PD
ON PV.ProductID = PD.ProductID
JOIN Production.Product PP
ON PP.ProductID = PV.ProductID
JOIN Production.ProductSubcategory PS
ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
--GROUP BY PD.ProductID, PP.Name, PS.Name
--ORDER BY #OfPurchased DESC
) CategoryRank
ORDER BY ProductRank;


-- Ranked order of products purchased By Category
SELECT *,
	RANK() OVER( ORDER BY #OfPurchased DESC) AS ProductRank
FROM(
SELECT DISTINCT PD.ProductID, PP.Name,
	PS.Name AS SubCategory,
	PC.Name AS Category,
	COUNT(*) OVER(PARTITION BY PC.Name) AS #OfPurchased
FROM Purchasing.ProductVendor PV
JOIN Purchasing.PurchaseOrderDetail PD
ON PV.ProductID = PD.ProductID
JOIN Production.Product PP
ON PP.ProductID = PV.ProductID
JOIN Production.ProductSubcategory PS
ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC
ON PC.ProductCategoryID = PS.ProductCategoryID
--GROUP BY PD.ProductID, PP.Name, PS.Name
--ORDER BY #OfPurchased DESC
) CategoryRank
ORDER BY ProductRank;


-- Ranked order of products purchased By product model (top 20)
SELECT *,
	RANK() OVER( ORDER BY #OfPurchased DESC) AS ProductRank
FROM(
SELECT DISTINCT TOP 20 PD.ProductID, PP.Name,
	PM.Name AS ModelName,
	COUNT(*) OVER(PARTITION BY PM.Name) AS #OfPurchased
FROM Purchasing.PurchaseOrderDetail PD
JOIN Production.Product PP
ON PP.ProductID = PD.ProductID
JOIN Production.ProductModel PM
ON PM.ProductModelID = PP.ProductModelID
) ModelRank
ORDER BY ProductRank;


-- Ranked order of products purchased By product (top 20)
SELECT *,
	RANK() OVER( ORDER BY #OfPurchased DESC) AS ProductRank
FROM(
SELECT DISTINCT TOP 20 PD.ProductID, PP.Name,
	COUNT(*) OVER(PARTITION BY PP.Name) AS #OfPurchased
FROM Purchasing.PurchaseOrderDetail PD
JOIN Production.Product PP
ON PP.ProductID = PD.ProductID
) ProductNumRank
ORDER BY ProductRank;


-- List of employees who purchased products with phone, email & address
SELECT DISTINCT ph.EmployeeID AS EmployeeID, p.FirstName AS EmployeeName, 
	ad.AddressLine1 AS EmployeeAddress, pf.PhoneNumber AS EmployeePhoneNumber,
	ema.EmailAddress AS EmployeeEmail
FROM HumanResources.Employee em
JOIN Person.Person p ON em.BusinessEntityID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress ead ON em.BusinessEntityID = ead.BusinessEntityID
JOIN Person.Address ad ON ead.AddressID = ad.AddressID
JOIN Person.PersonPhone pf ON pf.BusinessEntityID = em.BusinessEntityID
JOIN person.EmailAddress ema ON ema.BusinessEntityID = em.BusinessEntityID
JOIN Purchasing.PurchaseOrderHeader ph ON ph.EmployeeID = em.BusinessEntityID
ORDER BY EmployeeID;


-- List of employees who purchased products with pay rate & raises (SCD)
SELECT DISTINCT ph.EmployeeID AS EmployeeID, p.FirstName AS EmployeeName, 
	eph.Rate AS PayRate, eph.RateChangeDate AS PayRaisedDate
FROM HumanResources.Employee em
JOIN Person.Person p ON em.BusinessEntityID = p.BusinessEntityID
JOIN Purchasing.PurchaseOrderHeader ph ON ph.EmployeeID = em.BusinessEntityID
JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID = em.BusinessEntityID
ORDER BY EmployeeID;


-- List of purchasing vendor contacts with vendor name, phone, email & address
SELECT DISTINCT vd.BusinessEntityID AS VendorID, vac.FirstName AS VendorName,
	vac.EmailAddress AS VendorEmail, vad.AddressLine1 As VendorAddress, vac.PhoneNumber AS VendorPhoneNumber
FROM Purchasing.vVendorWithAddresses vad
JOIN Purchasing.Vendor vd ON vd.BusinessEntityID = vad.BusinessEntityID
JOIN Purchasing.vVendorWithContacts vac ON vac.BusinessEntityID = vd.BusinessEntityID
JOIN Purchasing.PurchaseOrderHeader ph ON ph.VendorID = vd.BusinessEntityID


-- List of product prices by product order by product and SCD effective ascending
SELECT DISTINCT p.ProductID, p.Name AS ProductName, p.ListPrice AS ProductPrices,
	pd.ModifiedDate AS SCD_Effective
FROM Production.Product p 
JOIN Purchasing.PurchaseOrderDetail pd ON pd.ProductID = p.ProductID
--JOIN Purchasing.PurchaseOrderHeader ph ON ph.PurchaseOrderID = pd.PurchaseOrderID
ORDER BY SCD_Effective, ProductID;


-- List of standard costs by product order by product and SCD effective ascending
SELECT DISTINCT p.ProductID, p.Name AS ProductName, p.StandardCost AS ProductStandatdCost,
	pd.ModifiedDate AS SCD_Effective
FROM Production.Product p 
JOIN Purchasing.PurchaseOrderDetail pd ON pd.ProductID = p.ProductID
JOIN Purchasing.PurchaseOrderHeader ph ON ph.PurchaseOrderID = pd.PurchaseOrderID
ORDER BY SCD_Effective, ProductID;