-- Bảng Employee
CREATE TABLE warehouse.Employee(
	EmployeeID SERIAL PRIMARY KEY,
	EmployeeNumber INT UNIQUE,
	Age INT,
	Gender VARCHAR(10),
	MaritalStatus VARCHAR(20),
	Education INT,
	EducationField VARCHAR(50)
);

-- Bảng Job
CREATE TABLE warehouse.Job (
    JobID SERIAL PRIMARY KEY ,
    JobRole VARCHAR(50),
	Department VARCHAR(50),
    JobLevel INT
);

-- Bảng EmploymentDetails
CREATE TABLE warehouse.EmploymentDetails (
	fact_id SERIAL PRIMARY KEY,
    EmployeeID INT REFERENCES warehouse.Employee(EmployeeID),
    JobID INT REFERENCES warehouse.Job(JobID),
    Attrition BOOLEAN,
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
	EnvironmentSatisfaction INT,
	JobSatisfaction INT,
	RelationshipSatisfaction INT,
	DistanceFromHome INT,
	JobInvolvement INT,
	TrainingTimeLastYear INT,
	WorkLifeBalance INT,
	NumCompaniesWorked INT
);
