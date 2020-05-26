-- Returns the Levenshtein distance between the two given strings
local utf8_len = utf8.len -- I'm not even sure if this is faster localized, thanks Luau and your massive inconsistency.
local utf8_codes = utf8.codes

local function Levenshtein(String1, String2)
	if String1 == String2 then
		return 0
	end

	local Length1 = utf8_len(String1)
	local Length2 = utf8_len(String2)

	if Length1 == 0 then
		return Length2
	elseif Length2 == 0 then
		return Length1
	end

	local Matrix = {} -- Would love to use table.create for this, but it starts at 0.
	for Index = 0, Length1 do
		Matrix[Index] = {[0] = Index}
	end

	for Index = 0, Length2 do
		Matrix[0][Index] = Index
	end

	local Index = 1
	local IndexSub1

	for _, Code1 in utf8_codes(String1) do
		local Jndex = 1
		local JndexSub1

		for _, Code2 in utf8_codes(String2) do
			local Cost = Code1 == Code2 and 0 or 1
			IndexSub1 = Index - 1
			JndexSub1 = Jndex - 1

			Matrix[Index][Jndex] = math.min(Matrix[IndexSub1][Jndex] + 1, Matrix[Index][JndexSub1] + 1, Matrix[IndexSub1][JndexSub1] + Cost)
			Jndex = Jndex + 1
		end

		Index = Index + 1
	end

	return Matrix[Length1][Length2]
end

local function SortResults(A, B)
	return A.Distance < B.Distance
end

local function FuzzySearch(String, ArrayOfStrings, MaxResults)
	local Results = table.create(#ArrayOfStrings)

	for Index, Value in ipairs(ArrayOfStrings) do
		Results[Index] = {
			String = Value;
			Distance = Levenshtein(String, Value);
		}
	end

	table.sort(Results, SortResults)
	return Results
end

return FuzzySearch