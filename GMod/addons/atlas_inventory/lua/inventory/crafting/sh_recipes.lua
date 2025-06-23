INVENTORY.Recipes = INVENTORY.Recipes or {}
INVENTORY.Crafting = INVENTORY.Crafting or {}


-- Example: INVENTORY.Crafting.CreateRecipe( "recipe_name", {requiredItems = {["item_one"] = true, ["item_two"] = true}, outputItem = "final_item"} )
function INVENTORY.Crafting.CreateRecipe( name, tbl )
    INVENTORY.Recipes[name] = tbl
end

function INVENTORY.Crafting.GetRecipe( name )
    return INVENTORY.Recipes[name]
end

function INVENTORY.Crafting.GetRecipes()
    return INVENTORY.Recipes
end

-- Example: INVENTORY.Crafting.IsRecipe( {["item_one"] = true, ["item_two"] = true} ) -> "recipe_name", "final_item"
function INVENTORY.Crafting.IsRecipe(items)
    -- Iterate through each recipe
    for recipeName, recipe in pairs(INVENTORY.Recipes) do
        local isMatch = true  -- Assume a match initially

        -- Check if each required item for the current recipe is present in the 'items' set and in the correct quantity
        for requiredItem, requiredQuantity in pairs(recipe.requiredItems) do
            -- Check for the presence of the item and that it's a number, then compare quantities
            if not items[requiredItem] or type(items[requiredItem]) ~= "number" or items[requiredItem] < requiredQuantity then
                isMatch = false  -- If any required item is missing, not a number, or in insufficient quantity, it's not a match
                break
            end
        end
        -- If a match is found, return the recipe name and output item
        if isMatch then
            return recipeName, recipe.outputItem
        end
    end
    return nil  -- Return nil if no matching recipe is found
end

hook.Run("InventoryCraftingLoaded")




-- Recipe Codes here
INVENTORY.Crafting.CreateRecipe( "c_iron", {requiredItems = {["iron_ore"] = 2}, outputItem = "combined_iron"} )
INVENTORY.Crafting.CreateRecipe( "c_wood", {requiredItems = {["wood_chunks"] = 2}, outputItem = "combined_wood"} ) 
INVENTORY.Crafting.CreateRecipe( "c_gold", {requiredItems = {["gold_ore"] = 2}, outputItem = "combined_gold"} ) 
INVENTORY.Crafting.CreateRecipe( "c_silicon", {requiredItems = {["silicon"] = 2}, outputItem = "combined_silicon"} ) 
/*INVENTORY.Crafting.CreateRecipe( "e_iron", {requiredItems = {["combined_iron"] = 2}, outputItem = "enhanced_iron"} )
INVENTORY.Crafting.CreateRecipe( "e_wood", {requiredItems = {["combined_wood"] = 2}, outputItem = "enhanced_wood"} ) 
INVENTORY.Crafting.CreateRecipe( "e_gold", {requiredItems = {["combined_gold"] = 2}, outputItem = "enhanced_gold"} ) 
INVENTORY.Crafting.CreateRecipe( "e_silicon", {requiredItems = {["combined_silicon"] = 2}, outputItem = "enhanced_silicon"} )*/
INVENTORY.Crafting.CreateRecipe( "q_iron", {requiredItems = {["combined_iron"] = 2}, outputItem = "quality_iron"} ) 
INVENTORY.Crafting.CreateRecipe( "q_wood", {requiredItems = {["combined_wood"] = 2}, outputItem = "quality_wood"} ) 
INVENTORY.Crafting.CreateRecipe( "q_gold", {requiredItems = {["combined_gold"] = 2}, outputItem = "quality_gold"} )
INVENTORY.Crafting.CreateRecipe( "q_silicon", {requiredItems = {["combined_silicon"] = 2}, outputItem = "quality_silicon"} )  
INVENTORY.Crafting.CreateRecipe( "trch", {requiredItems = {["lighter"] = 2}, outputItem = "torch"} ) 
INVENTORY.Crafting.CreateRecipe( "n_ails", {requiredItems = {["quality_iron"] = 2}, outputItem = "nails"} ) 
INVENTORY.Crafting.CreateRecipe( "jugg", {requiredItems = {["cardboard_suit"] = 1, ["power_core"] = 1}, outputItem = "juggernaut_mk1"} )
INVENTORY.Crafting.CreateRecipe( "c_board", {requiredItems = {["quality_gold"] = 1, ["quality_silicon"] = 1}, outputItem = "circuit_board"} ) 
INVENTORY.Crafting.CreateRecipe( "m_plastic", {requiredItems = {["plastic"] = 1, ["lighter"] = 1}, outputItem = "molded_plastic"} ) 
INVENTORY.Crafting.CreateRecipe( "hmmer", {requiredItems = {["quality_iron"] = 1, ["quality_wood"] = 1}, outputItem = "hammer"} ) 
INVENTORY.Crafting.CreateRecipe( "m_iron", {requiredItems = {["quality_iron"] = 1, ["torch"] = 1}, outputItem = "molded_iron"} ) 
INVENTORY.Crafting.CreateRecipe( "i_plating", {requiredItems = {["hammer"] = 1, ["molded_iron"] = 1}, outputItem = "iron_plating"} ) 
INVENTORY.Crafting.CreateRecipe( "c_shell", {requiredItems = {["cardboard"] = 1, ["nails"] = 1}, outputItem = "cardboard_shell"} ) 
INVENTORY.Crafting.CreateRecipe( "r_pi", {requiredItems = {["circuit_board"] = 2}, outputItem = "raspberry_pi"} )
INVENTORY.Crafting.CreateRecipe( "t_comp", {requiredItems = {["raspberry_pi"] = 2}, outputItem = "tiny_computer"} )
INVENTORY.Crafting.CreateRecipe( "p_source", {requiredItems = {["quality_gold"] = 1, ["batteries"] = 1}, outputItem = "power_source"} )
INVENTORY.Crafting.CreateRecipe( "p_core", {requiredItems = {["tiny_computer"] = 1, ["power_source"] = 1}, outputItem = "power_core"} )
INVENTORY.Crafting.CreateRecipe( "kcard", {requiredItems = {["circuit_board"] = 1, ["molded_plastic"] = 1}, outputItem = "scuffed_keycard"} )
INVENTORY.Crafting.CreateRecipe( "n_club", {requiredItems = {["nails"] = 1, ["quality_wood"] = 1}, outputItem = "nail_club"} )
INVENTORY.Crafting.CreateRecipe( "q_razor", {requiredItems = {["quartz"] = 1, ["rubber_bands"] = 1}, outputItem = "hm_glass_knife"} )
INVENTORY.Crafting.CreateRecipe( "s_pipe", {requiredItems = {["quality_iron"] = 1, ["enhanced_iron"] = 1}, outputItem = "sturdy_pipe"} )
INVENTORY.Crafting.CreateRecipe( "c_suit", {requiredItems = {["iron_plating"] = 1, ["cardboard_shell"] = 1}, outputItem = "cardboard_suit"} )
INVENTORY.Crafting.CreateRecipe( "see_one", {requiredItems = {["essence_049"] = 1, ["essence_076_2"] = 1}, outputItem = "see"} )
INVENTORY.Crafting.CreateRecipe( "see_two", {requiredItems = {["essence_049"] = 1, ["essence_939"] = 1}, outputItem = "see"} )
INVENTORY.Crafting.CreateRecipe( "see_three", {requiredItems = {["essence_076_2"] = 1, ["essence_939"] = 1}, outputItem = "see"} )
INVENTORY.Crafting.CreateRecipe( "bomb", {requiredItems = {["power_core"] = 1, ["power_source"] = 1}, outputItem = "m9k_suicide_bomb"} )
INVENTORY.Crafting.CreateRecipe( "doorbuster", {requiredItems = {["tiny_computer"] = 1, ["power_core"] = 1}, outputItem = "wos_keypad_cracker"} )