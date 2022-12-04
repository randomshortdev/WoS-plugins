local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Selection = game:GetService("Selection")
local selected_parts = Selection:Get()

function create_window(title)
	local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, -- floating window
		true,   -- will be open
		true,  -- will change status if already there
		250,    -- Default width of the window
		225,    -- Default height of the window
		125,    -- Minimum width of the window
		112     -- Minimum height of the window
	)

	local custom_window_ui = plugin:CreateDockWidgetPluginGui(title, widgetInfo)
	custom_window_ui.Title = title
	return custom_window_ui
end

function create_plating_creation_widgets(Widget)
	local Frame = Instance.new("Frame", Widget)
	Frame.Name = "WoSPluginPlatingGUI"
	Frame.Position = UDim2.fromScale(0, 0)
	Frame.Size = UDim2.fromScale(1, 1)

	local LayerWidthTextLabel = Instance.new("TextLabel", Frame)
	LayerWidthTextLabel.Name = "LayerWidthTextLabel"
	LayerWidthTextLabel.Text = "Layer Width"
	LayerWidthTextLabel.Position = UDim2.fromScale(0.4, 0.058)
	LayerWidthTextLabel.Size = UDim2.fromScale(0.2, 0.133)

	local LayersTextLabel = Instance.new("TextLabel", Frame)
	LayersTextLabel.Name = "LayersTextLabel"
	LayersTextLabel.Text = "Layers"
	LayersTextLabel.Position = UDim2.fromScale(0.038, 0.058)
	LayersTextLabel.Size = UDim2.fromScale(0.2, 0.133)

	local MaterialTextLabel = Instance.new("TextLabel", Frame)
	MaterialTextLabel.Name = "MaterialTextLabel"
	MaterialTextLabel.Text = "Material"
	MaterialTextLabel.Position = UDim2.fromScale(0.76, 0.058)
	MaterialTextLabel.Size = UDim2.fromScale(0.2, 0.133)

	local LayerWidthTextBox = Instance.new("TextBox", Frame)
	LayerWidthTextBox.Name = "LayerWidthTextBox"
	LayerWidthTextBox.Position = UDim2.fromScale(0.4, 0.255)
	LayerWidthTextBox.Size = UDim2.fromScale(0.2, 0.133)

	local LayersTextBox = Instance.new("TextBox", Frame)
	LayersTextBox.Name = "LayersTextBox"
	LayersTextBox.Position = UDim2.fromScale(0.038, 0.255)
	LayersTextBox.Size = UDim2.fromScale(0.2, 0.133)

	local MaterialTextBox = Instance.new("TextBox", Frame)
	MaterialTextBox.Name = "MaterialTextBox"
	MaterialTextBox.Position = UDim2.fromScale(0.76, 0.255)
	MaterialTextBox.Size = UDim2.fromScale(0.2, 0.133)

	local CreationButton = Instance.new("TextButton", Frame)
	CreationButton.Name = "CreationButton"
	CreationButton.Position = UDim2.fromScale(0.25, 0.665)
	CreationButton.Size = UDim2.fromScale(0.5, 0.25)
	CreationButton.Text = "Create Plating"
	CreationButton.MouseButton1Click:Connect(function()
		local layers = tonumber(LayersTextBox.Text)
		local layer_width = tonumber(LayerWidthTextBox.Text)
		local material = MaterialTextBox.Text
		MakePlating(layers, layer_width, material)
	end)
	
	return Frame
end

local plating_creation_window = create_window("Plating Creation")
plating_creation_window.Enabled = false
local plating_creation_window_frame = create_plating_creation_widgets(plating_creation_window)

function create_plating_scaling_widgets(Widget)
	local Frame = Instance.new("Frame", Widget)
	Frame.Name = "WoSScalingPluginGUI"
	Frame.Position = UDim2.fromScale(0, 0)
	Frame.Size = UDim2.fromScale(1, 1)

	local XSizeTextLabel = Instance.new("TextLabel", Frame)
	XSizeTextLabel.Name = "XSizeTextLabel"
	XSizeTextLabel.Position = UDim2.fromScale(0.074, 0.133)
	XSizeTextLabel.Size = UDim2.fromScale(0.4, 0.2)
	XSizeTextLabel.Text = "X Size"

	local ZSizeTextLabel = Instance.new("TextLabel", Frame)
	ZSizeTextLabel.Name = "ZSizeTextLabel"
	ZSizeTextLabel.Position = UDim2.fromScale(0.526, 0.133)
	ZSizeTextLabel.Size = UDim2.fromScale(0.4, 0.2)
	ZSizeTextLabel.Text = "Z Size"

	local XSizeTextBox = Instance.new("TextBox", Frame)
	XSizeTextBox.Name = "XSizeTextBox"
	XSizeTextBox.Position = UDim2.fromScale(0.074, 0.4)
	XSizeTextBox.Size = UDim2.fromScale(0.4, 0.2)
	XSizeTextBox.PlaceholderText = "Input X size"

	local ZSizeTextBox = Instance.new("TextBox", Frame)
	ZSizeTextBox.Name = "ZSizeTextBox"
	ZSizeTextBox.Position = UDim2.fromScale(0.526, 0.4)
	ZSizeTextBox.Size = UDim2.fromScale(0.4, 0.2)
	ZSizeTextBox.PlaceholderText = "Input Z size"

	local ScaleButton = Instance.new("TextButton", Frame)
	ScaleButton.Name = "ScaleButton"
	ScaleButton.Position = UDim2.fromScale(0.3, 0.7)
	ScaleButton.Size = UDim2.fromScale(0.4, 0.15)
	ScaleButton.Text = "Set Size"
	ScaleButton.MouseButton1Click:Connect(function()
		local x = tonumber(XSizeTextBox.Text)
		local z = tonumber(ZSizeTextBox.Text)
		ScalePlating(x, z)
	end)
	
	return Frame
end

local plating_scaling_window = create_window("Plating Scaling")
plating_scaling_window.Enabled = false
local plating_scaling_window_frame = create_plating_scaling_widgets(plating_scaling_window)

local toolbar = plugin:CreateToolbar("WoS Plating Plugin")
local plating_creation_button = toolbar:CreateButton("Create New Plating", "Opens creation window", "000")
local plating_scaling_button = toolbar:CreateButton("Scale Plating", "Opens plating scaling window", "000")


function MakePlating(layers, layer_width, material)
	local plating_model = Instance.new("Model", workspace)
	plating_model.Name = "PluginWoSPlating"
	local base = Instance.new("Part", plating_model)
	base.Size = Vector3.new(4, 1, 2)
	base.Name = material
	for i = 1, layers do
		local plating = Instance.new("Part", plating_model)
		plating.Name = material
		local size = layer_width * i
		plating.Size = plating.Size + Vector3.new(0, size - 1.2, 0)
		plating.Position = base.Position + Vector3.new(0, size/2 + 0.5, 0)
	end
	ChangeHistoryService:SetWaypoint("Created new plating")
end


plating_creation_button.Click:Connect(function()
	plating_creation_window.Enabled = true
	plating_creation_button:SetActive(false)
end)

function ScalePlating(x, z)
	local selected_parts = Selection:Get()
	for i, object in selected_parts do
		object.Size = Vector3.new(x, object.Size.Y, z)
	end
end

plating_scaling_button.Click:Connect(function()
	plating_scaling_window.Enabled = true
	plating_scaling_button:SetActive(false)
	ChangeHistoryService:SetWaypoint("Scaled plating")
end)

plugin.Unloading:Connect(function()
	print("Unloading!")
end)
