require('lfs')
require('strutil')

local function getNumValue(strValue)
    if(strValue == '--')
	then
	    return 0
	end
	local valueStart, valueEnd = string.find(strValue, '[%d\.]+')
    local value = tonumber(string.sub(strValue, valueStart, valueEnd))
	if(2 == valueStart)
	then
	  value = -value
	end
	local unit = '无'
	local unitStart, unitEnd = string.find(strValue, '[^%d\.]+$')
	if(unitStart)
	then
	    unit = string.sub(strValue, unitStart, unitEnd)
	end
	
	local unitMap = {}
	local unitNames = {'亿', '万', '千', '百', '十', '无'}
	local unitValues = {100000000, 10000, 1000, 100, 10, 1}
	for k, v in pairs(unitNames)
	do
	    unitMap[v] = unitValues[k]
	end
	return value * unitMap[unit]
end

local function getStrValue(numValue)
    if(numValue >= 100000000)
	then
	    return string.format('%.3f亿', numValue / 100000000)
	else
	    return string.format('%.3f万', numValue / 10000)
	end
end

local function getPencentStr(value)
    return string.format('%.2f', value * 100) .. '%'
end

local function parseSheet(fileName, dataMap, mapTitle)
	for line in io.lines(fileName)
	do
		line = string.gsub(line, '^[%s]*', '')
		local lineArr = split(line, '\t')
		local itemName = table.remove(lineArr, 1)
		if not(itemName == mapTitle)
		then
			for key, value in ipairs(lineArr)
			do
				lineArr[key] = getNumValue(value)
			end
		end
		dataMap[itemName] = lineArr
	end
end

local function makeHtml(stockCode)
    fileRoot = 'data/' .. stockCode .. '/'
	-- 资产负债表
	balancesheet = {}
	parseSheet(fileRoot .. 'balancesheet.txt', balancesheet, '资产负债表')

	-- 利润表
	profitstatement = {}
	parseSheet(fileRoot .. 'profitstatement.txt', profitstatement, '利润表')

	-- 读入页面模板
	tmplFile = io.open('tmpl.html', 'r')
	htmlContent = tmplFile:read('*a')
	tmplFile:close()

	-- 写入数据
	local periodCnt = #profitstatement['利润表']
	profitstatement['毛利润'] = {}
	profitstatement['毛利率'] = {}
	profitstatement['净利率'] = {}
	for i = 1, periodCnt
	do
		profitstatement['毛利润'][i] = profitstatement['营业总收入'][i] - profitstatement['营业成本'][i]
		profitstatement['毛利率'][i] = profitstatement['毛利润'][i] / profitstatement['营业总收入'][i]
		profitstatement['净利率'][i] = profitstatement['净利润'][i] / profitstatement['营业总收入'][i]	
	end

	profitstatement['营业总收入同比'] = {}
	profitstatement['归母净利润同比'] = {}
	profitstatement['毛利率同比'] = {}
	profitstatement['净利率同比'] = {}

	balancesheet['存货同比'] = {}
	for i = 1, periodCnt - 1
	do
		profitstatement['营业总收入同比'][i] = profitstatement['营业总收入'][i] / profitstatement['营业总收入'][i + 1] - 1
		profitstatement['归母净利润同比'][i] = profitstatement['其中:归属于母公司股东的净利润'][i] / profitstatement['其中:归属于母公司股东的净利润'][i + 1] - 1
		profitstatement['毛利率同比'][i] = profitstatement['毛利率'][i] / profitstatement['毛利率'][i + 1] - 1
		profitstatement['净利率同比'][i] = profitstatement['净利率'][i] / profitstatement['净利率'][i + 1] - 1
		
		balancesheet['存货同比'][i] = balancesheet['存货'][i] / balancesheet['存货'][i + 1] - 1
	end

	local periods = ''
	local shortTermLoans = ''
	local longTermLoans = ''
	local monetaryCapitals = ''
	for i = 1, periodCnt
	do
		if not(periods == '')
		then
			periods = ', ' .. periods
			shortTermLoans = ', ' .. shortTermLoans
			longTermLoans = ', ' .. longTermLoans
			monetaryCapitals = ', ' .. monetaryCapitals
		end
		periods = '\'' .. balancesheet['资产负债表'][i] .. '\'' .. periods
		shortTermLoans = balancesheet['短期借款'][i] .. shortTermLoans
		longTermLoans = balancesheet['长期借款'][i] .. longTermLoans
		monetaryCapitals = balancesheet['货币资金'][i] .. monetaryCapitals
	end

	local periodsYOY = ''
	local incomeYOYs = ''
	local netProfitYOYs = ''
	local grossProfitMarginYOYs = ''
	local netProfitMarginYOYs = ''
	local inventoryYOYS = ''
	for i = 1, periodCnt - 1
	do
		if not(periodsYOY == '')
		then
			periodsYOY = ', ' .. periodsYOY
			incomeYOYs = ', ' .. incomeYOYs
			netProfitYOYs = ', ' .. netProfitYOYs
			grossProfitMarginYOYs = ', ' .. grossProfitMarginYOYs
			netProfitMarginYOYs = ', ' .. netProfitMarginYOYs
			inventoryYOYS = ', ' .. inventoryYOYS
		end
		periodsYOY = '\'' .. balancesheet['资产负债表'][i] .. '\'' .. periodsYOY
		incomeYOYs = string.format('%.2f', profitstatement['营业总收入同比'][i] * 100) .. incomeYOYs
		netProfitYOYs = string.format('%.2f', profitstatement['归母净利润同比'][i] * 100) .. netProfitYOYs
		grossProfitMarginYOYs = string.format('%.2f', profitstatement['毛利率同比'][i] * 100) .. grossProfitMarginYOYs
		netProfitMarginYOYs = string.format('%.2f', profitstatement['净利率同比'][i] * 100) .. netProfitMarginYOYs
		inventoryYOYS = string.format('%.2f', balancesheet['存货同比'][i] * 100) .. inventoryYOYS
	end

	htmlContent = string.gsub(htmlContent, '<periods>', periods)
	htmlContent = string.gsub(htmlContent, '<shortTermLoans>', shortTermLoans)
	htmlContent = string.gsub(htmlContent, '<longTermLoans>', longTermLoans)
	htmlContent = string.gsub(htmlContent, '<monetaryCapitals>', monetaryCapitals)
	htmlContent = string.gsub(htmlContent, '<periodsYOY>', periodsYOY)
	htmlContent = string.gsub(htmlContent, '<incomeYOYs>', incomeYOYs)
	htmlContent = string.gsub(htmlContent, '<netProfitYOYs>', netProfitYOYs)
	htmlContent = string.gsub(htmlContent, '<grossProfitMarginYOYs>', grossProfitMarginYOYs)
	htmlContent = string.gsub(htmlContent, '<netProfitMarginYOYs>', netProfitMarginYOYs)
	htmlContent = string.gsub(htmlContent, '<inventoryYOYS>', inventoryYOYS)

	-- 生成页面
	htmlFile = io.open(stockCode .. '.html', 'w')
	io.output(htmlFile)
	io.write(htmlContent)
	io.close(htmlFile)
end

function makeAll()
    for entry in lfs.dir('data')
	do
	    if entry ~= '.' and entry ~= '..' then
		    makeHtml(entry)
		end
	end
end