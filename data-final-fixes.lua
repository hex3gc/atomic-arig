local function removeItemFromRecipe(recipeName, itemName)
    for i, ingredient in pairs(data.raw["recipe"][recipeName].ingredients) do
        if ingredient.name == itemName then
            table.remove(data.raw["recipe"][recipeName].ingredients, i);
        end
    end
end

local function removeItemFromRecipeResults(recipeName, itemName)
    for i, ingredient in pairs(data.raw["recipe"][recipeName].results) do
        if ingredient.name == itemName then
            table.remove(data.raw["recipe"][recipeName].results, i);
        end
    end
end

local function addItemToRecipe(recipeName, itemName, quantity)
    table.insert(data.raw["recipe"][recipeName].ingredients, {type = "item", name = itemName, amount = quantity});
end

local function addFluidToRecipe(recipeName, fluidName, quantity)
    table.insert(data.raw["recipe"][recipeName].ingredients, {type = "fluid", name = fluidName, amount = quantity});
end

local function removePackFromTech(techName, itemName)
    for i, ingredient in pairs(data.raw["technology"][techName].unit.ingredients) do
        if ingredient[1] == itemName then
            table.remove(data.raw["technology"][techName].unit.ingredients, i);
        end
    end
end

local function addPackToTech(techName, itemName, quantity)
    table.insert(data.raw["technology"][techName].unit.ingredients, {itemName, quantity});
end

local function doesTableContain(table, doIExist)
    for _, val in pairs(table) do
        if val == doIExist then
            return true;
        end
    end
    return false;
end

-- #region PLANET

-- Add uranium ore to Arig
data.raw["planet"]["arig"].map_gen_settings.autoplace_controls =
{
    ["arig_sand"] = 
    {
        frequency = 10,
        Size = 10,
    },
    ["stone"] = 
    {
        frequency = 2,
        Size = 2,
    },
    ["uranium-ore"] = -- Add uranium ore
    {
        richness = 1,
        frequency = 6,
        Size = 1,
    },
    ["arig_cliff"] = {},
    ["arig_rocks"] = {},
    ["arig_crash"] = {},
    ["heavy-oil-geyser"] = 
    {
        richness = 2,
        frequency = 10,
        Size = 4,
    },
};
data.raw["planet"]["arig"].map_gen_settings.autoplace_settings =
{
    ["tile"] =
    {
        settings =
        {
        ["arig-sand"] = {},
        ["planetaris-sandstone-1"] = {},
        ["planetaris-sandstone-2"] = {},
        ["planetaris-sandstone-3"] = {},
        ["planetaris-arig-rock"] = {},
        }
    },
    ["decorative"] =
    {
        settings =
        {
        ["arig-red-desert-decal"] = {},
        ["arig-sand-decal"] = {},
        ["arig-brown-fluff"] = {},
        ["arig-brown-fluff-dry"] = {},
        ["arig-small-sand-rock"] = {},
        ["arig-small-cactus"] = {},
        ["arig-crack-decal"] = {},
        ["arig-crack-decal-large"] = {},
        ["arig-tiny-rock-cluster"] = {},
        ["arig-dune-decal"] = {},
        ["arig-pumice-relief-decal"] = {},
        }
    },
    ["entity"] =
    {
        settings =
        {
        ["stone"] = {},
        ["uranium-ore"] = {},
        ["arig-big-sand-rock"] = {},
        ["arig-medium-sand-rock"] = {},
        ["heavy-oil-geyser"] = {},
        ["arig-crash"] = {},
        }
    }
};

-- Change space location params
data.raw["planet"]["arig"].orientation = 0.40;
data.raw["space-connection"]["vulcanus-arig"].length = 25000;

-- Remove uranium ore from Nauvis
for i, autoplace in pairs(data.raw["planet"]["nauvis"].map_gen_settings.autoplace_controls) do
    if i == "uranium-ore" then
        data.raw["planet"]["nauvis"].map_gen_settings.autoplace_controls[i] = nil;
    end
end
for i, autoplace in pairs(data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings["entity"].settings) do
    if i == "uranium-ore" then
        data.raw["planet"]["nauvis"].map_gen_settings.autoplace_settings["entity"].settings[i] = nil;
    end
end

-- #endregion

-- #region TECHNOLOGY

-- Replace nuclear science pack with compression science
for i, technology in pairs(data.raw["technology"]) do
    if technology.prerequisites then
        for j, prerequisite in pairs(technology.prerequisites) do
            if prerequisite == "nuclear-science-pack" then
                table.remove(technology.prerequisites, j);
                table.insert(technology.prerequisites, "planetaris-compression-science");
            end
            if prerequisite == "planetaris-heavy-glass" then -- Remove heavy glass prereqs
                table.remove(technology.prerequisites, j);
                table.insert(technology.prerequisites, "planetaris-compression-science");
            end
        end
    end
    if technology.unit then
        local foundCompressionPack = false;
        local removedNuclearPack = false;
        for j, ingredient in pairs(technology.unit.ingredients) do
            if ingredient[1] == "nuclear-science-pack" then
                table.remove(technology.unit.ingredients, j);
                removedNuclearPack = true;
            end
            if ingredient[1] == "planetaris-compression-science-pack" then
                foundCompressionPack = true;
            end
        end
        if foundCompressionPack == false and removedNuclearPack == true and technology.name ~= "science-pack-productivity" then
            table.insert(technology.unit.ingredients, {"planetaris-compression-science-pack", 1}); -- Secretas science pack productivity breaks this somehow?? idk man
        end
    end
end

-- Prereqs
table.insert(data.raw["technology"]["uranium-processing"].prerequisites, "planetaris-compression");
table.insert(data.raw["technology"]["planetaris-compression-science"].prerequisites, "uranium-processing");
data.raw["technology"]["planetaris-compression"].prerequisites = {"planetaris-sand-sifting"};
data.raw["technology"]["planetaris-advanced-solar-panel"].prerequisites = {"planetaris-silica-processing"};

-- Fix Kovarex
data.raw["technology"]["kovarex-enrichment-process"].unit.count = 1000;
data.raw["technology"]["kovarex-enrichment-process"].unit.time = 60;
data.raw["technology"]["kovarex-enrichment-process"].unit.ingredients = 
{
    {"automation-science-pack", 1},
    {"logistic-science-pack", 1},
    {"chemical-science-pack", 1},
    {"space-science-pack", 1},
    {"planetaris-compression-science-pack", 1}
}

-- Remove nuclear science
data.raw["technology"]["nuclear-science-pack"] = nil;

-- Remove glass research, combine into sifting. Also move sandstone brick back
data.raw["technology"]["planetaris-glass"] = nil;
data.raw["technology"]["planetaris-heavy-glass"] = nil;
table.insert(data.raw["technology"]["planetaris-sand-sifting"].effects, {type = "unlock-recipe", recipe = "planetaris-glass-panel"});
table.insert(data.raw["technology"]["planetaris-sand-sifting"].effects, {type = "unlock-recipe", recipe = "planetaris-heavy-glass"});
table.insert(data.raw["technology"]["planetaris-sand-sifting"].effects, {type = "unlock-recipe", recipe = "planetaris-sandstone-brick"});

for i, effect in pairs(data.raw["technology"]["planetaris-compression"].effects) do
    if effect.recipe == "planetaris-sandstone-brick" then
        table.remove(data.raw["technology"]["planetaris-compression"].effects, i);
    end
end

-- Remove Vulcanus requirement from Arig
data.raw["technology"]["planet-discovery-arig"].prerequisites = {"space-platform-thruster"};
removePackFromTech("planet-discovery-arig", "metallurgic-science-pack");

-- Add simple calcite processes to Arig
table.insert(data.raw["technology"]["planetaris-sand-sifting"].effects, {type = "unlock-recipe", recipe = "steam-condensation"});
table.insert(data.raw["technology"]["planetaris-advanced-sand-sifting"].effects, {type = "unlock-recipe", recipe = "simple-coal-liquefaction"});

-- Add concrete sandstone to compression tech
table.insert(data.raw["technology"]["planetaris-compression"].effects, {type = "unlock-recipe", recipe = "h3-arig-sandstone-brick-concrete"});
table.insert(data.raw["technology"]["planetaris-compression"].effects, {type = "unlock-recipe", recipe = "h3-arig-sandstone-brick-refined-concrete"});

-- Move atom forge to Automation 4
data.raw["technology"]["atan-atom-forge"] = nil;
table.insert(data.raw["technology"]["planetaris-automation-4"].effects, {type = "unlock-recipe", recipe = "atan-atom-forge"});

-- Add simulating units to reactors
data.raw["technology"]["nuclear-power"].prerequisites = {"planetaris-simulating-unit"};

-- Add Vulcanus prereq to Logistics 4, remove simulating unit
data.raw["technology"]["planetaris-hyper-transport-belt"].prerequisites = {"planetaris-simulating-unit", "turbo-transport-belt"};

-- Raw quartz productivity localized to Arig
removePackFromTech("planetaris-raw-quartz-productivity", "metallurgic-science-pack");

-- Remove vulcanus from advanced solar panels
removePackFromTech("planetaris-advanced-solar-panel", "metallurgic-science-pack");

-- Quantum processor simulating unit prereq
table.insert(data.raw["technology"]["quantum-processor"].prerequisites, "planetaris-simulating-unit");

-- Remove production science from some techs, balancing out the progression a bit more
removePackFromTech("kovarex-enrichment-process", "production-science-pack");
data.raw["technology"]["kovarex-enrichment-process"].prerequisites = {"planetaris-compression-science"};
removePackFromTech("planetaris-sandstone-foundation", "production-science-pack");
data.raw["technology"]["planetaris-sandstone-foundation"].prerequisites = {"planetaris-compression-science"};
removePackFromTech("planetaris-silica-processing", "production-science-pack");
data.raw["technology"]["planetaris-silica-processing"].prerequisites = {"planetaris-compression-science"};
removePackFromTech("planetaris-advanced-solar-panel", "production-science-pack");
removePackFromTech("planetaris-simulating-unit", "production-science-pack");
addPackToTech("nuclear-power", "space-science-pack", 1);

-- Optionally remove big container research
if settings.startup["h3-arig-removeContainer"].value == true then
    data.raw["technology"]["planetaris-big-chest"] = nil;
end

-- Optionally make belts higher tech and more difficult to craft
if settings.startup["h3-arig-difficultBelts"].value == true then
    -- Tech
    table.insert(data.raw["technology"]["planetaris-hyper-transport-belt"].prerequisites, "carbon-fiber");
    table.insert(data.raw["technology"]["planetaris-hyper-transport-belt"].prerequisites, "electromagnetic-science-pack");
    addPackToTech("planetaris-hyper-transport-belt", "agricultural-science-pack", 1);
    addPackToTech("planetaris-hyper-transport-belt", "electromagnetic-science-pack", 1);

    -- Recipe
    removeItemFromRecipe("planetaris-hyper-transport-belt", "planetaris-silica");
    addItemToRecipe("planetaris-hyper-transport-belt", "planetaris-silica", 1);
    addItemToRecipe("planetaris-hyper-transport-belt", "carbon-fiber", 1);
    addItemToRecipe("planetaris-hyper-transport-belt", "superconductor", 1);

    removeItemFromRecipe("planetaris-hyper-underground-belt", "lubricant");
    removeItemFromRecipe("planetaris-hyper-underground-belt", "planetaris-silica");
    addItemToRecipe("planetaris-hyper-underground-belt", "planetaris-silica", 5);
    addItemToRecipe("planetaris-hyper-underground-belt", "carbon-fiber", 5);
    addItemToRecipe("planetaris-hyper-underground-belt", "superconductor", 5);
    addFluidToRecipe("planetaris-hyper-underground-belt", "lubricant", 40);

    removeItemFromRecipe("planetaris-hyper-splitter", "planetaris-silica");
    removeItemFromRecipe("planetaris-hyper-splitter", "processing-unit");
    addItemToRecipe("planetaris-hyper-splitter", "planetaris-simulating-unit", 1);
    addItemToRecipe("planetaris-hyper-splitter", "carbon-fiber", 2);
    addItemToRecipe("planetaris-hyper-splitter", "superconductor", 2);
    addFluidToRecipe("planetaris-hyper-splitter", "lubricant", 80);

    -- Entity
    data.raw["transport-belt"]["planetaris-hyper-transport-belt"].speed = 0.1875;
    data.raw["underground-belt"]["planetaris-hyper-underground-belt"].speed = 0.1875;
    data.raw["splitter"]["planetaris-hyper-splitter"].speed = 0.1875;
end

-- #endregion

-- #region RECIPE

-- Change heavy glass to contain steel because all my homies hate Vulcanus
removeItemFromRecipe("planetaris-heavy-glass", "tungsten-plate");
removeItemFromRecipe("planetaris-heavy-glass", "planetaris-glass-panel");
addItemToRecipe("planetaris-heavy-glass", "steel-plate", 4);
addItemToRecipe("planetaris-heavy-glass", "copper-plate", 4);
addItemToRecipe("planetaris-heavy-glass", "planetaris-glass-panel", 2);

-- Add uranium to planetaris science
removeItemFromRecipe("planetaris-compression-science-pack", "planetaris-sandstone-brick");
addItemToRecipe("planetaris-compression-science-pack", "uranium-238", 10);

-- Add uranium ore to sand sifting, and extra sulfur to compensate for additional costs elsewhere
removeItemFromRecipeResults("planetaris-sand-sifting", "sulfur");
table.insert(data.raw["recipe"]["planetaris-sand-sifting"].results, {type = "item", name = "uranium-ore", amount = 1,  probability = 0.04, show_details_in_recipe_tooltip = false});
table.insert(data.raw["recipe"]["planetaris-sand-sifting"].results, {type = "item", name = "sulfur", amount = 1,  probability = 0.04, show_details_in_recipe_tooltip = false});
table.insert(data.raw["recipe"]["planetaris-advanced-sand-sifting"].results, {type = "item", name = "uranium-ore", amount = 1,  probability = 0.2, show_details_in_recipe_tooltip = false});

-- Double sandstone brick usage in quartz to compensate for its removal from science
removeItemFromRecipe("planetaris-raw-quartz", "planetaris-sandstone-brick");
addItemToRecipe("planetaris-raw-quartz", "planetaris-sandstone-brick", 4);

-- Assembler 4 recipe: Add nuclear components, remove tungsten, remove EM plant
data.raw["recipe"]["planetaris-assembling-machine-4"].ingredients =
{
    {type = "item", name = "planetaris-simulating-unit", amount = 10},
    {type = "item", name = "assembling-machine-3", amount = 2},
    {type = "item", name = "uranium-fuel-cell", amount = 4},
};
data.raw["recipe"]["planetaris-assembling-machine-4"].category = "crafting";

-- Atom forge recipe: Add simulating unit and nuclear components
data.raw["recipe"]["atan-atom-forge"].ingredients =
{
    {type = "item", name = "centrifuge", amount = 2},
    {type = "item", name = "planetaris-simulating-unit", amount = 40},
    {type = "item", name = "refined-concrete", amount = 100},
    {type = "item", name = "uranium-fuel-cell", amount = 24},
};
data.raw["recipe"]["atan-atom-forge"].surface_conditions =
{
    {
        property = "planetaris-dust-concentration",
        min = 50,
        max = 100,
    }
};

-- Make simulating units cheaper on heavy glass, remove EM plant restriction because why
removeItemFromRecipe("planetaris-simulating-unit", "planetaris-heavy-glass");
removeItemFromRecipe("planetaris-simulating-unit", "planetaris-silica");
addItemToRecipe("planetaris-simulating-unit", "planetaris-heavy-glass", 2);
addItemToRecipe("planetaris-simulating-unit", "planetaris-silica", 5);
addFluidToRecipe("planetaris-simulating-unit", "sulfuric-acid", 5);
data.raw["recipe"]["planetaris-simulating-unit"].category = "electronics";

-- Why is the EM plant used for everything it's not even a tech prerequisite :(
data.raw["recipe"]["planetaris-hyper-transport-belt"].category = "metallurgy";
data.raw["recipe"]["planetaris-hyper-underground-belt"].category = "metallurgy";
data.raw["recipe"]["planetaris-hyper-splitter"].category = "metallurgy";
data.raw["recipe"]["planetaris-hyper-transport-belt"].surface_conditions =
{
    {
        property = "pressure",
        min = 4000,
        max = 4000,
    }
};
data.raw["recipe"]["planetaris-hyper-underground-belt"].surface_conditions =
{
    {
        property = "pressure",
        min = 4000,
        max = 4000,
    }
};
data.raw["recipe"]["planetaris-hyper-splitter"].surface_conditions =
{
    {
        property = "pressure",
        min = 4000,
        max = 4000,
    }
};

-- Change centrifuge
removeItemFromRecipe("centrifuge", "steel-plate");
addItemToRecipe("centrifuge", "planetaris-heavy-glass", 20);

-- Add simulating unit to reactors & quantum processors, making them more useful
removeItemFromRecipe("nuclear-reactor", "advanced-circuit");
removeItemFromRecipe("nuclear-reactor", "steel-plate");
removeItemFromRecipe("nuclear-reactor", "copper-plate");
addItemToRecipe("nuclear-reactor", "planetaris-simulating-unit", 100);
addItemToRecipe("nuclear-reactor", "steel-plate", 100);
addItemToRecipe("nuclear-reactor", "copper-plate", 100);
addItemToRecipe("nuclear-reactor", "planetaris-heavy-glass", 100);
removeItemFromRecipe("fission-reactor-equipment", "processing-unit");
addItemToRecipe("fission-reactor-equipment", "planetaris-simulating-unit", 40);
addItemToRecipe("fission-reactor-equipment", "planetaris-glass-panel", 20);

removeItemFromRecipe("quantum-processor", "processing-unit");
addItemToRecipe("quantum-processor", "planetaris-simulating-unit", 1);

-- Simple recipe for sandstone, might serve as a stone sink
data.raw["recipe"]["planetaris-sandstone-brick"].category = "crafting-with-fluid";
removeItemFromRecipe("planetaris-sandstone-brick", "planetaris-pure-sand");
addFluidToRecipe("planetaris-sandstone-brick", "planetaris-pure-sand", 500);
addItemToRecipe("planetaris-sandstone-brick", "stone", 40);
removeItemFromRecipe("planetaris-glass-panel", "planetaris-pure-sand-barrel");
removeItemFromRecipeResults("planetaris-glass-panel", "barrel");
addItemToRecipe("planetaris-glass-panel", "planetaris-sandstone-brick", 2);

-- Add advanced recipe to press tech
table.insert(data.raw["technology"]["planetaris-compression"].effects, {type = "unlock-recipe", recipe = "h3-arig-sandstone-brick-compression"});

-- Press press press press press, Cardi don't need more press
removeItemFromRecipe("planetaris-press", "steel-plate");
addItemToRecipe("planetaris-press", "planetaris-heavy-glass", 20);

-- Change heavy glass graphics
data.raw["item"]["planetaris-heavy-glass"].icon = "__atomic-arig__/graphics/icons/h3-arig-heavy-glass.png";

-- Optional: New chemical compression recipes now use lubricant as a catalyst for significant efficiency gains
if settings.startup["h3-arig-lubricatedPress"].value == true then
    -- Recipe
    removeItemFromRecipe("planetaris-plastic-bar", "petroleum-gas");
    addFluidToRecipe("planetaris-plastic-bar", "petroleum-gas", 20);
    addFluidToRecipe("planetaris-plastic-bar", "lubricant", 10);

    removeItemFromRecipe("planetaris-solid-fuel-from-heavy-oil", "heavy-oil");
    addFluidToRecipe("planetaris-solid-fuel-from-heavy-oil", "heavy-oil", 5);
    addFluidToRecipe("planetaris-solid-fuel-from-heavy-oil", "lubricant", 10);

    removeItemFromRecipe("planetaris-solid-fuel-from-light-oil", "light-oil");
    addFluidToRecipe("planetaris-solid-fuel-from-light-oil", "light-oil", 5);
    addFluidToRecipe("planetaris-solid-fuel-from-light-oil", "lubricant", 10);

    removeItemFromRecipe("planetaris-solid-fuel-from-petroleum-gas", "petroleum-gas");
    addFluidToRecipe("planetaris-solid-fuel-from-petroleum-gas", "petroleum-gas", 15);
    addFluidToRecipe("planetaris-solid-fuel-from-petroleum-gas", "lubricant", 10);

    addFluidToRecipe("planetaris-carbon", "lubricant", 10);
end

-- #endregion

-- #region ENTITY

-- Modify Assembler 4, slight nerf to put it below the advanced assembler from AoP
--data.raw["assembling-machine"]["planetaris-assembling-machine-4"].energy_source = {type = "void"};
--data.raw["assembling-machine"]["planetaris-assembling-machine-4"].allowed_effects = {"speed", "productivity", "quality"};
data.raw["assembling-machine"]["planetaris-assembling-machine-4"].crafting_speed = 1.75;
data.raw["item"]["planetaris-assembling-machine-4"].weight = data.raw["item"]["assembling-machine-3"].weight; -- only 3 could fit on a rocket for some reason
data.raw["assembling-machine"]["planetaris-assembling-machine-4"].energy_usage = "232kW";

-- Modify Atom Forge, halved energy usage to justify higher crafting costs
--data.raw["assembling-machine"]["atan-atom-forge"].energy_source = {type = "void"};
--data.raw["assembling-machine"]["atan-atom-forge"].allowed_effects = {"speed", "productivity", "quality"};
table.insert(data.raw["assembling-machine"]["atan-atom-forge"].crafting_categories, "compressing-or-crafting");
data.raw["assembling-machine"]["atan-atom-forge"].energy_usage = "1250kW";
--[[
data.raw["assembling-machine"]["atan-atom-forge"].surface_conditions =
{
    {
        property = "planetaris-dust-concentration",
        min = 50,
        max = 100,
    }
};
]]

-- Add Arig science crafting category to machines
for i, machine in pairs(data.raw["assembling-machine"]) do
    if doesTableContain(machine.crafting_categories, "crafting") or doesTableContain(machine.crafting_categories, "compressing") then
        table.insert(machine.crafting_categories, "compressing-or-crafting");
    end
end
data.raw["recipe"]["planetaris-compression-science-pack"].category = "compressing-or-crafting";

-- Reverse change to furnaces because we killed pure sand barrels
local stone_furnace = data.raw["furnace"]["stone-furnace"]
if stone_furnace then
  if stone_furnace.result_inventory_size == 2 then
    stone_furnace.result_inventory_size = 1
  end
end

local steel_furnace = data.raw["furnace"]["steel-furnace"]
if steel_furnace then
  if steel_furnace.result_inventory_size == 2 then
    steel_furnace.result_inventory_size = 1
  end
end

local electric_furnace = data.raw["furnace"]["electric-furnace"]
if electric_furnace then
  if electric_furnace.result_inventory_size == 2 then
    electric_furnace.result_inventory_size = 1
  end
end

-- #endregion

-- #region MOD COMPAT

-- Paracelsin: Add new concrete recipes to productivity research
if mods["Paracelsin"] then
    table.insert(data.raw["technology"]["concrete-productivity"].effects, { type = "change-recipe-productivity", recipe = "h3-arig-sandstone-brick-concrete", change = 0.1});
    table.insert(data.raw["technology"]["concrete-productivity"].effects, { type = "change-recipe-productivity", recipe = "h3-arig-sandstone-brick-refined-concrete", change = 0.1});
end

-- Maraxsis: Glass productivity also affects Arig glasses
if mods["maraxsis"] then
    table.insert(data.raw["technology"]["maraxsis-glass-productivity"].effects, { type = "change-recipe-productivity", recipe = "planetaris-glass-panel", change = 0.1});
    table.insert(data.raw["technology"]["maraxsis-glass-productivity"].effects, { type = "change-recipe-productivity", recipe = "planetaris-heavy-glass", change = 0.1});
    addPackToTech("maraxsis-glass-productivity", "planetaris-compression-science-pack", 1);
    table.insert(data.raw["technology"]["maraxsis-glass-productivity"].prerequisites, "planetaris-compression-science");
end

-- Atomic robots: Add to Arig tech progression, adjust stats so that power draw is reduced but not entirely removed
if mods["AtomicRobotsFix2Boost"] then
    -- Recipe
    data.raw["recipe"]["atomic-logistic-robot"].category = "advanced-centrifuging-or-crafting";
    removeItemFromRecipe("atomic-logistic-robot", "fission-reactor-equipment");
    addItemToRecipe("atomic-logistic-robot", "uranium-fuel-cell", 1);
    addItemToRecipe("atomic-logistic-robot", "planetaris-simulating-unit", 1);
    addItemToRecipe("atomic-logistic-robot", "supercapacitor", 2);
    addItemToRecipe("atomic-logistic-robot", "low-density-structure", 1);

    data.raw["recipe"]["atomic-construction-robot"].category = "advanced-centrifuging-or-crafting";
    removeItemFromRecipe("atomic-construction-robot", "fission-reactor-equipment");
    addItemToRecipe("atomic-construction-robot", "uranium-fuel-cell", 1);
    addItemToRecipe("atomic-construction-robot", "planetaris-simulating-unit", 1);
    addItemToRecipe("atomic-construction-robot", "superconductor", 2);
    addItemToRecipe("atomic-construction-robot", "low-density-structure", 1);

    -- Tech
    data.raw["technology"]["atomic-logistic-robots"].prerequisites = {"utility-science-pack", "planetaris-simulating-unit", "electromagnetic-science-pack"};
    addPackToTech("atomic-logistic-robots", "utility-science-pack", 1);
    addPackToTech("atomic-logistic-robots", "space-science-pack", 1);
    addPackToTech("atomic-logistic-robots", "planetaris-compression-science-pack", 1);
    addPackToTech("atomic-logistic-robots", "electromagnetic-science-pack", 1);

    data.raw["technology"]["atomic-construction-robots"].prerequisites = {"utility-science-pack", "planetaris-simulating-unit", "electromagnetic-science-pack"};
    addPackToTech("atomic-construction-robots", "utility-science-pack", 1);
    addPackToTech("atomic-construction-robots", "space-science-pack", 1);
    addPackToTech("atomic-construction-robots", "planetaris-compression-science-pack", 1);
    addPackToTech("atomic-construction-robots", "electromagnetic-science-pack", 1);

    -- Entity
    data.raw["construction-robot"]["atomic-construction-robot"].speed = 0.09;
    data.raw["construction-robot"]["atomic-construction-robot"].max_payload_size = 2;
    data.raw["construction-robot"]["atomic-construction-robot"].max_energy = "3MJ";
    data.raw["construction-robot"]["atomic-construction-robot"].energy_per_tick = "0.01kJ";
    data.raw["construction-robot"]["atomic-construction-robot"].speed_multiplier_when_out_of_energy = 0.5;
    data.raw["construction-robot"]["atomic-construction-robot"].energy_per_move = "1kJ";

    data.raw["logistic-robot"]["atomic-logistic-robot"].speed = 0.09;
    data.raw["logistic-robot"]["atomic-logistic-robot"].max_payload_size = 2;
    data.raw["logistic-robot"]["atomic-logistic-robot"].max_energy = "3MJ";
    data.raw["logistic-robot"]["atomic-logistic-robot"].energy_per_tick = "0.01kJ";
    data.raw["logistic-robot"]["atomic-logistic-robot"].speed_multiplier_when_out_of_energy = 0.5;
    data.raw["logistic-robot"]["atomic-logistic-robot"].energy_per_move = "1kJ";
end

-- #endregion