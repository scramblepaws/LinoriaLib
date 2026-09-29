-- Showcase for scramblepaws/LinoriaLib animated fork
-- Every custom feature is exercised below; automatic motion needs no calls.
local repo = 'https://raw.githubusercontent.com/scramblepaws/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Animated demo',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2, -- open/close fade + 95% scale pop
    AnimationEnabled = true, -- master switch for all motion
    AnimationDuration = 0.15, -- toggle/slider/dropdown/tab/logo timing
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Animations = Window:AddTab('Animations'), -- switching tabs: 10px slide + fade
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- 1. Animated logo (unicode icon; Roblox text can't render HTTP SVGs)
-- ponytail: guards so a stale cached lib skips instead of erroring
if Window.SetLogo then Window:SetLogo('Animated demo', '✦') end
if Window.AnimateLogo then Window:AnimateLogo(true, '✦', 'Animated demo') end

-- 2. Key gating: custom check fn; gated controls block with 🔒 until Unlock passes
-- (key box itself is never gated)
if Library.SetKeyCheck then Library:SetKeyCheck(function(Key) return Key == 'demo123' end) end
local KeyBox = Tabs.Main:AddLeftGroupbox('Key')
KeyBox:AddInput('KeyInput', { Default = '', Text = 'Key (hint: demo123)', Placeholder = 'Enter key' })
KeyBox:AddButton({ Text = 'Unlock', Func = function()
    local Ok = Library.Unlock and Library:Unlock(Options.KeyInput.Value)
    Library:Notify(Ok and 'Unlocked ✓' or 'Wrong key', 2)
end })

-- 3. Transitions (all automatic): toggle fill, slider fill, dropdown grow + arrow spin
local Left = Tabs.Main:AddLeftGroupbox('Transitions')
Left:AddToggle('DemoToggle', { Text = 'Toggle (fill tween)', Default = true })
Left:AddSlider('DemoSlider', { Text = 'Slider (fill tween)', Default = 50, Min = 0, Max = 100, Rounding = 0 })
Left:AddDropdown('DemoDropdown', { Text = 'Dropdown (grow + arrow)', Values = { 'a', 'b', 'c' }, Default = 1 })
Left:AddDropdown('DemoMulti', { Text = 'Multi dropdown', Values = { 'a', 'b', 'c' }, Default = 1, Multi = true })
Left:AddDropdown('DemoSearch', { Text = 'Open + type to filter', Values = { 'Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu' }, Default = 1 })
Left:AddButton({ Text = 'Randomize slider', Func = function() Options.DemoSlider:SetValue(math.random(0, 100)) end })
Left:AddLabel('Color'):AddColorPicker('DemoColor', { Default = Color3.fromRGB(88, 101, 242) })
Left:AddLabel('Keybind'):AddKeyPicker('DemoKey', { Default = 'MB2', Mode = 'Toggle', Text = 'Demo key' })

-- 4. Tab content slide+fade: switch Main <-> Animations, or these:
local TabBox = Tabs.Main:AddRightTabbox()
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab content slides + fades in' })
local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Switch tabs to see it' })

-- 5. Dependency box (visibility follows toggle tween)
local Right = Tabs.Main:AddRightGroupbox('Visibility')
Right:AddToggle('ControlToggle', { Text = 'Show extra' })
local Dep = Right:AddDependencyBox()
Dep:AddToggle('DepToggle', { Text = 'Revealed with toggle' })
Dep:AddSlider('DepSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 })
Dep:SetupDependencies({ { Toggles.ControlToggle, true } })

-- 6. Locked controls (try before entering the key)
local Gated = Tabs.Main:AddRightGroupbox('Locked 🔒')
Gated:AddToggle('GatedToggle', { Text = 'Gated toggle', Gated = true })
Gated:AddSlider('GatedSlider', { Text = 'Gated slider', Default = 50, Min = 0, Max = 100, Rounding = 0, Gated = true })
Gated:AddDropdown('GatedDropdown', { Text = 'Gated dropdown', Values = { 'x', 'y' }, Default = 1, Gated = true })
Gated:AddButton({ Text = 'Gated button', Func = function() Library:Notify('Gated action ran', 2) end, Gated = true })

-- 7. Every animation knob in one place (ponytail: direct props fall back for stale libs)
local function ApplyAnimEnabled(V) if Library.SetAnimationEnabled then Library:SetAnimationEnabled(V) else Library.AnimationEnabled = (not not V) end end
local function ApplyAnimSpeed(V) if Library.SetAnimationSpeed then Library:SetAnimationSpeed(V / 100) else Library.AnimationDuration = math.clamp((tonumber(V) or 15) / 100, 0, 1) end end
local Anim = Tabs.Animations:AddLeftGroupbox('Motion')
Anim:AddToggle('AnimEnabled', { Text = 'Animations enabled', Default = true, Callback = ApplyAnimEnabled })
Anim:AddSlider('AnimSpeed', { Text = 'Duration (0-100)', Default = 15, Min = 0, Max = 100, Rounding = 0, Callback = ApplyAnimSpeed })
Anim:AddToggle('LogoRainbow', { Text = 'Rainbow logo ✦', Default = true, Callback = function(V) if Window.AnimateLogo then Window:AnimateLogo(V, '✦', 'Animated demo') end end })
Anim:AddToggle('ControlPulse', { Text = 'Pulse ON toggles/sliders', Default = true, Callback = function(V) if Library.SetControlPulse then Library:SetControlPulse(V) else Library.ControlPulse = (not not V) end end })
Anim:AddToggle('OutlineSweep', { Text = 'Outline gradient sweep', Default = true, Callback = function(V) if Window.SetOutlineGradient then Window:SetOutlineGradient(V) end end })
Anim:AddToggle('WatermarkStats', { Text = 'Watermark fps/ping', Default = true, Callback = function(V) if Library.SetWatermarkStats then Library:SetWatermarkStats(V) end end })
Anim:AddLabel('0 = instant, 100 = 1s. Covers toggle/slider/dropdown/tab/menu/logo.', true)
Anim:AddLabel('Ctrl+K jumps to any control. Type into slider boxes.', true)

Toggles.AnimEnabled:OnChanged(function() ApplyAnimEnabled(Toggles.AnimEnabled.Value) end)
Options.AnimSpeed:OnChanged(function() ApplyAnimSpeed(Options.AnimSpeed.Value) end)

-- 8. Watermark avatar: custom asset -> player avatar -> text (pass '' for auto)
local Pic = Tabs.Animations:AddRightGroupbox('Watermark picture')
Pic:AddInput('AvatarAsset', { Default = '', Text = 'Custom asset id (blank = auto)', Placeholder = 'rbxassetid://...' })
Pic:AddButton({ Text = 'Apply picture', Func = function() if Library.SetWatermarkAvatar then Library:SetWatermarkAvatar(Options.AvatarAsset.Value) end end })
Pic:AddLabel('Blank fetches your Roblox avatar; failure falls back to text.', true)

-- 9. Typed notifies: same slide, colored bar (also try Crimson/Mono in UI Settings > Themes)
local Note = Tabs.Animations:AddRightGroupbox('Notify types')
Note:AddButton({ Text = 'Info notify', Func = function() Library:NotifyInfo('Info notify', 2) end })
Note:AddButton({ Text = 'Success notify', Func = function() Library:NotifySuccess('Success notify', 2) end })
Note:AddButton({ Text = 'Error notify', Func = function() Library:NotifyError('Error notify', 2) end })

-- 10. Collapsible: click any ▼ header to collapse it (try this box)

-- Menu + theme plumbing (unchanged API)
Library:SetWatermarkVisibility(true)
Library:SetWatermark('Animated LinoriaLib demo')
if Library.SetWatermarkAvatar then Library:SetWatermarkAvatar('') end
if Library.SetWatermarkStats then Library:SetWatermarkStats(true) end

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
