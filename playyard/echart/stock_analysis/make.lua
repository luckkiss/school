stockCode = "600337";

function split(str, reps)
    local resultStrList = {}
	string.gsub(str, '[^'..reps..']+', function(w)
	    table.insert(resultStrList, w)
		-- print(w)
	end)
	return resultStrList
end

function getNumValue(strValue)
    local value = tonumber(string.sub(strValue, string.find(strValue, '[%d\.]+')))
	local unit = string.sub(strValue, string.find(strValue, '[^%d\.]+'))
	
	local unitMap = {}
	local unitNames = {'亿', '万', '千', '百', '十', '元'}
	local unitValues = {100000000, 10000, 1000, 100, 10, 1}
	for k, v in pairs(unitNames)
	do
	    unitMap[v] = unitValues[k]
	end
	return value * unitMap[unit]
end

function getStrValue(numValue)
    if(numValue >= 100000000)
	then
	    return string.format('%.3f亿', numValue / 100000000)
	else
	    return string.format('%.3f万', numValue / 10000)
	end
end

function getPencentStr(value)
    return string.format('%.2f', value * 100) .. '%'
end

function parseSheet(fileName, dataMap)
	for line in io.lines('data/' .. stockCode .. '/' .. fileName)
	do
		line = string.gsub(line, '^[%s]*', '')
		local lineArr = split(line, '\t')
		local itemName = table.remove(lineArr, 1)
		dataMap[itemName] = lineArr
	end
end

-- 资产负债表
balancesheet = {}
parseSheet('balancesheet.txt', balancesheet)

-- 利润表
profitstatement = {}
parseSheet('profitstatement.txt', profitstatement)

-- 读入页面模板
tmplFile = io.open('tmpl.html', 'r')
htmlContent = tmplFile:read('*a')
tmplFile:close()

-- 写入数据
local periods = ''
local shortTermLoans = ''
local longTermLoans = ''
local monetaryCapitals = ''
local loansVSmonetary = ''
for key, monetaryCapital in ipairs(balancesheet['货币资金'])
do
    if not(periods == '')
	then
	    periods = ', ' .. periods
		shortTermLoans = ', ' .. shortTermLoans
		longTermLoans = ', ' .. longTermLoans
		monetaryCapitals = ', ' .. monetaryCapitals
		loansVSmonetary = ', ' .. loansVSmonetary
	end
    periods = '\'' .. balancesheet['资产负债表'][key] .. '\'' .. periods
	local theShortTermLoans = getNumValue(balancesheet['短期借款'][key])
	local theLongTermLoans = getNumValue(balancesheet['长期借款'][key])
	local theMonetaryCapital = getNumValue(monetaryCapital)
	shortTermLoans = theShortTermLoans .. shortTermLoans
	longTermLoans = theLongTermLoans .. longTermLoans
	monetaryCapitals = theMonetaryCapital .. monetaryCapitals
	loansVSmonetary = string.format('%.2f', (theShortTermLoans + theLongTermLoans) / theMonetaryCapital) .. loansVSmonetary
end

htmlContent = string.gsub(htmlContent, '<periods>', periods)
htmlContent = string.gsub(htmlContent, '<shortTermLoans>', shortTermLoans)
htmlContent = string.gsub(htmlContent, '<longTermLoans>', longTermLoans)
htmlContent = string.gsub(htmlContent, '<monetaryCapitals>', monetaryCapitals)
htmlContent = string.gsub(htmlContent, '<loansVSmonetary>', loansVSmonetary)

-- 生成页面
htmlFile = io.open(stockCode .. '.html', 'w')
io.output(htmlFile)
io.write(htmlContent)
io.close(htmlFile)