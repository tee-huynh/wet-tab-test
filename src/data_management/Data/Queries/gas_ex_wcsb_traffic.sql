select [Date],
[Alliance Pipeline Limited Partnership - Alliance Pipeline - Border] as [Alliance Pipeline - Border],
[Foothills Pipe Lines Ltd. (Foothills) - Foothills System - Kingsgate] as [Foothills System - Kingsgate],
[Foothills Pipe Lines Ltd. (Foothills) - Foothills System - Monchy] as [Foothills System - Monchy],
[TransCanada PipeLines Limited - Canadian Mainline - Prairies] as [TC Canadian Mainline - Prairies (Empress)],
--[TransCanada PipeLines Limited - Canadian Mainline - Emerson I] as [TC Canadian Mainline - Emerson I],
--[TransCanada PipeLines Limited - Canadian Mainline - Emerson II] as [TC Canadian Mainline - Emerson II],
[Westcoast Energy Inc. - BC Pipeline - Huntingdon Export] + [Westcoast Energy Inc. - BC Pipeline - FortisBC Lower Mainland] as [Westcoast Energy Inc. - BC Pipeline - Huntingdon/Lower Mainland],
[Capacity (1000 m3/d)] as [Capacity]
from (SELECT 
cast(str([Month])+'-'+'1'+'-'+str([Year]) as date) as [Date],
[Corporate Entity]+' - '+[Pipeline Name]+' - '+[Key Point] as [Point],
round(avg(([Throughput (1000 m3/d)]/28316.85)),2) as [value]
FROM [EnergyData].[dbo].[Pipelines_Gas] where 
([Year] >= '2015' and [Corporate Entity] = 'Alliance Pipeline Limited Partnership' and [Key Point] = 'Border') or
([Year] >= '2015' and [Corporate Entity] = 'Westcoast Energy Inc.' and [Key Point] = 'Huntingdon Export') or
([Year] >= '2015' and [Corporate Entity] = 'Westcoast Energy Inc.' and [Key Point] = 'FortisBC Lower Mainland') or
--([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Emerson I') or
--([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Emerson II') or
([Year] >= '2015' and [Corporate Entity] = 'Foothills Pipe Lines Ltd. (Foothills)' and [Key Point] in ('Kingsgate','Monchy')) or
([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Prairies')
group by [Year], [Month], [Corporate Entity], [Pipeline Name], [Key Point], [Trade Type]
union all
select [Date], 'Capacity (1000 m3/d)' as [Point], round(sum([Capacity (1000 m3/d)]/28316.85),2) as [value]
from (SELECT cast(str([Month])+'-'+'1'+'-'+str([Year]) as date) as [Date],[Corporate Entity],[Pipeline Name], [Key Point],
round(avg([Capacity (1000 m3/d)]),1) as [Capacity (1000 m3/d)]
FROM [EnergyData].[dbo].[Pipelines_Gas] where
([Year] >= '2015' and [Corporate Entity] = 'Alliance Pipeline Limited Partnership' and [Key Point] = 'Border') or
([Year] >= '2015' and [Corporate Entity] = 'Westcoast Energy Inc.' and [Key Point] = 'Huntingdon Export') or
--([Year] >= '2015' and [Corporate Entity] = 'Westcoast Energy Inc.' and [Key Point] = 'FortisBC Lower Mainland') or
--([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Emerson I') or
--([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Emerson II') or
([Year] >= '2015' and [Corporate Entity] = 'Foothills Pipe Lines Ltd. (Foothills)' and [Key Point] in ('Kingsgate','Monchy')) or
([Year] >= '2015' and [Corporate Entity] = 'TransCanada PipeLines Limited' and [Key Point] = 'Prairies') 
group by [Year],[Month],[Corporate Entity],[Pipeline Name], [Key Point]
) as gas_cap group by [Date]) as SourceTable
pivot (avg([value])
for Point in ([Alliance Pipeline Limited Partnership - Alliance Pipeline - Border],
[Foothills Pipe Lines Ltd. (Foothills) - Foothills System - Kingsgate],
[Foothills Pipe Lines Ltd. (Foothills) - Foothills System - Monchy],
[TransCanada PipeLines Limited - Canadian Mainline - Prairies],
--[TransCanada PipeLines Limited - Canadian Mainline - Emerson I],
--[TransCanada PipeLines Limited - Canadian Mainline - Emerson II],
[Westcoast Energy Inc. - BC Pipeline - Huntingdon Export],
[Westcoast Energy Inc. - BC Pipeline - FortisBC Lower Mainland],
[Capacity (1000 m3/d)])
) as PivotTable order by [Date]