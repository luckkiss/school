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
	for line in io.lines(stockCode .. '/' .. fileName)
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


-- 检查策略：http://news.cnfol.com/guoneicaijing/20190601/27513766.shtml

-- 检查长期借款+短期借款是否大于货币资金，如是表明账上的钱都是借来的
for key, monetary in ipairs(balancesheet['货币资金'])
do
    local totalLoans = getNumValue(balancesheet['长期借款'][key]) + getNumValue(balancesheet['短期借款'][key])
    if(totalLoans >= getNumValue(monetary))
	then
	    print(balancesheet['资产负债表'][key] .. ': long-term loans(' .. balancesheet['长期借款'][key] .. ') + short-term loans(' .. balancesheet['短期借款'][key] .. ') = ' .. getStrValue(totalLoans) .. ' , bigger than monetary capital(' .. monetary .. ')')
	end
end

-- 检查营业总收入增速和存货增速对比
for i = 1, #profitstatement['营业总收入'] - 1
do
    local incomeYOY = getNumValue(profitstatement['营业总收入'][i]) / getNumValue(profitstatement['营业总收入'][i + 1]) - 1
	local inventoryYOY = getNumValue(balancesheet['存货'][i]) / getNumValue(balancesheet['存货'][i + 1]) - 1
	if(inventoryYOY / incomeYOY >= 1.8)
	then
	    print(balancesheet['资产负债表'][i] .. ': inventory YOY(' .. getPencentStr(inventoryYOY) .. ') bigger than income YOY(' .. getPencentStr(incomeYOY) .. ')')
	end    
end

-- 检查预收账款/营业总收入
for key, monetary in ipairs(balancesheet['货币资金'])
do
    local totalLoans = getNumValue(balancesheet['预收款项'][key]) / getNumValue(profitstatement['营业总收入'][key])
    if(totalLoans >= getNumValue(monetary))
	then
	    print(balancesheet['资产负债表'][key] .. ': long-term loans(' .. balancesheet['长期借款'][key] .. ') + short-term loans(' .. balancesheet['短期借款'][key] .. ') = ' .. getStrValue(totalLoans) .. ' , bigger than monetary capital(' .. monetary .. ')')
	end
end
