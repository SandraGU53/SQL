with regionEmpCount as(
  select 
    reg.name,
    count(emp.id) as empNum
  from regions reg
  left join states sta on sta.regionId = reg.id 
  left join employees emp on emp.stateId = sta.id
  group by reg.name
),regionAmount as(
  select 
    reg.name,
    sal.employeeId,
    isnull(sum(amount),0) as totalAmount
  from regions reg
  inner join states sta on sta.regionId = reg.id 
  inner join employees emp on emp.stateId = sta.id
  inner join sales sal on sal.employeeId = emp.id
  group by reg.name,sal.employeeId

), regionAVGAmount as(
select 
  cnt.name,
  case when max(cnt.empNum) =0 then 0
  else isnull(sum(amt.totalAmount),0)/max(cnt.empNum) end as average
from regionEmpCount cnt
left join regionAmount amt on cnt.name = amt.name
group by cnt.name)

select 
name,
average,
(select max(average)from regionAVGAmount)-average as difference
from regionAVGAmount
