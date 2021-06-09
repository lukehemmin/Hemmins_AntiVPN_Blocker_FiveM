AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("[HAC-ANTIVPN] %s. Your IP Address is being checked.", name)) -- en
    -- deferrals.update(string.format("[HAC-ANTIVPN] %s. 접속한 아이피 확인중...", name)) -- kr
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("[HAC-ANTIVPN] We could not find your IP Address.") -- en
        -- deferrals.done("[HAC-ANTIVPN] 아이피 위치를 찾을 수 없습니다.") -- kr
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if tbl["proxy"] == false then
                    deferrals.done("[HAC-ANTIVPN] very Good! have a nice game!") -- en
                    -- deferrals.done("[HAC-ANTIVPN] 이제 게임플레이가 가능합니다. 즐거운 시간 되세요~!") -- kr
                else
                    deferrals.done("[HAC-ANTIVPN] You are using a VPN. Please disable and try again.") -- en
                    -- deferrals.done("[HAC-ANTIVPN] VPN을 연결해제 후 다시 접속해주세요.") -- kr
                end
            else
                deferrals.done("[HAC-ANTIVPN] There was an error in the API.") -- en
                -- deferrals.done("[HAC-ANTIVPN] API 서버 연결이 원활하지 않습니다.") -- kr
            end
        end)
    end
end)