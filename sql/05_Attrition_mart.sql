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
-- 1 Tỷ lệ nghỉ việc của công ty
SELECT
	COUNT(*) AS TotalEmployee,
	COUNT(*) AS TotalLeavers,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM warehouse.hr_attrition_mart;
-- 2 Số nhân viên nghỉ việc và còn lại
SELECT
	COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalAttrition,
	COUNT(CASE WHEN Attrition = FALSE THEN 1 END) AS TotalEmployeeCurrent
FROM warehouse.hr_attrition_mart;
-- 3 Xu hướng nghỉ việc theo độ tuổi
SELECT
	COUNT(CASE WHEN Age <= 22 THEN 1 END) AS From18To22,
	COUNT(CASE WHEN Age > 22 AND Age <= 30 THEN 1 END) AS From23To30,
	COUNT(CASE WHEN Age > 30 AND Age <= 39 THEN 1 END) AS From31To39,
	COUNT(CASE WHEN Age >= 40 THEN 1 END) AS LargerThan40
FROM warehouse.hr_attrition_mart
WHERE Attrition = TRUE;
-- 4 Tỷ lệ nghỉ việc giữa nam và nữ
-- Cơ cấu nghỉ việc của từng giới
SELECT
	ROUND(COUNT(CASE WHEN Gender = 'F' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateFemale,
	ROUND(COUNT(CASE WHEN Gender = 'M' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateMale
FROM warehouse.hr_attrition_mart
WHERE Attrition = TRUE;
-- Tỷ lệ nghỉ việc của từng giới
SELECT 
	Gender,
	ROUND(100.0 * COUNT(CASE WHEN Attrition = TRUE THEN 1 END)/COUNT(*),2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY Gender;
-- 5 Sự ảnh hưởng của Marital Status đến Attrition
SELECT
	ROUND(COUNT(CASE WHEN MaritalStatus = 'Married' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateMarried,
	ROUND(COUNT(CASE WHEN MaritalStatus = 'Divorced' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateDivorced,
	ROUND(COUNT(CASE WHEN MaritalStatus = 'Single' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateSingle
FROM warehouse.hr_attrition_mart
WHERE Attrition = TRUE;
-- 6 Tỷ lệ nghỉ việc theo Department và số nhân viên của từng phòng ban
-- Tỷ lệ nghỉ việc của từng phòng ban so với tổng số nhân viên nghỉ việc
SELECT
	ROUND(COUNT(CASE WHEN Department = 'Sales' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateSales,
	ROUND(COUNT(CASE WHEN Department = 'Research & Development' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateRD,
	ROUND(COUNT(CASE WHEN Department = 'Human Resources' THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRateHR
FROM warehouse.hr_attrition_mart
WHERE Attrition = TRUE;
-- Tỷ lệ nghỉ việc của từng phòng ban so với tổng số nhân viên trong phòng ban đó 
SELECT
	Department,
	COUNT(*) AS TotalEmployee,
	COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY Department;

-- 7 Tỷ lệ nghỉ việc theo JobRole

SELECT
	JobRole,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY JobRole;

-- 8 Nhân viên Overtime có tỷ lệ nghỉ việc cao hơn nhân viên không làm thêm giờ hay không ?
SELECT
	Overtime,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY Overtime;

-- 9 Số năm làm việc tại công ty có ảnh hưởng hay không ?
SELECT
	CASE
		WHEN YearsAtCompany <= 5 THEN '0-5'
		WHEN YearsAtCompany > 5 AND YearsAtCompany <= 10 THEN '6-10'
		WHEN YearsAtCompany > 10 AND YearsAtCompany <= 20 THEN '11-20'
		ELSE '20+'
	END AS YearsGroup,
	ROUND(100.0*COUNT(CASE WHEN Attrition = TRUE THEN 1 END)/COUNT(*),2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY YearsGroup
ORDER BY YearsGroup;