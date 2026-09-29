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
    MenuFadeTime = 0.2, -- menu open/close fade (Quad Out, instant when animations off)
    AnimationEnabled = true,
    AnimationDuration = 0.15, -- toggle/slider/dropdown/tab/logo transitions
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Animated logo (unicode icon; Roblox text can't render HTTP SVGs)
-- ponytail: guards so old cached lib can't crash demo
if Window.SetLogo then Window:SetLogo('Animated demo', '✦') end
if Window.AnimateLogo then Window:AnimateLogo(true, '✦', 'Animated demo') end

-- Transitions are automatic: toggle fill, slider fill, dropdown grow + arrow spin, tab slide-in, menu fade.
local Left = Tabs.Main:AddLeftGroupbox('Transitions')
Left:AddToggle('DemoToggle', { Text = 'Toggle (fill tween)', Default = true })
Left:AddSlider('DemoSlider', { Text = 'Slider (fill tween)', Default = 50, Min = 0, Max = 100, Rounding = 0 })
Left:AddDropdown('DemoDropdown', { Text = 'Dropdown (grow + arrow)', Values = { 'a', 'b', 'c' }, Default = 1 })
Left:AddDropdown('DemoMulti', { Text = 'Multi dropdown', Values = { 'a', 'b', 'c' }, Default = 1, Multi = true })
Left:AddButton({ Text = 'Pulse toggle', Func = function() Toggles.DemoToggle:SetValue(not Toggles.DemoToggle.Value) end })
Left:AddLabel('Color'):AddColorPicker('DemoColor', { Default = Color3.fromRGB(88, 101, 242) })
Left:AddLabel('Keybind'):AddKeyPicker('DemoKey', { Default = 'MB2', Mode = 'Toggle', Text = 'Demo key' })

-- Tab slide-in transition: switch Main <-> UI Settings, or these:
local TabBox = Tabs.Main:AddRightTabbox()
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab content slides in' })
local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Switch tabs to see it' })

-- Dependency box (inherits transitions on show/hide via toggle tween)
local Right = Tabs.Main:AddRightGroupbox('Visibility')
Right:AddToggle('ControlToggle', { Text = 'Show extra' })
local Dep = Right:AddDependencyBox()
Dep:AddToggle('DepToggle', { Text = 'Revealed with toggle' })
Dep:AddSlider('DepSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 })
Dep:SetupDependencies({ { Toggles.ControlToggle, true } })

-- Locked until key passes (try them before unlocking)
local Gated = Tabs.Main:AddRightGroupbox('Locked 🔒')
Gated:AddToggle('GatedToggle', { Text = 'Gated toggle', Gated = true })
Gated:AddSlider('GatedSlider', { Text = 'Gated slider', Default = 50, Min = 0, Max = 100, Rounding = 0, Gated = true })
Gated:AddButton({ Text = 'Gated button', Func = function() Library:Notify('Gated action ran', 2) end, Gated = true })

-- Key gating: custom check fn + key box tab (gated controls carry Gated = true)
if Library.SetKeyCheck then Library:SetKeyCheck(function(Key) return Key == 'demo123' end) end
local KeyBox = Tabs.Main:AddLeftGroupbox('Key')
KeyBox:AddInput('KeyInput', { Default = '', Text = 'Key (hint: demo123)', Placeholder = 'Enter key' })
KeyBox:AddButton({ Text = 'Unlock', Func = function()
    local Ok = Library.Unlock and Library:Unlock(Options.KeyInput.Value)
    Library:Notify(Ok and 'Unlocked ✓' or 'Wrong key', 2)
end })
-- Animation knobs (ponytail: direct props so demo runs on old remote too)
local function ApplyAnimEnabled(V) if Library.SetAnimationEnabled then Library:SetAnimationEnabled(V) else Library.AnimationEnabled = (not not V) end end
local function ApplyAnimSpeed(V) if Library.SetAnimationSpeed then Library:SetAnimationSpeed(V / 100) else Library.AnimationDuration = math.clamp((tonumber(V) or 15) / 100, 0, 1) end end
local Anim = Tabs.Main:AddLeftGroupbox('Animations')
Anim:AddToggle('AnimEnabled', { Text = 'Animations enabled', Default = true, Callback = ApplyAnimEnabled })
Anim:AddSlider('AnimSpeed', { Text = 'Duration (0-100)', Default = 15, Min = 0, Max = 100, Rounding = 0, Callback = ApplyAnimSpeed })
Anim:AddToggle('LogoRainbow', { Text = 'Rainbow logo ✦', Default = true, Callback = function(V) if Window.AnimateLogo then Window:AnimateLogo(V, '✦', 'Animated demo') end end })
Anim:AddToggle('ControlPulse', { Text = 'Pulse controls', Default = true, Callback = function(V) if Library.SetControlPulse then Library:SetControlPulse(V) else Library.ControlPulse = (not not V) end end })
Anim:AddLabel('0 = instant, 100 = 1s. Covers toggle/slider/dropdown/tab/menu/logo.', true)

Toggles.AnimEnabled:OnChanged(function() ApplyAnimEnabled(Toggles.AnimEnabled.Value) end)
Options.AnimSpeed:OnChanged(function() ApplyAnimSpeed(Options.AnimSpeed.Value) end)

-- Menu + theme plumbing (unchanged API)
Library:SetWatermarkVisibility(true)
Library:SetWatermark('Animated LinoriaLib demo')
if Library.SetWatermarkAvatar then Library:SetWatermarkAvatar('') end -- '' = player avatar, fail = text

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
