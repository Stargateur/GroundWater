local resource_autoplace = require("__core__/lualib/resource-autoplace")

local ground_water = {
  type = "resource",
  name = "ground-water",
  icon = "__base__/graphics/icons/fluid/water.png",
  icon_size = 64,
  icon_mipmaps = 4,
  flags = { "placeable-neutral" },
  category = "basic-fluid",
  subgroup = "mineable-fluids",
  order = "a-b-g",
  infinite = true,
  highlight = true,
  minimum = 60000,
  normal = 300000,
  infinite_depletion_amount = 10,
  resource_patch_search_radius = 21,
  tree_removal_probability = 0.7,
  tree_removal_max_distance = 32 * 32,
  minable =
  {
    mining_time = 1,
    results =
    {
      {
        type = "fluid",
        name = "water",
        amount_min = 10 * settings.startup["ground-water-amount-multiplier"].value,
        amount_max = 10 * settings.startup["ground-water-amount-multiplier"].value,
        probability = 1
      }
    }
  },
  collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } },
  selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
  autoplace = resource_autoplace.resource_autoplace_settings
      {
        name = "ground-water",
        order = "b",
        base_density = 8.2,
        base_spots_per_km2 = 1.8,
        random_probability = 1 / 48,
        random_spot_size_minimum = 1,
        random_spot_size_maximum = 1,
        additional_richness = 220000,
        has_starting_area_placement = true,
        regular_rq_factor_multiplier = 1
      },
  stage_counts = { 0 },
  stages =
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
  },
  map_color = { r = 0, g = 0.2, b = 1 },
  map_grid = false,
}

local ground_water_autoplace_control = {
  type = "autoplace-control",
  name = "ground-water",
  localised_name = { "", "[fluid=water] ", { "fluid-name.water" } },
  richness = true,
  order = "a-g",
  category = "resource",
}

local burner_water_pump_entity = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
burner_water_pump_entity.name = "burner-water-pump"
burner_water_pump_entity.minable.result = "burner-water-pump"
burner_water_pump_entity.energy_source = {
  type = "burner",
  fuel_categories = { "chemical" },
  fuel_inventory_size = 1,
  smoke =
  {
    {
      name = "smoke",
      deviation = { 0.1, 0.1 },
      frequency = 9
    }
  },
  emissions_per_minute = { pollution = 12 },
}
burner_water_pump_entity.energy_usage = "150kW"
burner_water_pump_entity.mining_speed = burner_water_pump_entity.mining_speed / 2
burner_water_pump_entity.module_slots = 0
burner_water_pump_entity.fast_replaceable_group = "pumpjack"
burner_water_pump_entity.next_upgrade = "pumpjack"
burner_water_pump_entity.resource_categories = { "basic-fluid" }
for _, sheet in ipairs(burner_water_pump_entity.base_picture.sheets) do
  sheet.tint = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
end
for _, layer in ipairs(burner_water_pump_entity.graphics_set.animation.north.layers) do
  layer.tint = { r = 0.5, g = 0.5, b = 0.5, a = 1 }
end

local burner_water_pump_item = table.deepcopy(data.raw["item"]["pumpjack"])
burner_water_pump_item.name = "burner-water-pump"
burner_water_pump_item.order = "b[fluids]-b[burner-water-pump]"
burner_water_pump_item.place_result = "burner-water-pump"

local burner_water_pump_recipe = {
  type = "recipe",
  name = "burner-water-pump",
  ingredients =
  {
    { type = "item", name = "stone-furnace",   amount = 1 },
    { type = "item", name = "pipe",            amount = 4 },
    { type = "item", name = "iron-gear-wheel", amount = 8 }
  },
  results = { { type = "item", name = "burner-water-pump", amount = 1 } },
  enabled = false,
}

data:extend(
  {
    ground_water,
    ground_water_autoplace_control,
    burner_water_pump_item,
    burner_water_pump_recipe,
    burner_water_pump_entity,
  }
)

table.insert(data.raw["technology"]["steam-power"].effects, { type = "unlock-recipe", recipe = "burner-water-pump" })
if settings.startup["ground-water-disable-offshore-pump"].value then
  for i, effect in ipairs(data.raw["technology"]["steam-power"].effects) do
    if effect.type == "unlock-recipe" and effect.recipe == "offshore-pump" then
      table.remove(data.raw["technology"]["steam-power"].effects, i)
      break
    end
  end
end

for planet in string.gmatch(settings.startup["ground-water-planets"].value, "([^,]+)") do
  planet = planet:gsub("^%s*(.-)%s*$", "%1") -- trim spaces
  if data.raw.planet[planet] then
    data.raw.planet[planet].map_gen_settings.autoplace_controls["ground-water"] = {}
    data.raw.planet[planet].map_gen_settings.autoplace_settings.entity.settings["ground-water"] = {}
  end
end
