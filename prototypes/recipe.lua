-- Concrete recipes as a sandstone brick sink
data:extend
({
    {
        type = "recipe",
        name = "h3-arig-sandstone-brick-concrete",
        category = "compressing",
        order = "a[sand-processing]-b[sand-processing]",
        icon = "__atomic-arig__/graphics/icons/h3-arig-sandstone-brick-concrete.png",
        enabled = false,
        energy_required = 10,
        surface_conditions =
        {
            {
                property = "planetaris-dust-concentration",
                min = 50,
                max = 100,
            }
        },
        ingredients = 
        { 
            { type = "item", name = "iron-ore", amount = 1 },
            { type = "item", name = "planetaris-sandstone-brick", amount = 5 },
            { type = "fluid", name = "lubricant", amount = 10 },
        },
        results = 
        { 
            { type = "item", name = "concrete", amount = 10 },
        }
    },
    {
        type = "recipe",
        name = "h3-arig-sandstone-brick-refined-concrete",
        category = "compressing",
        order = "a[sand-processing]-b[sand-processing]",
        icon = "__atomic-arig__/graphics/icons/h3-arig-sandstone-brick-refined-concrete.png",
        enabled = false,
        energy_required = 15,
        surface_conditions =
        {
            {
                property = "planetaris-dust-concentration",
                min = 50,
                max = 100,
            }
        },
        ingredients = 
        { 
            { type = "item", name = "concrete", amount = 10 },
            { type = "item", name = "iron-stick", amount = 8 },
            { type = "item", name = "steel-plate", amount = 1 },
            { type = "fluid", name = "lubricant", amount = 10 },
        },
        results = 
        { 
            { type = "item", name = "refined-concrete", amount = 10 },
        }
    },
    {
        type = "recipe",
        name = "h3-arig-sandstone-brick-compression",
        category = "compressing",
        order = "a[sand-processing]-b[sand-processing]",
        icon = "__atomic-arig__/graphics/icons/h3-arig-sandstone-brick-compression.png",
        enabled = false,
        energy_required = 2,
        ingredients = 
        { 
            { type = "fluid", name = "planetaris-pure-sand", amount = 500 },
            { type = "fluid", name = "lubricant", amount = 10 },
            { type = "item", name = "stone", amount = 10 },
        },
        results = 
        { 
            { type = "item", name = "planetaris-sandstone-brick", amount = 10 },
        }
    },
})