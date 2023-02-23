Config = {}

Config.ShopToken = "your shop token" -- API authorization
Config.ServerName = "your server name"
Config.PrintLoaded = true --this will print in your server side console if player without ban was loaded -- boolean


Config.checkbanFunction = function(steam , discord , license , ip , xbl)
    -- YOUR OWN CHECK BAN FUNCTION TO CHECK IF SOMEONE HAS BAN EXAMPLE OF GIVEN ID :    STEAM:00000000000, DISCORD:0000000000
    -- ONLY EXAMPLE IT WILL NOT WORK IN 50% CASES YOU NEED TO DO IT ALONE ONLY EXAMPLE!!
    local daysOfBan = 20 -- interger
    local price = 20 -- interger
    local banned = true -- boolean

    if daysOfBan < 30 then
    price = 30
    elseif daysOfBan >= 30 then
        price = 60
    elseif daysOfBan >= 60 then
        price = 120
    elseif daysOfBan >= 120 then
        price = 240
    end
    
    local banned = {
    banDays = tostring(daysOfBan), -- need to be a string
    isBanned = banned, -- boolean
    price = tostring(price) -- need to be a string
    } 
    return banned 
end


Config.unbanFunction = function(steam , discord , license , ip , xbl)
    -- YOUR OWN UNBAN FUNCTION THIS WILL UNBAN PLAYER EXAMPLE OF GIVEN ID :    STEAM:00000000000, DISCORD:0000000000
    -- ONLY EXAMPLE IT WILL NOT WORK IN 50% CASES YOU NEED TO DO IT ALONE ONLY EXAMPLE!!
    MySQL.Async.execute(
		'DELETE FROM banlist WHERE license=@license',
		{
		['@license']  = license
		},
		function ()
			print("player has been unbanned License : " .. license)
	end)
end




