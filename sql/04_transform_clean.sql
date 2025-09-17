-- Copy dữ liệu để xử lý
CREATE TABLE warehouse.employee_raw_copy AS SELECT * FROM staging.employee_raw;

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
		WHEN Attrition = 'Yes' THEN 1
		ELSE 0 END;
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

-- Bảng Department
INSERT INTO Department(Department) SELECT DISTINCT Department FROM employee_raw_copy;
-- Bảng Employee
INSERT INTO Employee(EmployeeNumber,Age,Gender,MaritalStatus,Education,EducationField)
SELECT DISTINCT
	EmployeeNumber::INT,
	Age::INT,
	Gender,
	MaritalStatus,
	Education::INT,
	EducationField
FROM employee_raw_copy;
-- Bảng Job
INSERT INTO Job(JobRole,JobLevel) SELECT DISTINCT JobRole,JobLevel::INT FROM employee_raw_copy;
-- Bảng EmploymentDetails
INSERT INTO EmploymentDetails