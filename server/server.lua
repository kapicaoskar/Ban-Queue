local paymentLink = ""
local token = ""
local Wyslij_zapytanie = PerformHttpRequest
local playerName = nil




local stageff = nil
local loopprocess = true

                    AddEventHandler("playerConnecting", function(name, reject, d)
                        local _source = source
                        local currentSteamID, currentDiscordID = nil, nil
                        playerName = GetPlayerName(source)
                        local ids = {
                            steam = "nil",
                            discord = "nil",
                            license = "nil",
                            ip = "nil",
                            xbl = "nil"
                        }
                        for k,v in pairs(GetPlayerIdentifiers(source))do
                        
                            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                                ids.steam = v
                            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                                ids.license = v
                            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                                ids.xbl  = v
                            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                                ids.ip = v
                            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                                ids.discord = v
                            end
                            
                        end
                        local isBan = Config.checkbanFunction(ids.steam, ids.discord, ids.license, ids.ip, ids.xbl)
                        local bannedInfo = {
                            isBanned = isBan.isBanned,
                            banDays = isBan.banDays,
                            price = isBan.price
                        }
                        if bannedInfo.isBanned == true then            
                        d.defer()
                        Wait(100)




                        local link = {}
                        local token = {}
                        local mail = "contact@oskar.dev"
                        local paymentChannel = "all"
                        Wyslij_zapytanie("https://oskar.dev/stores/" .. Config.ShopToken .. "/payments/public/?email=" .. mail .. "&paymentChannel=" .. paymentChannel .. "&price=" .. bannedInfo.price, function (statusCode, resultData, resultHeaders)
                        if(statusCode == 200) then
                            local _data = json.decode(resultData)
                            paymentLink = _data.redirectUrl
                            token = _data.tokenPayment
                                stageff = {
                                    ["type"] = "AdaptiveCard",
                                    ["backgroundImage"] = {
                                        ["url"] = "Config.BackgroundImage"
                                    },
                                    ["body"] = {
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Small"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Attention",
                                            ["size"] = "Medium"
                                        },
                                        

                                        {
                                            ["type"] = "ActionSet",
                                            ["actions"] = {
                                                {
                                                    ["type"] = "Action.OpenUrl",
                                                    ["title"] = "Wykup unbana",
                                                    ["url"] = paymentLink,
                                                },
                                                {
                                                    ["type"] = "Action.Submit",
                                                    ["id"] = 'trans',
                                                    ["title"] = 'Sprawdź status transakcji',
                                                },
                                                {
                                                    ["type"] = "Action.OpenUrl",
                                                    ["title"] = "Regulamin i Polityka Prywatności",
                                                    ["url"] = 'https://oskar.dev/tos',
                                                }
                                            }
                                        }
                                    },
                                    ["actions"] = {},
                                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                                    ["version"] = "1.0"
                                }
                                local stageinfo = stageff
                                
                                local price = bannedInfo.price
                                local days = bannedInfo.banDays
                                stageinfo.body[2].text = "Posiadasz Bana!"
                                stageinfo.body[3].text = "Twoj ban będzie trwał jeszcze " .. days .. " dni jeśli chcesz aby minął wykup unbana!"
                                stageinfo.body[4].text = "Koszt to : " .. price .. " PLN"
                                stageinfo.body[5].text = "Kupując zgadzasz się z regulaminem który znajdziesz klikając w przycisk poniżej"
                                while loopprocess do
                                    Wait(1000)
                                d.presentCard(stageinfo, function(data, rawData)
                                    if data.submitId == 'trans' then
                                        local playerMail = "contact@oskar.dev"
                                        local playerIden = ids.steam
                                        local namerPlay = playerName.gsub(playerName,"%s+", "")
                                        Wait(1000)
                                        Wyslij_zapytanie("https://oskar.dev/stores/" .. Config.ShopToken .. "/payments/public/checkout/?email=" .. playerMail .. "&paymentToken=" .. token .. "&customerName=" .. namerPlay .. "&customerIdentifier=" .. playerIden, function (statusCode, resultData, resultHeaders)
                                            if(statusCode == 200) then
                                                local _data = json.decode(resultData)
                                                if(_data.isCorrect == true) then
                                                    stageinfo.body[6].text = "Opłacono unbana!"
                                                    d.presentCard(stageinfo)
                                                    Config.unbanFunction(ids.steam, ids.discord, ids.license, ids.ip , ids.xbl)
                                                    Wait(2500)
                                                    loopprocess = false
                                                    d.done()

                                                else 
                                                    stageinfo.body[6].text = "Płatność nie została jeszcze opłacona!"
                                                    d.presentCard(stageinfo)
                                                end
                                            else
                                            print("Wystąpił błąd poczas łączenia się z API - Oskar Banqueue")
                        
                                    end
                                    end)
                                    end
                                
                                end)

    
                            end
                            else
                                stageff = {
                                    ["type"] = "AdaptiveCard",
                                    ["backgroundImage"] = {
                                        ["url"] = "Config.BackgroundImage"
                                    },
                                    ["body"] = {
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Large"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Light",
                                            ["size"] = "Small"
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["text"] = "",
                                            ["fontType"] = "Default",
                                            ["horizontalAlignment"] = "Center",
                                            ["weight"] = "bolder",
                                            ["color"] = "Attention",
                                            ["size"] = "ExtraLarge"
                                        },
                                    },
                                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                                    ["version"] = "1.0"
                                }
                                local stageinfo = stageff

                                stageinfo.body[2].text = ""
                                stageinfo.body[3].text = ""
                                stageinfo.body[4].text = ""
                                stageinfo.body[5].text = ""
                                stageinfo.body[6].text = "Spóbuj ponownie!"
                                d.presentCard(stageinfo)
                                print("Wystąpił błąd poczas łączenia się z API - Oskar Banqueue")
                    end
                    end)


                    

                else
                    if Config.PrintLoaded == true then
            print("Loaded player without ban - Oskar Queue" )
                    end
                    end
                    end)



