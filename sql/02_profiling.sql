-- tổng số dòng
SELECT COUNT(*) FROM staging.employee_raw;

-- tổng giá trị NULL/blank
SELECT gender, COUNT(*) FROM staging.employee_raw GROUP BY gender;

-- Giá trị bị lặp
SELECT employeenumber, COUNT(*) FROM staging.employee_raw GROUP BY employeenumber HAVING COUNT(*) > 1;