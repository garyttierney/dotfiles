local wezterm = require 'wezterm'

return {
  color_scheme = "tokyonight",
  audible_bell = "Disabled",
  max_fps = 144,
  use_fancy_tab_bar = false,
  window_decorations = "RESIZE",
  default_cursor_style = "SteadyBar",
  hide_mouse_cursor_when_typing = false,
  enable_kitty_keyboard = true,
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",
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
  },
  keys = {
    { key = 'f', mods = 'CTRL | SHIFT', action = 'DisableDefaultAssignment' }
  }
}
