if os == nil then
  os = class({})
end

function os:Initialize()

   standardFormat = '%A, %B %d %Y at %H:%M:%S'
   timeMeasure = SKIN:GetMeasure('TimeMeasure')
   
end

function os:Update()

   local itemDate = timeMeasure:GetStringValue()
   if itemDate == '' then return -1 end
   
   local timeLocalNow = os.time(os.date('*t'))
   local timeUTCNow = os.time(os.date('!*t'))
   if os.date(isdst) then
      timeUTCAdjusted = timeUTCNow - 3600
   end
      
   local itemTimeStamp = TimeStamp(itemDate)
   
   local diffTotal = timeUTCNow - itemTimeStamp
   
   SKIN:Bang('!SetOption', 'MeterNowLocal', 'Text', 'Now Local:   '..os.date(standardFormat, timeLocalNow))
   SKIN:Bang('!SetOption', 'MeterNowUTC', 'Text', 'Now UTC:   '..os.date(standardFormat, timeUTCAdjusted))
   SKIN:Bang('!SetOption', 'MeterDate1Original', 'Text', 'Input String:   '..itemDate)
   SKIN:Bang('!SetOption', 'MeterDate1Formatted', 'Text', 'Formatted:   '..os.date(standardFormat, itemTimeStamp))   
   
   if diffTotal >= 0 then
      textPrefix = 'Elapsed:'
   else
      textPrefix = 'Remaining:'
   end
      
   diffWeeks, diffDays, diffHours, diffMinutes, diffSeconds = FormatSeconds(math.abs(diffTotal))
   
   if diffWeeks == 1 then
      outputWeeks = diffWeeks..' Week'
   else
      outputWeeks = diffWeeks..' Weeks'
   end
   
   if diffDays == 1 then
      outputDays = diffDays..' Day'
   else
      outputDays = diffDays..' Days'
   end
   
   if diffHours == 1 then
      outputHours = diffHours..' Hour'
   else
      outputHours = diffHours..' Hours'
   end
   
   if diffMinutes == 1 then
      outputMinutes = diffMinutes..' Minute'
   else
      outputMinutes = diffMinutes..' Minutes'
   end   
   
   if diffSeconds == 1 then
      outputSeconds = diffSeconds..' Second'
   else
      outputSeconds = diffSeconds..' Seconds'
   end      
   
   if diffWeeks > 0 then
      outputString = textPrefix..'     '..outputWeeks..' '..outputDays..' '..outputHours..' '..outputMinutes..' '..outputSeconds
   elseif diffDays > 0 then
      outputString = textPrefix..'     '..outputDays..' '..outputHours..' '..outputMinutes..' '..outputSeconds
   elseif diffHours > 0 then
      outputString = textPrefix..'     '..outputHours..' '..outputMinutes..' '..outputSeconds
   elseif diffMinutes > 0 then
      outputString = textPrefix..'     '..outputMinutes..' '..outputSeconds
   else
      outputString = textPrefix..'     '..outputSeconds
   end
   
   SKIN:Bang('!SetOption', 'MeterDiffFormatted', 'Text', outputString)
   
   return diffTotal
   
end

function os:TimeStamp(dateStringArg)
   
   local inYear, inMonth, inDay, inHour, inMinute, inSecond, inZone =      
  string.match(dateStringArg, '^(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)(.-)$')

   local zHours, zMinutes = string.match(inZone, '^(.-):(%d%d)$')
   inYear = string.sub(inYear, 3)
   local returnTime = {year=inYear, month=inMonth, day=inDay, hour=inHour, min=inMinute, sec=inSecond, isdst=false}
      
   -- local returnTime = os.time({year=inYear, month=inMonth, day=inDay, hour=inHour, min=inMinute, sec=inSecond, isdst=false})
   
   -- if zHours then
   --    returnTime = returnTime - ((tonumber(zHours)*3600) + (tonumber(zMinutes)*60))
   -- end
   
   return returnTime
   
end

function os:ServerTimeToTable()
 	local date = GetSystemDate()
	local time = GetSystemTime()
	local inMonth, inDay, inYear =  string.match(date, '^(%d%d)/(%d%d)/(%d%d)$')
   local inHour, inMinute, inSecond = string.match(time, '^(%d%d):(%d%d):(%d%d)$')

   local returnTime = {year=inYear, month=inMonth, day=inDay, hour=inHour, min=inMinute, sec=inSecond, isdst=false}
      
   -- local returnTime = os.time({year=inYear, month=inMonth, day=inDay, hour=inHour, min=inMinute, sec=inSecond, isdst=false})
   
   -- if zHours then
   --    returnTime = returnTime - ((tonumber(zHours)*3600) + (tonumber(zMinutes)*60))
   -- end
   
   return returnTime
   
end

function os:FormatSeconds(secondsArg)

   local weeks = math.floor(secondsArg / 604800)
   local remainder = secondsArg % 604800
   local days = math.floor(remainder / 86400)
   local remainder = remainder % 86400
   local hours = math.floor(remainder / 3600)
   local remainder = remainder % 3600
   local minutes = math.floor(remainder / 60)
   local seconds = remainder % 60
   
   return weeks, days, hours, minutes, seconds
   
end