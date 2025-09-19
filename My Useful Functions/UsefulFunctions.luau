--!strict

--[[ READ ME
	THIS CAN BE INSERTED INTO ANY GAME, SINCE ALL OF THE FUNCTIONS ARE PURE, MEANING THAT
	THEY DON'T USE ANY VALUES OUTSIDE OF THE FUNCTION'S SCOPE.
	INSERT ME IN REPLICATED STORAGE.
]]

local functions = {}

-----[BOOLEAN ALGEBRA]-----

type bool = boolean | () -> (boolean)

function functions:Nand(condition1: bool, condition2: bool): boolean
	if type(condition1) == "function" then
		if type(condition2) == "function" then
			return not(condition1() and condition2())
		else
			return not(condition1() and condition2)
		end
	else
		if type(condition2) == "function" then
			return not(condition1 and condition2())
		else
			return not(condition1 and condition2)
		end
	end
end

function functions:Nor(condition1: bool, condition2: bool): boolean
	if type(condition1) == "function" then
		if type(condition2) == "function" then
			return not(condition1() or condition2())
		else
			return not(condition1() or condition2)
		end
	else
		if type(condition2) == "function" then
			return not(condition1 or condition2())
		else
			return not(condition1 or condition2)
		end
	end
end

-----[VARIATIONS OF ":GetChildren()"]-----

-- returns a table of an instance's children with a specified tag
function functions:GetChildrenWithTag(instance: Instance, ...: string): {Instance}
	local children = {}
	local hasTags = {}
	
	local tags = {...}
	
	for _, element: Instance in pairs(instance:GetChildren()) do
		for _, tag in ipairs(tags) do
			table.insert(hasTags, element:HasTag(tag) or (#element:GetTags() == 0 and tag == "{notag}"))
		end
		
		if #element:GetTags() == #tags then
			local isTrue = false
			
			for _, truth in ipairs(hasTags) do
				if not truth then
					isTrue = false
					break
				else
					isTrue = true
				end
			end
			
			if isTrue then
				table.insert(children, element)
			end
		end
		
		table.clear(hasTags)
	end
	
	return children
end

-- returns a table of an instance's children which are a specific type of object
function functions:GetChildrenWhichAre(instance: Instance, className: string): {Instance}
	local children = {}
	
	for _, element: Instance in pairs(instance:GetChildren()) do
		if element:IsA(className) then
			table.insert(children, element)
		end
	end
	
	return children
end

-----[VARIATIONS OF ":FindFirstChild()"]-----

-- returns a child which was first found in an instance with a specified tag
-- (if such child doesn't exist, returns nil)
function functions:FindFirstChildWithTag(instance: Instance, ...: string): Instance?
	local hasTags = {}

	local tags = {...}

	for _, element: Instance in pairs(instance:GetChildren()) do
		for _, tag in ipairs(tags) do
			table.insert(hasTags, element:HasTag(tag) or (#element:GetTags() == 0 and tag == "{notag}"))
		end

		if #element:GetTags() == #tags then
			local isTrue = false

			for _, truth in ipairs(hasTags) do
				if not truth then
					isTrue = false
					break
				else
					isTrue = true
				end
			end

			if isTrue then
				return element
			end
		end

		table.clear(hasTags)
	end

	return nil
end

-----[VARIATIONS OF ":GetDescendants()"]-----

-- returns the descendants of an instance which have the specified tag
function functions:GetDescendantsWithTag(instance: Instance, ...: string): {Instance}
	local descendants: {Instance} = {}
	local hasTags = {}

	local tags = {...}

	for _, element: Instance in pairs(instance:GetDescendants()) do
		for _, tag in ipairs(tags) do
			table.insert(hasTags, element:HasTag(tag) or (#element:GetTags() == 0 and tag == "{notag}"))
		end

		if #element:GetTags() == #tags then
			local isTrue = false

			for _, truth in ipairs(hasTags) do
				if not truth then
					isTrue = false
					break
				else
					isTrue = true
				end
			end

			if isTrue then
				table.insert(descendants, element)
			end
		end

		table.clear(hasTags)
	end
	
	return descendants
end

-- returns the descendants of an instance which have the specified class name
function functions:GetDescendantsWhichAre(instance: Instance, className: string): {Instance}
	local descendants: {Instance} = {}
	
	for _, instance in pairs(instance:GetDescendants()) do
		if instance:IsA(className) then
			table.insert(descendants, instance)
		end
	end
	
	return descendants
end

-----[FUNCTIONS THAT IMPROVE READABILITY]-----

-- checks if the table is in a dictionary format
function functions:IsADictionary(myTable: {any}): boolean
	return not myTable[1]
end

-- removes a certain value from a table/dictionary (if done with a dictionary, must input the value's name)
function functions:RemoveFromTable(myTable: {any}, target: any): {any}
	local tablePos = table.find(myTable, target)

	if not tablePos then
		-- myTable is a dictionary
		if self:GetDictionaryLength(myTable) == 0 then
			warn("Table is empty!")
			return {}
		end

		myTable[target] = nil
	else
		-- myTable is a table
		table.remove(myTable, tablePos)
	end

	return myTable
end

-- finds the length of the dictionary (can't use # symbol)
function functions:GetDictionaryLength(dict: {any}): number
	local length = 0

	for i, v in pairs(dict) do
		length += 1
	end

	return length
end

-----[OTHER USEFUL FUNCTIONS]-----

-- makes a copy of a table/dictionary without referencing the original table
function functions:DeepCopy(myTable: {any}): {any}
	local copy = {}

	for index, value in pairs(myTable) do
		copy[index] = value
	end

	return copy
end

-- filters through a table by checking if the element of a table meets a specific requirement (credit to Crusherfire for the idea)
function functions:Filter<T>(myTable: {T}, requirement: (T) -> (boolean)): {T} | T
	local newTable: {any} = {}
	
	for name, element in pairs(myTable) do
		if requirement(element) then
			if self:IsADictionary(myTable) then
				newTable[name] = element
			else
				table.insert(newTable, element)
			end
		end
	end
	
	return newTable
end

return functions
