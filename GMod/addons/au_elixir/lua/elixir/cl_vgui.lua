local EFrame = {}

AccessorFunc(EFrame, "m_bIsMenuComponent", "IsMenu",        FORCE_BOOL)
AccessorFunc(EFrame, "m_bDraggable",       "Draggable",     FORCE_BOOL)
AccessorFunc(EFrame, "m_bSizable",         "Sizable",       FORCE_BOOL)
AccessorFunc(EFrame, "m_bScreenLock",      "ScreenLock",    FORCE_BOOL)
AccessorFunc(EFrame, "m_bDeleteOnClose",   "DeleteOnClose", FORCE_BOOL)
AccessorFunc(EFrame, "m_bPaint",           "Paint",         FORCE_BOOL)

AccessorFunc(EFrame, "m_iMinWidth",	       "MinWidth",		FORCE_NUMBER)
AccessorFunc(EFrame, "m_iMinHeight",	   "MinHeight",	    FORCE_NUMBER)

surface.CreateFont("elixir.window.title", {
    font = "Roboto",
    weight = 700,
    size = 20,
    antialis = true
})

surface.CreateFont("elixir.window.item", {
    font = "Roboto",
    weight = 500,
    size = 20,
    antialis = true
})

function EFrame:Init()
    self:SetFocusTopLevel(true)

    self.CloseButton = vgui.Create("DButton", self)
    self.CloseButton:SetText("")
    self.CloseButton:SetSize(22, 22)
    self.CloseButton.DoClick = function () self:Close() end
    self.CloseButton.Paint = function (self, w, h)
        surface.SetDrawColor(Color(255, 255, 255))
        draw.NoTexture()
        
        surface.DrawPoly({
            { x = 5, y = 7 },
            { x = 7, y = 5 },
            { x = w - 5, y = h - 7 },
            { x = w - 7, y = h - 5 }            
        })

        surface.DrawPoly({
            { x = 7, y = h - 5 },
            { x = 5, y = h - 7 },
            { x = w - 7, y = 5 },
            { x = w - 5, y = 7 }            
        })
    end

    self.TitleLabel = vgui.Create("DLabel", self)
    self.TitleLabel:SetFont("elixir.window.title")
    self.TitleLabel:SetColor(Color(255, 255, 255))
    self.TitleLabel:SetText("ELIXIR")

    self:SetPaint(true)
    self:SetSizable(false)
    self:SetDraggable(true)
    self:SetScreenLock(false)
    self:SetDeleteOnClose(true)

    self:SetMinWidth(50)
    self:SetMinHeight(50)

    self:SetPaintBackgroundEnabled(false)
    self:SetPaintBorderEnabled(false)

    self.m_fCreateTime = SysTime()

    self:DockPadding(5, 30, 5, 5)
end

function EFrame:SetTitle(title)
    self.TitleLabel:SetText(title)
end

function EFrame:GetTitle(title)
    return self.TitleLabel:GetText()
end

function EFrame:ShowCloseButton(show)
    self.CloseButton:SetVisible(show)
end

function EFrame:Close()
    self:SetVisible(false)
    if self:GetDeleteOnClose() then self:Remove() end
    self:OnClose()
end

function EFrame:OnClose()
end

function EFrame:Center()
    self:InvalidateLayout(true)
    self:CenterVertical()
    self:CenterHorizontal()
end

function EFrame:IsActive()
    if self:HasFocus() then return true end
    if vgui.FocusedHasParent(self) then return true end
    return false
end

function EFrame:Think()
    local mouse_x = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
    local mouse_y = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

    if self.Dragging then
        local x = mouse_x - self.Dragging[1]
        local y = mouse_y - self.Dragging[2]

        if self:GetScreenLock() then
            x = math.Clamp(x, 0, ScrW() - self:GetWide())
            y = math.Clamp(y, 0, ScrH() - self:GetTall())
        end

        self:SetPos(x, y)
    end

    if self.Sizing then
        local x = mouse_x - self.Sizing[1]
        local y = mouse_y - self.Sizing[2]
        local px, py = self:GetPos()

        if x < self.m_iMinWidth then x = self.m_iMinWidth elseif x > ScrW() - px and self:GetScreenLock() then x = ScrW() - px end
        if y < self.m_iMinHeight then y = self.m_iMinHeight elseif y > ScrH() - py and self:GetScreenLock() then y = ScrH() - py end

        self:SetSize(x, y)
        self:SetCursor("sizenwse")
        return
    end

    local screen_x, screen_y = self:LocalToScreen(0, 0)

    if mouse_y < screen_y + 30 then
        self:SetCursor("sizeall")
        return
    end

    if self.Hovered and self.m_bSizable and mouse_x > (screen_x + self:GetWide() - 20) and mouse_y > (screen_y + self:GetTall() - 20) then
        self:SetCursor("sizenwse")
        return
    end

    if self.Hovered and self:GetDraggable() and mouse_y < (screen_y + 24) then
        self:SetCursor("sizeall")
    end

    self:SetCursor("arrow")

    if self.y < 0 then
        self:GetPos(self.x, 0)
    end
end

function EFrame:Paint(w, h)
    if not self.m_bPaint then return end

    draw.RoundedBox(0, 0, 0, w, h, Color(39, 36, 42))
    draw.RoundedBox(0, 0, 0, w, 30, Color(54, 41, 69))

    local width, height = self:GetSize()
    
    if self.m_bSizable then
        surface.SetDrawColor(50, 50, 50)
        surface.DrawLine(width - 5, height - 3, width - 3, height - 5)
        surface.DrawLine(width - 10, height - 3, width - 3, height - 10)
        surface.DrawLine(width - 15, height - 3, width - 3, height - 15)
    end
end

function EFrame:OnMousePressed()
    local screen_x, screen_y = self:LocalToScreen(0, 0)

    if self.m_bSizable and gui.MouseX() > (screen_x + self:GetWide() - 20) and gui.MouseY() > (screen_y + self:GetTall() - 20) then
        self.Sizing = {
            gui.MouseX() - self:GetWide(),
            gui.MouseY() - self:GetTall()
        }

        self:MouseCapture()
        return
    end

    if self:GetDraggable() and gui.MouseY() < (screen_y + 30) then
        self.Dragging = {
            gui.MouseX() - self.x,
            gui.MouseY() - self.y
        }

        self:MouseCapture(true)
        return
    end
end

function EFrame:OnMouseReleased()
    self.Dragging = nil 
    self.Sizing = nil 
    self:MouseCapture(false)
end

function EFrame:PerformLayout()
    self.CloseButton:SetPos(self:GetWide() - 30, 4)
    self.TitleLabel:SetPos(10, 5)
    self.TitleLabel:SetSize(self:GetSize() - 50, 20)
    self:LayoutChildren()
end

function EFrame:LayoutChildren()
end

derma.DefineControl("ElixirFrame", "Elixir window.", EFrame, "EditablePanel")

local EScroll = {}

function EScroll:Init()
    local v_scroll = self:GetVBar()
    v_scroll:SetSize(10, self:GetTall())
    v_scroll:SetHideButtons(true)
    
    v_scroll.Paint = function (self, w, h) end

    v_scroll.btnGrip.Paint = function (self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(107, 99, 110))
    end
end

derma.DefineControl("ElixirScroll", "Elixir scroll panel.", EScroll, "DScrollPanel")