-- 1 -- Retrieve the total number of employees in the dataset.

	select count(e.employeeid)
	from employee_survey e

-- 2 -- List all unique job roles in the dataset.

	select distinct jobrole
	from general_data

-- 3 -- Find the average age of employees.
		
	select round(avg(age),0)
	from general_data

-- 4 -- Retrieve the names and ages of employees who have worked at the company for more 
        -- than 5 years.

		select g.[Emp Name] employee_Name , g.Age Age
		from general_data g 
		where g.TotalWorkingYears > 5 

-- 5 -- Get a count of employees grouped by their department.
	
		select g.Department , count(g.EmployeeID) Number_Of_Employees
		from general_data g
		group by g.Department

-- 6 --  List employees who have 'High' Job Satisfaction.

		select g.[Emp Name] Employee_Name
		from general_data g join employee_survey e
		on g.EmployeeID = e.EmployeeID
		where e.JobSatisfaction = 4

-- 7 -- Find the highest Monthly Income in the dataset.

		select max(g.MonthlyIncome) Highest_Monthly_Income
		from general_data g

-- 8 -- List employees who have 'Travel_Rarely' as their BusinessTravel type.

		select g.[Emp Name] Employee_Name
		from general_data g
		where g.BusinessTravel = 'Travel_Rarely'

-- 9 -- Retrieve the distinct MaritalStatus categories in the dataset.

		select distinct g.MaritalStatus
		from general_data g

-- 10 -- Get a list of employees with more than 2 years of work experience but less than 4 years in 
      -- their current role.

		select g.[Emp Name] Employee_Name  ,TotalWorkingYears, YearsAtCompany
		from general_data g
		WHERE TotalWorkingYears > 2
				AND YearsAtCompany > 2
				AND YearsAtCompany < 4

-- 11 --  List employees who have changed their job roles within the company (JobLevel and 
        -- JobRole differ from their previous job).

		select EmployeeID , CurrentJobLevel , CurrentJobRole , PreviousJobLevel , PreviousJobRole
		from(
				select EmployeeID, 
				   JobLevel AS CurrentJobLevel, 
				   JobRole AS CurrentJobRole,
				   LAG(JobLevel) OVER (PARTITION BY EmployeeID ORDER BY EmployeeCount) AS PreviousJobLevel,
				   LAG(JobRole) OVER (PARTITION BY EmployeeID ORDER BY EmployeeCount) AS PreviousJobRole
			   from general_data) as job_changes
		where CurrentJobLevel != PreviousJobLevel or CurrentJobRole != PreviousJobRole

-- 12 --  Find the average distance from home for employees in each department.

		select g.Department ,round(avg(g.DistanceFromHome),0) 
		from general_data g
		group by g.Department

-- 13 -- Retrieve the top 5 employees with the highest MonthlyIncome.

		select top 6 g.[Emp Name] EmployeeName , g.MonthlyIncome
		from general_data g
		order by g.MonthlyIncome desc

-- 14 --  Calculate the percentage of employees who have had a promotion in the last year.

		select (count(case when g.YearsSinceLastPromotion <= 1 then 1 end) * 100.0) 
		         / count(*) as PromotionPercentage
		FROM general_data g;

-- 15 -- List the employees with the highest and lowest EnvironmentSatisfaction

		select max(e.EnvironmentSatisfaction) as  highest_EnvironmentSatisfaction 
		 , min(e.EnvironmentSatisfaction) as lowest_EnvironmentSatisfaction
		from employee_survey e

-- 16 --  Find the employees who have the same JobRole and MaritalStatus.
		
		select g1.[Emp Name] Employee_Name , g1.JobRole , g1.MaritalStatus
		from general_data g1 join general_data g2
		on g1.EmployeeID != g2.EmployeeID
		 and g1.JobRole = g2.JobRole 
		 and g1.MaritalStatus = g2.MaritalStatus 

-- 17 -- List the employees with the highest TotalWorkingYears who also have a 
        -- PerformanceRating of 4.
		   
		   select g.[Emp Name] Employee_Name 
		   from general_data g join employee_survey e
		   on e.EmployeeID = g.EmployeeID
		   where g.TotalWorkingYears = (select max(g1.TotalWorkingYears) from general_data g1)
		   and e.JobSatisfaction  = 4

-- 18 -- Calculate the average Age and JobSatisfaction for each BusinessTravel type

		 select g.BusinessTravel , avg(g.Age) Age , avg(e.JobSatisfaction) JobSatisfaction
	     from general_data g join employee_survey e
		 on e.EmployeeID = g.EmployeeID
		 group by g.BusinessTravel


-- 19 -- Retrieve the most common EducationField among employees

		select top 1 g.EducationField , count(g.EducationField)
		from general_data g
		group by g.EducationField
		order by count(g.EducationField) desc

-- 20 --  List the employees who have worked for the company the longest but haven't had a 
       -- promotion.

		select g.[Emp Name] Employee_Name , g.YearsAtCompany, g.YearsSinceLastPromotion
		from general_data g
		where g.YearsAtCompany = (select max(g1.YearsAtCompany) from general_data g1)
		and (g.YearsSinceLastPromotion = 0 or g.YearsSinceLastPromotion is null )