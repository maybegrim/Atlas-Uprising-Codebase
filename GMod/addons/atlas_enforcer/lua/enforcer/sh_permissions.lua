hook.Add("Initialize", "ATLAS.ENFORCER.PERMS", function()
    sam.permissions.add("give_warn", "Atlas Enforcer", "admin")
    sam.permissions.add("delete_warn", "Atlas Enforcer", "admin")
    sam.permissions.add("edit_warn", "Atlas Enforcer", "admin")
    sam.permissions.add("view_warning_db", "Atlas Enforcer", "admin")

    sam.permissions.add("view_ban_db", "Atlas Enforcer", "admin")
    sam.permissions.add("edit_ban", "Atlas Enforcer", "admin")
    sam.permissions.add("delete_ban", "Atlas Enforcer", "admin")
end)

print("Loaded SAM Permissions for Enforcer")
