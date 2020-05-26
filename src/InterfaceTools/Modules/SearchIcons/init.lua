local CollectionService = game:GetService("CollectionService")

local MaterialIcon = require(script.Parent.MaterialIcon)
local MaterialSpritesheet = require(script.Parent.MaterialIcon.MaterialSpritesheet)
local FuzzySearch = require(script.FuzzySearch)
local t = require(script.t)

local IconStrings = table.create(957)

local Length = 0
for IconName in next, MaterialSpritesheet do
	Length = Length + 1
	IconStrings[Length] = IconName
end

table.sort(IconStrings)

local WHITE_COLOR3 = Color3.new(1, 1, 1)
local ICON_SIZE = UDim2.fromOffset(25, 25)
local EMPTY_UDIM2 = UDim2.new()
local EMPTY_VECTOR2 = Vector2.new()

local function InputBeganFenv(GuiButton)
	return function(InputObject)
		if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			print(GuiButton.Name)
		end
	end
end

local SearchIcons = {}
local ipairs = ipairs

local SearchTuple = t.tuple(t.string, t.Instance)
local GenerateTuple = t.tuple(t.Instance, t.callback, t.optional(t.Color3))

--[[**
	Searches for an icon using fuzzy string searching.

	@param [t:string] IconName The name of the icon to search for.
	@param [t:Instance] Parent The parent of the icons. Must have had Generate called on it.
	@returns [void]
**--]]
function SearchIcons.Search(IconName, Parent)
	assert(SearchTuple(IconName, Parent))
	local MatchedIcons = FuzzySearch(string.lower(IconName), IconStrings)

	for _, Information in ipairs(MatchedIcons) do
		local Icon = Parent:FindFirstChild(Information.String)
		if Icon then
			Icon.LayoutOrder = Information.Distance
		end
	end
end

--[[**
	Generates all the material icons in the given Parent.

	@param [t:Instance] Parent The parent to generate the icons in.
	@param [t:callback] Function The function that'll be called when then icon is pressed. The API should be: Function(Icon, InputObject).
	@param [t:optional<t:Color3>] IconColor3 The Color3 of the icons. Will default to white if not given.
	@returns [void]
**--]]
function SearchIcons.Generate(Parent, Function, IconColor3)
	assert(GenerateTuple(Parent, Function, IconColor3))
	IconColor3 = IconColor3 or WHITE_COLOR3

	if not CollectionService:HasTag(Parent, "IconsGenerated") then
		CollectionService:AddTag(Parent, "IconsGenerated")

		for _, IconName in ipairs(IconStrings) do
			local Icon = MaterialIcon{
				Icon = IconName;
				Type = "ImageButton";
				IconColor3 = IconColor3;
				IconTransparency = 0;
				Size = ICON_SIZE;
				Position = EMPTY_UDIM2;
				AnchorPoint = EMPTY_VECTOR2;
				ZIndex = 2;
			}

			Icon.Name = IconName
			Icon.Parent = Parent
			Icon.InputBegan:Connect(function(InputObject)
				if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
					Function(Icon, InputObject)
				end
			end)
		end
	else
		warn("The Instance", Parent, "has already had icons generated in.")
	end
end

return SearchIcons