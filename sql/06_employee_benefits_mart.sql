-- Xây dựng Employee Benefits mart để phân tích phúc lợi
CREATE VIEW warehouse.hr_employee_benefits_mart AS
SELECT
	e.EmployeeID, ed.MonthlyIncome, j.JobRole, j.Department, e.Gender, ed.StockOptionLevel, ed.PercentSalaryHike
FROM 
	warehouse.Employee AS e JOIN warehouse.EmploymentDetails as ed
	ON e.EmployeeID = ed.EmployeeID JOIN warehouse.Job AS j
	ON ed.JobID = j.JobID;

-- 1. Mức lương trung bình của nhân viên nghỉ việc và nhân viên ở lại
SELECT
	CASE WHEN Attrition = TRUE THEN 'Inactivity' ELSE 'Working' END,
	ROUND(AVG(MonthlyIncome),2) AS AverageSalary
FROM
	warehouse.hr_attrition_mart  
GROUP BY Attrition

-- 2. Nhân viên thu nhập thấp có rời bỏ nhiều hơn không 
SELECT
	COUNT(*) AS TotalEmployeeInactivity,
	COUNT(CASE WHEN MonthlyIncome < (SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY MonthlyIncome) FROM warehouse.hr_attrition_mart) THEN 1 END),
	ROUND(COUNT(CASE WHEN MonthlyIncome < (SELECT PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY MonthlyIncome) FROM warehouse.hr_attrition_mart) THEN 1 END)*100.0/COUNT(*),2) AS AttritionRate
FROM
	warehouse.hr_attrition_mart
WHERE Attrition = TRUE

-- 3. Thu nhập thấp có ảnh hưởng tới nghỉ việc trong từng JobRole ?
WITH median_income AS (
	SELECT
		JobRole,
		PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY MonthlyIncome) AS median_income
	FROM
		warehouse.hr_attrition_mart
	GROUP BY JobRole
)
SELECT
	h.JobRole,
	CASE
		WHEN h.MonthlyIncome < m.median_income THEN 'Low Income'
		ELSE 'High Income'
	END AS IncomeLevel,
	ROUND(100.0*COUNT(CASE WHEN h.Attrition = TRUE THEN 1 END)/COUNT(*),2) AS AttritionRate
FROM
	warehouse.hr_attrition_mart AS h JOIN median_income AS m
	ON h.JobRole = m.JobRole
GROUP BY h.JobRole,IncomeLevel
ORDER BY h.JobRole,IncomeLevel

-- 4. Lương trung bình giữa nam và nữ
SELECT
	Gender,
	ROUND(AVG(MonthlyIncome),2) AS AverageSalary
FROM
	warehouse.hr_attrition_mart
GROUP BY Gender

-- 5. Nhân viên được tăng lương nhiều hơn có ít nghỉ việc hơn
-- Tỷ lệ nhân viên nghỉ việc của từng nhóm tăng lương so với số nhân viên trong công ty trong cùng khoảng phần trăm tăng lương
SELECT
	CASE
		WHEN eb.PercentSalaryHike >= 10 AND eb.PercentSalaryHike <= 15 THEN 'Low'
		WHEN eb.PercentSalaryHike > 15 AND eb.PercentSalaryHike <= 20 Then 'Average'
		ELSE 'High' END AS PercentSalaryLevel,
	COUNT(*) TotalEmployeeInGroup,
	COUNT(CASE WHEN h.Attrition = TRUE THEN 1 END) TotalEmployeeInactivity,
	ROUND(100.0*COUNT(CASE WHEN h.Attrition = TRUE THEN 1 END)/COUNT(*),2) AS AttritionRate
FROM
	warehouse.hr_attrition_mart AS h JOIN warehouse.hr_employee_benefits_mart as eb
	ON h.EmployeeID = eb.EmployeeID
GROUP BY PercentSalaryLevel

-- 6. Quyền lựa chọn cổ phiếu có tác động đến việc nhân viên nghỉ việc
SELECT
	StockOptionLevel,
	COUNT(*) TotalEmployeeInGroup,
	COUNT(CASE WHEN h.Attrition = TRUE THEN 1 END) TotalEmployeeInactivity,
 	ROUND(100.0*COUNT(CASE WHEN h.Attrition = TRUE THEN 1 END)/COUNT(*),2) AS AttritionRate
FROM
 	warehouse.hr_attrition_mart AS h JOIN warehouse.hr_employee_benefits_mart as eb
	ON h.EmployeeID = eb.EmployeeID
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel
