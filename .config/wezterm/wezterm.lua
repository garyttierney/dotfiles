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
  keys = {
    { key = 'f', mods = 'CTRL | SHIFT', action = 'DisableDefaultAssignment' }
  }
}
