net.Receive("Atlas.ClearChat", function()

    chat.Close()
    scb.chatbox.scroll_panel:Remove()
    scb.chatbox = nil
    scb.create_chatbox()
    chat.Close()
    
    chat.AddText( Color(255, 56, 56), "| SCP.GG", Color(255, 255, 255), ": Chat Cleared by staff!" )

end)