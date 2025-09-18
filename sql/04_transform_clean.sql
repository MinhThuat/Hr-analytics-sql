-- Copy dữ liệu để xử lý
CREATE TABLE warehouse.employee_raw_copy AS
SELECT
	Age,
	Attrition,
	BusinessTravel,
	CAST(DailyRate AS INT),
	Department,
	CAST(DistanceFromHome AS INT),
	CAST(Education AS INT),
	EducationField,
	EmployeeCount,
	EmployeeNumber,
	CAST(EnvironmentSatisfaction AS INT),
	Gender,
	CAST(HourlyRate AS INT),
	CAST(JobInvolvement AS INT),
	CAST(JobLevel AS INT),
	JobRole,
	CAST(JobSatisfaction AS INT),
	MaritalStatus,
	MonthlyIncome,
	CAST(MonthlyRate AS INT),
	CAST(NumCompaniesWorked AS INT),
	Over18,
	OverTime,
	CAST(PercentSalaryHike AS INT),
	CAST(PerformanceRating AS INT),
	CAST(RelationshipSatisfaction AS INT),
	StandardHours,
	CAST(StockOptionLevel AS INT),
	CAST(TotalWorkingYears AS INT),
	CAST(TrainingTimesLastYear AS INT),
	CAST(WorkLifeBalance AS INT),
	CAST(YearsAtCompany AS INT),
	CAST(YearsInCurrentRole AS INT),
	CAST(YearsSinceLastPromotion AS INT),
	CAST(YearsWithCurrManager AS INT)
FROM staging.employee_raw;

-- SET đường dẫn mặc định
SET SEARCH_PATH = warehouse;

-- 1. Chuẩn hóa text, NULLIF
UPDATE employee_raw_copy
SET
	EmployeeNumber = NULLIF(trim(regexp_replace(EmployeeNumber, '[\t\r\n]', ' ', 'g')), ''),
	Age = NULLIF(TRIM(Age),''),
	Gender = NULLIF(TRIM(Gender),''),
	Department = NULLIF(TRIM(Department),''),
	JobRole = NULLIF(TRIM(JobRole),''),
	MonthlyIncome = NULLIF(TRIM(MonthlyIncome),'');

UPDATE employee_raw_copy
SET
	Gender = INITCAP(Gender),
	Department = INITCAP(Department),
	JobRole = INITCAP(JobRole);

-- 2. Chuẩn hóa category

UPDATE employee_raw_copy
SET 
	Gender = CASE
		WHEN LOWER(Gender) IN ('m','male','man') THEN 'M'
		WHEN LOWER(Gender) IN ('f','female','woman') THEN 'F'
		ELSE 'O' END,
	Attrition = CASE
		WHEN Attrition = 'Yes' THEN TRUE
		ELSE FALSE END;
-- 3. Loại bỏ các cột không cần thiết 
ALTER TABLE employee_raw_copy DROP COLUMN Over18;
ALTER TABLE employee_raw_copy DROP COLUMN StandardHours;
ALTER TABLE employee_raw_copy DROP COLUMN EmployeeCount;


-- Kiểm tra lại dữ liệu sau khi tiền xử lý
SELECT Gender, COUNT(*) AS total
FROM employee_raw_copy
GROUP BY Gender;

SELECT Department, COUNT(*) AS total
FROM employee_raw_copy
GROUP BY Department;

-- Chuyển dữ liệu đã xử lý vào các bảng trong warehouse

-- Bảng Employee
INSERT INTO Employee(EmployeeNumber,Age,Gender,MaritalStatus,Education,EducationField)
SELECT DISTINCT
	EmployeeNumber::INT,
	Age::INT,
	Gender,
	MaritalStatus,
	Education,
	EducationField
FROM employee_raw_copy;
-- Bảng Job
INSERT INTO Job(JobRole,Department,JobLevel) SELECT DISTINCT JobRole,Department,JobLevel FROM employee_raw_copy;
-- Bảng EmploymentDetails
INSERT INTO warehouse.EmploymentDetails (
    EmployeeID, JobID, Attrition, BusinessTravel,
    DailyRate, HourlyRate, MonthlyIncome, MonthlyRate, OverTime,
    PercentSalaryHike, PerformanceRating, StockOptionLevel, TotalWorkingYears,
    YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager,
	EnvironmentSatisfaction,JobSatisfaction, RelationshipSatisfaction, DistanceFromHome,
	JobInvolvement, TrainingTimeLastYear, WorkLifeBalance, NumCompaniesWorked
)
SELECT DISTINCT 
    e.EmployeeID,
    j.JobID,
    ec.Attrition::BOOLEAN,
    ec.BusinessTravel,
    ec.DailyRate,
    ec.HourlyRate,
    ec.MonthlyIncome::INT,
    ec.MonthlyRate,
    ec.OverTime,
    ec.PercentSalaryHike,
    ec.PerformanceRating,
    ec.StockOptionLevel,
    ec.TotalWorkingYears,
    ec.YearsAtCompany,
    ec.YearsInCurrentRole,
    ec.YearsSinceLastPromotion,
    ec.YearsWithCurrManager,
	ec.EnvironmentSatisfaction,
	ec.JobSatisfaction,
	ec.RelationshipSatisfaction, 
	ec.DistanceFromHome,
	ec.JobInvolvement,
	ec.TrainingTimesLastYear,
	ec.WorkLifeBalance,
	ec.NumCompaniesWorked
FROM employee_raw_copy ec
JOIN warehouse.Employee e ON ec.EmployeeNumber::INT = e.EmployeeNumber
JOIN warehouse.Job j ON ec.JobRole = j.JobRole AND ec.Department = j.Department AND ec.JobLevel = j.JobLevel;

-- Kiểm tra dữ liệu sau khi nạp vào warehouse
SELECT COUNT(*) FROM Employee;
SELECT COUNT(*) FROM Job;
SELECT COUNT(*) FROM EmploymentDetails;
-- Kiểm tra về khóa ngoại
SELECT COUNT(*) 
FROM EmploymentDetails ed
LEFT JOIN Employee e ON ed.EmployeeID = e.EmployeeID
WHERE e.EmployeeNumber IS NULL;