-- Xây dựng Attrition Mart để phân tích nghỉ việc
CREATE VIEW warehouse.hr_attrition_mart AS
SELECT
	e.EmployeeID,e.EmployeeNumber,e.Age,e.Gender,e.MaritalStatus,
	j.JobID,j.JobRole,j.JobLevel,j.Department,ed.Attrition,ed.MonthlyIncome,
	ed.Overtime,ed.TotalWorkingYears,ed.YearsAtCompany
FROM
	warehouse.Employee AS e JOIN warehouse.EmploymentDetails AS ed 
	ON e.EmployeeID = ed.EmployeeID JOIN warehouse.Job AS j 
	ON ed.JobID = j.JobID;
-- Tổng quan --
-- 1. Tổng quan
-- 1.1 Tỷ lệ nghỉ việc của công ty
SELECT COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100 AS AttritionRate
FROM warehouse.hr_attrition_mart
-- 1.2 Số nhân viên nghỉ việc và còn lại
SELECT
	COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalAttrition,
	COUNT(CASE WHEN Attrition = FALSE THEN 1 END) AS TotalEmployeeCurrent
FROM warehouse.hr_attrition_mart
-- 1.3 Xu hướng nghỉ việc theo độ tuổi
SELECT
	COUNT(CASE WHEN Age <= 22 THEN 1 END) AS From18To22,
	COUNT(CASE WHEN Age > 22 AND Age <= 30 THEN 1 END) AS From23To30,
	COUNT(CASE WHEN Age > 30 AND Age <= 39 THEN 1 END) AS From31To39,
	COUNT(CASE WHEN Age >= 40 THEN 1 END) AS LargerThan40
FROM warehouse.hr_attrition_mart
WHERE Attrition = TRUE

SELECT COUNT(*) FROM warehouse.hr_attrition_mart GROUP BY Age