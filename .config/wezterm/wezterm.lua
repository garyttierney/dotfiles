local wezterm = require 'wezterm'
local w = require('wezterm')

return {
  color_scheme = "tokyonight",
  audible_bell = "Disabled",
  max_fps = 144,
  default_cursor_style = "SteadyBar",
  hide_mouse_cursor_when_typing = false,
  enable_kitty_keyboard = false,
  font = wezterm.font("Terminess Nerd Font Mono"),
  window_decorations = "TITLE | RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.Nop,
    },
  },
  keys = {
    { key = 'Tab', mods = 'CTRL',         action = 'DisableDefaultAssignment' },
    { key = 'f',   mods = 'CTRL | SHIFT', action = 'DisableDefaultAssignment' },
  }
}
