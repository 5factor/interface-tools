local MarketplaceService = game:GetService("MarketplaceService")
local InterfaceTools = {}

local function IsValidImage(Id)
    local Success, ProductInfo = pcall(MarketplaceService.GetProductInfo, MarketplaceService, Id, Enum.InfoType.Asset)
    if Success and ProductInfo then
        return ProductInfo.AssetId
	else
        return false
    end
end

function InterfaceTools:RegisterIcon(Id)
    local Icons = plugin:GetSetting("InterfaceIcons")
    if not Icons then
        Icons = {}
    end

    if not IsValidImage(Id) then return end
	if table.find(Icons, Id) then return end
    Icons[#Icons + 1] = tostring("http://www.roblox.com/asset/?id=" .. Id)
    plugin:SetSetting("InterfaceIcons", Icons)
    script.Parent.Parent.Assets.NewIconEvent:Fire()
end

function InterfaceTools:GetIcons()
	return plugin:GetSetting("InterfaceIcons")
end

function InterfaceTools:ClearIcon(Id)
    local Icons = plugin:GetSetting("InterfaceIcons")
    if not Icons then return end
    local Index = table.find(Icons, Id)
    if Index then 
        table.remove(Icons, Index)
    end
    plugin:SetSetting("InterfaceIcons", Icons)
end

function InterfaceTools:ClearIcons()
	plugin:SetSetting("InterfaceIcons", {})
	script.Parent.Parent.Assets.NewIconEvent:Fire()
end

_G.InterfaceTools = InterfaceTools