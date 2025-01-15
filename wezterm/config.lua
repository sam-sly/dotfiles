-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = {}
local merge = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

function merge.all(base, overrides)
	local ret = base or {}
	local second = overrides or {}
	for _, v in pairs(second) do
		table.insert(ret, v)
	end
	return ret
end

-- Font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 19

-- Window
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.94
config.macos_window_background_blur = 30
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.enable_scroll_bar = false
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- Color Scheme
config.color_scheme = "Catppuccin Mocha"

-- Cursor
config.default_cursor_style = "SteadyBar"

-- Tab Bar
config.tab_bar_at_bottom = true

-- Quit
config.quit_when_all_windows_are_closed = true
config.window_close_confirmation = "NeverPrompt"

-- Neovim Zen Mode Compatibility
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
		else
			overrides.font_size = number_value
		end
	end
	window:set_config_overrides(overrides)
end)

-- Plugins

-- wez-tmux
config.leader = { key = "Space", mods = "CTRL" }
require("wez-tmux.plugin").apply_to_config(config, {})

-- smart-splits
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "CTRL|ALT", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
	-- log level to use: info, warn, error
	log_level = "info",
})

-- smart_workspace_switcher
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"
config.default_workspace = "~"
workspace_switcher.apply_to_config(config)

-- resurrect
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.periodic_save({
	interval_seconds = 5 * 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	-- loads the state whenever I create a new workspace
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	-- Saves the state whenever I select a workspace
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

local resurrect_keys = {
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
}

-- tabline
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Catppuccin Mocha",
		tabs_enabled = true,
		color_overrides = {
			normal_mode = {
				a = { fg = "#181825", bg = "#f0c6c6" },
				b = { fg = "#000000", bg = "#181825" },
			},
			copy_mode = {
				b = { fg = "#000000", bg = "#181825" },
			},
			search_mode = {
				b = { fg = "#000000", bg = "#181825" },
			},
			window_mode = {
				b = { fg = "#000000", bg = "#181825" },
			},
			tab = {
				active = { fg = "#89b4fa", bg = "#313244" },
			},
		},
		section_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_left_half_circle_thin,
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "" },
		tabline_c = { "" },
		tab_active = {
			"index",
			{ "process", padding = { left = 0, right = 0 }, icons_only = true },
			{ "cwd", padding = { left = 0, right = 1 }, max_length = 10 },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = {
			"index",
			{ "process", padding = { left = 0, right = 0 }, icons_only = true },
			{ "cwd", padding = { left = 0, right = 1 }, max_length = 10 },
		},
		tabline_x = { "ram", "cpu" },
		tabline_y = { "" },
		tabline_z = { "workspace" },
	},
	extensions = {
		"resurrect",
		"smart_workspace_switcher",
	},
})
tabline.apply_to_config(config)

-- Keybinds
config.keys = merge.all(config.keys, resurrect_keys)

-- and finally, return the configuration to wezterm
return config
