# HR Analytics - Attrition Analysis

## 1. Mục tiêu chính
- Phân tích dữ liệu về nhân sự để xác định những yếu tố ảnh hưởng đến khả năng nghỉ việc của nhân viên với mục tiêu chính:
    + Tìm ra các nhóm nhân viên có rủi ro nghỉ việc cao
    + Đề xuất 1 số giải pháp để giảm tỷ lệ nghỉ việc.

## 2. Dữ liệu
- Nguồn: IBM HR Dataset (Kaggle). Đường Link dữ liệu: [text](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
- Tổng quan về dữ liệu:
    + Số records: 1470 (nhân viên)
    + Số biến: 35
    + Bảng sử dụng: Employee (thông tin cá nhân về tuổi, giới tính, tình trạng hôn nhân), Job (chức vụ, phòng ban, cấp bậc), EmploymentDetails (thời gian làm việc, tăng ca, thu nhập, nghỉ việc (Y/N)).

- Thông tin chi tiết về các biến:
    + Age: Tuổi nhân viên.
    + Attrition: Tình trạng nghỉ việc (Y/N).
    + BusinessTravel: Tần suất đi công tác.
    + DailyRate: Mức lương hằng ngày.
    + Department: Phòng ban.
    + DistanceFromHome: Khoảng cách từ nhà đến công ty.
    + Education: Trình độ học vấn.
    + EducationField: Lĩnh vực đào tạo.
    + EmployeeNumber: Mã nhân viên.
    + EnvironmentSatisfaction: Mức độ hài lòng với môi trường làm việc.
    + Gender: Giới tính.
    + HourlyRate: Mức lương theo giờ.
    + JobInvolvement: Mức độ tham gia công việc.
    + JobLevel: Cấp bậc công việc.
    + JobRole: Vai trò công việc.
    + JobSatisfaction: Mức độ hài lòng với công việc.
    + MaritalStatus: Tình trạng hôn nhân.
    + MonthlyIncome: Thu nhập hằng tháng.
    + MonthlyRate: Mức lương hằng tháng.
    + NumCompaniesWorked: Số công ty đã làm việc trong quá khứ.
    + OverTime: Tăng ca (Y/N).
    + PercentSalaryHike: Tỷ lệ tăng lương (%).
    + PerformanceRating: Đánh giá hiệu suất.
    + RelationshipSatisfaction: Mức độ hài lòng với mối quan hệ.
    + StockOptionLevel: Cấp bậc quyền lợi cổ phiếu.
    + TotalWorkingYears: Tổng số năm kinh nghiệm.
    + TrainingTimesLastYear: Số lần được đào tạo trong năm qua.
    + WorkLifeBalance: Mức độ hài lòng với môi trường làm việc và cuộc sống.
    + YearsAtCompany: Số năm làm việc tại công ty.
    + YearsInCurrentRole: Số năm làm việc trong vai trò hiện tại.
    + YearsSinceLastPromotion: Số nằm từ khi được thăng chức đến hiện tại.
    + YearsWithCurrManager: Số năm làm việc với quản lý hiện tại.

## 3. Tổng quan
- Attrition Overall: 16,12%, [file](outputs/attrition_mart.xlsx)
- Tỷ lệ nghỉ việc ở các phòng ban:
    1. Sales - 20.63%
    2. Human Resources - 19.05%
    3. Research & Development - 13.84%