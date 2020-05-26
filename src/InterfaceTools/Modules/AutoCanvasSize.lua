-- @original https://github.com/Fm-Trick/auto-canvas-size
local AutoCanvasSize = {}
local Connections = {}

function AutoCanvasSize.Disconnect(ScrollingFrame)
    if Connections[ScrollingFrame] then
        local Table = Connections[ScrollingFrame]
        for Index, Connection in ipairs(Table) do
            if Connection then
                Table[Index] = Connection:Disconnect()
            end
        end

        Connections[ScrollingFrame] = nil
    end
end

function AutoCanvasSize.Connect(ScrollingFrame, OnlyY)
    OnlyY = OnlyY or true

    local Layout = ScrollingFrame:FindFirstChildOfClass("UIListLayout")
                or ScrollingFrame:FindFirstChildOfClass("UIGridLayout")

    local function Update()
        ScrollingFrame.CanvasSize = UDim2.fromOffset(
            OnlyY and 0 or Layout.AbsoluteContentSize.X,
            Layout.AbsoluteContentSize.Y + 25
        )
    end

    Connections[ScrollingFrame] = {
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Update);

        ScrollingFrame.AncestryChanged:Connect(function()
            if not ScrollingFrame.Parent then
                AutoCanvasSize.Disconnect(ScrollingFrame)
            end
        end);

        ScrollingFrame.ChildAdded:Connect(function()
            spawn(Update)
        end);

        ScrollingFrame.ChildRemoved:Connect(Update);
    }

    ScrollingFrame.CanvasSize = UDim2.fromOffset(
        OnlyY and 0 or Layout.AbsoluteContentSize.X,
        Layout.AbsoluteContentSize.Y + 25
    )
end

return AutoCanvasSize