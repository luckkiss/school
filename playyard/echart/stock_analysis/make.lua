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

local function getYOY(current, last)
    if(0 == last)
	then
	    return 0
	end
	return current / last - 1
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

local function toJson(dataMap)
    local jsonStr = ''
	local tmpArr = {}
    for key, value in pairs(dataMap)
	do
	    local tmpStr = '"' .. key .. '": ['
		local tmpSubArr = {}
		for subKey, subValue in pairs(value)
		do
			if('string' == type(subValue))
			then
			    table.insert(tmpSubArr, '"' .. subValue .. '"')
			else
			    table.insert(tmpSubArr, subValue)
			end
		end
	    table.insert(tmpArr, tmpStr .. table.concat(tmpSubArr, ', ') .. ']')
	end
	return '{' .. table.concat(tmpArr, ', ') .. '}'
end

function makeAll()
    local initData = ''
	
    for entry in lfs.dir('data')
	do
	    if entry ~= '.' and entry ~= '..' then
		    stockCode = entry
		    fileRoot = 'data/' .. stockCode .. '/'
			-- 资产负债表
			balancesheet = {}
			parseSheet(fileRoot .. 'balancesheet.txt', balancesheet, '资产负债表')

			-- 利润表
			profitstatement = {}
			parseSheet(fileRoot .. 'profitstatement.txt', profitstatement, '利润表')

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
				profitstatement['营业总收入同比'][i] = getYOY(profitstatement['营业总收入'][i], profitstatement['营业总收入'][i + 1])
				profitstatement['归母净利润同比'][i] = getYOY(profitstatement['其中:归属于母公司股东的净利润'][i], profitstatement['其中:归属于母公司股东的净利润'][i + 1])
				profitstatement['毛利率同比'][i] = getYOY(profitstatement['毛利率'][i], profitstatement['毛利率'][i + 1])
				profitstatement['净利率同比'][i] = getYOY(profitstatement['净利率'][i], profitstatement['净利率'][i + 1])
				
				balancesheet['存货同比'][i] = getYOY(balancesheet['存货'][i], balancesheet['存货'][i + 1])
			end
			
			initData = initData .. 'dataMap["' .. stockCode .. '"] = {"balancesheet": ' .. toJson(balancesheet) .. ', "profitstatement": ' .. toJson(profitstatement) .. '};\n'
		end
	end

	-- 读入页面模板
	tmplFile = io.open('tmpl.html', 'r')
	htmlContent = tmplFile:read('*a')
	tmplFile:close()
	
	htmlContent = string.gsub(htmlContent, '<initData>', initData)

	-- 生成页面
	htmlFile = io.open('index.html', 'w')
	io.output(htmlFile)
	io.write(htmlContent)
	io.close(htmlFile)
end