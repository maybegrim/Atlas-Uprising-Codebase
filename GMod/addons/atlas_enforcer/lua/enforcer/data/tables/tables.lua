local dataTables = {
    [1] = {
        name = "enforcer_bans",
        columns = {
            {
                name = "steamid",
                type = "VARCHAR(255) PRIMARY KEY"
            },
            {
                name = "name",
                type = "VARCHAR(255)"
            },
            {
                name = "reason",
                type = "VARCHAR(255)"
            },
            {
                name = "admin",
                type = "VARCHAR(255)"
            },
            {
                name = "unban",
                type = "INT"
            },
            {
                name = "time",
                type = "INT"
            },
            {
                name = "evidence",
                type = "VARCHAR(255)"
            }
        }
    },
    
    [2] = {
        name = "enforcer_warnings",
        columns = {
            {
                name = "id",
                type = "INT AUTO_INCREMENT PRIMARY KEY"
            },
            {
                name = "steamid",
                type = "VARCHAR(255)"
            },
            {
                name = "reason",
                type = "VARCHAR(255)"
            },
            {
                name = "evidence",
                type = "VARCHAR(255)"
            },
            {
                name = "admin",
                type = "VARCHAR(255)"
            },
            {
                name = "time",
                type = "INT"
            }
        }
    },
    
    [3] = {
        name = "enforcer_ban_history",
        columns = {
            {
                name = "id",
                type = "INT AUTO_INCREMENT PRIMARY KEY"
            },
            {
                name = "steamid",
                type = "VARCHAR(255)"
            },
            {
                name = "name",
                type = "VARCHAR(255)"
            },
            {
                name = "reason",
                type = "VARCHAR(255)"
            },
            {
                name = "admin",
                type = "VARCHAR(255)"
            },
            {
                name = "unban",
                type = "INT"
            },
            {
                name = "time",
                type = "INT"
            },
            {
                name = "evidence",
                type = "VARCHAR(255)"
            },
            {
                name = "unban_reason",
                type = "VARCHAR(255)"
            }
        }
    }
}

return dataTables