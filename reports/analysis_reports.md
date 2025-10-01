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

## 4. Các câu hỏi và kết quả 

### Q1: Xu hướng nghỉ việc theo độ tuổi
-SQL:
```sql   
    SELECT  
        CASE  
            WHEN Age <= 22 THEN '18-22'  
            WHEN Age > 22 AND Age <= 30 THEN '23-30'  
            WHEN Age > 30 AND Age <= 39 THEN '31-39'  
            ELSE '40+'  
        END AS AgeGroup,  
        COUNT(*) AS TotalEmployee,  
        COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers,  
        ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*100.0/COUNT(*),2) AS AttritionRate  
    FROM warehouse.hr_attrition_mart  
    GROUP BY AgeGroup  
    ORDER BY AgeGroup;  
```
- Kết quả:
<pre>
    "agegroup"	"totalemployee"	"totalleavers"	"attritionrate"
    "18-22"	        57	            27	            47.37
    "23-30"	        329	            73	            22.19
    "31-39"	        562	            80	            14.23
    "40+"	        522	            57	            10.92
</pre>
- Insight: Tỷ lệ nghỉ việc giảm dần theo tuổi với nhóm nhỏ hơn 22 tuổi có tỷ lệ nghỉ việc cực cao do họ còn trẻ và dễ bị thu hút bởi các cơ hội khác. Với nhóm từ 23-30 họ bắt đầu ổn định sự nghiệp của mình và tỷ lệ nghỉ việc giảm xuống nhưng vẫn còn khá cao do họ thường tìm các công việc có lộ trình thăng tiến rõ ràng và lương ổn định và công ty cần chú trọng chính sách lương thưởng và lộ trình thăng tiến rõ ràng cho nhóm này. Những nhóm tuổi lớn hơn có tỷ lệ nghỉ việc thấp hơn nhưng nếu để mất những người này công ty sẽ mất đi những nhân lực giàu kinh nghiệm.

### Q2: Sự ảnh hưởng của Marital Status đến Attrition
- SQL:
```sql
    SELECT    
	MaritalStatus,    
        COUNT(*) AS TotalEmployee,  
        COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers,  
        ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*100.0/COUNT(*),2) AS AttritionRate  
    FROM warehouse.hr_attrition_mart  
    GROUP BY MaritalStatus  
    ORDER BY AttritionRate;  
```
</pre>
- Kết quả:
    "maritalstatus"  	"totalemployee"  	"totalleavers"  	"attritionrate"  
    "Divorced"	            327  	            33  	            10.09  
    "Married"	            673  	            84  	            12.48  
    "Single"	            470  	            120  	            25.53  
</pre>
- Insight: Tỷ lệ nghỉ việc cao nhất ở những người độc thân khi mà họ có thể tự do chuyển ngành hay nơi làm việc mà không cần lo lắng quá nhiều về tiền với khoảng 25.53% nghỉ việc ở nhóm này. Tỷ lệ này được giảm xuống khá thấp với nhóm những người đã kết hôn do họ cần sự ổn định và gắn bó với công ty lâu dài hơn và thấp nhất ở những người đã ly hôn có thể do nhu cầu tài chính hoặc sự ổn định cá nhân cao hơn.

### Q3: Tỷ lệ nghỉ việc theo Department
- SQL:
```sql
    SELECT
        Department,
        COUNT(*) AS TotalEmployee,
        COUNT(CASE WHEN Attrition = TRUE THEN 1 END) AS TotalLeavers,
        ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
    FROM warehouse.hr_attrition_mart
    GROUP BY Department;
```
</pre>
- Kết quả:
    "department"	            "totalemployee"	"totalleavers"	"attritionrate"
    "Human Resources"	            63	            12	            19.05
    "Research & Development"	    961	            133	            13.84
    "Sales"	                        446	            92	            20.63
</pre>  
- Insight: Tỷ lệ nghỉ việc ở các phòng ban có thể xem là tương tự nhau với mức cao nhất ở phòng Sales (20.63%) và thấp nhất ở phòng Research & Development (13.84%). Cần xem xét lại những lý do chính khiến mức nghỉ việc ở phòng Sales cao như vậy (lương thưởng, chính sách thăng tiến, môi trường làm việc). Ngoài ra phòng Human Resources cũng có tỷ lệ khá cao gần bằng Sales (19.05%) nhưng tổng số nhân viên khá ít và số nhân viên nghỉ việc cũng ít nhưng tỷ lệ nghỉ việc như vậy cũng nên xem xét lại những chính sách giữ chân

### Q4: Tỷ lệ nghỉ việc theo JobRole
- SQL: 
```sql
    SELECT
        JobRole,
        ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
    FROM warehouse.hr_attrition_mart
    GROUP BY JobRole
    ORDER BY AttritionRate;
```
</pre>
- Kết quả:
    "jobrole"	                "attritionrate"
    "Research Director"	            2.50
    "Manager"	                    4.90
    "Healthcare Representative"	    6.87
    "Manufacturing Director"	    6.90
    "Research Scientist"	        16.10
    "Sales Executive"	            17.48
    "Human Resources"	            23.08
    "Laboratory Technician"	        23.94
    "Sales Representative"	        39.76
</pre>
- Insight: Nhóm những vị trí như Research Director, Manager có tỷ lệ nghỉ việc rất thấp do đây là những vị trí cấp cao, ổn định lương cao và khó tìm người thay thế và họ cũng là những người gắn bó lâu dài. Research Scientist và Sales Executive là những nhóm chuyên môn hóa cao có tỷ lệ nghỉ việc trung bình (16-17%) khả năng cạnh tranh từ thị trường cao những vẫn tương đối ổn định. Những nhóm còn lại như HR, Laboratory Technician, Sales Representative có tỷ lệ nghỉ việc cực cao phản ánh đúng việc tỷ lệ nghỉ việc ở những phòng ban này cũng cao do đó đây là những nhóm có áp lực công việc cao, biến động thị trường việc làm cũng dễ ảnh hưởng tới những nhóm này và thiếu động lực giữ chân những nhân sự này

### Q5: Nhân viên Overtime có tỷ lệ nghỉ việc cao hơn nhân viên không làm thêm giờ hay không ?
- SQL: 
```sql
    SELECT
        Overtime,
        ROUND(COUNT(CASE WHEN Attrition = TRUE THEN 1 END)*1.0/COUNT(*) * 100,2) AS AttritionRate
    FROM warehouse.hr_attrition_mart
    GROUP BY Overtime;
```
</pre>
- Kết quả:
    "overtime"	"attritionrate"
    "No"	        10.44
    "Yes"	        30.53
</pre>
- Insight: Những người thường xuyên tăng ca có tỷ lệ nghỉ việc gấp 3 lần so với những người không làm thêm giờ. Công ty nên xem xét lại chính sách lương thưởng dành cho những nhân viên làm thêm giờ để tạo thêm động lực giữ chân những người này.