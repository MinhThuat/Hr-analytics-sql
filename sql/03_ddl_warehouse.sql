-- Bảng Department
CREATE TABLE warehouse.Department(
	DepartmentID SERIAL PRIMARY KEY,
	Department VARCHAR(50)
);
ALTER TABLE warehouse.Department ADD PRIMARY KEY (DepartmentID)
-- Bảng Employee
CREATE TABLE warehouse.Employee(
	EmployeeNumber INT PRIMARY KEY,
	Age INT,
	Gender VARCHAR(10),
	MaritalStatus VARCHAR(20),
	Education INT,
	EducationField VARCHAR(50),
	Over18 CHAR(1)
);

-- Bảng Job
CREATE TABLE warehouse.Job (
    JobRoleID SERIAL PRIMARY KEY ,
    JobRole VARCHAR(50),
    JobLevel INT
);

-- Bảng EmploymentDetails
CREATE TABLE warehouse.EmploymentDetails (
    EmployeeNumber INT,
    DepartmentID INT,
    JobRoleID INT,
    Attrition VARCHAR(3),
    BusinessTravel VARCHAR(20),
    DailyRate INT,
    HourlyRate INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,
    FOREIGN KEY (EmployeeNumber) REFERENCES warehouse.Employee(EmployeeNumber),
    FOREIGN KEY (DepartmentID) REFERENCES warehouse.Department(DepartmentID),
    FOREIGN KEY (JobRoleID) REFERENCES warehouse.Job(JobRoleID)
);

-- Bảng Satisfaction
CREATE TABLE warehouse.Satisfaction (
    SatisfactionID SERIAL PRIMARY KEY ,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    JobSatisfaction INT,
    RelationshipSatisfaction INT,
    FOREIGN KEY (EmployeeNumber) REFERENCES warehouse.Employee(EmployeeNumber)
);

-- Bảng WorkDetails
CREATE TABLE warehouse.WorkDetails (
    WorkDetailsID SERIAL PRIMARY KEY,
    EmployeeNumber INT,
    DistanceFromHome INT,
    JobInvolvement INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    NumCompaniesWorked INT,
    FOREIGN KEY (EmployeeNumber) REFERENCES warehouse.Employee(EmployeeNumber)
);