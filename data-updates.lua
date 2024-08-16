-- Helper function to check if a value exists in an array
local function contains(array, value)
  for _, v in ipairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

-- Purpose: Increase the base_level of output_fluid_box of all mining-drill to the max amount possible of fluid resources.
local ground_water = data.raw["resource"]["ground-water"]
local results = ground_water.minable.results
for _, result in ipairs(results) do
  if result.type == "fluid" and result.amount then
    for _, mining_drill in pairs(data.raw["mining-drill"]) do
      if contains(mining_drill.resource_categories, "ground-water") then
        local output_fluid_box = mining_drill.output_fluid_box
        if output_fluid_box and output_fluid_box.base_area then
          -- This assumes max richness of fluid resource is 10000%
          output_fluid_box.base_area = math.max(output_fluid_box.base_area, result.amount)
        end
      end
    end
  end
end
