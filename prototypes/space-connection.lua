data:extend
({
    {
        type = "space-connection",
        name = "nauvis-arig",
        subgroup = "planet-connections",
        from = "nauvis",
        to = "arig", 
        length = 10000,
        icon_size = 64,
        asteroid_spawn_definitions = data.raw["space-connection"]["nauvis-vulcanus"].asteroid_spawn_definitions;
    }
})