local resource_autoplace = require("__core__/lualib/resource-autoplace")

local ground_water = table.deepcopy(data.raw["resource"]["crude-oil"])
ground_water.name = "ground-water"
ground_water.icon = "__base__/graphics/icons/fluid/water.png"
ground_water.icon_size = 64
ground_water.icon_mipmaps = 4
ground_water.category = "ground-water"
ground_water.order = "a-b-a"
ground_water.infinite_depletion_amount = 10
ground_water.minable.results = {
  {
    type = "fluid",
    name = "water",
    amount = settings.startup["ground-water-amount"].value,
  },
}
ground_water.autoplace = resource_autoplace.resource_autoplace_settings {
  name = "ground-water",
  order = "b",
  base_density = 8.2,
  random_spot_size_minimum = 1,
  random_spot_size_maximum = 1,
  random_probability = 1 / 48,
  additional_richness = 220000,
  has_starting_area_placement = true,
}
ground_water.autoplace.noise_layer = "ground-water"
ground_water.stages =
{
  sheet =
  {
    filename = "__GroundWater__/graphics/ground_water.png",
    priority = "extra-high",
    width = 75,
    height = 61,
    frame_count = 4,
    variation_count = 1
  }
}
ground_water.map_color = { r = 0, g = 0.2, b = 1 }

local ratio = 2
local burner_water_pump = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
burner_water_pump.name = "burner-water-pump"
burner_water_pump.minable.result = "burner-water-pump"
burner_water_pump.max_health = burner_water_pump.max_health / ratio
burner_water_pump.energy_source = {
  type = "burner",
  fuel_category = "chemical",
  fuel_inventory_size = 1,
  smoke =
  {
    {
      name = "smoke",
      deviation = { 0.1, 0.1 },
      frequency = 9
    }
  },
  emissions_per_minute = 12,
}
burner_water_pump.energy_usage = "150kW"
burner_water_pump.mining_speed = burner_water_pump.mining_speed / ratio
burner_water_pump.module_specification.module_slots = 0
burner_water_pump.fast_replaceable_group = "water-pump"
burner_water_pump.resource_categories = { "ground-water" }
burner_water_pump.animations.tint = { r = 0.5, g = 0.5, b = 0.5, a = 1 }

local water_pump = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
water_pump.name = "water-pump"
water_pump.minable.result = "water-pump"
water_pump.fast_replaceable_group = "water-pump"
water_pump.resource_categories = { "ground-water" }
water_pump.animations.tint = { r = 0.5, g = 0.5, b = 0.5, a = 1 }

local burner_water_pump_item = table.deepcopy(data.raw["item"]["pumpjack"])
burner_water_pump_item.name = "burner-water-pump"
burner_water_pump_item.order = "b[fluids]-b[burner-water-pump]"
burner_water_pump_item.place_result = "burner-water-pump"

local water_pump_item = table.deepcopy(data.raw["item"]["pumpjack"])
water_pump_item.name = "water-pump"
water_pump_item.order = "b[fluids]-b[water-pump]"
water_pump_item.place_result = "water-pump"

data:extend(
  {
    {
      type = "resource-category",
      name = "ground-water"
    },
    burner_water_pump_item,
    water_pump_item,
    {
      type = "recipe",
      name = "burner-water-pump",
      ingredients =
      {
        { "stone-furnace",   1 },
        { "pipe",            1 },
        { "iron-gear-wheel", 1 }
      },
      result = "burner-water-pump",
    },
    {
      type = "recipe",
      name = "water-pump",
      ingredients = data.raw.recipe["pumpjack"].ingredients,
      result = "water-pump",
    },

    burner_water_pump,
    water_pump,
    {
      type = "noise-layer",
      name = "ground-water"
    },
    {
      type = "autoplace-control",
      name = "ground-water",
      richness = true,
      order = "b-g",
      category = "resource",
    },
    ground_water,
  }
)

data.raw["recipe"]["offshore-pump"].enabled = not settings.startup["ground-water-disable-offshore-pump"].value
