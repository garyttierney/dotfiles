local wezterm = require 'wezterm'

return {
  color_scheme = "tokyonight",
  audible_bell = "Disabled",
  max_fps = 144,
  window_decorations = "RESIZE",
  enable_wayland = false, -- https=//github.com/wez/wezterm/issues/1701
  front_end = "WebGpu",
  webgpu_preferred_adapter = {
    backend = "Vulkan",
    device_type = "DiscreteGpu",
    name = "NVIDIA GeForce GTX 1660 Ti",
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
