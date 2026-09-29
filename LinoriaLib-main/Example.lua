-- Animated demo for scramblepaws/LinoriaLib fork
local repo = 'https://raw.githubusercontent.com/scramblepaws/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Animated demo',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    AnimationEnabled = true,
    AnimationDuration = 0.15,
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Main controls (tweened: toggle fill, slider fill, tab button)
local Left = Tabs.Main:AddLeftGroupbox('Demo')
Left:AddToggle('DemoToggle', { Text = 'Animated toggle', Default = true })
Left:AddSlider('DemoSlider', { Text = 'Animated slider', Default = 50, Min = 0, Max = 100, Rounding = 0 })
Left:AddDropdown('DemoDropdown', { Text = 'Dropdown', Values = { 'a', 'b', 'c' }, Default = 1 })
Left:AddButton({ Text = 'Pulse toggle', Func = function() Toggles.DemoToggle:SetValue(not Toggles.DemoToggle.Value) end })

-- Animation knobs
local Anim = Tabs.Main:AddRightGroupbox('Animations')
Anim:AddToggle('AnimEnabled', { Text = 'Animations enabled', Default = true, Callback = function(V) Library:SetAnimationEnabled(V) end })
Anim:AddSlider('AnimSpeed', { Text = 'Duration (s)', Default = 15, Min = 0, Max = 100, Rounding = 0, Callback = function(V) Library:SetAnimationSpeed(V / 100) end })
Anim:AddLabel('0 = instant, 100 = 1s. Toggle/slider/tab/menu fade all use it.', true)

Toggles.AnimEnabled:OnChanged(function() Library:SetAnimationEnabled(Toggles.AnimEnabled.Value) end)
Options.AnimSpeed:OnChanged(function() Library:SetAnimationSpeed(Options.AnimSpeed.Value / 100) end)

-- Menu + theme plumbing (unchanged API)
Library:SetWatermarkVisibility(true)
Library:SetWatermark('Animated LinoriaLib demo')
Library.ToggleKeybind = Options.MenuKeybind

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('AnimatedHub')
SaveManager:SetFolder('AnimatedHub/demo')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
