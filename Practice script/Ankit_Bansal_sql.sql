select * from employee_checkin_details;
select * from employee_details ;

-- Q1. Write an Sql code to find output table as below
-- employee_id, employee_default_phone_number, total_entry, total_login,total_logout, latest_login,latest_logout

select employeeid, count(*) total_count,
count(case when entry_details = 'login' then timestamp_details else null end) as total_login,
count(case when entry_details = 'logout' then timestamp_details else null end) as total_logout,
max(case when entry_details = 'login' then timestamp_details else null end) as latest_login,
max(case when entry_details = 'logout' then timestamp_details else null end) as latest_logout
from employee_checkin_details
group by employeeid;
