data:extend({
  {
    type = "int-setting",
    name = "ground-water-amount-multiplier",
    setting_type = "startup",
    default_value = 3,
    minimum_value = 1,
  },
  {
    type = "bool-setting",
    name = "ground-water-disable-offshore-pump",
    setting_type = "startup",
    default_value = true,
  },
  {
    type = "string-setting",
    name = "ground-water-planets",
    setting_type = "startup",
    default_value = "nauvis, gleba",
  }
})
