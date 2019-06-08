function split(str, reps)
    local resultStrList = {}
	string.gsub(str, '[^'..reps..']+', function(w)
	    table.insert(resultStrList, w)
		-- print(w)
	end)
	return resultStrList
end