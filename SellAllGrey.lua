-- Localization table
local L = {
    enUS = {
        earned_message = "SellAllGrey: You earned %s from selling grey items."
    },
    frFR = {
        earned_message = "SellAllGrey : Vous avez gagné %s en vendant des objets gris."
    },
    deDE = {
        earned_message = "SellAllGrey: Du hast %s durch den Verkauf von grauen Gegenständen verdient."
    },
    itIT = {
        earned_message = "SellAllGrey: Hai guadagnato %s dalla vendita di oggetti grigi."
    },
    koKR = {
        earned_message = "SellAllGrey: 회색 아이템을 판매하여 %s를 획득했습니다."
    },
    zhCN = {
        earned_message = "SellAllGrey: 你卖掉灰色物品获得了 %s."
    },
    zhTW = {
        earned_message = "SellAllGrey: 你賣掉灰色物品獲得了 %s."
    },
    ruRU = {
        earned_message = "SellAllGrey: Вы заработали %s, продавая серые предметы."
    },
    esES = {
        earned_message = "SellAllGrey: Has ganado %s vendiendo objetos grises."
    },
    esMX = {
        earned_message = "SellAllGrey: Has ganado %s vendiendo objetos grises."
    },
    ptBR = {
        earned_message = "SellAllGrey: Você ganhou %s vendendo itens cinza."
    }
}

-- Function to get localized text
local function GetLocaleText(key)
    local locale = GetLocale()
    return L[locale] and L[locale][key] or L["enUS"][key]
end

-- Function to format the currency with icons
local function FormatCurrency(amount)
    local gold = floor(amount / 10000)
    local silver = floor((amount % 10000) / 100)
    local copper = amount % 100

    local goldText = gold > 0 and string.format("|cffffd700%d|r|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t", gold) or ""
    local silverText = silver > 0 and string.format("|cffc7c7cf%d|r|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t", silver) or ""
    local copperText = copper > 0 and string.format("|cffeda55f%d|r|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", copper) or ""

    return goldText .. " " .. silverText .. " " .. copperText
end

-- Function to sell all grey items and calculate total earnings
local function SellGreyItems()
    local totalEarnings = 0 -- Variable to keep track of total earnings

    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
                local itemCount = C_Container.GetContainerItemInfo(bag, slot).stackCount
                if itemRarity == 0 and itemSellPrice > 0 then
                    -- Calculate earnings from this item and add to total
                    local earnings = itemSellPrice * itemCount
                    totalEarnings = totalEarnings + earnings
                    -- Sell the item
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end

    -- If there were any earnings, print the total earnings to the chat
    if totalEarnings > 0 then
        local formattedEarnings = FormatCurrency(totalEarnings)
        -- Output to the chat window with yellow/amber color
        print("|cffffff00" .. string.format(GetLocaleText("earned_message"), formattedEarnings) .. "|r")
    end
end

-- Event handler function
local function OnEvent(self, event)
    if event == "MERCHANT_SHOW" then
        SellGreyItems()
    end
end

-- Create frame and register events
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", OnEvent)
