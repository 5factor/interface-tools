-- Author: FiveFactor
-- File: Core.lua
-- Note: This plugin/script may be modified but you must leave credit
-- Note: You may not resuse this plugin for commercial purposes

-- Services
local StarterGui = game:GetService("StarterGui")

-- Plugin
local API, _Attempts = _G.PluginToolbar, 0; repeat API = _G.PluginToolbar; _Attempts = _Attempts + 1; wait() until API or _Attempts > 50; if not API then API = plugin end
local Toolbar = API:CreateToolbar("Factor Plugins", "Making UI design easy!", "rbxassetid://4509828459")
local TogglePluginButton = Toolbar:CreateButton("Interface Tools", "Factor Plugins", "rbxassetid://4509828459")

local SelectedGuiInstance = nil

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	800,    -- Default width of the floating window
	500,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)
 
-- Create new widget GUI
local NewWidget = plugin:CreateDockWidgetPluginGui("Interface Tools", widgetInfo)
NewWidget.Title = "Interface Tools"  -- Optional widget title
script.Parent.Parent.Assets.Main.Parent = NewWidget

TogglePluginButton.Click:Connect(function() NewWidget.Enabled = not NewWidget.Enabled end)

-- Plugin Variables
local PluginVariables = {}
local GuiPath = NewWidget

PluginVariables.Path = GuiPath

PluginVariables.Buttons = {
	Top = {
		Path = GuiPath.Main.Container.Options.Top,
		IconsButton = GuiPath.Main.Container.Body.IconsFrame,
		GradientsButton = GuiPath.Main.Container.Body.GradientsFrame,
		FramesButton = GuiPath.Main.Container.Body.FramesFrame,
		ButtonsButton = GuiPath.Main.Container.Body.ButtonsFrame,
		CustomIconsButton = GuiPath.Main.Container.Body.CustomIconsFrame
	},
	Bottom = {
		Path = GuiPath.Main.Container.Options.Bottom,
		APIButton = GuiPath.Main.Container.Body.APIFrame,
		SettingsButton = GuiPath.Main.Container.Body.SettingsFrame,
		CreditsButton = GuiPath.Main.Container.Body.CreditsFrame
	},
}

PluginVariables.Frames = {
	Path = GuiPath.Main.Container.Body,
	SettingsFrame = {
		Path = GuiPath.Main.Container.Body.SettingsFrame
	},
	APIFrame = {
		Path = GuiPath.Main.Container.Body.APIFrame
	},
	IconsFrame = {
		Path = GuiPath.Main.Container.Body.IconsFrame
	},
	GradientsFrame = {
		Path = GuiPath.Main.Container.Body.GradientsFrame
	},
	FramesFrame = {
		Path = GuiPath.Main.Container.Body.FramesFrame
	},
	ButtonsFrame = {
		Path = GuiPath.Main.Container.Body.ButtonsFrame
	},
	CustomIconsFrame = {
		Path = GuiPath.Main.Container.Body.CustomIconsFrame
	},
	CreditsFrame = {
		Path = GuiPath.Main.Container.Body.CreditsFrame
	}
}

-- Variables
local PluginButtons, PluginButtonsB = PluginVariables.Buttons.Top.Path, PluginVariables.Buttons.Bottom.Path
local AutoCanvasSize = require(script.Parent.Parent.Modules.AutoCanvasSize)
local IconButton = script.Parent.Parent.Assets.IconButton
local IconImage = script.Parent.Parent.Assets.IconImage
local PageLayout = GuiPath.Main.Container.Body.UIPageLayout

-- ScrollingFrames
for _, child in pairs (PluginVariables.Frames.Path:GetChildren()) do
	if child:FindFirstChild("Content") then
		local ContentFrame = child:FindFirstChild("Content")
		if ContentFrame:IsA("ScrollingFrame") then
			AutoCanvasSize.Connect(ContentFrame)
		end
	end
end

-- Local Functions
local function OpenPage(page, button)
	for _, child in pairs (PluginButtons:GetChildren()) do
		if child:IsA("TextButton") and child.Selectable == true then
			child.BackgroundTransparency = 1
		end
	end
	for _, child in pairs (PluginButtonsB:GetChildren()) do
		if child:IsA("TextButton") and child.Selectable == true then
			child.BackgroundTransparency = 1
		end
	end
	button.BackgroundTransparency = .8
	PageLayout:JumpTo(page)
end

-- Button Menu
for _, child in pairs (PluginButtons:GetChildren()) do
	if child:IsA("TextButton") and child.Selectable == true then
		child.MouseButton1Click:Connect(function()
			OpenPage(PluginVariables.Buttons.Top[child.Name], child)
		end)
	end
end

for _, child in pairs (PluginButtonsB:GetChildren()) do
	if child:IsA("TextButton") and child.Selectable == true then
		child.MouseButton1Click:Connect(function()
			OpenPage(PluginVariables.Buttons.Bottom[child.Name], child)
		end)
	end
end

-- Selection Parent
local Selection = game:GetService("Selection")

game.Selection.SelectionChanged:Connect(function()
	local SelectedObjects = Selection:Get()
	local SelectedObject = SelectedObjects[1]
	if SelectedObject and SelectedObject:IsA("GuiBase2d") then
		SelectedGuiInstance = SelectedObject
	else
		SelectedGuiInstance = nil
	end
end)

local function ParentToStarterGui()
	if not SelectedGuiInstance then
		local InsertedObjects = game.StarterGui:FindFirstChild("InsertedObjects")
		if not InsertedObjects then InsertedObjects = Instance.new("ScreenGui", StarterGui); InsertedObjects.Name = "InsertedObjects" end
		return InsertedObjects
	else
		return SelectedGuiInstance
	end
end

-- Custom Icons
local function UpdateIcons()
	local CustomIcons = _G.InterfaceTools:GetIcons()
	
	for _, PrevChild in pairs(PluginVariables.Frames.CustomIconsFrame.Path.Content:GetChildren()) do
		if PrevChild:IsA("ImageButton") then PrevChild:Destroy() end
	end
	
	if not CustomIcons then return end
	for Index, IconId in pairs(CustomIcons) do
		local NewIconButton = IconButton:Clone()
		NewIconButton.Image = IconId
		NewIconButton.Parent = PluginVariables.Frames.CustomIconsFrame.Path.Content
		
		NewIconButton.MouseButton1Click:Connect(function()
			local NewIconImage = IconImage:Clone()
			NewIconImage.Image = IconId
			NewIconImage.Parent = ParentToStarterGui()
			game.Selection:Set{NewIconImage}
		end)
	end
end

UpdateIcons()
script.Parent.Parent.Assets.NewIconEvent.Event:Connect(UpdateIcons)

-- Buttons Frame
for _, child in pairs (PluginVariables.Frames.ButtonsFrame.Path.Content:GetChildren()) do
	if child:IsA("GuiButton") then
		child.MouseButton1Click:Connect(function()
			local Clone = child.Button:Clone()
			Clone.Size = UDim2.new(0, 200, 0, 40)
			Clone.Parent = ParentToStarterGui()
			game.Selection:Set{Clone}
		end)
	end
end

-- Frames Frame
for _, child in pairs (PluginVariables.Frames.FramesFrame.Path.Content:GetChildren()) do
	if child:IsA("GuiButton") then
		child.MouseButton1Click:Connect(function()
			local Clone = child.Frame:Clone()
			Clone.Size = UDim2.new(0, 100, 0, 100)
			Clone.Parent = ParentToStarterGui()
			game.Selection:Set{Clone}
		end)
	end
end

-- Gradients Frame
for _, child in pairs (PluginVariables.Frames.GradientsFrame.Path.Content:GetChildren()) do
	
	if child:IsA("GuiButton") then
		child.MouseButton1Click:Connect(function()
			local Clone = child.Gradient:Clone()
			Clone.Size = UDim2.new(0, 100, 0, 100)
			Clone.Parent = ParentToStarterGui()
			game.Selection:Set{Clone}
		end)
	end
end

-- Icons Search
local SearchIcons = require(script.Parent.Parent.Modules.SearchIcons)

local SearchBox = PluginVariables.Buttons.Top.Path.SearchBox.SearchInput

SearchIcons.Generate(PluginVariables.Frames.Path.IconsFrame.Content, function(Icon)
	local Clone = Icon:Clone()
	Clone.Parent = ParentToStarterGui()
	game.Selection:Set{ParentToStarterGui()[Clone.Name]}
end)

local SearchIcons_Search = SearchIcons.Search

-- This is much riskier, but more fancy.
local function PropertyChanged()
	SearchIcons_Search(SearchBox.Text, PluginVariables.Frames.Path.IconsFrame.Content)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(PropertyChanged)