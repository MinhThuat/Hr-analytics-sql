-- Xây dựng Career Mart (nghề nghiệp và thăng tiến)
CREATE VIEW warehouse.hr_career_mart AS
SELECT
	e.EmployeeID, j.JobLevel, ed.TotalWorkingYears, ed.YearsAtCompany, ed.YearsInCurrentRole,
	ed.YearsSinceLastPromotion, ed.NumCompaniesWorked
FROM
	warehouse.Employee AS e JOIN warehouse.EmploymentDetails AS ed 
	ON e.EmployeeID = ed.EmployeeID JOIN warehouse.Job AS j 
	ON ed.JobID = j.JobID;

SELECT * FROM warehouse.hr_career_mart

-- 1. Sự khác nhau giữa các JobLevel về Attrition
SELECT
	JobLevel,
	COUNT(*) AS TotalEmployee,
	COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM warehouse.hr_attrition_mart
GROUP BY JobLevel
ORDER BY JobLevel;

-- 2. Liệu nhân viên với ít năm làm việc tổng thể có dễ nghỉ việc hơn ?
SELECT
	CASE
		WHEN TotalWorkingYears <= 5 THEN '0-5 years'
		WHEN TotalWorkingYears > 5 AND TotalWorkingYears <= 10 THEN '6-10 years'
		WHEN TotalWorkingYears > 10 AND TotalWorkingYears <= 20 THEN '11-20 years'
		ELSE '20+ years'
	END AS WorkingYearsGroup,
	ROUND(100.0 * COUNT(CASE WHEN Attrition = TRUE THEN 1 END) / COUNT(*), 2) AS AttritionRate,
	COUNT(*) AS TotalEmployees
FROM warehouse.hr_attrition_mart
GROUP BY
	CASE
		WHEN TotalWorkingYears <= 5 THEN '0-5 years'
		WHEN TotalWorkingYears > 5 AND TotalWorkingYears <= 10 THEN '6-10 years'
		WHEN TotalWorkingYears > 10 AND TotalWorkingYears <= 20 THEN '11-20 years'
		ELSE '20+ years'
	END
ORDER BY WorkingYearsGroup;
-- 3. Những người được thăng chức đã lâu có tỷ lệ nghỉ việc cao hơn không ?
SELECT
	CASE
		WHEN YearsSinceLastPromotion <= 5 THEN '0-5 years'
		WHEN YearsSinceLastPromotion > 5 AND YearsSinceLastPromotion <= 10 THEN '6-10 years'
		ELSE '10+ years'
	END AS YearsSinceLastPromotionGroup,
	ROUND(100.0 * COUNT(CASE WHEN Attrition = TRUE THEN 1 END) / COUNT(*), 2) AS AttritionRate,
	COUNT(*) AS TotalEmployees
FROM
	warehouse.hr_career_mart as cm JOIN warehouse.hr_attrition_mart as am
	ON cm.EmployeeID = am.EmployeeID
GROUP BY
	CASE
		WHEN YearsSinceLastPromotion <= 5 THEN '0-5 years'
		WHEN YearsSinceLastPromotion > 5 AND YearsSinceLastPromotion <= 10 THEN '6-10 years'
		ELSE '10+ years'
	END
ORDER BY YearsSinceLastPromotionGroup;

-- 4. Tỷ lệ nghỉ việc có ảnh hưởng bởi số công ty mà người đó đã làm trong quá khứ ?
SELECT
	NumCompaniesWorked,
	ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
FROM
	warehouse.hr_career_mart as cm JOIN warehouse.hr_attrition_mart as am
	ON cm.EmployeeID = am.EmployeeID
GROUP BY NumCompaniesWorked
ORDER BY NumCompaniesWorked;

-- 5. Có mối liên hệ nào giữa việc ở quá lâu 1 vị trí và nghỉ việc ?
SELECT
	CASE
		WHEN YearsInCurrentRole <= 5 THEN '0-5 years'
		WHEN YearsInCurrentRole > 5 AND YearsInCurrentRole <= 10 THEN '6-10 years'
		ELSE '10+ years'
	END AS YearsInCurrentRoleGroup,
	ROUND(100.0 * COUNT(CASE WHEN Attrition = TRUE THEN 1 END) / COUNT(*), 2) AS AttritionRate,
	COUNT(*) AS TotalEmployees,
	COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers
FROM
	warehouse.hr_career_mart as cm JOIN warehouse.hr_attrition_mart as am
	ON cm.EmployeeID = am.EmployeeID
GROUP BY
	CASE
		WHEN YearsInCurrentRole <= 5 THEN '0-5 years'
		WHEN YearsInCurrentRole > 5 AND YearsInCurrentRole <= 10 THEN '6-10 years'
		ELSE '10+ years'
	END
ORDER BY YearsInCurrentRoleGroup;

