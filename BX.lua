-------------------修改表注严禁修改的地方必将追责，请尊重作者以及license-------------------
----------------------本人开发时已获取KEK作者许可调用函数
----------------------如需二改清自行联系作者以及KEK作者许可

-----------------严禁修改此处----------------------------
ui.notify_above_map("~b~BX_SYSTEM\n欢迎使用BX整合v0.1\n2T玩家交流群：872986398\n买科技加群775255063","欢迎使用BX整合",0)
ui.notify_above_map("~b~BX_SYSTEM\n~r~本LUA部分函数已获KEK授权","欢迎使用BX整合",0)
ui.notify_above_map("~b~BX_SYSTEM\n本LUA开源地址\n~y~https://github.com/BaiXinSpuer/2T1_BX_MIX","欢迎使用BX整合",0)
-----------------严禁修改此处----------------------------

local main=menu.add_feature("BX_SYSTEM","parent",0)
--------------整合其他LUA必备库（方法）---------------
local Myped = function()
    return player.get_player_ped(player.player_id())
end
local Pedshoot = function()
    return ped.is_ped_shooting(Myped()) and not player.is_player_in_any_vehicle(player.player_id()) or
        ped.get_vehicle_ped_is_using == 0 or
        ped.get_vehicle_ped_is_using == nil
end
local Pedweapon = function()
    return ped.get_current_ped_weapon(Myped())
end
local all_ped=ped.get_all_peds()
-----------------抢主机 functions from KEK‘s authorization--------------------
local script_event_hashes = {
    ["Netbail kick"] = 2092565704,
    ["Kick 1"] = 1964309656,
    ["Kick 2"] = 696123127,
    ["Kick 3"] = 43922647,
    ["Kick 4"] = 600486780,
    ["Kick 5"] = 1954846099,
    ["Kick 6"] = 153488394,
    ["Kick 7"] = 1249026189,
    ["Kick 8"] = 515799090,
    ["Kick 9"] = 1463355688,
    ["Kick 10"] = -1382676328,
    ["Kick 11"] = 1256866538,
    ["Kick 12"] = 515799090,
    ["Kick 13"] = -1813981910,
    ["Kick 14"] = 202252150,
    ["Kick 15"] = -19131151,
    ["Kick 16"] = -635501849,
    ["Kick 17"] = 1964309656,
    ["Crash 1"] = -988842806,
    ["Crash 2"] = -2043109205,
    ["Crash 3"] = 1926582096,
    ["Crash 4"] = 153488394,
    ["Script host crash 1"] = 315658550,
    ["Script host crash 2"] = -877212109,
    ["Disown personal vehicle"] = -2072214082,
    ["Vehicle EMP"] = 975723848,
    ["Destroy personal vehicle"] = 1229338575,
    ["Kick out of vehicle"] = -1005623606,
    ["Remove wanted level"] = 1187364773,
    ["Give OTR or ghost organization"] = -397188359,
    ["Block passive"] = 1472357458,
    ["Send to mission"] = -1147284669,
    ["Send to Perico island"] = -1479371259,
    ["Apartment invite"] = 1249026189,
    ["CEO ban"] = 1355230914,
    ["Dismiss or terminate from CEO"] = -316948135,
    ["Insurance notification"] = 299217086,
    ["Transaction error"] = -2041535807,
    ["CEO money"] = 1152266822,
    ["Bounty"] = -1906146218,
    ["Banner"] = 1659915470,
    ["Sound 1"] = 1537221257,
    ["Sound 2"] = -1162153263,
    ["Bribe authorities"] = -151720011
}	

function get_script_event_hash(name)
    local hash = script_event_hashes[name]
    if math.type(hash) == "integer" then
        return hash
    else
        return 0
    end

end

function generic_player_global(pid)
    return script.get_global_i(1630816 + (1 + (pid * 597) + 508))
end

local function get_people_in_front_of_person_in_host_queue()
    if network.network_is_host() then
        return {}, {}
    end
    local hosts, friends = {}, {}
    local player_host_priority = player.get_player_host_priority(player.player_id())
    for pid = 0, 31 do
        if player.is_player_valid(pid) and pid ~= player.player_id() then
            if player.get_player_host_priority(pid) <= player_host_priority or player.is_player_host(pid) then
                hosts[#hosts + 1] = pid
                if network.is_scid_friend(player.get_player_scid(pid)) then
                    friends[#friends + 1] = pid
                end
            end
        end
    end
    return hosts, friends
end

local SE_send_limiter = {}
function send_script_event(name, pid, args, friend_condition)
    if player.is_player_valid(pid) and pid ~= player.player_id() then
        if math.type(pid) == "integer" then 
            for i = 1, #args do
                if math.type(args[i]) ~= "integer" then
                    return
                end
            end
        else
            return
        end
        repeat
            local temp = {}
            for i = 1, #SE_send_limiter do
                if SE_send_limiter[i] > utils.time_ms() then
                    temp[#temp + 1] = SE_send_limiter[i]
                end
            end
            SE_send_limiter = temp
            if #temp >= 10 then
                system.yield(0)
            end
        until #temp < 10
        if player.is_player_valid(pid) then
            SE_send_limiter[#SE_send_limiter + 1] = utils.time_ms() + (1 // gameplay.get_frame_time())
            script.trigger_script_event(get_script_event_hash(name), pid, args)
        end
    else
        system.yield(0)
    end
end

local function get_host()
    local hosts = get_people_in_front_of_person_in_host_queue()
    for i, pid in pairs(hosts) do
        send_script_event("Netbail kick", pid, {pid, generic_player_global(pid)})
        for x=0,17 do
            send_script_event("Kick "..tostring(x), pid, {pid, generic_player_global(pid)})
        end
    end
    return {}, false
end
--------------------------------------------------------

---------------------mian-------------------------------

local main_self=menu.add_feature("玩家选项","parent",main.id)


local main_network=menu.add_feature("在线选项","parent",main.id)


local Heist_Control=menu.add_feature("任务选项","parent",main.id)


local main_weapon=menu.add_feature("武器选项","parent",main.id)


local main_protect=menu.add_feature("保护选项","parent",main.id)


local main_about=menu.add_feature(
    "关于",
    "action",
    main.id,
    function ()
    -----------------严禁修改此处----------------------------
        ui.notify_above_map("~b~BX_SYSTEM\n欢迎使用BX整合v0.1\n2T玩家交流群：872986398\n买科技加群775255063","欢迎使用BX整合",0)
        ui.notify_above_map("~b~BX_SYSTEM\n~r~本LUA部分函数已获KEK授权","欢迎使用BX整合",0)
        ui.notify_above_map("~b~BX_SYSTEM\n本LUA开源地址\n~y~https://github.com/BaiXinSpuer/2T1_BX_MIX","欢迎使用BX整合",0)
    -----------------严禁修改此处---------------------------- 
end)

----------------------main_targets-------------------------------
local main_net_all=menu.add_feature("全体成员","parent",main_network.id)








--------------------toggle_targets------------------------------

------------自我选项------------------
--------------在地图上隐藏自己 Done----------------
local health_cheat=menu.add_feature(
    "在地图上隐藏自己"
    ,"toggle",
    main_self.id,
    function(a)
        if a.on then
            local me = player.player_id()
            local myid = player.get_player_ped(me)
            ped.set_ped_max_health(myid,0)
        else
            local me = player.player_id()
            local myid = player.get_player_ped(me)
            ped.set_ped_max_health(myid,328)
        end
    end
)

-----------在线玩家---------------


-----------主机掠夺 Done--------------

local get_host=menu.add_feature(
    "主机掠夺",
    "toggle",
    main_network.id,
    function(a)
        while a.on and not network.network_is_host() do
            system.yield(0)
				local nothing, friends = get_host()
				if friends then
					break
				end
		end
			a.on = false
    end


)









-------------主机检测 Done--------------

local is_host=menu.add_feature(
    "成为主机通知",
    "toggle",
    main_network.id,
    function(a)
        while a.on do
            system.yield(0)
            if network.network_is_host() then
                ui.set_text_color(255, 0, 155, 255)					
                    ui.set_text_scale(0.5)
                    ui.set_text_font(0)
                    ui.set_text_centre(true)
                    ui.set_text_outline(true)
                    ui.draw_text("主机模式",v2(0.95,0.96))
            end
        end
    end
            


)
---------------踢出玩家 Done-------------------
local kick=menu.add_feature(
    "主机踢",
    "toggle",
    main_net_all.id,
    function(a)
        while a.on do
            system.yield(0)
            local me=player.player_id()
            for pid =0,31 do
                if pid ~= me and not player.is_player_friend(pid) then
                    network.network_session_kick_player(pid)
                end
            end
        end
    end

)

-----------------暴力踢出 Done-----------------
local force_kick=menu.add_feature(
    "暴力踢出",
    "toggle",
    main_net_all.id,
    function(a)
        while a.on do
            system.yield(0)
            local me=player.player_id()
            for pid=0,31 do
                if pid~=me and not player.is_player_friend(pid) and player.is_player_valid(pid) then
                    network.network_session_kick_player(pid)
                    send_script_event("Netbail kick", pid, {pid, generic_player_global(pid)})
                    for x=0,17 do
                        send_script_event("Kick "..tostring(x), pid, {pid, generic_player_global(pid)})
                    end
                end
            end
        end
    end
)



-------------------激光眼 待完善--------------------
local killing_eye=menu.add_feature(
    "激光眼",
    "toggle",
    main_self.id,
    function(a)
        while a.on do
            system.yield(0)
            local me=player.player_id()
            local ped=player.get_player_ped(me)
            if controls.is_control_pressed(0,252) then
                pos=player.get_player_coords(me)
                rot = entity.get_entity_rotation(ped)
                pos=pos+rot
                print(pos)
            end
        end
    end

)
killing_eye.hidden=true




--------------载具驾驶枪----------------------

local vehicle_driver_weapon=menu.add_feature("载具驾驶枪","toggle",main_weapon.id)
vehicle_driver_weapon.hidden=true

------------------快速射击 Done---------------------------
---------------------此处代码基于 revive---------------
local fast_shooter=menu.add_feature(
    "快速射击",
    "toggle",
    main_weapon.id,
    function(a)
        while a.on do
            local me=player.player_id()
            local my_ped=player.get_player_ped(me)
            system.yield(0)
            if controls.get_control_normal(0,142)==0.0 then
                state=nil
            else
                state=1
            end
            while state do
                local success, v3_start = ped.get_ped_bone_coords(my_ped, 0x67f2, v3())
                while not success do
                    success, v3_start = ped.get_ped_bone_coords(my_ped, 0x67f2, v3())
                    system.wait(0)
                end
                local dir = cam.get_gameplay_cam_rot()
                dir:transformRotToDir()
                dir = dir * 1.5
                v3_start = v3_start + dir
                dir = nil
                local v3_end = player.get_player_coords(me)
                dir = cam.get_gameplay_cam_rot()
                dir:transformRotToDir()
                dir = dir * 1500
                v3_end = v3_end + dir
                local hash_weapon = ped.get_current_ped_weapon(my_ped)
                gameplay.shoot_single_bullet_between_coords(v3_start, v3_end, 1, hash_weapon, my_ped, true, false, 1000)
                system.yield(0)
                return HANDLER_CONTINUE
            end
        end
    end


)
-------------------------------------------------------



---------------冻结战局 Done---------------------

local freeze_session=menu.add_feature(
    "冻结战局",
    "toggle",
    main_net_all.id,
    function(a)
        while a.on do
            system.yield(0)
            for pid = 0, 31 do
				if player.is_player_valid(pid) 
				and player.player_id() ~= pid 
				and not player.is_player_friend(pid) 
				and not player.is_player_modder(pid, -1) 
				and not entity.is_entity_dead(player.get_player_ped(pid)) then
					ped.clear_ped_tasks_immediately(player.get_player_ped(pid))
				end
			end
        end
    end
)

---------------刷屏机器人------------------
local ad_m=menu.add_feature(
    "刷屏机器人",
    "action_value_str",
    main_network.id,
    function(a)
        while a.value==0 do
            system.yield(0)
            network.send_chat_message("QQGroup:775255063\nU this poor bitch never could bought a 2Take1 in there\n2T uers'QQ group：872986398\nQQ群775255063\n你这个穷逼一辈子在那也买不起一个2Take1\n2T玩家交流群：872986398",false)
        end
    end
)
ad_m:set_str_data({
    "开启",
    "关闭"
})


--------------------保护选项-------------------
----------------标记所有玩家 Done------------------
local fuck_them=menu.add_feature(
    "阻止同步（标记所有玩家）",
    "toggle",
    main_protect.id,
    function(a)
        while a.on do
            system.yield(0)
            if a.on then
                for pid=0,31 do
                    if pid~=me and player.is_player_valid(pid) then
                        player.set_player_as_modder(pid,1<<0x10)
                    end
                end
            else
                for pid=0,31 do
                    if pid~=me and player.is_player_valid(pid) then
                        player.unset_player_as_modder(pid,1<<0x10)
                    end
                end
            end
        end
    end
                



)

------------------Ozark's protect Done------------------
local fuck_myself=menu.add_feature(
    "Øzark的紧急避难",
    "toggle",
    main_protect.id,
    function(a)
        while a.on do
            system.yield(0)
            local me=player.player_id()
            local pos=player.get_player_coords(me)
            if a.on then
                gameplay.clear_area_of_objects(pos,500,0)
                gameplay.clear_area_of_vehicles(pos,500,false,false,false,false,false)
                gameplay.clear_area_of_peds(pos,500,false)
                gameplay.clear_area_of_cops(pos,500,false)
                for pid=0,31 do
                    if pid~=me and player.is_player_valid(pid) and a.on then
                        player.set_player_as_modder(pid,1<<0x10)
                        player.set_player_visible_locally(pid,false)
                    end
                end
            else
                for pid=0,31 do
                    if pid~=me and player.is_player_valid(pid) then
                        player.unset_player_as_modder(pid,1<<0x10)
                        player.set_player_visible_locally(pid,true)
                    end
                end
            end
        end
    end


)







---------------------观察者检测 Done---------------
local fuck_spectater=menu.add_feature(
    "监听观察者",
    "toggle",
    main_protect.id,
    function(a)
        local me=player.player_id()
        while a.on do
            system.yield(0)
            for pid=0,31 do
                if player.is_player_spectating(ped.get_player_ped(pid)) and player.is_player_valid(pid) and pid~=me then
                    who = player.get_player_name(network.get_player_player_is_spectating(ped.get_player_ped(pid)))
                    who_spec=player.get_player_name(ped.get_player_ped(pid))
                    ui.draw_rect(0.001, 0.999, 4.5, 0.085, 0, 0, 0, 0)
                            ui.set_text_color(255, 255, 0, 255)				
                                    ui.set_text_scale(0.5)
                                    ui.set_text_font(0)
                                    ui.set_text_centre(true)
                                    ui.set_text_outline(true)
                                    ui.draw_text(who_spec.." 正在观察 "..who,v2(0.5,0.96))
                end
            end
        end
    end

)

--------------------武器--------------------
-------------------彩虹枪 Done-------------
local main_weapon_color=menu.add_feature(
    "彩虹枪",
    "toggle",
    main_weapon.id,
    function(a)
        while a.on do
            for i, weapon_hash in pairs(weapon.get_all_weapon_hashes()) do
                if weapon.has_ped_got_weapon(player.get_player_ped(player.player_id()), weapon_hash) then
                    local number_of_tints = weapon.get_weapon_tint_count(weapon_hash)
                    if weapon_hash and weapon_hash ~= 2725352035 and number_of_tints > 0 then
                        weapon.set_ped_weapon_tint_index(player.get_player_ped(player.player_id()), weapon_hash, math.random(1, number_of_tints))
                    end
                end
            end
            system.yield(50)
        end
    end



)

-------------------导弹连发 Done--------------

local speed_fire_veh=menu.add_feature(
    "车载武器快速射击",
    "toggle",
    main_weapon.id,
    function(a)
        if a.on then
            local myped = player.get_player_ped(player.player_id())
            if ped.is_ped_in_any_vehicle(myped) == true then
              local Curveh = ped.get_vehicle_ped_is_using(myped)
              vehicle.set_vehicle_fixed(Curveh)
              vehicle.set_vehicle_deformation_fixed(Curveh)
            end
            return HANDLER_CONTINUE
        end
        return HANDLER_POP
    end
)

--------------自动切枪 Done----------------
local main_weapon_switch=menu.add_feature(
    "自动切枪",
    "toggle",
    main_weapon.id,
    function(a)
        if a.on then
            if Pedshoot() then
                if Pedweapon() == 0xA284510B then
                    weapon.remove_weapon_from_ped(Myped(), 0xA284510B)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0xA284510B, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0xA284510B, 2147483647)
                elseif Pedweapon() == 0xB1CA77B1 then
                    weapon.remove_weapon_from_ped(Myped(), 0xB1CA77B1)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0xB1CA77B1, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0xB1CA77B1, 2147483647)
                elseif Pedweapon() == 0x7F7497E5 then
                    weapon.remove_weapon_from_ped(Myped(), 0x7F7497E5)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x7F7497E5, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x7F7497E5, 2147483647)
                elseif Pedweapon() == 0x6D544C99 then
                    weapon.remove_weapon_from_ped(Myped(), 0x6D544C99)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x6D544C99, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x6D544C99, 2147483647)
                elseif Pedweapon() == 0x63AB0442 then
                    weapon.remove_weapon_from_ped(Myped(), 0x63AB0442)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x63AB0442, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x63AB0442, 2147483647)
                elseif Pedweapon() == 0x0781FE4A then
                    weapon.remove_weapon_from_ped(Myped(), 0x0781FE4A)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x0781FE4A, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x0781FE4A, 2147483647)
                elseif Pedweapon() == 0x05FC3C11 then
                    weapon.remove_weapon_from_ped(Myped(), 0x05FC3C11)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x05FC3C11, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x05FC3C11, 2147483647)
                elseif Pedweapon() == 0x0C472FE2 then
                    weapon.remove_weapon_from_ped(Myped(), 0x0C472FE2)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x0C472FE2, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x0C472FE2, 2147483647)
                elseif Pedweapon() == 0xA914799 then
                    weapon.remove_weapon_from_ped(Myped(), 0xA914799)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0xA914799, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0xA914799, 2147483647)
                elseif Pedweapon() == 0xC734385A then
                    weapon.remove_weapon_from_ped(Myped(), 0xC734385A)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0xC734385A, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0xC734385A, 2147483647)
                elseif Pedweapon() == 0x6A6C02E0 then
                    weapon.remove_weapon_from_ped(Myped(), 0x6A6C02E0)
                    weapon.give_delayed_weapon_to_ped(Myped(), 0x6A6C02E0, 0, 1)
                    weapon.set_ped_ammo(Myped(), 0x6A6C02E0, 2147483647)
                end
            end
            return HANDLER_CONTINUE
        end
        return HANDLER_POP
    end
)

-------------自动跳过过场动画 Done--------------
local main_auto_skip=menu.add_feature(
    "自动跳过过场动画",
    "toggle",
    Heist_Control.id,
    function(a)
        while a.on do
            system.yield(0)
            if cutscene.is_cutscene_active() or cutscene.is_cutscene_playing() then
                cutscene.stop_cutscene_immediately()
                cutscene.remove_cutscene()
            else
                return HANDLER_CONTINUE
            end
        end
    end
)


--------------车友会1000级-----------------
local main_cheyouhui=menu.add_feature(
    "车友会解锁1000级",
    "action",
    Heist_Control.id,
    function()
        stats.stat_set_int(gameplay.get_hash_key("MP0_CAR_CLUB_REP"), 997430, true)
        stats.stat_set_int(gameplay.get_hash_key("MP1_CAR_CLUB_REP"), 997430, true)
    end

)

local main_reset_cheyouhui=menu.add_feature(
    "车友会重置1级",
    "action",
    Heist_Control.id,
    function()
        stats.stat_set_int(gameplay.get_hash_key("MP0_CAR_CLUB_REP"), 0, true)
        stats.stat_set_int(gameplay.get_hash_key("MP1_CAR_CLUB_REP"), 0, true)
    end

)



















































































































-------------------------抢劫------------------------
local function stat_set_float(hash, prefix, value, save)
    save = save or true
    local hash0, hash1 = hash
    if prefix then
        hash0 = "MP0_" .. hash
        hash1 = "MP1_" .. hash
        hash1 = gameplay.get_hash_key(hash1)
    end
    hash0 = gameplay.get_hash_key(hash0)
    local value0, e = stats.stat_get_float(hash0, -1)
    if value0 ~= value then
        stats.stat_set_float(hash0, value, save)
    end
    if prefix then
        local value1, e = stats.stat_get_float(hash1, -1)
        if value1 ~= value then
            stats.stat_set_float(hash1, value, save)
        end
    end
end
-- INT
local function stat_set_int(hash, prefix, value, save)
    save = save or true
    local hash0, hash1 = hash
    if prefix then
        hash0 = "MP0_" .. hash
        hash1 = "MP1_" .. hash
        hash1 = gameplay.get_hash_key(hash1)
    end
    hash0 = gameplay.get_hash_key(hash0)
    local value0, e = stats.stat_get_int(hash0, -1)
    if value0 ~= value then
        stats.stat_set_int(hash0, value, save)
    end
    if prefix then
        local value1, e = stats.stat_get_int(hash1, -1)
        if value1 ~= value then
            stats.stat_set_int(hash1, value, save)
        end
    end
end
-- BOOL
local function stat_set_bool(hash, prefix, value, save)
    save = save or true
    local hash0, hash1 = hash
    if prefix then
        hash0 = "MP0_" .. hash
        hash1 = "MP1_" .. hash
        hash1 = gameplay.get_hash_key(hash1)
    end
    hash0 = gameplay.get_hash_key(hash0)
    local value0, e = stats.stat_get_bool(hash0, -1)
    if value0 ~= value then
        stats.stat_set_bool(hash0, value, save)
    end
    if prefix then
        local value1, e = stats.stat_get_bool(hash1, -1)
        if value1 ~= value then
            stats.stat_set_bool(hash1, value, save)
        end
    end
end

local PERICO_HEIST = menu.add_feature("» 佩里科岛抢劫", "parent", Heist_Control.id)
local CAYO_AUTO_PRST = menu.add_feature("» 自动预设", "parent", PERICO_HEIST.id, function()
menu.notify("记住：你必须在潜艇外或主甲板上选择预设", "", 6, 0x50F0FF14)
end)
local AUTOMATED_SOLO = menu.add_feature("» 单人$240万", "parent", CAYO_AUTO_PRST.id)
local AUTOMATED_2P = menu.add_feature("» 双人240万", "parent", CAYO_AUTO_PRST.id)
local AUTOMATED_3P = menu.add_feature("» 3人240万", "parent", CAYO_AUTO_PRST.id)
local AUTOMATED_4P = menu.add_feature("» 4人240万", "parent", CAYO_AUTO_PRST.id)
local STANDARD_SET = menu.add_feature("» 标准预置", "parent", PERICO_HEIST.id, function()
    menu.notify("记住：你必须在潜艇外或主甲板上选择预设", "", 6, 0x50F0FF14)
end)
local TELEPORT = menu.add_feature("» 自定义传送", "parent", PERICO_HEIST.id)
local PERICO_ADV = menu.add_feature("» 高级功能", "parent", PERICO_HEIST.id)
local HSCUT_CP = menu.add_feature("» 玩家分红", "parent", PERICO_ADV.id, function()
menu.notify("重要信息\n\n-添加高百分比可能会对付款产生负面影响", "", 5, 0x6414F0FF)
end)
local PERICO_HOST_CUT = menu.add_feature("» 你的分红", "parent", HSCUT_CP.id)
local PERICO_P2_CUT = menu.add_feature("» 玩家2 ", "parent", HSCUT_CP.id)
local PERICO_P3_CUT = menu.add_feature("» 玩家3 ", "parent", HSCUT_CP.id)
local PERICO_P4_CUT = menu.add_feature("» 玩家4 ", "parent", HSCUT_CP.id)
local CAYO_BAG = menu.add_feature("» 容量调整器", "parent", PERICO_ADV.id)
local CAYO_VEHICLES = menu.add_feature("» 设置接近载具", "parent", PERICO_HEIST.id)
local CAYO_PRIMARY = menu.add_feature("» 主要目标", "parent", PERICO_HEIST.id)
local CAYO_SECONDARY = menu.add_feature("» 次要目标", "parent", PERICO_HEIST.id)
local CAYO_WEAPONS = menu.add_feature("» 武器选择", "parent", PERICO_HEIST.id)
local CAYO_EQUIPM = menu.add_feature("» 装备(钩爪,衣服,剪钳)生成区域", "parent", PERICO_HEIST.id)
local CAYO_TRUCK = menu.add_feature("» 补给车位置", "parent", PERICO_HEIST.id)
local CAYO_DFFCTY = menu.add_feature("» 难度设置", "parent", PERICO_HEIST.id)
local MORE_OPTIONS = menu.add_feature("» 更多选项", "parent", PERICO_HEIST.id)
local CASINO_HEIST = menu.add_feature("» 名钻赌场豪劫", "parent", Heist_Control.id)
local CASINO_PRESETS = menu.add_feature("» 快速配置", "parent", CASINO_HEIST.id, function()
menu.notify("记住：你必须先支付准备费用才能开始抢劫，然后走出游戏厅/车库才能正确应用预设！", "", 6, 0x50F0FF14)
end)
local CAH_ADVCED = menu.add_feature("» 高级功能", "parent", CASINO_HEIST.id)
local CASINO_BOARD1 = menu.add_feature("» 设置策划板1", "parent", CASINO_HEIST.id)
local BOARD1_APPROACH = menu.add_feature("» 改变方法和难度", "parent", CASINO_BOARD1.id)
local CASINO_TARGET = menu.add_feature("» 修改目标", "parent", CASINO_BOARD1.id)
local CASINO_BOARD2 = menu.add_feature("» 设置策划板2", "parent", CASINO_HEIST.id)
local CASINO_BOARD3 = menu.add_feature("» 设置策划板3", "parent", CASINO_HEIST.id)
local CASINO_LBOARDS = menu.add_feature("» 重置策划板", "parent", CASINO_HEIST.id)
local CASINO_MORE = menu.add_feature("» 更多选项", "parent", CASINO_HEIST.id)
local DOOMS_HEIST = menu.add_feature("» 末日豪劫", "parent", Heist_Control.id)
local DOOMS_PRESETS = menu.add_feature("» 快速配置", "parent", DOOMS_HEIST.id)
local DDHEIST_PLYR_MANAGER = menu.add_feature("» 玩家分红", "parent", DOOMS_HEIST.id)
local CLASSIC_HEISTS = menu.add_feature("» 公寓抢劫", "parent", Heist_Control.id)
local CLASSIC_CUT = menu.add_feature("» 你的分红", "parent", CLASSIC_HEISTS.id)
local LS_ROBBERY = menu.add_feature("» 改装铺抢劫", "parent", Heist_Control.id)
local MASTER_UNLOCKR = menu.add_feature("» 解锁大师", "parent", Heist_Control.id)
local TOOLS = menu.add_feature("» 工具", "parent", Heist_Control.id)

menu.add_feature("» 虎鲸 : 策划面板 [先呼出虎鲸]", "action", TELEPORT.id, function()
    menu.notify("如果你不呼出虎鲸就传送，你会出现BUG", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(1561.224,386.659,-49.685))
end)

menu.add_feature("» 虎鲸 : 主甲板 [先呼出虎鲸]", "action", TELEPORT.id, function()
    menu.notify("如果你不呼出虎鲸就传送，你会出现BUG", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(1563.218,406.030,-49.667))
end)

menu.add_feature("» 排水管道 : 入口", "action", TELEPORT.id, function()
    menu.notify("传送到排水管道 : 入口", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(5044.726,-5816.164,-11.213))
end)

menu.add_feature("» 排水管道 : 第二个检查点", "action", TELEPORT.id, function()
    menu.notify("传送到排水管道 : 第二个检查点", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(5054.630,-5771.519,-4.807))
end)

menu.add_feature("» 主要目标", "action", TELEPORT.id, function()
    menu.notify("传送到 Main Target", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(5006.896,-5755.963,15.487))
end)

menu.add_feature("» 次要目标房间", "action", TELEPORT.id, function()
    menu.notify("传送到 次要目标房间", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(5003.467,-5749.352,14.840))
end)

menu.add_feature("» 金库（金发老大房间）", "action", TELEPORT.id, function()
    menu.notify("传送到 金库", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(5010.753,-5757.639,28.845))
end)

menu.add_feature("» 大门出口", "action", TELEPORT.id, function()
    menu.notify("传送到 出口", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(4992.854,-5718.537,19.880))
end)

menu.add_feature("» 海洋撤离点", "action", TELEPORT.id, function()
    menu.notify("传送到 海洋撤离点", "", 4, 0x64F06414)
    pedmy = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(pedmy,v3(4771.792,-6166.055,-40.266))
end)

do
end
----------------------------------------------------------------
---- AUTO (ALL PLAYERS) NO SECONDARY TARGET
do
local QUICK_SET_ANY = {
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4CNF_APPROACH", -1},
    {"H4LOOT_CASH_I", 0},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_COKE_I", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_PAINT", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT_V", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_CASH_I_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_I_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 0},
    {"H4CNF_TARGET", 5},
    {"H4CNF_WEAPONS", 5},
    {"H4_MISSIONS", 65283},
    {"H4_PROGRESS", 126823},
    {"H4_PLAYTHROUGH_STATUS", 5}
}
menu.add_feature("» [1-4玩家 240万] [快速] [只有主要目标]", "toggle", CAYO_AUTO_PRST.id, function(quickcp)
    menu.notify("抢劫已准备\n\n- 这里没有次要目标, 你的目标就是偷走主要目标并逃跑\n\n- 除了虎鲸以外没有别的车辆可以使用\n\n- 不要弄乱百分比或目标\n\n保持激活状态直到结束", "任务大师", 15, 0x64F06414)
    menu.notify("注意：这个预设有一个视觉错误，在抢劫结束时显示了一个不寻常的数额，但是如果你查看在线玩家，你可以验证其他成员的真实付款情况。", "", 10, 0x501400FF)
    while quickcp.on do
        for i = 1, #QUICK_SET_ANY do
        stat_set_int(QUICK_SET_ANY[i][1], true, QUICK_SET_ANY[i][2])
        end
        script.set_global_i(1711169,100) -- original version 1710289 + 823 + 56 + 1
        script.set_global_i(1711170,145) -- original version 1710289 + 823 + 56 + 2
        script.set_global_i(1711171,145) -- original version 1710289 + 823 + 56 + 3
        script.set_global_i(1711172,145) -- original version 1710289 + 823 + 56 + 4
        script.set_global_f(262145+29470,0.0)
        script.set_global_f(262145+29471,0.0)
        script.set_global_i(262145 + 29466, 2455000)
    if not quickcp.on then return end
    system.wait(0)
    end
end)
end

--- CAYO AUTOMATED PRESET SOLO PLAYERS
do
local AUTO_SOLO_SAPPHIRE_HARD = {
    {"H4CNF_TARGET", 5},
    {"H4LOOT_CASH_I", 5551206},
    {"H4LOOT_CASH_I_SCOPED", 5551206},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 4884838},
    {"H4LOOT_COKE_I_SCOPED", 4884838},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 192},
    {"H4LOOT_GOLD_C_SCOPED", 192},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 120},
    {"H4LOOT_PAINT_SCOPED", 120},
    {"H4LOOT_CASH_V", 224431},
    {"H4LOOT_COKE_V", 353863},
    {"H4LOOT_GOLD_V", 471817},
    {"H4LOOT_PAINT_V", 353863},
    {"H4LOOT_WEED_V", 0},
        --
    {"H4_PROGRESS", 131055}, --hard
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}

local USER_CAN_MDFY_PRESET_AUTO_SPSOLO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 蓝宝石豹", "toggle", AUTOMATED_SOLO.id, function(SOLO_SAPH_var0)
    menu.notify("预设已修改为单人\n-不使用任何高级选项\n-不使用容量修改器\n-不更改脚本设置的百分比\n-只需游玩:)\n\n在抢劫结束前保持激活状态。", "佩里科岛单人 | 蓝宝石豹", 7, 0xffcc63a6)
        for i = 1, #USER_CAN_MDFY_PRESET_AUTO_SPSOLO do
        stat_set_int(USER_CAN_MDFY_PRESET_AUTO_SPSOLO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_SPSOLO[i][2])
        end
        while SOLO_SAPH_var0.on do
        for i = 1, #AUTO_SOLO_SAPPHIRE_HARD do
        stat_set_int(AUTO_SOLO_SAPPHIRE_HARD[i][1], true, AUTO_SOLO_SAPPHIRE_HARD[i][2])
        end
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,100) -- original version 1710289 + 823 + 56 + 1
        if not SOLO_SAPH_var0.on then return end
        system.wait(0)
    end
end)
end

---- SOLO RUBY
--- CAYO AUTOMATED PRESET SOLO PLAYERS
do
local AUTO_SOLO_RUBY_HARD = {
    {"H4CNF_TARGET", 1},
    {"H4LOOT_CASH_I", 9208137},
    {"H4LOOT_CASH_I_SCOPED", 9208137},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 1048704},
    {"H4LOOT_COKE_I_SCOPED", 1048704},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 4206596},
    {"H4LOOT_WEED_I_SCOPED", 4206596},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 424431},
    {"H4LOOT_COKE_V", 848863},
    {"H4LOOT_GOLD_V", 1131817},
    {"H4LOOT_PAINT_V", 848863},
    {"H4LOOT_WEED_V", 679090},
    --
    {"H4_PROGRESS", 131055}, --hard
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}

local USER_CAN_MDFY_PRESET_AUTO_RNSOLO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 红宝石项链", "toggle", AUTOMATED_SOLO.id, function(SOLO_RUBY_var0)
    menu.notify("预设已修改为单人\n-不使用任何高级选项\n-不使用容量修改器\n-不更改脚本设置的百分比\n-只需游玩:)\n\n在抢劫结束前保持激活状态。", "佩里科岛单人 | 红宝石项链", 7, 0xffcc63a6)
        for i = 1, #USER_CAN_MDFY_PRESET_AUTO_RNSOLO do
        stat_set_int(USER_CAN_MDFY_PRESET_AUTO_RNSOLO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_RNSOLO[i][2])
        end
        while SOLO_RUBY_var0.on do      
        for i = 2, #AUTO_SOLO_RUBY_HARD do
        stat_set_int(AUTO_SOLO_RUBY_HARD[i][1], true, AUTO_SOLO_RUBY_HARD[i][2])
        end      
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,100) -- cut original version 1710289 + 823 + 56 + 1
        if not SOLO_RUBY_var0.on then return end
        system.wait(0)
        end
end)
end
----- AUTOMATED 2 PLAYERS
do
local AUTO_2PLAYERs_SAPPHIRE_NORMAL = {
    {"H4CNF_TARGET", 5},
    {"H4LOOT_CASH_I", 2359448},
    {"H4LOOT_CASH_I_SCOPED", 2359448},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 2},
    {"H4LOOT_COKE_I_SCOPED", 2},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 474431},
    {"H4LOOT_COKE_V", 948863},
    {"H4LOOT_GOLD_V", 1265151},
    {"H4LOOT_PAINT_V", 948863},
    {"H4LOOT_WEED_V", 0},
        --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_SPDUO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
menu.add_feature("» 蓝宝石豹", "toggle", AUTOMATED_2P.id, function(AUTO_2_SAPH_var0)
    menu.notify("为2名玩家添加的预设\n-不使用任何高级选项\n-不使用容量修改器\n-不更改脚本设置的百分比\n-只需游玩:)\n\n将其激活，直到抢劫结束。", "佩里科岛2人抢劫 | 蓝宝石豹", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_SPDUO do
    stat_set_int(USER_CAN_MDFY_PRESET_AUTO_SPDUO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_SPDUO[i][2])
    end
    while AUTO_2_SAPH_var0.on do
    for i = 1, #AUTO_2PLAYERs_SAPPHIRE_NORMAL do
    stat_set_int(AUTO_2PLAYERs_SAPPHIRE_NORMAL[i][1], true, AUTO_2PLAYERs_SAPPHIRE_NORMAL[i][2])
    end
    script.set_global_f(262145+29470,-0.1) --pavel cut protection
    script.set_global_f(262145+29471,-0.02) --fency fee cut protection
    script.set_global_i(262145+29227,1800) -- bag protection
    script.set_global_i(1711169,50)
    script.set_global_i(1711170,50)
    if not AUTO_2_SAPH_var0.on then return end
    system.wait(0)
end
end)
end

--- AUTOMATED 2 RUBY
do
local AUTO_2PLAYERs_RUBY_NORMAL = {
    {"H4CNF_TARGET", 1},
    {"H4LOOT_CASH_I", 9208137},
    {"H4LOOT_CASH_I_SCOPED", 9208137},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 1048704},
    {"H4LOOT_COKE_I_SCOPED", 1048704},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 4206596},
    {"H4LOOT_WEED_I_SCOPED", 4206596},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 572727},
    {"H4LOOT_COKE_V", 1145454},
    {"H4LOOT_GOLD_V", 1527272},
    {"H4LOOT_PAINT_V", 1145454},
    {"H4LOOT_WEED_V", 916363},
    --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_RBDUO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 红宝石项链", "toggle", AUTOMATED_2P.id, function(AUTO_2_RUBY_var0)
    menu.notify("为2名玩家添加的预设\n-不使用任何高级选项\n-不使用容量修改器\n-不更改脚本设置的百分比\n-只需游玩:)\n\n将其激活，直到抢劫结束！", "佩里科岛2人抢劫 | 红宝石项链", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_RBDUO do
    stat_set_int(USER_CAN_MDFY_PRESET_AUTO_RBDUO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_RBDUO[i][2])
    end
    while AUTO_2_RUBY_var0.on do
    for i = 1, #AUTO_2PLAYERs_RUBY_NORMAL do
    stat_set_int(AUTO_2PLAYERs_RUBY_NORMAL[i][1], true, AUTO_2PLAYERs_RUBY_NORMAL[i][2])
    script.set_global_f(262145+29470,-0.1) --pavel cut protection
    script.set_global_f(262145+29471,-0.02) --fency fee cut protection
    script.set_global_i(262145+29227,1800) -- bag protection
    script.set_global_i(1711169,50)
    script.set_global_i(1711170,50)
    if not AUTO_2_RUBY_var0.on then return end
    system.wait(0)
    end
end
end)
end

do
--- CAYO AUTOMATED PRESET 3 PLAYERS
local AUTO_3PLAYERs_SAPPHIRE_NORMAL = {
    {"H4CNF_TARGET", 5},
    {"H4LOOT_CASH_I", 2359448},
    {"H4LOOT_CASH_I_SCOPED", 2359448},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 4901222},
    {"H4LOOT_COKE_I_SCOPED", 4901222},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 515151},
    {"H4LOOT_COKE_V", 1030303},
    {"H4LOOT_GOLD_V", 1373737},
    {"H4LOOT_PAINT_V", 1030303},
    {"H4LOOT_WEED_V", 0},
    --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_SPTRIO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 蓝宝石豹", "toggle", AUTOMATED_3P.id, function(AUTO_3_SAPH_var0)
    menu.notify("为3名玩家添加的预设\n-不使用任何高级选项\n-不使用包修改器\n-不更改脚本设置的百分比\n-只需播放:)\n\n将其激活，直到抢劫结束。", "佩里科岛3人 | 蓝宝石豹", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_SPTRIO do
    stat_set_int(USER_CAN_MDFY_PRESET_AUTO_SPTRIO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_SPTRIO[i][2])
    end
        while AUTO_3_SAPH_var0.on do    
        for i = 1, #AUTO_3PLAYERs_SAPPHIRE_NORMAL do
        stat_set_int(AUTO_3PLAYERs_SAPPHIRE_NORMAL[i][1], true, AUTO_3PLAYERs_SAPPHIRE_NORMAL[i][2])
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,30)
        script.set_global_i(1711170,35)
        script.set_global_i(1711171,35)
        if not AUTO_3_SAPH_var0.on then return end
        system.wait(0)
    end
    end
end)
end

do
--- CAYO AUTOMATED 3 PLAYERS RUBY
local AUTO_3PLAYERs_RUBY_NORMAL = {
    {"H4CNF_TARGET", 1},
    {"H4LOOT_CASH_I", 9208137},
    {"H4LOOT_CASH_I_SCOPED", 9208137},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 1048704},
    {"H4LOOT_COKE_I_SCOPED", 1048704},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 4206596},
    {"H4LOOT_WEED_I_SCOPED", 4206596},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 598268},
    {"H4LOOT_COKE_V", 1196536},
    {"H4LOOT_GOLD_V", 1595382},
    {"H4LOOT_PAINT_V", 1196536},
    {"H4LOOT_WEED_V", 957229},
    --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_RBTRIO = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 红宝石项链", "toggle", AUTOMATED_3P.id, function(AUTO_3_RUBY_var0)
    menu.notify("为3名玩家添加的预设\n-不使用任何高级选项\n-不使用包修改器\n-不更改脚本设置的百分比\n-只需播放:)\n\n将其激活，直到抢劫结束。", "佩里科岛3人 | 红宝石项链", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_RBTRIO do
        stat_set_int(USER_CAN_MDFY_PRESET_AUTO_RBTRIO[i][1], true, USER_CAN_MDFY_PRESET_AUTO_RBTRIO[i][2])
    end
    while AUTO_3_RUBY_var0.on do
        for i = 1, #AUTO_3PLAYERs_RUBY_NORMAL do
        stat_set_int(AUTO_3PLAYERs_RUBY_NORMAL[i][1], true, AUTO_3PLAYERs_RUBY_NORMAL[i][2])
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,30)
        script.set_global_i(1711170,35)
        script.set_global_i(1711171,35)
        if not AUTO_3_RUBY_var0.on then return end
        system.wait(0)
    end
    end
end)
end

--- CAYO AUTOMATED PRESET 4 PLAYERS
do
local AUTO_4PLAYERs_SAPPHIRE_NORMAL = {
    {"H4CNF_TARGET", 5},
    {"H4LOOT_CASH_I", 2359448},
    {"H4LOOT_CASH_I_SCOPED", 2359448},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 4901222},
    {"H4LOOT_COKE_I_SCOPED", 4901222},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 599431},
    {"H4LOOT_COKE_V", 1198863},
    {"H4LOOT_GOLD_V", 1598484},
    {"H4LOOT_PAINT_V", 1198863},
    {"H4LOOT_WEED_V", 0},
        --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_SPQUAD = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
menu.add_feature("» 蓝宝石豹", "toggle", AUTOMATED_4P.id, function(AUTO_4_SAPH_var0)
    menu.notify("为4名玩家添加的预设\n-不使用任何高级选项\n-不使用包修改器\n-不更改脚本设置的百分比\n-只需播放:)\n\n将其激活，直到抢劫结束。", "佩里科岛4人 | 蓝宝石豹", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_SPQUAD do
        stat_set_int(USER_CAN_MDFY_PRESET_AUTO_SPQUAD[i][1], true, USER_CAN_MDFY_PRESET_AUTO_SPQUAD[i][2])
    end
        while AUTO_4_SAPH_var0.on do
        for i = 1, #AUTO_4PLAYERs_SAPPHIRE_NORMAL do
        stat_set_int(AUTO_4PLAYERs_SAPPHIRE_NORMAL[i][1], true, AUTO_4PLAYERs_SAPPHIRE_NORMAL[i][2])
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,25) -- player 1
        script.set_global_i(1711170,25) -- player 2
        script.set_global_i(1711171,25) -- player 3
        script.set_global_i(1711172,25) -- player 4
        if not AUTO_4_SAPH_var0.on then return end
        system.wait(0)
    end
    end
end)
end

--- CAYO AUTOMATED PRESET 4 PLAYERS RUBY
do
local AUTO_4PLAYERs_RUBY_NORMAL = {
    {"H4CNF_TARGET", 1},
    {"H4LOOT_CASH_I", 9208137},
    {"H4LOOT_CASH_I_SCOPED", 9208137},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_COKE_I", 1048704},
    {"H4LOOT_COKE_I_SCOPED", 1048704},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C", 255},
    {"H4LOOT_GOLD_C_SCOPED", 255},
    {"H4LOOT_WEED_I", 4206596},
    {"H4LOOT_WEED_I_SCOPED", 4206596},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4LOOT_CASH_V", 655681},
    {"H4LOOT_COKE_V", 1311363},
    {"H4LOOT_GOLD_V", 1748484},
    {"H4LOOT_PAINT_V", 1311363},
    {"H4LOOT_WEED_V", 1049090},
    --
    {"H4_PROGRESS", 126823},
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_APPROACH", -1}
}
local USER_CAN_MDFY_PRESET_AUTO_RBQUAD = {
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4_MISSIONS", 65535},
    {"H4CNF_WEAPONS", 5},
    {"H4CNF_TROJAN", 5},
    {"H4_PLAYTHROUGH_STATUS", 100}
}
    menu.add_feature("» 红宝石项链", "toggle", AUTOMATED_4P.id, function(AUTO_4_RUBY_var0)
    menu.notify("为4名玩家添加的预设\n-不使用任何高级选项\n-不使用包修改器\n-不更改脚本设置的百分比\n-只需播放:)\n\n将其激活，直到抢劫结束。", "佩里科岛4人 | 红宝石项链", 7, 0xffcc63a6)
    for i = 1, #USER_CAN_MDFY_PRESET_AUTO_RBQUAD do
        stat_set_int(USER_CAN_MDFY_PRESET_AUTO_RBQUAD[i][1], true, USER_CAN_MDFY_PRESET_AUTO_RBQUAD[i][2])
    end
    while AUTO_4_RUBY_var0.on do    
        for i = 1, #AUTO_4PLAYERs_RUBY_NORMAL do
        stat_set_int(AUTO_4PLAYERs_RUBY_NORMAL[i][1], true, AUTO_4PLAYERs_RUBY_NORMAL[i][2])
        script.set_global_f(262145+29470,-0.1) --pavel cut protection
        script.set_global_f(262145+29471,-0.02) --fency fee cut protection
        script.set_global_i(262145+29227,1800) -- bag protection
        script.set_global_i(1711169,25) -- player 1
        script.set_global_i(1711170,25) -- player 2
        script.set_global_i(1711171,25) -- player 3
        script.set_global_i(1711172,25) -- player 4
        if not AUTO_4_RUBY_var0.on then return end
        system.wait(0)
    end
end
end)
end

---- STANDARD SET
do
local STANDARD_PRSET = {
    {"H4CNF_BS_GEN", 262143},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_ABIL", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3},
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_GRAPPEL", 5156},
    {"H4CNF_APPROACH", -1},
    {"H4LOOT_CASH_I", 1089792},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_WEED_I", 9114214},
    {"H4LOOT_WEED_C", 37},
    {"H4LOOT_COKE_I", 6573209},
    {"H4LOOT_COKE_C", 26},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 192},
    {"H4LOOT_PAINT", 127},
    {"H4_PROGRESS", 124271},
    {"H4LOOT_CASH_V", 22500},
    {"H4LOOT_COKE_V", 55023},
    {"H4LOOT_GOLD_V", 83046},
    {"H4LOOT_PAINT_V", 47375},
    {"H4LOOT_WEED_V", 36967},
    {"H4LOOT_CASH_I_SCOPED", 1089792},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", 9114214},
    {"H4LOOT_WEED_C_SCOPED", 37},
    {"H4LOOT_COKE_I_SCOPED", 6573209},
    {"H4LOOT_COKE_C_SCOPED", 26},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 192},
    {"H4LOOT_PAINT_SCOPED", 127},
    {"H4_MISSIONS", 65535},
    {"H4_PLAYTHROUGH_STATUS", 5}
}
local RANDOM_TARGET = {
    {"H4CNF_TARGET", 1,5,1,5},
    {"H4CNF_WEAPONS", 1,5,1,5}
}
    menu.add_feature("» 半原始预设（未估算）", "action", STANDARD_SET.id, function()
    menu.notify("预设值已设置，请记住处于极限\n\n您是否可以使用\n-高级选项（无例外）\n-修改主要和次要目标\n\n请记住，只有在每位玩家不超过$2500000的限制时，您才能收到这笔钱", "任务大师", 15, 0x64F06414)
    for i = 1, #STANDARD_PRSET do
    stat_set_int(STANDARD_PRSET[i][1], true, STANDARD_PRSET[i][2])
    end
    for i = 1, #RANDOM_TARGET do
    stat_set_int(RANDOM_TARGET[i][1], true, math.random(RANDOM_TARGET[i][4], RANDOM_TARGET[i][5]))
    end
end)
end
------- ADVANCED FEATURES CAYO

menu.add_feature("0%", "action", PERICO_HOST_CUT.id, function()
        script.set_global_i(1711169,0)
end)

menu.add_feature("100%", "action", PERICO_HOST_CUT.id, function()
        script.set_global_i(1711169,100)
end)

menu.add_feature("125%", "action", PERICO_HOST_CUT.id, function()
        script.set_global_i(1711169,125)
end)

menu.add_feature("150%", "action", PERICO_HOST_CUT.id, function()
        script.set_global_i(1711169,150)
end)

-- PLAYER 2 CUT MANAGER

menu.add_feature("0%", "action", PERICO_P2_CUT.id, function()
        script.set_global_i(1711170,0)
end)

menu.add_feature("100%", "action", PERICO_P2_CUT.id, function()
        script.set_global_i(1711170,100)
end)

menu.add_feature("125%", "action", PERICO_P2_CUT.id, function()
        script.set_global_i(1711170,125)
end)

menu.add_feature("150%", "action", PERICO_P2_CUT.id, function()
        script.set_global_i(1711170,150)
end)

-- PLAYER 3 CUT MANAGER

menu.add_feature("0%", "action", PERICO_P3_CUT.id, function()
        script.set_global_i(1711171,0)
end)

menu.add_feature("100%", "action", PERICO_P3_CUT.id, function()
        script.set_global_i(1711171,100)
end)

menu.add_feature("125%", "action", PERICO_P3_CUT.id, function()
        script.set_global_i(1711171,125)
end)

menu.add_feature("150%", "action", PERICO_P3_CUT.id, function()
        script.set_global_i(1711171,150)
end)

-- PLAYER 4 CUT MANAGER

menu.add_feature("0%", "action", PERICO_P4_CUT.id, function()
        script.set_global_i(1711172,0)
end)

menu.add_feature("100%", "action", PERICO_P4_CUT.id, function()
        script.set_global_i(1711172,100)
end)

menu.add_feature("125%", "action", PERICO_P4_CUT.id, function()
        script.set_global_i(1711172,125)
end)

menu.add_feature("150%", "action", PERICO_P4_CUT.id, function()
        script.set_global_i(1711172,150)
end)

menu.add_feature("» 给每个人分配100%分红", "action", HSCUT_CP.id, function()
        script.set_global_i(1711169,100)
        script.set_global_i(1711170,100)
        script.set_global_i(1711171,100)
        script.set_global_i(1711172,100)
end)

menu.add_feature("» 背包正常容量", "action", CAYO_BAG.id, function()
    menu.notify("Affects only you\n\nBag Restored", "任务大师", 3, 0xffef5a09)
    script.set_global_i(262145+29227,1800)
end)

menu.add_feature("» 背包双倍容量", "action", CAYO_BAG.id, function()
    menu.notify("Affects only you\n\nBag Modified to 2 Players", "任务大师", 3, 0xffef5a09)
    script.set_global_i(262145+29227,3600)
end)

menu.add_feature("» 背包三倍容量", "action", CAYO_BAG.id, function()
    menu.notify("Affects only you\n\nBag Modified to 3 Players", "任务大师", 3, 0xffef5a09)
    script.set_global_i(262145+29227,5400)
end)

menu.add_feature("» 背包4倍容量", "action", CAYO_BAG.id, function()
    menu.notify("Affects only you\n\nBag Modified to 4 Players", "任务大师", 3, 0xffef5a09)
    script.set_global_i(262145+29227,7200)
end)

    menu.add_feature("» 移除倒卖费用&帕维尔分红", "toggle", PERICO_ADV.id, function(abc)
    menu.notify("在抢劫结束前保持激活状态", "任务大师", 5, 0x64F06414)
    while abc.on do
        script.set_global_f(262145+29470,0)
        script.set_global_f(262145+29471,0)
        if not abc.on then return end
        system.wait(900)
    end
end)

-------------------------
do
local CP_VEH_KA = {
    {"H4_MISSIONS", 65283}
}
    menu.add_feature("» 潜水艇 虎鲸", "action", CAYO_VEHICLES.id, function()
        menu.notify("虎鲸已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_KA do
            stat_set_int(CP_VEH_KA[i][1], true, CP_VEH_KA[i][2])
        end
    end)
end

do
local CP_VEH_AT = {
    {"H4_MISSIONS", 65413}
}
    menu.add_feature("» 飞机 阿尔诺克斯特", "action", CAYO_VEHICLES.id, function()
    menu.notify("阿尔诺克斯特已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_AT do
            stat_set_int(CP_VEH_AT[i][1], true, CP_VEH_AT[i][2])
        end
    end)
end

do
local CP_VEH_VM = {
    {"H4_MISSIONS", 65289}
}
    menu.add_feature("» 飞机 美杜莎", "action", CAYO_VEHICLES.id, function()
    menu.notify("美杜莎已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_VM do
            stat_set_int(CP_VEH_VM[i][1], true, CP_VEH_VM[i][2])
        end
    end)
end

do
local CP_VEH_SA = {
    {"H4_MISSIONS", 65425}
}
    menu.add_feature("» 直升机 隐形歼灭者", "action", CAYO_VEHICLES.id, function()
    menu.notify("隐形歼灭者已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_SA do
            stat_set_int(CP_VEH_SA[i][1], true, CP_VEH_SA[i][2])
        end
    end)
end

do
local CP_VEH_PB = {
    {"H4_MISSIONS", 65313}
}
    menu.add_feature("» 船只 巡逻艇", "action", CAYO_VEHICLES.id, function()
    menu.notify("巡逻艇已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_PB do
            stat_set_int(CP_VEH_PB[i][1], true, CP_VEH_PB[i][2])
        end
    end)
end

do
local CP_VEH_LN = {
    {"H4_MISSIONS", 65345}
}
    menu.add_feature("» 船只 长鳍", "action", CAYO_VEHICLES.id, function()
    menu.notify("长鳍已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_LN do
            stat_set_int(CP_VEH_LN[i][1], true, CP_VEH_LN[i][2])
        end
    end)
end

do
local CP_VEH_ALL = {
    {"H4_MISSIONS", 65535}
}
    menu.add_feature("» 解锁所有接近载具", "action", CAYO_VEHICLES.id, function()
    menu.notify("所有载具已生效", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_VEH_ALL do
            stat_set_int(CP_VEH_ALL[i][1], true, CP_VEH_ALL[i][2])
        end
    end)
end


do
local Target_SapphirePanther = {
    {"H4CNF_TARGET", 5}
}
    menu.add_feature("» 蓝宝石豹", "action", CAYO_PRIMARY.id, function()
    menu.notify("主要目标修改为蓝宝石豹\n\n-$190万（普通）\n-$209万(困难)", "任务大师", 3, 0xffef5a09)
        for i = 1, #Target_SapphirePanther do
            stat_set_int(Target_SapphirePanther[i][1], true, Target_SapphirePanther[i][2])
        end
    end)
end

do
local Target_MadrazoF = {
    {"H4CNF_TARGET", 4}
}
    menu.add_feature("» 玛德拉索文件", "action", CAYO_PRIMARY.id, function()
    menu.notify("主要目标修改为玛德拉索文件\n\n- $110万(普通)\n- $121万(困难)", "任务大师", 3, 0xffef5a09)
        for i = 1, #Target_MadrazoF do
            stat_set_int(Target_MadrazoF[i][1], true, Target_MadrazoF[i][2])
        end
    end)
end

do
local Target_PinkDiamond = {
    {"H4CNF_TARGET", 3}
}
    menu.add_feature("» 粉钻", "action", CAYO_PRIMARY.id, function()
    menu.notify("主要目标修改为粉钻\n\n- $130万(普通)\n- $143万(困难)", "任务大师", 3, 0xffef5a09)
        for i = 1, #Target_PinkDiamond do
            stat_set_int(Target_PinkDiamond[i][1], true, Target_PinkDiamond[i][2])
        end
    end)
end

do
local Target_BearerBonds = {
    {"H4CNF_TARGET", 2}
}
    menu.add_feature("» 无记名债券", "action", CAYO_PRIMARY.id, function()
    menu.notify("主要目标修改为无记名债券\n\n- $110万(普通)\n- $121万(困难)", "任务大师", 3, 0xffef5a09)
        for i = 1, #Target_BearerBonds do
            stat_set_int(Target_BearerBonds[i][1], true, Target_BearerBonds[i][2])
        end
    end)
end

do
local Target_Ruby = {
    {"H4CNF_TARGET", 1}
}
    menu.add_feature("» 红宝石项链", "action", CAYO_PRIMARY.id, function()
    menu.notify("修改主要目标为红宝石项链\n\n- $100万(普通)\n- $110万(困难)", "任务大师", 3, 0xffef5a09)
    for i = 1, #Target_Ruby do
            stat_set_int(Target_Ruby[i][1], true, Target_Ruby[i][2])
        end
    end)
end

do
local Target_Tequila = {
    {"H4CNF_TARGET", 0}
}
    menu.add_feature("» 西西米托龙舌兰", "action", CAYO_PRIMARY.id, function()
    menu.notify("主要目标修改为西西米托龙舌兰\n\n- $90万(普通)\n- $99万 (困难)", "任务大师", 3, 0xffef5a09)
        for i = 1, #Target_Tequila do
        stat_set_int(Target_Tequila[i][1], true, Target_Tequila[i][2])
        end
    end)
end

do
local SecondaryT_RDM = {
    {"H4LOOT_CASH_I", 1319624},
    {"H4LOOT_CASH_C", 18},
    {"H4LOOT_CASH_V", 89400},
    {"H4LOOT_WEED_I", 2639108},
    {"H4LOOT_WEED_C", 36},
    {"H4LOOT_WEED_V", 149000},
    {"H4LOOT_COKE_I", 4229122},
    {"H4LOOT_COKE_C", 72},
    {"H4LOOT_COKE_V", 221200},
    {"H4LOOT_GOLD_I", 8589313},
    {"H4LOOT_GOLD_C", 129},
    {"H4LOOT_GOLD_V", 322600},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 186800},
    {"H4LOOT_CASH_I_SCOPED", 1319624},
    {"H4LOOT_CASH_C_SCOPED", 18},
    {"H4LOOT_WEED_I_SCOPED", 2639108},
    {"H4LOOT_WEED_C_SCOPED", 36},    
    {"H4LOOT_COKE_I_SCOPED", 4229122},
    {"H4LOOT_COKE_C_SCOPED", 72},
    {"H4LOOT_GOLD_I_SCOPED", 8589313},
    {"H4LOOT_GOLD_C_SCOPED", 129},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 混合目标", "action", CAYO_SECONDARY.id, function()
    menu.notify("次要目标为混合\n\n使用此方法时，百分比和最终付款是随机的！", "任务大师", 3, 0xffef5a09)
    for i = 1, #SecondaryT_RDM do
        stat_set_int(SecondaryT_RDM[i][1], true, SecondaryT_RDM[i][2])
    end
end)
end

do
local SecondaryT_FCash = {
    {"H4LOOT_CASH_I", -1},
    {"H4LOOT_CASH_C", -1},
    {"H4LOOT_CASH_V", 90000},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_I", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_I_SCOPED", -1},
    {"H4LOOT_CASH_C_SCOPED", -1},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},    
    {"H4LOOT_COKE_I_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 现金", "action", CAYO_SECONDARY.id, function()
        menu.notify("次要目标修改为现金\n\n百分比和最终付款是随机的", "任务大师", 3, 0xffef5a09)
    for i = 1, #SecondaryT_FCash do
        stat_set_int(SecondaryT_FCash[i][1], true, SecondaryT_FCash[i][2])
    end
end)
end

do
local SecondaryT_FWeed = {
    {"H4LOOT_CASH_I", 0},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_I", -1},
    {"H4LOOT_WEED_C", -1},
    {"H4LOOT_WEED_V", 140000},
    {"H4LOOT_COKE_I", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_I_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", -1},
    {"H4LOOT_WEED_C_SCOPED", -1},    
    {"H4LOOT_COKE_I_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 大麻", "action", CAYO_SECONDARY.id, function()
    menu.notify("次要目标修改为大麻\n\n百分比和最终付款是随机的", "任务大师", 3, 0xffef5a09)
    for i = 1, #SecondaryT_FWeed do
        stat_set_int(SecondaryT_FWeed[i][1], true, SecondaryT_FWeed[i][2])
    end
end)
end

do
local SecondaryT_FCoke = {
    {"H4LOOT_CASH_I", 0},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_I", -1},
    {"H4LOOT_COKE_C", -1},
    {"H4LOOT_COKE_V", 210000},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_I_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},    
    {"H4LOOT_COKE_I_SCOPED", -1},
    {"H4LOOT_COKE_C_SCOPED", -1},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 可卡因", "action", CAYO_SECONDARY.id, function()
        menu.notify("次要目标修改为可卡因\n\n百分比和最终付款是随机的", "任务大师", 3, 0xffef5a09)
    for i = 1, #SecondaryT_FCoke do
        stat_set_int(SecondaryT_FCoke[i][1], true, SecondaryT_FCoke[i][2])
    end
end)
end

do
local SecondaryT_FGold = {
    {"H4LOOT_CASH_I", 0},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_I", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_I", -1},
    {"H4LOOT_GOLD_C", -1},
    {"H4LOOT_GOLD_V", 320000},
    {"H4LOOT_PAINT", -1},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_I_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},    
    {"H4LOOT_COKE_I_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I_SCOPED", -1},
    {"H4LOOT_GOLD_C_SCOPED", -1},
    {"H4LOOT_PAINT_SCOPED", -1}
}
    menu.add_feature("» 黄金", "action", CAYO_SECONDARY.id, function()
    menu.notify("次要目标修改为黄金\n\n百分比和最终付款是随机的", "任务大师", 3, 0xffef5a09)
    for i = 1, #SecondaryT_FGold do
        stat_set_int(SecondaryT_FGold[i][1], true, SecondaryT_FGold[i][2])
    end
end)
end

do
local SecondaryT_Remove = {
    {"H4LOOT_CASH_I", 0},
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_I", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_I", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_I", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT", 0},
    {"H4LOOT_PAINT_V", 0},
    {"H4LOOT_CASH_I_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_I_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_I_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_I_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 0}
}
    menu.add_feature("» 移除次要目标", "action", CAYO_SECONDARY.id, function()
        menu.notify("所有次要目标已被移除", "任务大师", 3, 0xffef5a09)
        for i = 1, #SecondaryT_Remove do
        stat_set_int(SecondaryT_Remove[i][1], true, SecondaryT_Remove[i][2])
    end
    end)
end

local CAYO_COMPOUND = menu.add_feature("» 庄园战利品", "parent", CAYO_SECONDARY.id)

do
local Compound_LT_MIX = {
    {"H4LOOT_CASH_C", 2},
    {"H4LOOT_CASH_V", 474431},
    {"H4LOOT_WEED_C", 17},
    {"H4LOOT_WEED_V", 759090},
    {"H4LOOT_COKE_C", 132},
    {"H4LOOT_COKE_V", 948863},
    {"H4LOOT_GOLD_C", 104},
    {"H4LOOT_GOLD_V", 1265151},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 948863},
    {"H4LOOT_CASH_C_SCOPED", 2},
    {"H4LOOT_WEED_C_SCOPED", 17},
    {"H4LOOT_COKE_C_SCOPED", 132},
    {"H4LOOT_GOLD_C_SCOPED", 104},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 混合战利品", "action", CAYO_COMPOUND.id, function()
    menu.notify("已修改为混合战利品", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_MIX do
        stat_set_int(Compound_LT_MIX[i][1], true, Compound_LT_MIX[i][2])
        end
    end)
end

do
local Compound_LT_CASH = {
    {"H4LOOT_CASH_C", -1},
    {"H4LOOT_CASH_V", 90000},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_C_SCOPED", -1},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 现金", "action", CAYO_COMPOUND.id, function()
    menu.notify("战利品已修改为 现金", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_CASH do
        stat_set_int(Compound_LT_CASH[i][1], true, Compound_LT_CASH[i][2])
        end
    end)
end

do
local Compound_LT_WEED = {
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_C", -1},
    {"H4LOOT_WEED_V", 140000},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", -1},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 大麻", "action", CAYO_COMPOUND.id, function()
    menu.notify("战利品已修改为 大麻", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_WEED do
        stat_set_int(Compound_LT_WEED[i][1], true, Compound_LT_WEED[i][2])
        end
    end)
end

do
local Compound_LT_COKE = {
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_C", -1},
    {"H4LOOT_COKE_V", 210000},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", -1},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 可卡因", "action", CAYO_COMPOUND.id, function()
    menu.notify("战利品已修改为可卡因", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_COKE do
        stat_set_int(Compound_LT_COKE[i][1], true, Compound_LT_COKE[i][2])
        end
    end)
end

do
local Compound_LT_GOLD = {
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_C", -1},
    {"H4LOOT_GOLD_V", 320000},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_GOLD_C_SCOPED", -1},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 黄金", "action", CAYO_COMPOUND.id, function()
        menu.notify("战利品已修改为黄金", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_GOLD do
        stat_set_int(Compound_LT_GOLD[i][1], true, Compound_LT_GOLD[i][2])
    end
    end)
end

do
local Compound_LT_PAINT = {
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_CASH_V", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_WEED_V", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_COKE_V", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_V", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_PAINT", 127},
    {"H4LOOT_PAINT_V", 190000},
    {"H4LOOT_PAINT_SCOPED", 127}
}
    menu.add_feature("» 画作", "action", CAYO_COMPOUND.id, function()
        menu.notify("战利品已修改为画作", "任务大师", 3, 0xffef5a09)
        for i = 1, #Compound_LT_PAINT do
        stat_set_int(Compound_LT_PAINT[i][1], true, Compound_LT_PAINT[i][2])
    end
    end)
end

do
local Remove_Compound_Paint = {
    {"H4LOOT_PAINT", 0},
    {"H4LOOT_PAINT_V", 0},
    {"H4LOOT_PAINT_SCOPED", 0}
}
    menu.add_feature("» 移除画作", "action", CAYO_COMPOUND.id, function()
    menu.notify("所有画作已移除", "任务大师", 3, 0xffef5a09)
    for i = 1, #Remove_Compound_Paint do
    stat_set_int(Remove_Compound_Paint[i][1], true, Remove_Compound_Paint[i][2])
    end
    end)
end

do
local Remove_ALL_Compound_LT = {
    {"H4LOOT_CASH_C", 0},
    {"H4LOOT_WEED_C", 0},
    {"H4LOOT_COKE_C", 0},
    {"H4LOOT_GOLD_C", 0},
    {"H4LOOT_GOLD_C_SCOPED", 0},
    {"H4LOOT_CASH_C_SCOPED", 0},
    {"H4LOOT_WEED_C_SCOPED", 0},
    {"H4LOOT_COKE_C_SCOPED", 0},
    {"H4LOOT_PAINT", 0},
    {"H4LOOT_PAINT_SCOPED", 0}
}
    menu.add_feature("» 移除所有战利品", "action", CAYO_COMPOUND.id, function()
        menu.notify("所有战利品已移除", "任务大师", 3, 0xffef5a09)
        for i = 1, #Remove_ALL_Compound_LT do
        stat_set_int(Remove_ALL_Compound_LT[i][1], true, Remove_ALL_Compound_LT[i][2])
    end
    end)
end

do
local Weapon_Aggressor = {
    {"H4CNF_WEAPONS", 1}
}
    menu.add_feature("» 突击霰弹枪,冲锋手枪,手榴弹,砍刀", "action", CAYO_WEAPONS.id, function()
    menu.notify("侵略者\n\n突击霰弹枪 + 冲锋手枪\n手榴弹 + 砍刀", "任务大师", 3, 0xffef5a09)
    for i = 1, #Weapon_Aggressor do
        stat_set_int(Weapon_Aggressor[i][1], true, Weapon_Aggressor[i][2])
        end
    end)
end

do
local Weapon_Conspirator = {
    {"H4CNF_WEAPONS", 2}
}
    menu.add_feature("» 军用步枪,穿甲手枪,粘弹,指虎", "action", CAYO_WEAPONS.id, function()
    menu.notify("阴谋者\n\n军用步枪 + 穿甲手枪\n粘弹 + 指虎", "任务大师", 3, 0xffef5a09)
    for i = 1, #Weapon_Conspirator do
        stat_set_int(Weapon_Conspirator[i][1], true, Weapon_Conspirator[i][2])
        end
    end)
end

do
local Weapon_Crackshot = {
    {"H4CNF_WEAPONS", 3}
}
    menu.add_feature("» 狙击步枪,穿甲手枪,汽油弹,小刀", "action", CAYO_WEAPONS.id, function()
    menu.notify("神枪手\n\n狙击步枪 + 穿甲手枪\n小刀 + 汽油弹", "任务大师", 3, 0xffef5a09)
    for i = 1, #Weapon_Crackshot do
        stat_set_int(Weapon_Crackshot[i][1], true, Weapon_Crackshot[i][2])
        end
    end)
end

do
local Weapon_Saboteur = {
    {"H4CNF_WEAPONS", 4}
}
    menu.add_feature("» MK2冲锋枪,MK2劣质手枪,土制炸弹,小刀", "action", CAYO_WEAPONS.id, function()
    menu.notify("破坏者\n\nMK2冲锋枪 + MK2劣质手枪\n小刀 + 土质炸弹", "任务大师", 3, 0xffef5a09)
    for i = 1, #Weapon_Saboteur do
        stat_set_int(Weapon_Saboteur[i][1], true, Weapon_Saboteur[i][2])
        end
    end)
end

do
local Weapon_Marksman = {
    {"H4CNF_WEAPONS", 5}
}
    menu.add_feature("» MK2突击步枪,0.5口径手枪,土制炸弹,小刀", "action", CAYO_WEAPONS.id, function()
    menu.notify("神射手\n\n- AK-47 + 0.5口径手枪\n- 土制炸弹 + 小刀", "任务大师", 3, 0xffef5a09)
    for i = 1, #Weapon_Marksman do
        stat_set_int(Weapon_Marksman[i][1], true, Weapon_Marksman[i][2])
        end
    end)
end

do
local CP_Item_SpawnPlace_AIR = {
    {"H4CNF_GRAPPEL", 2022},
    {"H4CNF_UNIFORM", 12},
    {"H4CNF_BOLTCUT", 4161},
    {"H4CNF_TROJAN", 1}
}
    menu.add_feature("» 生成在机场", "action", CAYO_EQUIPM.id, function()
    menu.notify("装备将生成在机场:\n\n- 抓钩\n- 保安服\n- 剪钳", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_Item_SpawnPlace_AIR do
        stat_set_int(CP_Item_SpawnPlace_AIR[i][1], true, CP_Item_SpawnPlace_AIR[i][2])
        end
    end)
end

do
local CP_Item_SpawnPlace_DKS = {
    {"H4CNF_GRAPPEL", 3671},
    {"H4CNF_UNIFORM", 5256},
    {"H4CNF_BOLTCUT", 4424},
    {"H4CNF_TROJAN", 2}
}
    menu.add_feature("» 生成在码头", "action", CAYO_EQUIPM.id, function()
    menu.notify("装备将生成在码头:\n\n- 抓钩\n- 保安服\n- 剪钳", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_Item_SpawnPlace_DKS do
        stat_set_int(CP_Item_SpawnPlace_DKS[i][1], true, CP_Item_SpawnPlace_DKS[i][2])
        end
    end)
end

do
local CP_Item_SpawnPlace_CP = {
    {"H4CNF_GRAPPEL", 85324},
    {"H4CNF_UNIFORM", 61034},
    {"H4CNF_BOLTCUT", 4612},
    {"H4CNF_TROJAN", 5}
}
    menu.add_feature("» 生成在庄园", "action", CAYO_EQUIPM.id, function()
    menu.notify("装备将生成在庄园:\n\n- 抓钩\n- 保安服\n- 剪钳", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_Item_SpawnPlace_CP do
    stat_set_int(CP_Item_SpawnPlace_CP[i][1], true, CP_Item_SpawnPlace_CP[i][2])
    end
end)
end

do
local CP_TRUCK_SPAWN_mov1 = {
    {"H4CNF_TROJAN", 1}
}
    menu.add_feature("» 机场", "action", CAYO_TRUCK.id, function()
    menu.notify("补给车辆将生成在机场", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_TRUCK_SPAWN_mov1 do
    stat_set_int(CP_TRUCK_SPAWN_mov1[i][1], true, CP_TRUCK_SPAWN_mov1[i][2])
    end
    end)
end

do
local CP_TRUCK_SPAWN_mov2 = {
    {"H4CNF_TROJAN", 2}
}
    menu.add_feature("» 北码头", "action", CAYO_TRUCK.id, function()
    menu.notify("补给车辆将生成在北码头", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_TRUCK_SPAWN_mov2 do
    stat_set_int(CP_TRUCK_SPAWN_mov2[i][1], true, CP_TRUCK_SPAWN_mov2[i][2])
    end
    end)
end

do
local CP_TRUCK_SPAWN_mov3 = {
    {"H4CNF_TROJAN", 3}
}
    menu.add_feature("» 主码头(东)", "action", CAYO_TRUCK.id, function()
    menu.notify("补给车辆将生成在主码头 - 东", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_TRUCK_SPAWN_mov3 do
    stat_set_int(CP_TRUCK_SPAWN_mov3[i][1], true, CP_TRUCK_SPAWN_mov3[i][2])
    end
    end)
end

do
local CP_TRUCK_SPAWN_mov4 = {
    {"H4CNF_TROJAN", 4}
}
    menu.add_feature("» 主码头(西)", "action", CAYO_TRUCK.id, function()
    menu.notify("补给车辆将生成在主码头 - 西", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_TRUCK_SPAWN_mov4 do
    stat_set_int(CP_TRUCK_SPAWN_mov4[i][1], true, CP_TRUCK_SPAWN_mov4[i][2])
    end
    end)
end

do
local CP_TRUCK_SPAWN_mov5 = {
    {"H4CNF_TROJAN", 5}
}
    menu.add_feature("» 庄园", "action", CAYO_TRUCK.id, function()
    menu.notify("补给车辆将生成在庄园", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_TRUCK_SPAWN_mov5 do
    stat_set_int(CP_TRUCK_SPAWN_mov5[i][1], true, CP_TRUCK_SPAWN_mov5[i][2])
    end
    end)
end

do
local CAYO_NORMAL = {
    {"H4_PROGRESS", 126823}
}
    menu.add_feature("» 设置为普通难度", "action", CAYO_DFFCTY.id, function()
    menu.notify("难度已修改为普通", "Difficulty Editor", 3, 0xffef5a09)
        for i = 1, #CAYO_NORMAL do
            stat_set_int(CAYO_NORMAL[i][1], true, CAYO_NORMAL[i][2])
        end
    end)
end

do
local CAYO_Hard = {
    {"H4_PROGRESS", 131055}
}
    menu.add_feature("» 设置为困难难度", "action", CAYO_DFFCTY.id, function()
    menu.notify("难度已修改为困难", "Difficulty Editor", 3, 0xffef5a09)
        for i = 1, #CAYO_Hard do
            stat_set_int(CAYO_Hard[i][1], true, CAYO_Hard[i][2])
        end
    end)
end



do
menu.add_feature("» 解锁佩里科岛奖杯", "action", MORE_OPTIONS.id, function()

local CP_AWRD_BL = {
    {"AWD_INTELGATHER", true},
    {"AWD_COMPOUNDINFILT", true},
    {"AWD_LOOT_FINDER", true},
    {"AWD_MAX_DISRUPT", true},
    {"AWD_THE_ISLAND_HEIST", true},
    {"AWD_GOING_ALONE", true},
    {"AWD_TEAM_WORK", true},
    {"AWD_MIXING_UP", true},
    {"AWD_PRO_THIEF", true},
    {"AWD_CAT_BURGLAR", true},
    {"AWD_ONE_OF_THEM", true},
    {"AWD_GOLDEN_GUN", true},
    {"AWD_ELITE_THIEF", true},
    {"AWD_PROFESSIONAL", true},
    {"AWD_HELPING_OUT", true},
    {"AWD_COURIER", true},
    {"AWD_PARTY_VIBES", true},
    {"AWD_HELPING_HAND", true},
    {"AWD_ELEVENELEVEN", true},
    {"COMPLETE_H4_F_USING_VETIR", true},
    {"COMPLETE_H4_F_USING_LONGFIN", true},
    {"COMPLETE_H4_F_USING_ANNIH", true},
    {"COMPLETE_H4_F_USING_ALKONOS", true},
    {"COMPLETE_H4_F_USING_PATROLB", true}
}
local CP_AWRD_IT = {
    {"AWD_LOSTANDFOUND", 500000},
    {"AWD_SUNSET", 1800000},
    {"AWD_TREASURE_HUNTER", 1000000},
    {"AWD_WRECK_DIVING", 1000000},
    {"AWD_KEINEMUSIK", 1800000},
    {"AWD_PALMS_TRAX", 1800000},
    {"AWD_MOODYMANN", 1800000},
    {"AWD_FILL_YOUR_BAGS", 1000000000},
    {"AWD_WELL_PREPARED", 80},
    {"H4_H4_DJ_MISSIONS", 65535}
}
    menu.notify("佩里科岛奖杯已解锁！", "任务大师", 3, 0xffef5a09)
    for i = 1, #CP_AWRD_IT do
    stat_set_int(CP_AWRD_IT[i][1], true, CP_AWRD_IT[i][2])
    for i = 1, #CP_AWRD_BL do
    stat_set_bool(CP_AWRD_BL[i][1], true, CP_AWRD_BL[i][2])
    end
end
end)
end

do

local COMPLETE_CP_MISSIONS = {
    {"H4_MISSIONS", 65535},
    {"H4CNF_APPROACH", -1},
    {"H4CNF_BS_ENTR", 63},
    {"H4CNF_BS_GEN", 63},
    {"H4CNF_WEP_DISRP", 3},
    {"H4CNF_ARM_DISRP", 3},
    {"H4CNF_HEL_DISRP", 3}
}
    menu.add_feature("» 完成所有前置", "action", MORE_OPTIONS.id, function()
    menu.notify("所有前置已完成！", "任务大师", 3, 0xffef5a09)
        for i = 1, #COMPLETE_CP_MISSIONS do
        stat_set_int(COMPLETE_CP_MISSIONS[i][1], true, COMPLETE_CP_MISSIONS[i][2])
        end
        end)
end

do
local WATCH_LONG_CUT = {
    {"H4_PLAYTHROUGH_STATUS", 0}
}
    menu.add_feature("» 强制执行最长的最终过场动画", "action", MORE_OPTIONS.id, function()
    menu.notify("请记住，在开始抢劫之前必须使用此选项！\n\n", "任务大师", 3, 0xffef5a09)
        for i = 1, #WATCH_LONG_CUT do
        stat_set_int(WATCH_LONG_CUT[i][1], true, WATCH_LONG_CUT[i][2])
    end
    end)
end

do
local CP_RST = {
    {"H4_MISSIONS", 0},
    {"H4_PROGRESS", 0},
    {"H4CNF_APPROACH", 0},
    {"H4CNF_BS_ENTR", 0},
    {"H4CNF_BS_GEN", 0},
    {"H4_PLAYTHROUGH_STATUS", 0}
}
    menu.add_feature("» 重置抢劫任务", "action", MORE_OPTIONS.id, function()
    menu.notify("抢劫任务已重置", "任务大师", 3, 0xffef5a09)
        for i = 1, #CP_RST do
        stat_set_int(CP_RST[i][1], true, CP_RST[i][2])
    end
    end)
end

do
local CLD_RMV = {
    {"H4_COOLDOWN", -1},
    {"H4_COOLDOWN_HARD", -1},
    {"MPPLY_H4_COOLDOWN", -1}
}
    menu.add_feature("» 移除抢劫冷却", "action", MORE_OPTIONS.id, function()
    menu.notify("警告：这不针对服务器端的冷却去除\n\n请等待15分钟，以避免无法收到分红", "任务大师", 5, 0x641400E6)
        for i = 1, #CLD_RMV do
        stat_set_int(CLD_RMV[i][1], true, CLD_RMV[i][2])
        stat_set_int(CLD_RMV[i][1], false, CLD_RMV[i][2])
    end
    end)
end
---------------------- CASINO HEIST
do
local CH_RANDOM_PRST = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_BITSET0", -1}
}
local CH_RANDOM_METHOD = {
    {"H3OPT_TARGET", 0,3,0,3},
    {"H3_HARD_APPROACH", 1,3,1,3},
    {"H3OPT_CREWWEAP", 1,5,1,5},
    {"H3OPT_CREWDRIVER", 1,5,1,5},
    {"H3OPT_CREWHACKER", 1,5,1,5},
    {"H3OPT_WEAPS", 0,1,0,1},
    {"H3OPT_VEHS", 0,3,0,3},
    {"H3OPT_MASKS", 1,12,1,12},
    {"H3OPT_APPROACH", 1,3,1,3}
}
    menu.add_feature("» 加载随机预设", "action", CASINO_PRESETS.id, function()
    menu.notify("在使用此选项之前，请确保您已在计划屏幕上支付了启动费用\n\n随机预设已加载！", "任务大师", 3, 0x6414F0FF)
        for i = 1, #CH_RANDOM_PRST do
        stat_set_int(CH_RANDOM_PRST[i][1], true, CH_RANDOM_PRST[i][2])
        for i = 2, #CH_RANDOM_METHOD do
        stat_set_int(CH_RANDOM_METHOD[i][1], true, math.random(CH_RANDOM_METHOD[i][4], CH_RANDOM_METHOD[i][5]))
    end
end
end)
end

do
local CAH_SILENT_SNEAKY_HARD = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 1},
    {"H3_HARD_APPROACH", 1},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 0},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 隐迹潜踪(困难)", "action", CASINO_PRESETS.id, function()
    menu.notify("隐迹潜踪困难模式\n\n目标: 钻石\n载具: 埃弗隆\n车手: 切斯特·麦考伊\n\n武器: 步枪 + 霰弹枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
        for i = 1, #CAH_SILENT_SNEAKY_HARD do
        stat_set_int(CAH_SILENT_SNEAKY_HARD[i][1], true, CAH_SILENT_SNEAKY_HARD[i][2])
        end
    end)
end

do
local CAH_SILENT_SNEAKY = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 1},
    {"H3_HARD_APPROACH", 0},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 0},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 隐迹潜踪 [普通]", "action", CASINO_PRESETS.id, function()
    menu.notify("隐迹潜踪普通难度\n\n目标: 钻石\n载具: 埃弗隆\nD车手: 切斯特·麦考伊\n\n武器: 步枪 + 霰弹枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
    for i = 1, #CAH_SILENT_SNEAKY do
        stat_set_int(CAH_SILENT_SNEAKY[i][1], true, CAH_SILENT_SNEAKY[i][2])
    end
end)
end

do
local CAH_BIG_CON_HARD = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 2},
    {"H3_HARD_APPROACH", 2},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 0},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 兵不厌诈[困难]", "action", CASINO_PRESETS.id, function()
    menu.notify("兵不厌诈困难模式\n\n目标: 钻石\n载具: 埃弗隆\n车手: 切斯特·麦考伊\n\n武器: 步枪 + 手枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
    for i = 1, #CAH_BIG_CON_HARD do
        stat_set_int(CAH_BIG_CON_HARD[i][1], true, CAH_BIG_CON_HARD[i][2])
    end
end)
end

do
local CAH_BIG_CON = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 2},
    {"H3_HARD_APPROACH", 0},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 0},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 兵不厌诈[普通]", "action", CASINO_PRESETS.id, function()
    menu.notify("兵不厌诈普通模式n\n目标: 钻石\n载具: 埃弗隆\n车手: 切斯特·麦考伊\n\n武器: 步枪 + 手枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
        for i = 1, #CAH_BIG_CON do
            stat_set_int(CAH_BIG_CON[i][1], true, CAH_BIG_CON[i][2])
        end
    end)
end

do
local CAH_AGGRESSIVE_HARD = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 3},
    {"H3_HARD_APPROACH", 3},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 1},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 气势汹汹[困难]", "action", CASINO_PRESETS.id, function()
    menu.notify("气势汹汹困难模式\n\n目标: 钻石\n载具: 埃弗隆\n车手: 切斯特·麦考伊\n\n武器: 冲锋枪 + 霰弹枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
        for i = 1, #CAH_AGGRESSIVE_HARD do
            stat_set_int(CAH_AGGRESSIVE_HARD[i][1], true, CAH_AGGRESSIVE_HARD[i][2])
        end
    end)
end

do
local CH_UNLCK_PT = {
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047}
}
    menu.add_feature("» 解锁所有兴趣点和出入口", "action", CASINO_BOARD1.id, function()
    menu.notify("解锁成功", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_UNLCK_PT do
        stat_set_int(CH_UNLCK_PT[i][1], true, CH_UNLCK_PT[i][2])
        end
    end)
end

do
local CAH_AGGRESSIVE = {
    {"H3_LAST_APPROACH", 4},
    {"H3OPT_APPROACH", 3},
    {"H3_HARD_APPROACH", 0},
    {"H3OPT_TARGET", 3},
    {"H3OPT_POI", 1023},
    {"H3OPT_ACCESSPOINTS", 2047},
    {"H3OPT_BITSET1", -1},
    {"H3OPT_CREWWEAP", 2},
    {"H3OPT_CREWDRIVER", 5},
    {"H3OPT_CREWHACKER", 4},
    {"H3OPT_WEAPS", 1},
    {"H3OPT_VEHS", 3},
    {"H3OPT_DISRUPTSHIP", 3},
    {"H3OPT_BODYARMORLVL", 3},
    {"H3OPT_KEYLEVELS", 2},
    {"H3OPT_MASKS", 2},
    {"H3OPT_BITSET0", -1}
}
    menu.add_feature("» 气势汹汹[普通]", "action", CASINO_PRESETS.id, function()
    menu.notify("气势汹汹普通难度\n\n目标: 钻石\n载具: 埃弗隆\n车手: 切斯特·麦考伊\n\n武器: 冲锋枪 + 霰弹枪\n枪手: 古斯塔沃·莫塔\n\n黑客: 阿维·施瓦茨曼\n未暴露: 3分30秒\n暴露: 2分26秒\n\n面具: 猎人系列", "任务大师", 6, 0x64F0AA14)
        for i = 1, #CAH_AGGRESSIVE do
            stat_set_int(CAH_AGGRESSIVE[i][1], true, CAH_AGGRESSIVE[i][2])
        end
    end)
end

do
local CH_Target_Diamond = {
    {"H3OPT_TARGET", 3}
}
    menu.add_feature("» 钻石", "action", CASINO_TARGET.id, function()
    menu.notify("目标修改为钻石", "Target Editor", 3, 0x64F0AA14)
        for i = 1, #CH_Target_Diamond do
            stat_set_int(CH_Target_Diamond[i][1], true, CH_Target_Diamond[i][2])
        end
    end)
end

do
local CH_Target_Gold = {
    {"H3OPT_TARGET", 1}
}
    menu.add_feature("» 黄金", "action", CASINO_TARGET.id, function()
    menu.notify("目标修改为 黄金", "Target Editor", 3, 0x64F0AA14)
        for i = 1, #CH_Target_Gold do
            stat_set_int(CH_Target_Gold[i][1], true, CH_Target_Gold[i][2])
        end
    end)
end

do
local CH_Target_Artwork = {
    {"H3OPT_TARGET", 2}
}
    menu.add_feature("» 画作", "action", CASINO_TARGET.id, function()
    menu.notify("目标修改为画作", "Target Editor", 3, 0x64F0AA14)
        for i = 1, #CH_Target_Artwork do
            stat_set_int(CH_Target_Artwork[i][1], true, CH_Target_Artwork[i][2])
        end
    end)
end

do
local CH_Target_Cash = {
    {"H3OPT_TARGET", 0}
}
    menu.add_feature("» 现金", "action", CASINO_TARGET.id, function()
    menu.notify("目标修改为现金", "Target Editor", 3, 0x64F0AA14)
        for i = 1, #CH_Target_Cash do
            stat_set_int(CH_Target_Cash[i][1], true, CH_Target_Cash[i][2])
        end
    end)
end
---- CASINO ADVANCED
do
    local SET_Diamond = {
        {"H3OPT_TARGET", 3}
    }
    local SET_NORMAL = {
    {"H3_LAST_APPROACH", 0},
    {"H3_HARD_APPROACH", 0}
}
    menu.add_feature("» 将预设修改为最大收入[$340万/人]", "toggle", CAH_ADVCED.id, function(hj)
    menu.notify("- 在执行此功能之前，请确保已选择预设\n\n-不要尝试修改难度\n\n-不要尝试修改目标\n\n- 在开始抢劫之前，在给玩家分红时使用此选项", "", 11, 0x64F0AA14)
    menu.notify("说明\n\n-始终选择最便宜的买家\n\n-在通过隧道逃跑之前，请使用“删除NPC分红”选项", "", 11, 0x64F0AA14)
    while hj.on do
    script.set_global_i(1703513 + 2326, 41)
    script.set_global_i(1703513 + 2326 + 1, 97)
    script.set_global_i(1703513 + 2326 + 2, 97)
    script.set_global_i(1703513 + 2326 + 3, 97)
    script.set_global_i(262145 + 28306, 1410065408)
    for i = 1, #SET_Diamond do
    stat_set_int(SET_Diamond[i][1], true, SET_Diamond[i][2])
    end
    for i = 1, #SET_NORMAL do
    stat_set_int(SET_NORMAL[i][1], true, SET_NORMAL[i][2])
    end
    if not hj.on then return end
    system.wait(0)
    end
end)
end

    menu.add_feature("» 增加潜在收益", "toggle", CAH_ADVCED.id, function(gains)
    menu.notify("在开始抢劫之前，必须启用此选项(在商场/车库外）\n\n如果使用此选项更改预设收入，则无需激活此选项", "", 5, 0x6414F0FF)
    while gains.on do
    script.set_global_i(262145 + 28303, 1410065408) --Cash
    script.set_global_i(262145 + 28304, 1410065408) --Art
    script.set_global_i(262145 + 28305, 1410065408) --Gold
    script.set_global_i(262145 + 28306, 1410065408) --Diamond
    if not gains.on then return end
    system.wait(0)
    end
end)

local CAH_PLAYER_CUT = menu.add_feature("» 玩家分红", "parent", CAH_ADVCED.id, function()
    menu.notify("重要信息\n\n-添加高百分比可能会对您的收入产生负面影响", "", 5, 0x6414F0FF)
end)

do
local CAH_PLAYER_HOST = menu.add_feature("» 你的分红", "parent", CAH_PLAYER_CUT.id)
menu.add_feature("0 %", "action", CAH_PLAYER_HOST.id, function()
    script.set_global_i(1703513 + 2326, 0)
end)

menu.add_feature("35 %", "action", CAH_PLAYER_HOST.id, function()
    script.set_global_i(1703513 + 2326, 35)
end)

menu.add_feature("100 %", "action", CAH_PLAYER_HOST.id, function()
    script.set_global_i(1703513 + 2326, 100)
end)

menu.add_feature("125 %", "action", CAH_PLAYER_HOST.id, function()
    script.set_global_i(1703513 + 2326, 125)
end)

menu.add_feature("150 %", "action", CAH_PLAYER_HOST.id, function()
    script.set_global_i(1703513 + 2326, 150)
end)

local CAH_PLAYER_TWO = menu.add_feature("» 玩家2", "parent", CAH_PLAYER_CUT.id)
menu.add_feature("0 %", "action", CAH_PLAYER_TWO.id, function()
    script.set_global_i(1703513 + 2326 +1, 0)
end)

menu.add_feature("85 %", "action", CAH_PLAYER_TWO.id, function()
    script.set_global_i(1703513 + 2326 +1, 85)
end)

menu.add_feature("100 %", "action", CAH_PLAYER_TWO.id, function()
    script.set_global_i(1703513 + 2326 +1, 100)
end)

menu.add_feature("125 %", "action", CAH_PLAYER_TWO.id, function()
    script.set_global_i(1703513 + 2326 +1, 125)
end)

menu.add_feature("150 %", "action", CAH_PLAYER_TWO.id, function()
    script.set_global_i(1703513 + 2326 +1, 150)
end)

local CAH_PLAYER_THREE = menu.add_feature("» 玩家3", "parent", CAH_PLAYER_CUT.id)
menu.add_feature("0 %", "action", CAH_PLAYER_THREE.id, function()
    script.set_global_i(1703513 + 2326 +2, 0)
end)

menu.add_feature("85 %", "action", CAH_PLAYER_THREE.id, function()
    script.set_global_i(1703513 + 2326 +2, 85)
end)

menu.add_feature("100 %", "action", CAH_PLAYER_THREE.id, function()
    script.set_global_i(1703513 + 2326 +2, 100)
end)

menu.add_feature("125 %", "action", CAH_PLAYER_THREE.id, function()
    script.set_global_i(1703513 + 2326 +2, 125)
end)

menu.add_feature("150 %", "action", CAH_PLAYER_THREE.id, function(g)
    script.set_global_i(1703513 + 2326 +2, 150)
end)

local CAH_PLAYER_FOUR = menu.add_feature("» 玩家4", "parent", CAH_PLAYER_CUT.id)
menu.add_feature("0 %", "action", CAH_PLAYER_FOUR.id, function()
    script.set_global_i(1703513 + 2326 +3, 0)
end)

menu.add_feature("85 %", "action", CAH_PLAYER_FOUR.id, function()
    script.set_global_i(1703513 + 2326 +3, 85)
end)

menu.add_feature("100 %", "action", CAH_PLAYER_FOUR.id, function()
    script.set_global_i(1703513 + 2326 +3, 100)
end)

menu.add_feature("125 %", "action", CAH_PLAYER_FOUR.id, function()
    script.set_global_i(1703513 + 2326 +3, 125)
end)

menu.add_feature("150 %", "action", CAH_PLAYER_FOUR.id, function()
    script.set_global_i(1703513 + 2326 +3, 150)
end)

menu.add_feature("» 给每个人分配100%分红", "action", CAH_PLAYER_CUT.id, function()
    script.set_global_i(1703513 + 2326, 100)
    script.set_global_i(1703513 + 2326 +1, 100)
    script.set_global_i(1703513 + 2326 +2, 100)
    script.set_global_i(1703513 + 2326 +3, 100)
end)
end

do
local CH_REM_CREW = {
    {"H3OPT_CREWWEAP", 6},
    {"H3OPT_CREWDRIVER", 6},
    {"H3OPT_CREWHACKER", 6}
}
menu.add_feature("» 去除NPC分红", "action", CAH_ADVCED.id, function()
    menu.notify("在 刚出 金库门 时使用\n\n删除成功", "任务大师", 4, 0x64FF7800)
    for i = 1, #CH_REM_CREW do
    stat_set_int(CH_REM_CREW[i][1], true, CH_REM_CREW[i][2])
    end
end)
end

--- CASINO DIFFICULTY
do
local CH_Diff_Hard1 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 1},
    {"H3_HARD_APPROACH", 1}
}
    menu.add_feature("» 隐迹潜踪 (困难)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为隐迹潜踪(困难)", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_Diff_Hard1 do
        stat_set_int(CH_Diff_Hard1[i][1], true, CH_Diff_Hard1[i][2])
    end
end)
end

do
local CH_Diff_Normal1 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 1},
    {"H3_HARD_APPROACH", 0}
}
    menu.add_feature("» 隐迹潜踪(普通)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为隐迹潜踪(普通)", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_Diff_Normal1 do
        stat_set_int(CH_Diff_Normal1[i][1], true, CH_Diff_Normal1[i][2])
        end
    end)
end


do
local CH_Diff_Hard2 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 2},
    {"H3_HARD_APPROACH", 2}
}
    menu.add_feature("» 兵不厌诈(困难)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为兵不厌诈(困难)", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_Diff_Hard2 do
        stat_set_int(CH_Diff_Hard2[i][1], true, CH_Diff_Hard2[i][2])
        end
    end)
end

do
local CH_Diff_Normal2 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 2},
    {"H3_HARD_APPROACH", 0}
}
    menu.add_feature("» 兵不厌诈(普通)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为兵不厌诈(普通)", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_Diff_Normal2 do
        stat_set_int(CH_Diff_Normal2[i][1], true, CH_Diff_Normal2[i][2])
    end
end)
end

do
local CH_Diff_Hard3 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 3},
    {"H3_HARD_APPROACH", 0}
}
    menu.add_feature("» 气势汹汹(困难)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为气势汹汹(困难)", "任务大师", 3, 0x64FF7800)
            for i = 1, #CH_Diff_Hard3 do
            stat_set_int(CH_Diff_Hard3[i][1], true, CH_Diff_Hard3[i][2])
        end
    end)
end

do
local CH_Diff_Normal3 = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 3},
    {"H3_HARD_APPROACH", 0}
}
    menu.add_feature("» 气势汹汹(普通)", "action", BOARD1_APPROACH.id, function()
    menu.notify("抢劫方式已修改为气势汹汹(普通)", "任务大师", 3, 0x64FF7800)
        for i = 1, #CH_Diff_Normal3 do
        stat_set_int(CH_Diff_Normal3[i][1], true, CH_Diff_Normal3[i][2])
        end
    end)
end

local CASINO_GUNMAN = menu.add_feature("» 更换枪手", "parent", CASINO_BOARD2.id)
do
local CH_GUNMAN_05 = {
    {"H3OPT_CREWWEAP", 4}
}
    menu.add_feature("» 切斯特·麦考伊 (10%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("切斯特·麦考伊现在是你的枪手\nCut 10%", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_05 do
        stat_set_int(CH_GUNMAN_05[i][1], true, CH_GUNMAN_05[i][2])
        end
    end)
end

do
local CH_GUNMAN_04 = {
    {"H3OPT_CREWWEAP", 2}
}
    menu.add_feature("» 古斯塔沃·莫塔 (9%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("古斯塔沃·莫塔现在是你的枪手\nCut 9%", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_04 do
        stat_set_int(CH_GUNMAN_04[i][1], true, CH_GUNMAN_04[i][2])
        end
end)
end

do
local CH_GUNMAN_03 = {
    {"H3OPT_CREWWEAP", 5}
}
    menu.add_feature("» 帕里克·麦克瑞利 (8%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("帕里克·麦克瑞利现在是你的枪手\nCut 8%", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_03 do
        stat_set_int(CH_GUNMAN_03[i][1], true, CH_GUNMAN_03[i][2])
        end
    end)
end

do
local CH_GUNMAN_02 = {
    {"H3OPT_CREWWEAP", 3}
}
    menu.add_feature("» 查理·里德 (7%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("查理·里德现在是你的枪手\nCut 7%", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_02 do
        stat_set_int(CH_GUNMAN_02[i][1], true, CH_GUNMAN_02[i][2])
        end
    end)
end

do
local CH_GUNMAN_01 = {
    {"H3OPT_CREWWEAP", 1}
}
    menu.add_feature("» 卡尔·阿布拉吉 (5%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("卡尔·阿布拉吉现在是你的枪手\nCut 5%", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_01 do
        stat_set_int(CH_GUNMAN_01[i][1], true, CH_GUNMAN_01[i][2])
        end
    end)
end


do
local CH_GUNMAN_RND = {
    {"H3OPT_CREWWEAP", 1, 5, 1 ,5}
}
    menu.add_feature("» 随机枪手 (??%)", "action", CASINO_GUNMAN.id, function()
    menu.notify("枪手随机\nCut ??", "RHeist Control", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_RND do
        stat_set_int(CH_GUNMAN_RND[i][1], true, math.random(CH_GUNMAN_RND[i][4], CH_GUNMAN_RND[i][5]))
        end
    end)
end

do
local CH_GUNMAN_00 = {
    {"H3OPT_CREWWEAP", 6}
}
menu.add_feature("» 移除枪手 (0% Payout)", "action", CASINO_GUNMAN.id, function()
    menu.notify("枪手已移除", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_GUNMAN_00 do
        stat_set_int(CH_GUNMAN_00[i][1], true, CH_GUNMAN_00[i][2])
        end
    end)
end

local CASINO_GUNMAN_var = menu.add_feature("» 武器设置", "parent", CASINO_GUNMAN.id)

do
local CH_Gunman_var_01 = {
    {"H3OPT_WEAPS", 1}
}
    menu.add_feature("» 最好的枪", "action", CASINO_GUNMAN_var.id, function()
    menu.notify("枪械已升级为最好", "任务大师", 3, 0x64F0AA14)
    for i = 1, #CH_Gunman_var_01 do
    stat_set_int(CH_Gunman_var_01[i][1], true, CH_Gunman_var_01[i][2])
    end
end)
end

do
local CH_Gunman_var_00 = {
    {"H3OPT_WEAPS", 0}
}
    menu.add_feature("» 最烂的枪", "action", CASINO_GUNMAN_var.id, function()
    menu.notify("最烂的枪你也选？\n修改完成，最烂的枪", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_Gunman_var_00 do
        stat_set_int(CH_Gunman_var_00[i][1], true, CH_Gunman_var_00[i][2])
        end
    end)
end

local CASINO_DRIVER_TEAM = menu.add_feature("» 载具设置", "parent", CASINO_BOARD2.id)

do
local CH_DRV_MAN_05 = {
    {"H3OPT_CREWDRIVER", 5}
}
    menu.add_feature("» 切斯特·麦考伊 (10%)", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("载具设置为最好\n载具: 埃弗隆4座\n\n载具优秀\n载具: 不法分子2座\n\n载具良好\n载具: 流浪者2座\n\n载具差劲\n载具: zhaba 4座", "切斯特·麦考伊分红10%", 5, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_05 do
        stat_set_int(CH_DRV_MAN_05[i][1], true, CH_DRV_MAN_05[i][2])
        end
    end)
end

do
local CH_DRV_MAN_04 = {
    {"H3OPT_CREWDRIVER", 3}
}
    menu.add_feature("» 艾迪淘 (9%)", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("Vehicle Variation Best\nVehicle: Komoda 4 Seats\n\nVehicle Variation Good\nVehicle: Ellie 2 Seats\n\nVehicle Variation Fine\nVehicle: Gauntlet Classic 2 Seats\n\nVehicle Variation Worst\nVehicle: Sultan Classic 4 Seats", "艾迪淘 Cut 9%", 5, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_04 do
        stat_set_int(CH_DRV_MAN_04[i][1], true, CH_DRV_MAN_04[i][2])
        end
    end)
end

do
local CH_DRV_MAN_03 = {
    {"H3OPT_CREWDRIVER", 2}
}
    menu.add_feature("» 塔丽娜·马丁内斯 (7%)", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("Vehicle Variation Best\nVehicle: Jugular 4 Seats\n\nVehicle Variation Good\nVehicle: Sugoi 4 Seats\n\nVehicle Variation: Fine\nVehicle Drift Yosemite 2 Seats\n\nVehicle Variation Worst\nVehicle: Retinue Mk II 2 Seats", "塔丽娜·马丁内斯 Cut 7%", 5, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_03 do
        stat_set_int(CH_DRV_MAN_03[i][1], true, CH_DRV_MAN_03[i][2])
        end
    end)
end

do
local CH_DRV_MAN_02 = {
    {"H3OPT_CREWDRIVER", 4}
}
    menu.add_feature("» 扎克·尼尔森 (6%)", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("Vehicle Variation Best\nVehicle: Lectro 2 Seats\n\nVehicle Variation Good\nVehicle: Defiler 1 Seat\n\nVehicle Variation Fine\nVehicle: Stryder 1 Seat\n\nVehicle Variation Worst\nVehicle: Manchez 2 Seats", "扎克·尼尔森 Cut 6%", 5, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_02 do
        stat_set_int(CH_DRV_MAN_02[i][1], true, CH_DRV_MAN_02[i][2])
        end
end)
end

do
local CH_DRV_MAN_01 = {
    {"H3OPT_CREWDRIVER", 1}
}
    menu.add_feature("» 卡里姆·登茨 (5%)", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("Vehicle Variation Best\nVehicle: Sentinel Classic 2 Seats\n\nVehicle Variation: Good\nVehicle: Kanjo 2 Seats\n\nVehicle Variation Fine\nVehicle: Asbo 2 Seats\n\nVehicle Variation Worst\nVehicle: Issi Classic 2 Seats", "卡里姆·登茨 Cut 5%", 5, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_01 do
        stat_set_int(CH_DRV_MAN_01[i][1], true, CH_DRV_MAN_01[i][2])
        end
end)
end

do
local CH_DRV_MAN_RND = {
    {"H3OPT_CREWDRIVER", 1, 5, 1 ,5}
}
    menu.add_feature("» 随机车手", "action", CASINO_DRIVER_TEAM.id, function()
    menu.notify("车手已随机", "任务大师", 3, 0x64F0AA14)
    for i = 1, #CH_DRV_MAN_RND do
    stat_set_int(CH_DRV_MAN_RND[i][1], true, math.random(CH_DRV_MAN_RND[i][4], CH_DRV_MAN_RND[i][5]))
    end
end)
end

do
    local CH_DRV_MAN_00 = {
        {"H3OPT_CREWDRIVER", 6}
    }
menu.add_feature("» 去除车手 (0%分红)", "action", CASINO_DRIVER_TEAM.id, function()
menu.notify("车手已去除", "任务大师", 3, 0x64F0AA14)
    for i = 1, #CH_DRV_MAN_00 do
    stat_set_int(CH_DRV_MAN_00[i][1], true, CH_DRV_MAN_00[i][2])
        end
    end)
end

local CAH_DRIVER_TEAM_var = menu.add_feature("» 载具设置", "parent", CASINO_DRIVER_TEAM.id)

do
local CH_DRV_MAN_var_03 = {
    {"H3OPT_VEHS", 3}
}
menu.add_feature("» 最好的载具", "action", CAH_DRIVER_TEAM_var.id, function()
menu.notify("已设置最好的载具", "任务大师", 3, 0x64F0AA14)
    for i = 1, #CH_DRV_MAN_var_03 do
    stat_set_int(CH_DRV_MAN_var_03[i][1], true, CH_DRV_MAN_var_03[i][2])
    end
end)
end

do
local CH_DRV_MAN_var_02 = {
        {"H3OPT_VEHS", 2}
    }
    menu.add_feature("» 优秀的载具", "action", CAH_DRIVER_TEAM_var.id, function()
    menu.notify("优秀的载具已设置", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_var_02 do
        stat_set_int(CH_DRV_MAN_var_02[i][1], true, CH_DRV_MAN_var_02[i][2])
        end
    end)
end
do
local CH_DRV_MAN_var_01 = {
    {"H3OPT_VEHS", 1}
}
    menu.add_feature("» 良好的载具", "action", CAH_DRIVER_TEAM_var.id, function()
    menu.notify("良好的载具已设置", "Heist Control - Vehicle Variation", 3, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_var_01 do
        stat_set_int(CH_DRV_MAN_var_01[i][1], true, CH_DRV_MAN_var_01[i][2])
        end
    end)
end
do

local CH_DRV_MAN_var_00 = {
    {"H3OPT_VEHS", 0}
}
    menu.add_feature("» 最烂的载具", "action", CAH_DRIVER_TEAM_var.id, function()
    menu.notify("最烂的载具已设置", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_var_00 do
        stat_set_int(CH_DRV_MAN_var_00[i][1], true, CH_DRV_MAN_var_00[i][2])
        end
    end)
end

do
local CH_DRV_MAN_var_RND = {
    {"H3OPT_VEHS", 0, 3, 0, 3}
}
    menu.add_feature("» 随机载具设置", "action", CAH_DRIVER_TEAM_var.id, function()
    menu.notify("载具已随机", "任务大师", 3, 0x64F0AA14)
        for i = 1, #CH_DRV_MAN_var_RND do
        stat_set_int(CH_DRV_MAN_var_RND[i][1], true, math.random(CH_DRV_MAN_var_RND[i][4], CH_DRV_MAN_var_RND[i][5]))
        end
    end)
end

local CASINO_HACKERs = menu.add_feature("» 设置黑客", "parent", CASINO_BOARD2.id)
do
local CH_HCK_MAN_04 = {
    {"H3OPT_CREWHACKER", 4}
}
    menu.add_feature("» 阿维·施瓦茨曼 (10%)", "action", CASINO_HACKERs.id, function()
    menu.notify("Name: 阿维·施瓦茨曼\nSkill: Expert\nTime Undetected: 3:30\nTime Detected: 2:26\nCut: 10%", "任务大师", 5, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_04 do
        stat_set_int(CH_HCK_MAN_04[i][1], true, CH_HCK_MAN_04[i][2])
        end
end)
end

do
local CH_HCK_MAN_05 = {
    {"H3OPT_CREWHACKER", 5}
}
    menu.add_feature("» 佩奇·哈里斯 (9%)", "action", CASINO_HACKERs.id, function()
    menu.notify("Name: 佩奇·哈里斯\nSkill: Expert\nTime Undetected: 3:25\nTime Detected: 2:23\nCut: 9%", "任务大师", 5, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_05 do
        stat_set_int(CH_HCK_MAN_05[i][1], true, CH_HCK_MAN_05[i][2])
        end
end)
end

do
local CH_HCK_MAN_03 = {
    {"H3OPT_CREWHACKER", 2}
}
    menu.add_feature("» 克里斯汀·菲尔兹 (7%)", "action", CASINO_HACKERs.id, function()
    menu.notify("Name: 克里斯汀·菲尔兹\nSkill: Good\nTime Undetected: 2:59\nTime Detected: 2:05\nCut: 7%", "任务大师", 5, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_03 do
        stat_set_int(CH_HCK_MAN_03[i][1], true, CH_HCK_MAN_03[i][2])
        end
end)
end

do
local CH_HCK_MAN_02 = {
    {"H3OPT_CREWHACKER", 3}
}
    menu.add_feature("» 尤汉·布莱尔 (5%)", "action", CASINO_HACKERs.id, function()
    menu.notify("Name: 尤汉·布莱尔\nSkill: Good\nTime Undetected: 2:52\nTime Detected: 2:01\nCut: 5%", "任务大师", 5, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_02 do
        stat_set_int(CH_HCK_MAN_02[i][1], true, CH_HCK_MAN_02[i][2])
        end
end)
end

do
local CH_HCK_MAN_01 = {
    {"H3OPT_CREWHACKER", 1}
}
    menu.add_feature("» 里奇·卢肯 (3%)", "action", CASINO_HACKERs.id, function()
    menu.notify("Name: 里奇·卢肯\nSkill: Poor\nTime Undetected: 2:26\nTime Detected: 1:42\nCut: 3%", "Heist Control - Hacker Member", 5, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_01 do
        stat_set_int(CH_HCK_MAN_01[i][1], true, CH_HCK_MAN_01[i][2])
        end
end)
end

do
local CH_HCK_MAN_RND = {
    {"H3OPT_CREWHACKER", 0, 5, 1, 5}
}
    menu.add_feature("» 随机黑客", "action", CASINO_HACKERs.id, function()
    menu.notify("黑客已随机", "任务大师", 4, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_RND do
        stat_set_int(CH_HCK_MAN_RND[i][1], true, math.random(CH_HCK_MAN_RND[i][4], CH_HCK_MAN_RND[i][5]))
        end
end)
end
do
local CH_HCK_MAN_00 = {
    {"H3OPT_CREWHACKER", 6}
}
    menu.add_feature("» 去除黑客(0%分红)", "action", CASINO_HACKERs.id, function()
    menu.notify("黑客已去除", "任务大师", 4, 0x64F0AA14)
        for i = 1, #CH_HCK_MAN_00 do
        stat_set_int(CH_HCK_MAN_00[i][1], true, CH_HCK_MAN_00[i][2])
        end
    end)
end

local CASINO_MASK = menu.add_feature("» 选择面具", "parent", CASINO_BOARD2.id)

do
local CH_MASK_00 = {
    {"H3OPT_MASKS", -1}
}
    menu.add_feature("» 去除面具", "action", CASINO_MASK.id, function()
    menu.notify("面具已去除", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_00 do
        stat_set_int(CH_MASK_00[i][1], true, CH_MASK_00[i][2])
        end
end)
end

do
local CH_MASK_01 = {
    {"H3OPT_MASKS", 1}
}
    menu.add_feature("» 几何系列", "action", CASINO_MASK.id, function()
    menu.notify("面具：几何", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_01 do
        stat_set_int(CH_MASK_01[i][1], true, CH_MASK_01[i][2])
        end
end)
end

do
local CH_MASK_02 = {
    {"H3OPT_MASKS", 2}
}
    menu.add_feature("» 猎人系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 系列", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_02 do
        stat_set_int(CH_MASK_02[i][1], true, CH_MASK_02[i][2])
        end
end)
end

do
local CH_MASK_03 = {
    {"H3OPT_MASKS", 3}
}
    menu.add_feature("» 半面鬼系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 半面鬼", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_03 do
    stat_set_int(CH_MASK_03[i][1], true, CH_MASK_03[i][2])
        end
    end)
end

do
local CH_MASK_04 = {
    {"H3OPT_MASKS", 4}
}
    menu.add_feature("» 表情包系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 表情包", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_04 do
        stat_set_int(CH_MASK_04[i][1], true, CH_MASK_04[i][2])
        end
end)
end

do
local CH_MASK_05 = {
    {"H3OPT_MASKS", 5}
}
    menu.add_feature("» 骷髅头系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 华丽骷髅头", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_05 do
        stat_set_int(CH_MASK_05[i][1], true, CH_MASK_05[i][2])
        end
end)
end

do
local CH_MASK_06 = {
    {"H3OPT_MASKS", 6}
}
    menu.add_feature("» 幸运水果系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 幸运水果", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_06 do
        stat_set_int(CH_MASK_06[i][1], true, CH_MASK_06[i][2])
        end
end)
end

do
local CH_MASK_07 = {
    {"H3OPT_MASKS", 7}
}
    menu.add_feature("» 游击队系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 游击队", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_07 do
        stat_set_int(CH_MASK_07[i][1], true, CH_MASK_07[i][2])
        end
end)
end

do
local CH_MASK_08 = {
    {"H3OPT_MASKS", 8}
}
    menu.add_feature("» 小丑系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 小丑", "任务大师", 2, 0x64F0AA14)
    for i = 1, #CH_MASK_08 do
    stat_set_int(CH_MASK_08[i][1], true, CH_MASK_08[i][2])
    end
end)
end

do
local CH_MASK_09 = {
    {"H3OPT_MASKS", 9}
}
    menu.add_feature("» 动物系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 动物", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_09 do
        stat_set_int(CH_MASK_09[i][1], true, CH_MASK_09[i][2])
        end
end)
end

do
local CH_MASK_10 = {
    {"H3OPT_MASKS", 10}
}
    menu.add_feature("» 防爆系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 防爆", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_10 do
        stat_set_int(CH_MASK_10[i][1], true, CH_MASK_10[i][2])
        end
end)
end

do
local CH_MASK_11 = {
    {"H3OPT_MASKS", 11}
}
    menu.add_feature("» 鬼面系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 鬼面", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_11 do
        stat_set_int(CH_MASK_11[i][1], true, CH_MASK_11[i][2])
        end
end)
end

do
local CH_MASK_12 = {
    {"H3OPT_MASKS", 12}
}
    menu.add_feature("» 冰球系列", "action", CASINO_MASK.id, function()
    menu.notify("面具: 冰球", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_MASK_12 do
        stat_set_int(CH_MASK_12[i][1], true, CH_MASK_12[i][2])
    end
end)
end

do
    local CH_DUGGAN = {
{"H3OPT_DISRUPTSHIP", 3}
}
local CH_SCANC_LVL = {
    {"H3OPT_KEYLEVELS", 2}
}
    menu.add_feature("» 解锁二级门禁卡", "action", CASINO_BOARD2.id, function()
    menu.notify("二级门禁已解锁", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_SCANC_LVL do
        stat_set_int(CH_SCANC_LVL[i][1], true, CH_SCANC_LVL[i][2])
    end
end)

    menu.add_feature("» 移除重甲兵保安", "action", CASINO_BOARD2.id, function()
    menu.notify("已移除重加兵保安", "任务大师", 2, 0x64F0AA14)
        for i = 1, #CH_DUGGAN do
        stat_set_int(CH_DUGGAN[i][1], true, CH_DUGGAN[i][2])
    end
end)
end

do
    local CH_UNLCK_3stboard_var1 = {
        {"H3OPT_BITSET0", -8849}
    }
    local CH_UNLCK_3stboard_var3bc = {
        {"H3OPT_BITSET0", -186}
    }
    menu.add_feature("» 为隐迹潜踪移除钻头", "action", CASINO_BOARD3.id, function()
    menu.notify("成功", "任务大师", 3, 0x64F06414)
    for i = 1, #CH_UNLCK_3stboard_var1 do
        stat_set_int(CH_UNLCK_3stboard_var1[i][1], true, CH_UNLCK_3stboard_var1[i][2])
    end
end)
    menu.add_feature("» 为兵不厌诈移除钻头", "action", CASINO_BOARD3.id, function()
    menu.notify("成功", "任务大师", 3, 0x64F06414)
    for i = 1, #CH_UNLCK_3stboard_var3bc do
        stat_set_int(CH_UNLCK_3stboard_var3bc[i][1], true, CH_UNLCK_3stboard_var3bc[i][2])
        end
    end)
end

do
local CH_LOAD_BOARD_var0 = {
    {"H3OPT_BITSET1", -1},
    {"H3OPT_BITSET0", -1}
}
local CH_UNLOAD_BOARD_var1 = {
    {"H3OPT_BITSET1", 0},
    {"H3OPT_BITSET0", 0}
}
menu.add_feature("» 策划板加载器", "action", CASINO_LBOARDS.id, function()
    menu.notify("加载所有策划板", "任务大师", 3, 0x6400FA14)
    for i = 1, #CH_LOAD_BOARD_var0 do
        stat_set_int(CH_LOAD_BOARD_var0[i][1], true, CH_LOAD_BOARD_var0[i][2])
    end
end)

menu.add_feature("» 重置所有策划板", "action", CASINO_LBOARDS.id, function()
    menu.notify("重置素有策划板成功", "任务大师", 3, 0x641400FF)
    for i = 1, #CH_UNLOAD_BOARD_var1 do
        stat_set_int(CH_UNLOAD_BOARD_var1[i][1], true, CH_UNLOAD_BOARD_var1[i][2])
    end
end)
end

do
local UNLCK_PATRICK = {
    {"CAS_HEIST_FLOW", -1}
}
    menu.add_feature("» 解锁帕里克·麦克瑞利(隐藏黑客 10%分红)", "action", CASINO_MORE.id, function()
    menu.notify("成功解锁帕里克·麦克瑞利", "任务大师", 3, 0x64F06414)
    for i = 1, #UNLCK_PATRICK do
    stat_set_int(UNLCK_PATRICK[i][1], true, UNLCK_PATRICK[i][2])
    end
end)
end

do
local CH_AWRD_BL = {
    {"AWD_FIRST_TIME1", true},
    {"AWD_FIRST_TIME2", true},
    {"AWD_FIRST_TIME3", true},
    {"AWD_FIRST_TIME4", true},
    {"AWD_FIRST_TIME5", true},
    {"AWD_FIRST_TIME6", true},
    {"AWD_ALL_IN_ORDER", true},
    {"AWD_SUPPORTING_ROLE", true},
    {"AWD_LEADER", true},
    {"AWD_ODD_JOBS", true},
    {"AWD_SURVIVALIST", true},
    {"AWD_SCOPEOUT", true},
    {"AWD_CREWEDUP", true},
    {"AWD_MOVINGON", true},
    {"AWD_PROMOCAMP", true},
    {"AWD_GUNMAN", true},
    {"AWD_SMASHNGRAB", true},
    {"AWD_INPLAINSI", true},
    {"AWD_UNDETECTED", true},
    {"AWD_ALLROUND", true},
    {"AWD_ELITETHEIF", true},
    {"AWD_PRO", true},
    {"AWD_SUPPORTACT", true},
    {"AWD_SHAFTED", true},
    {"AWD_COLLECTOR", true},
    {"AWD_DEADEYE", true},
    {"AWD_PISTOLSATDAWN", true},
    {"AWD_TRAFFICAVOI", true},
    {"AWD_CANTCATCHBRA", true},
    {"AWD_WIZHARD", true},
    {"AWD_APEESCAPE", true},
    {"AWD_MONKEYKIND", true},
    {"AWD_AQUAAPE", true},
    {"AWD_KEEPFAITH", true},
    {"AWD_TRUELOVE", true},
    {"AWD_NEMESIS", true},
    {"AWD_FRIENDZONED", true},
    {"VCM_FLOW_CS_RSC_SEEN", true},
    {"VCM_FLOW_CS_BWL_SEEN", true},
    {"VCM_FLOW_CS_MTG_SEEN", true},
    {"VCM_FLOW_CS_OIL_SEEN", true},
    {"VCM_FLOW_CS_DEF_SEEN", true},
    {"VCM_FLOW_CS_FIN_SEEN", true},
    {"CAS_VEHICLE_REWARD", false},
    {"HELP_FURIA", true},
    {"HELP_MINITAN", true},
    {"HELP_YOSEMITE2", true},
    {"HELP_ZHABA", true},
    {"HELP_IMORGEN", true},
    {"HELP_SULTAN2", true},
    {"HELP_VAGRANT", true},
    {"HELP_VSTR", true},
    {"HELP_STRYDER", true},
    {"HELP_SUGOI", true},
    {"HELP_KANJO", true},
    {"HELP_FORMULA", true},
    {"HELP_FORMULA2", true},
    {"HELP_JB7002", true}
}
local CH_AWRD_IT = {
    {"CH_ARC_CAB_CLAW_TROPHY", -1},
    {"CH_ARC_CAB_LOVE_TROPHY", -1},
    {"SIGNAL_JAMMERS_COLLECTED", 50},
    {"AWD_ODD_JOBS", 52},
    {"AWD_PREPARATION", 40},
    {"AWD_ASLEEPONJOB", 20},
    {"AWD_DAICASHCRAB", 100000},
    {"AWD_BIGBRO", 40},
    {"AWD_SHARPSHOOTER", 40},
    {"AWD_RACECHAMP", 40},
    {"AWD_BATSWORD", 1000000},
    {"AWD_COINPURSE", 950000},
    {"AWD_ASTROCHIMP", 3000000},
    {"AWD_MASTERFUL", 40000},
    {"VCM_FLOW_PROGRESS", 1839072},
    {"VCM_STORY_PROGRESS", 0},
    {"H3_BOARD_DIALOGUE0", -1},
    {"H3_BOARD_DIALOGUE1", -1},
    {"H3_BOARD_DIALOGUE2", -1},
    {"H3_VEHICLESUSED", -1}
}
    menu.add_feature("» 解锁赌场豪劫奖杯", "action", CASINO_MORE.id, function()
    menu.notify("成功解锁赌场豪劫奖杯", "任务大师", 3, 0x6400FA14)
    for i = 1, #CH_AWRD_IT do
        stat_set_int(CH_AWRD_IT[i][1], true, CH_AWRD_IT[i][2])
    for i = 2, #CH_AWRD_BL do
        stat_set_bool(CH_AWRD_BL[i][1], true, CH_AWRD_BL[i][2])
            end
        end
    end)
end

do
local CLD_CH_RMV = {
    {"H3_COMPLETEDPOSIX", -1},
    {"MPPLY_H3_COOLDOWN", -1}
}
    menu.add_feature("» 重置抢劫冷却", "action", CASINO_MORE.id, function()
    menu.notify("这不会绕过服务器的冷却（可能无法拿到分红）", "任务大师", 3, 0x6414F0FF)
    for i = 1, #CLD_CH_RMV do
        stat_set_int(CLD_CH_RMV[i][1], true, CLD_CH_RMV[i][2])
        stat_set_int(CLD_CH_RMV[i][1], false, CLD_CH_RMV[i][2])
        end
    end)
end

do
local CH_RST = {
    {"H3_LAST_APPROACH", 0},
    {"H3OPT_APPROACH", 0},
    {"H3_HARD_APPROACH", 0},
    {"H3OPT_TARGET", 0},
    {"H3OPT_POI", 0},
    {"H3OPT_ACCESSPOINTS", 0},
    {"H3OPT_BITSET1", 0},
    {"H3OPT_CREWWEAP", 0},
    {"H3OPT_CREWDRIVER", 0},
    {"H3OPT_CREWHACKER", 0},
    {"H3OPT_WEAPS", 0},
    {"H3OPT_VEHS", 0},
    {"H3OPT_DISRUPTSHIP", 0},
    {"H3OPT_BODYARMORLVL", 0},
    {"H3OPT_KEYLEVELS", 0},
    {"H3OPT_MASKS", 0},
    {"H3OPT_BITSET0", 0}
}
menu.add_feature("» 重置抢劫", "action", CASINO_MORE.id, function()
    menu.notify("现在打电话给莱斯特，试着取消赌场抢劫案", "任务大师", 3, 0x6414F0FF)
for i = 1, #CH_RST do
    stat_set_int(CH_RST[i][1], true, CH_RST[i][2])
end
end)
end
-------- DOOMSDAY HEIST
do
local DD_H_ACT1 = {
    {"GANGOPS_FLOW_MISSION_PROG", 503},
    {"GANGOPS_HEIST_STATUS", -229383},
    {"GANGOPS_FLOW_NOTIFICATIONS", 1557}
}
    menu.add_feature("» 数据泄露[终章]", "action", DOOMS_PRESETS.id, function()
    menu.notify("数据泄露\n准备好了", "任务大师", 4, 0x64FF78B4)
    for i = 1, #DD_H_ACT1 do
        stat_set_int(DD_H_ACT1[i][1], true, DD_H_ACT1[i][2])
    end
end)
end

do
local DD_H_ACT2 = {
    {"GANGOPS_FLOW_MISSION_PROG", 240},
    {"GANGOPS_HEIST_STATUS", -229378},
    {"GANGOPS_FLOW_NOTIFICATIONS", 1557}
}
    menu.add_feature("» 波格丹危机[终章]", "action", DOOMS_PRESETS.id, function()
    menu.notify("波格丹危机\n准备好了", "任务大师", 4, 0x64FF78B4)
    for i = 1, #DD_H_ACT2 do
        stat_set_int(DD_H_ACT2[i][1], true, DD_H_ACT2[i][2])
    end
end)
end

do
local DD_H_ACT3 = {
    {"GANGOPS_FLOW_MISSION_PROG", 16368},
    {"GANGOPS_HEIST_STATUS", -229380},
    {"GANGOPS_FLOW_NOTIFICATIONS", 1557}
}
    menu.add_feature("» 末日将至[终章]", "action", DOOMS_PRESETS.id, function()
    menu.notify("末日终章\n准备好了", "任务大师", 4, 0x64FF78B4)
    for i = 1, #DD_H_ACT3 do
        stat_set_int(DD_H_ACT3[i][1], true, DD_H_ACT3[i][2])
    end
end)
end

do
local DDHEIST_HOST_MANAGER = menu.add_feature("» 你的分红", "parent", DDHEIST_PLYR_MANAGER.id)
    menu.add_feature("0%", "toggle", DDHEIST_HOST_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+1, 0)
    if not p.on then return end
    system.wait(0)
    end
end)

    menu.add_feature("100%", "toggle", DDHEIST_HOST_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+1, 100)
    if not p.on then return end
    system.wait(0)
end
end)

    menu.add_feature("150%", "toggle", DDHEIST_HOST_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+1, 150)
    if not p.on then return end
    system.wait(0)
end
end)

    menu.add_feature("175%", "toggle", DDHEIST_HOST_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+1, 175)
    if not p.on then return end
    system.wait(0)
end
end)

    menu.add_feature("205%", "toggle", DDHEIST_HOST_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+1, 205)
    if not p.on then return end
    system.wait(0)
end
end)
end

do
    local DDHEIST_PLAYER2_MANAGER = menu.add_feature("» 玩家2", "parent", DDHEIST_PLYR_MANAGER.id)

    menu.add_feature("0%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 0)
    if not p.on then return end
    system.wait(0)
end
end)

    menu.add_feature("100%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 100)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("150%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 150)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("175%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 175)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("200%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 200)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("205%", "toggle", DDHEIST_PLAYER2_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+2, 205)
    if not p.on then return end
    system.wait(0)
end
end)
end

do
local DDHEIST_PLAYER3_MANAGER = menu.add_feature("» 玩家3", "parent", DDHEIST_PLYR_MANAGER.id)
menu.add_feature("0%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 0)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("100%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 100)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("150%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 150)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("175%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 175)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("200%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 200)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("205%", "toggle", DDHEIST_PLAYER3_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+3, 205)
    if not p.on then return end
    system.wait(0)
end
end)
end

do
local DDHEIST_PLAYER4_MANAGER = menu.add_feature("» 玩家4", "parent", DDHEIST_PLYR_MANAGER.id)
menu.add_feature("0%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 0)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("100%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 100)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("150%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 150)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("175%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 175)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("200%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 200)
    if not p.on then return end
    system.wait(0)
end
end)

menu.add_feature("205%", "toggle", DDHEIST_PLAYER4_MANAGER.id, function(p)
    while p.on do
    script.set_global_i(1699568+812+50+4, 205)
    if not p.on then return end
    system.wait(0)
end
end)
end

menu.add_feature("» 修改波格丹危机分红(240万/人)", "toggle", DDHEIST_PLYR_MANAGER.id, function(act)
    menu.notify("波格丹危机\n将其设置为难度，如果在游戏中显示不同的百分比，请不要担心\n\n请在抢劫结束前一直处于激活状态", "任务大师", 6, 0x6414F0FF)
    while act.on do
    script.set_global_i(1699568+812+50+1, 205)
    script.set_global_i(1699568+812+50+2, 205)
    script.set_global_i(1699568+812+50+3, 205)
    script.set_global_i(1699568+812+50+4, 205)
    if not act.on then return end
    system.wait(0)
end
end)


do
local DD_H_ULCK = {
    {"GANGOPS_HEIST_STATUS", -1},
    {"GANGOPS_HEIST_STATUS", -229384}
}
    menu.add_feature("» 解锁所有末日豪劫选项", "action", DOOMS_HEIST.id, function()
    menu.notify("打电话给莱斯特，要求取消世界末日劫案（三次）\n只能按此选项一次", "任务大师", 4, 0x64F06414)
    for i = 1, #DD_H_ULCK do
    stat_set_int(DD_H_ULCK[i][1], true, DD_H_ULCK[i][2])
    end
    end)
end

do
local DD_PREPS_DONE = {
    {"GANGOPS_FM_MISSION_PROG", -1}
}
    menu.add_feature("» 完成所有准备任务(不是前置)", "action", DOOMS_HEIST.id, function()
        menu.notify("已完成所有准备任务", "任务大师", 3, 0x64F06414)
        for i = 1, #DD_PREPS_DONE do
            stat_set_int(DD_PREPS_DONE[i][1], true, DD_PREPS_DONE[i][2])
        end
    end)
end

do
local DD_H_RST = {
    {"GANGOPS_FLOW_MISSION_PROG", 240},
    {"GANGOPS_HEIST_STATUS", 0},
    {"GANGOPS_FLOW_NOTIFICATIONS", 1557}
}
    menu.add_feature("» 重置抢劫", "action", DOOMS_HEIST.id, function()
    menu.notify("抢劫已重置\n换个新战局!!!", "任务大师", 3, 0x64F06414)
        for i = 1, #DD_H_RST do
        stat_set_int(DD_H_RST[i][1], true, DD_H_RST[i][2])
        end
    end)
    end
do
    local DD_AWARDS_I = {
    {"GANGOPS_FM_MISSION_PROG", -1},
    {"GANGOPS_FLOW_MISSION_PROG", -1},
    {"MPPLY_GANGOPS_ALLINORDER", 100},
    {"MPPLY_GANGOPS_LOYALTY", 100},
    {"MPPLY_GANGOPS_CRIMMASMD", 100},
    {"MPPLY_GANGOPS_LOYALTY2", 100},
    {"MPPLY_GANGOPS_LOYALTY3", 100},
    {"MPPLY_GANGOPS_CRIMMASMD2", 100},
    {"MPPLY_GANGOPS_CRIMMASMD3", 100},
    {"MPPLY_GANGOPS_SUPPORT", 100},
    {"CR_GANGOP_MORGUE", 10},
    {"CR_GANGOP_DELUXO", 10},
    {"CR_GANGOP_SERVERFARM", 10},
    {"CR_GANGOP_IAABASE_FIN", 10},
    {"CR_GANGOP_STEALOSPREY", 10},
    {"CR_GANGOP_FOUNDRY", 10},
    {"CR_GANGOP_RIOTVAN", 10},
    {"CR_GANGOP_SUBMARINECAR", 10},
    {"CR_GANGOP_SUBMARINE_FIN", 10},
    {"CR_GANGOP_PREDATOR", 10},
    {"CR_GANGOP_BMLAUNCHER", 10},
    {"CR_GANGOP_BCCUSTOM", 10},
    {"CR_GANGOP_STEALTHTANKS", 10},
    {"CR_GANGOP_SPYPLANE", 10},
    {"CR_GANGOP_FINALE", 10},
    {"CR_GANGOP_FINALE_P2", 10},
    {"CR_GANGOP_FINALE_P3", 10}
}
local DD_AWARDS_B = {
    {"MPPLY_AWD_GANGOPS_IAA", true},
    {"MPPLY_AWD_GANGOPS_SUBMARINE", true},
    {"MPPLY_AWD_GANGOPS_MISSILE", true},
    {"MPPLY_AWD_GANGOPS_ALLINORDER", true},
    {"MPPLY_AWD_GANGOPS_LOYALTY", true},
    {"MPPLY_AWD_GANGOPS_LOYALTY2", true},
    {"MPPLY_AWD_GANGOPS_LOYALTY3", true},
    {"MPPLY_AWD_GANGOPS_CRIMMASMD", true},
    {"MPPLY_AWD_GANGOPS_CRIMMASMD2", true},
    {"MPPLY_AWD_GANGOPS_CRIMMASMD3", true}
}
    menu.add_feature("» 解锁所有末日豪劫奖杯", "action", DOOMS_HEIST.id, function()
    menu.notify("解锁成功", "任务大师", 3, 0x6400FA14)
    for i = 1, #DD_AWARDS_I do
        stat_set_int(DD_AWARDS_I[i][1], true, DD_AWARDS_I[i][2])
        stat_set_int(DD_AWARDS_I[i][1], false, DD_AWARDS_I[i][2])
    for i = 1, #DD_AWARDS_B do
        stat_set_bool(DD_AWARDS_B[i][1], true, DD_AWARDS_B[i][2])
        stat_set_bool(DD_AWARDS_B[i][1], false, DD_AWARDS_B[i][2])
        end
    end
    end)
end
-------- CLASSIC HEIST
do
local Apartment_SetDone = {
    {"HEIST_PLANNING_STAGE", -1}
}
    menu.add_feature("» 完成所有前置(先看过场)", "action", CLASSIC_HEISTS.id, function()
    for i = 1, #Apartment_SetDone do
    menu.notify("您需要观看/跳过第一个过场动画才能激活此选项", "任务大师", 5, 0x6414F0FF)
    stat_set_int(Apartment_SetDone[i][1], true, Apartment_SetDone[i][2])
end
end)
end

do
local CUT_CHAR_P1 = menu.add_feature("» 你的分红", "parent", CLASSIC_CUT.id)
menu.add_feature("0 %", "toggle", CUT_CHAR_P1.id, function(a)
    while a.on do
    script.set_global_i(1671773 + 3008 +1, 0)
    if not a.on then return end
    system.wait(0)
    end
end)
menu.add_feature("100 %", "toggle", CUT_CHAR_P1.id, function(a)
    while a.on do
    script.set_global_i(1671773 + 3008 +1, 100)
    if not a.on then return end
    system.wait(0)
    end
end)
menu.add_feature("125 %", "toggle", CUT_CHAR_P1.id, function(a)
    while a.on do
    script.set_global_i(1671773 + 3008 +1, 125)
    if not a.on then return end
    system.wait(0)
    end
end)
menu.add_feature("150 %", "toggle", CUT_CHAR_P1.id, function(a)
    while a.on do
    script.set_global_i(1671773 + 3008 +1, 150)
    if not a.on then return end
    system.wait(0)
    end
end)
menu.add_feature("200 %", "toggle", CUT_CHAR_P1.id, function(a)
    while a.on do
    script.set_global_i(1671773 + 3008 +1, 200)
    if not a.on then return end
    system.wait(0)
    end
end)
end

do
local Apartment_AWD_B = {
    {"MPPLY_AWD_COMPLET_HEIST_MEM", true},
    {"MPPLY_AWD_COMPLET_HEIST_1STPER", true},
    {"MPPLY_AWD_FLEECA_FIN", true},
    {"MPPLY_AWD_HST_ORDER", true},
    {"MPPLY_AWD_HST_SAME_TEAM", true},
    {"MPPLY_AWD_HST_ULT_CHAL", true},
    {"MPPLY_AWD_HUMANE_FIN", true},
    {"MPPLY_AWD_PACIFIC_FIN", true},
    {"MPPLY_AWD_PRISON_FIN", true},
    {"MPPLY_AWD_SERIESA_FIN", true},
    {"AWD_FINISH_HEIST_NO_DAMAGE", true},
    {"AWD_SPLIT_HEIST_TAKE_EVENLY", true},
    {"AWD_ALL_ROLES_HEIST", true},
    {"AWD_MATCHING_OUTFIT_HEIST", true},
    {"HEIST_PLANNING_DONE_PRINT", true},
    {"HEIST_PLANNING_DONE_HELP_0", true},
    {"HEIST_PLANNING_DONE_HELP_1", true},
    {"HEIST_PRE_PLAN_DONE_HELP_0", true},
    {"HEIST_CUTS_DONE_FINALE", true},
    {"HEIST_IS_TUTORIAL", false},
    {"HEIST_STRAND_INTRO_DONE", true},
    {"HEIST_CUTS_DONE_ORNATE", true},
    {"HEIST_CUTS_DONE_PRISON", true},
    {"HEIST_CUTS_DONE_BIOLAB", true},
    {"HEIST_CUTS_DONE_NARCOTIC", true},
    {"HEIST_CUTS_DONE_TUTORIAL", true},
    {"HEIST_AWARD_DONE_PREP", true},
    {"HEIST_AWARD_BOUGHT_IN", true}
}
    local Apartment_AWD_I = {
    {"AWD_FINISH_HEISTS", 900},
    {"MPPLY_WIN_GOLD_MEDAL_HEISTS", 900},
    {"AWD_DO_HEIST_AS_MEMBER", 900},
    {"AWD_DO_HEIST_AS_THE_LEADER", 900},
    {"AWD_FINISH_HEIST_SETUP_JOB", 900},
    {"AWD_FINISH_HEIST", 900},
    {"HEIST_COMPLETION", 900},
    {"HEISTS_ORGANISED", 900},
    {"AWD_CONTROL_CROWDS", 900},
    {"AWD_WIN_GOLD_MEDAL_HEISTS", 900},
    {"AWD_COMPLETE_HEIST_NOT_DIE", 900},
    {"HEIST_START", 900},
    {"HEIST_END", 900},
    {"CUTSCENE_MID_PRISON", 900},
    {"CUTSCENE_MID_HUMANE", 900},
    {"CUTSCENE_MID_NARC", 900},
    {"CUTSCENE_MID_ORNATE", 900},
    {"CR_FLEECA_PREP_1", 5000},
    {"CR_FLEECA_PREP_2", 5000},
    {"CR_FLEECA_FINALE", 5000},
    {"CR_PRISON_PLANE", 5000},
    {"CR_PRISON_BUS", 5000},
    {"CR_PRISON_STATION", 5000},
    {"CR_PRISON_UNFINISHED_BIZ", 5000},
    {"CR_PRISON_FINALE", 5000},
    {"CR_HUMANE_KEY_CODES", 5000},
    {"CR_HUMANE_ARMORDILLOS", 5000},
    {"CR_HUMANE_EMP", 5000},
    {"CR_HUMANE_VALKYRIE", 5000},
    {"CR_HUMANE_FINALE", 5000},
    {"CR_NARC_COKE", 5000},
    {"CR_NARC_TRASH_TRUCK", 5000},
    {"CR_NARC_BIKERS", 5000},
    {"CR_NARC_WEED", 5000},
    {"CR_NARC_STEAL_METH", 5000},
    {"CR_NARC_FINALE", 5000},
    {"CR_PACIFIC_TRUCKS ", 5000},
    {"CR_PACIFIC_WITSEC", 5000},
    {"CR_PACIFIC_HACK", 5000},
    {"CR_PACIFIC_BIKES", 5000},
    {"CR_PACIFIC_CONVOY", 5000},
    {"CR_PACIFIC_FINALE", 5000},
    {"MPPLY_HEIST_ACH_TRACKER", -1}
}
    menu.add_feature("» 解锁所有公寓抢劫奖杯", "action", CLASSIC_HEISTS.id, function()
    menu.notify("解锁完成", "任务大师", 3, 0x6400FA14)
    for i = 1, #Apartment_AWD_I do
    stat_set_int(Apartment_AWD_I[i][1], true, Apartment_AWD_I[i][2])
    stat_set_int(Apartment_AWD_I[i][1], false, Apartment_AWD_I[i][2])
    for i = 1, #Apartment_AWD_B do
    stat_set_bool(Apartment_AWD_B[i][1], true, Apartment_AWD_B[i][2])
    stat_set_bool(Apartment_AWD_B[i][1], false, Apartment_AWD_B[i][2])
end
end
end)
end
    menu.add_feature("全福银行分红1000万(仅对你有效)", "toggle", CLASSIC_HEISTS.id, function(a)
    menu.notify("您需要成为此次抢劫的主人\n\n在最终抢劫中使用此选项（在选择百分比的屏幕中）\n\n不要尝试更改玩家2的百分比，这对他不起作用", "", 12, 0x6414F0FF)
    menu.notify("小心使用。\n\n如果在新帐户上过度使用，可能会导致您的帐户被封禁\n\n激活此项直到完成抢劫", "", 12, 0x6414F0FF)
    while a.on do
    script.set_global_i(1671773 + 3008 +1,7000)
    if not a.on then return end
    system.wait(0)
    end
end)
------------- LS CONTRACTS
    menu.add_feature("» 提高合约收益 (100万) (仅对你有效)", "toggle", LS_ROBBERY.id, function(rob)
    menu.notify("在开始合同之前，始终保持此选项处于激活状态\n\n收入有一个冷却时间，如果您计划重复此操作，冷却时间可能在15-20分钟之间。","任务大师", 5, 0x6400FA14)
    while rob.on do
        script.set_global_i(262145+30515+0,1000000) 
        script.set_global_i(262145+30515+1,1000000) 
        script.set_global_i(262145+30515+2,1000000)
        script.set_global_i(262145+30515+3,1000000) 
        script.set_global_i(262145+30515+4,1000000)
        script.set_global_i(262145+30515+5,1000000) 
        script.set_global_i(262145+30515+6,1000000) 
        script.set_global_i(262145+30515+7,1000000) 
        script.set_global_i(262145+30514,1000000) -- reward when joining a contract
        script.set_global_i(262145+30511,0) -- IA cut removal
    if not rob.on then return end
    system.wait(0)
    end
end)

do
local LS_CONTRACT_0_UD = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 0}
}
    menu.add_feature("» 联合储蓄银行合约", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_0_UD do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n联合储蓄银行合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_0_UD[i][1], true, LS_CONTRACT_0_UD[i][2])
    end
    end)
end

do
local LS_CONTRACT_1_SD = {
    {"TUNER_GEN_BS", 4351},
    {"TUNER_CURRENT", 1}
}
    menu.add_feature("» 大钞交易", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_1_SD do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n大钞交易合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_1_SD[i][1], true, LS_CONTRACT_1_SD[i][2])
    end
    end)
end

do
local LS_CONTRACT_2_BC = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 2}
}
    menu.add_feature("» 银行合约", "action", LS_ROBBERY.id, function()
    for i = 1, #LS_CONTRACT_2_BC do
    menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n银行合约准备就绪", "任务大师", 3, 0x64F06414)
    stat_set_int(LS_CONTRACT_2_BC[i][1], true, LS_CONTRACT_2_BC[i][2])
    end
    end)
end

do
local LS_CONTRACT_3_ECU = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 3}
}
    menu.add_feature("» 电控单元合约", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_3_ECU do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n电控单元合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_3_ECU[i][1], true, LS_CONTRACT_3_ECU[i][2])
    end
    end)
end

do
local LS_CONTRACT_4_PRSN = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 4}
} 
    menu.add_feature("» 监狱合约", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_4_PRSN do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n监狱合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_4_PRSN[i][1], true, LS_CONTRACT_4_PRSN[i][2])
    end
    end)
end

do
local LS_CONTRACT_5_AGC = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 5}
}
    menu.add_feature("» IAA交易", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_5_AGC do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\nIAA交易 合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_5_AGC[i][1], true, LS_CONTRACT_5_AGC[i][2])
    end
    end)
end

do
local LS_CONTRACT_6_LOST = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 6}
}
    menu.add_feature("» 失落摩托帮合约", "action", LS_ROBBERY.id, function()
    for i = 1, #LS_CONTRACT_6_LOST do
    menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n失落摩托帮合约准备就绪", "任务大师", 3, 0x64F06414)
    stat_set_int(LS_CONTRACT_6_LOST[i][1], true, LS_CONTRACT_6_LOST[i][2])
    end
    end)
end

do
local LS_CONTRACT_7_DATA = {
    {"TUNER_GEN_BS", 12543},
    {"TUNER_CURRENT", 7}
}
    menu.add_feature("» 数据合约", "action", LS_ROBBERY.id, function()
        for i = 1, #LS_CONTRACT_7_DATA do
        menu.notify("只有当你不在改装铺时，才会发生变化\n\n\n数据合约准备就绪", "任务大师", 3, 0x64F06414)
        stat_set_int(LS_CONTRACT_7_DATA[i][1], true, LS_CONTRACT_7_DATA[i][2])
    end
    end)
end

do
local LS_CONTRACT_MSS_ONLY = {
    {"TUNER_GEN_BS", -1}
}
    menu.add_feature("» 完成所有前置", "action", LS_ROBBERY.id, function()
    for i = 1, #LS_CONTRACT_MSS_ONLY do
    menu.notify("只有当你不在改装铺时，才会发生变化\n\n前置已完成","任务大师", 3, 0x64F06414)
    stat_set_int(LS_CONTRACT_MSS_ONLY[i][1], true, LS_CONTRACT_MSS_ONLY[i][2])
    end
    end)
end

do
local LS_CONTRACT_MISSION_RST = {
    {"TUNER_GEN_BS", 12467}
}
menu.add_feature("» 重置所有前置", "action", LS_ROBBERY.id, function()
    for i = 1, #LS_CONTRACT_MISSION_RST do
    menu.notify("只有当你不在改装铺时，才会发生变化\n\n前置已重置","任务大师", 3, 0x64F06414)
    stat_set_int(LS_CONTRACT_MISSION_RST[i][1], true, LS_CONTRACT_MISSION_RST[i][2])
    end
    end)
end

do
local LS_CONTRACT_RST = {
    {"TUNER_GEN_BS", 8371},
    {"TUNER_CURRENT", -1}
}
menu.add_feature("» 重置合约", "action", LS_ROBBERY.id, function()
    for i = 1, #LS_CONTRACT_RST do
    menu.notify("只有当你不在改装铺时，才会发生变化\n\n合约已重置","任务大师", 3, 0x64F06414)
    stat_set_int(LS_CONTRACT_RST[i][1], true, LS_CONTRACT_RST[i][2])
end
end)
end
-------------------- MASTER UNLOCKER AREA

    local TUNERS_DLC = menu.add_feature("» 洛圣都车友会", "parent", MASTER_UNLOCKR.id)
    menu.add_feature("» 暂时解锁所有未开放的载具", "toggle", TUNERS_DLC.id, function(bit)
        menu.notify("如果您想在任务、抢劫和自由模式下玩新车，可以保持此选项处于活动状态\n\n可以购买新车!", "解锁大师", 5, 0x64F06414)
        while bit.on do 
        script.set_global_i(262145 + 30494, 1)
        script.set_global_i(262145 + 30498, 1)
        script.set_global_i(262145 + 30499, 1)
        script.set_global_i(262145 + 30500, 1)
        script.set_global_i(262145 + 30488, 1)
        script.set_global_i(262145 + 30486, 1)
        script.set_global_i(262145 + 30493, 1)
        system.wait(0)
        if not bit.on then return end
    end
    end)

    menu.add_feature("» 暂时解锁未开放的套装", "action", TUNERS_DLC.id, function()
        menu.notify("斯普林克连体衣\nCola降落伞袋\nSprunk降落伞袋\n万圣节降落伞袋\nLos Santos海关T恤\nKnuckleduster T恤\nAmpage T恤", "", 15, 0x64F06414)
        menu.notify("有几件物品已解锁：\n\n临时工作服套装（延迟）\n黑色和蓝色t恤\n Born X凸起黑色、蓝色和白色T恤\n彩色T恤\n棒球球拍T恤\n已阵亡！T恤\nRockstar游戏字体Tee\nSprunk x eCola", "", 15, 0x64F06414)
        script.set_global_i(262145 + 30657, 1)
        script.set_global_i(262145 + 30658, 1)
        script.set_global_i(262145 + 30659, 1)
        script.set_global_i(262145 + 30660, 1)
        script.set_global_i(262145 + 30661, 1)
        script.set_global_i(262145 + 30662, 1)
        script.set_global_i(262145 + 30663, 1)
        script.set_global_i(262145 + 30664, 1)
        script.set_global_i(262145 + 30665, 1)
        script.set_global_i(262145 + 30666, 1)
        script.set_global_i(262145 + 30667, 1)
        script.set_global_i(262145 + 30668, 1)
        script.set_global_i(262145 + 30669, 1)
        script.set_global_i(262145 + 30670, 1)
        script.set_global_i(262145 + 30671, 1)
        script.set_global_i(262145 + 30672, 1)
        script.set_global_i(262145 + 30673, 1)
        script.set_global_i(262145 + 30674, 1)
        script.set_global_i(262145 + 30675, 1)
        script.set_global_i(262145 + 30676, 1)
        script.set_global_i(262145 + 30677, 1)
        script.set_global_i(262145 + 30678, 1)
        script.set_global_i(262145 + 30679, 1)
        script.set_global_i(2595595,0)
    end)
do
    local LS_TUNERS_DLC_BL = {
    {"AWD_CAR_CLUB", true},
    {"AWD_PRO_CAR_EXPORT", true},
    {"AWD_UNION_DEPOSITORY", true},
    {"AWD_MILITARY_CONVOY", true},
    {"AWD_FLEECA_BANK", true},
    {"AWD_FREIGHT_TRAIN", true},
    {"AWD_BOLINGBROKE_ASS", true},
    {"AWD_IAA_RAID", true},
    {"AWD_METH_JOB", true},
    {"AWD_BUNKER_RAID", true},
    {"AWD_STRAIGHT_TO_VIDEO", true},
    {"AWD_MONKEY_C_MONKEY_DO", true},
    {"AWD_TRAINED_TO_KILL", true},
    {"AWD_DIRECTOR", true}
}
local LS_TUNERS_DLC_IT = {
    {"AWD_CAR_CLUB_MEM", 100},
    {"AWD_SPRINTRACER", 50},
    {"AWD_STREETRACER", 50},
    {"AWD_PURSUITRACER", 50},
    {"AWD_TEST_CAR", 240},
    {"AWD_AUTO_SHOP", 50},
    {"AWD_CAR_EXPORT", 100},
    {"AWD_GROUNDWORK", 40},
    {"AWD_ROBBERY_CONTRACT", 100},
    {"AWD_FACES_OF_DEATH", 100}
}
    menu.add_feature("» 解锁奖励", "action", TUNERS_DLC.id, function()
    menu.notify("奖励已解锁", "解锁大师", 4, 257818)
    for i = 1, #LS_TUNERS_DLC_IT do
        stat_set_int(LS_TUNERS_DLC_IT[i][1], true, LS_TUNERS_DLC_IT[i][2])
    for i = 2, #LS_TUNERS_DLC_BL do
        stat_set_bool(LS_TUNERS_DLC_BL[i][1], true, LS_TUNERS_DLC_BL[i][2])
            end
        end
    end)
end

do
local LS_TUNERS_PRIZE_BL = {
    {"CARMEET_PV_CHLLGE_CMPLT", true},
    {"CARMEET_PV_CLMED", false}
}
--local LS_TUNERS_PRICE_IT = {
--   {"CARMEET_PV_CHLLGE_PRGRSS",0},
--   {"CARMEET_PV_CHLLGE_POXIS", -1}
--}
    menu.add_feature("» 解锁汽车批发价", "action", TUNERS_DLC.id, function()
        menu.notify("成功", "解锁大师", 4, 257818)
        for i = 1, #LS_TUNERS_PRIZE_BL do
            stat_set_bool(LS_TUNERS_PRIZE_BL[i][1], true, LS_TUNERS_PRIZE_BL[i][2])
        --for i = 2, #LS_TUNERS_PRICE_IT do
        --  stat_set_int(LS_TUNERS_PRICE_IT[i][1], true, LS_TUNERS_PRICE_IT[i][2])
        end
    --end
end)
end

    menu.add_feature("» 解锁情人节内容", "action", MASTER_UNLOCKR.id, function()
        script.set_global_i(262145+6770,1)
        script.set_global_i(262145+11733,1)
        script.set_global_i(262145+11734,1)
        script.set_global_i(262145+11735,1)
        script.set_global_i(262145+11736,1)
        script.set_global_i(262145+11737,1)
        script.set_global_i(262145+13100,1)
    end)

    menu.add_feature("» 解锁独立日内容", "action", MASTER_UNLOCKR.id, function()
        script.set_global_i(262145+7965,1)
        script.set_global_i(262145+7970,1)
        script.set_global_i(262145+7971,1)
        script.set_global_i(262145+7972,1)
        script.set_global_i(262145+7973,1)
        script.set_global_i(262145+7974,1)
        script.set_global_i(262145+7975,1)
        script.set_global_i(262145+7978,1)
        script.set_global_i(262145+7979,1)
        script.set_global_i(262145+7980,1)
        script.set_global_i(262145+7981,1)
        script.set_global_i(262145+7982,1)
        script.set_global_i(262145+7983,1)
        script.set_global_i(262145+7984,1)
        script.set_global_i(262145+7985,1)
        script.set_global_i(262145+7986,1)
        script.set_global_i(262145+7987,1)
        script.set_global_i(262145+7988,1)
        script.set_global_i(262145+7989,1)
        script.set_global_i(262145+7990,1)
        script.set_global_i(262145+7991,1)
        script.set_global_i(262145+7992,1)
        script.set_global_i(262145+7993,1)
        script.set_global_i(262145+7994,1)
        script.set_global_i(262145+7995,1)
        script.set_global_i(262145+8003,1) -- from now not related to independence
        script.set_global_i(262145+8004,1)
        script.set_global_i(262145+8005,1)
        script.set_global_i(262145+8006,1)
        script.set_global_i(262145+8007,1)
        script.set_global_i(262145+8008,1)
        script.set_global_i(262145+8009,1)
end)

    menu.add_feature("» 解锁万圣节内容", "action", MASTER_UNLOCKR.id, function()
        script.set_global_i(262145+11699,1) --turn on
        script.set_global_i(262145+11747,1)
        script.set_global_i(262145+11747,1)
        script.set_global_i(262145+11739,1)
        script.set_global_i(262145+11744,1)
        script.set_global_i(262145+11745,1)
        script.set_global_i(262145+11746,1)
        script.set_global_i(262145+11748,1)
        script.set_global_i(262145+11749,1)
        script.set_global_i(262145+11750,1)
        script.set_global_i(262145+11754,1)
        script.set_global_i(262145+11755,1)
        script.set_global_i(262145+11756,1)
        script.set_global_i(262145+11762,1)
        script.set_global_i(262145+12405,1)
        script.set_global_i(262145+17200,1)
        script.set_global_i(262145+12266,1)
        script.set_global_i(262145+12267,1)
        script.set_global_i(262145+12268,1)
        script.set_global_i(262145+12269,1)
        script.set_global_i(262145+12270,1)
        script.set_global_i(262145+12271,1)
        script.set_global_i(262145+12272,1)
        script.set_global_i(262145+12273,1)
        script.set_global_i(262145+12274,1)
        script.set_global_i(262145+12275,1)
        script.set_global_i(262145+12276,1)
        script.set_global_i(262145+12277,1)
        script.set_global_i(262145+12278,1)
        script.set_global_i(262145+12279,1)
        script.set_global_i(262145+12280,1)
        script.set_global_i(262145+12281,1)
        script.set_global_i(262145+12282,1)
        script.set_global_i(262145+12283,1)
        script.set_global_i(262145+12284,1)
        script.set_global_i(262145+12285,1)
        script.set_global_i(262145+12286,1)
        script.set_global_i(262145+12287,1)
    end)

    menu.add_feature("» 解锁回归玩家奖励+原子能枪奖励", "action", MASTER_UNLOCKR.id,function()
        script.set_global_i(151130,2)
        script.set_global_i(102284,90)
        script.set_global_i(102285,1)
    end)

    menu.add_feature("» 佩里科岛奖励解锁", "action", MASTER_UNLOCKR.id, function()
    menu.notify("这些物品将在商店中解锁以供购买\n\n衬衫\n围巾\n编织者\n卡普斯\n低眼镜\n低项链\n特殊眼镜\nDJ T恤", "解锁大师", 5, 0x64F06414)
        -- T-shirts/Jackets/Sweaters
    script.set_global_i(262145 + 29688, 1)
    script.set_global_i(262145 + 29689, 1)
    script.set_global_i(262145 + 29690, 1)
    script.set_global_i(262145 + 29691, 1)
    script.set_global_i(262145 + 29692, 1)
    script.set_global_i(262145 + 29693, 1)
    script.set_global_i(262145 + 29694, 1)
    script.set_global_i(262145 + 29695, 1)
    script.set_global_i(262145 + 29696, 1)
    script.set_global_i(262145 + 29697, 1)
    script.set_global_i(262145 + 29698, 1)
    script.set_global_i(262145 + 29699, 1)
    script.set_global_i(262145 + 29700, 1)
    script.set_global_i(262145 + 29701, 1)
    script.set_global_i(262145 + 29702, 1)
    script.set_global_i(262145 + 29703, 1)
    script.set_global_i(262145 + 29704, 1)
    script.set_global_i(262145 + 29705, 1)
    script.set_global_i(262145 + 29706, 1)
    script.set_global_i(262145 + 29707, 1)
    -- Shorts
    script.set_global_i(262145 + 29708, 1)
    script.set_global_i(262145 + 29709, 1)
    script.set_global_i(262145 + 29710, 1)
    script.set_global_i(262145 + 29711, 1)
    -- Caps
    script.set_global_i(262145 + 29712, 1)
    script.set_global_i(262145 + 29713, 1)
    script.set_global_i(262145 + 29714, 1)
    script.set_global_i(262145 + 29715, 1)
    script.set_global_i(262145 + 29716, 1)
            -- Glow bracelets
    script.set_global_i(262145 + 29717, 1)
    script.set_global_i(262145 + 29718, 1)
    script.set_global_i(262145 + 29719, 1)
    script.set_global_i(262145 + 29720, 1)
    script.set_global_i(262145 + 29721, 1)
    script.set_global_i(262145 + 29722, 1)
    script.set_global_i(262145 + 29723, 1)
    script.set_global_i(262145 + 29724, 1)
    script.set_global_i(262145 + 29725, 1)
    script.set_global_i(262145 + 29726, 1)
    script.set_global_i(262145 + 29727, 1)
    script.set_global_i(262145 + 29728, 1)
            -- Glow glasses
    script.set_global_i(262145 + 29729, 1)
    script.set_global_i(262145 + 29730, 1)
    script.set_global_i(262145 + 29731, 1)
    script.set_global_i(262145 + 29732, 1)
    script.set_global_i(262145 + 29733, 1)
    script.set_global_i(262145 + 29734, 1)
    script.set_global_i(262145 + 29735, 1)
    script.set_global_i(262145 + 29736, 1)
    script.set_global_i(262145 + 29737, 1)
    script.set_global_i(262145 + 29738, 1)
    script.set_global_i(262145 + 29739, 1)
    script.set_global_i(262145 + 29740, 1)
    -- Glow necklaces
    script.set_global_i(262145 + 29741, 1)
    script.set_global_i(262145 + 29742, 1)
    script.set_global_i(262145 + 29743, 1)
    script.set_global_i(262145 + 29744, 1)
    script.set_global_i(262145 + 29745, 1)
    script.set_global_i(262145 + 29746, 1)
    script.set_global_i(262145 + 29747, 1)
    script.set_global_i(262145 + 29748, 1)
    script.set_global_i(262145 + 29749, 1)
    script.set_global_i(262145 + 29750, 1)
    script.set_global_i(262145 + 29751, 1)
    script.set_global_i(262145 + 29752, 1)
    script.set_global_i(262145 + 29753, 1)
    script.set_global_i(262145 + 29754, 1)
    script.set_global_i(262145 + 29755, 1)
    script.set_global_i(262145 + 29756, 1)
            -- Full head masks
    script.set_global_i(262145 + 29761, 1)
    script.set_global_i(262145 + 29762, 1)
    script.set_global_i(262145 + 29763, 1)
    script.set_global_i(262145 + 29764, 1)
    script.set_global_i(262145 + 29765, 1)
    script.set_global_i(262145 + 29766, 1)
    script.set_global_i(262145 + 29767, 1)
    script.set_global_i(262145 + 29768, 1)
    script.set_global_i(262145 + 29769, 1)
    script.set_global_i(262145 + 29770, 1)
    script.set_global_i(262145 + 29771, 1)
    script.set_global_i(262145 + 29772, 1)
    script.set_global_i(262145 + 29773, 1)
    script.set_global_i(262145 + 29774, 1)
    script.set_global_i(262145 + 29775, 1)
    script.set_global_i(262145 + 29776, 1)
    script.set_global_i(262145 + 29777, 1)
    script.set_global_i(262145 + 29778, 1)
    script.set_global_i(262145 + 29779, 1)
    script.set_global_i(262145 + 29780, 1)
            -- Special glasses
    script.set_global_i(262145 + 30345, 1)
    script.set_global_i(262145 + 30346, 1)
    script.set_global_i(262145 + 30347, 1)
    script.set_global_i(262145 + 30348, 1)
    script.set_global_i(262145 + 30349, 1)
    script.set_global_i(262145 + 30350, 1)
    script.set_global_i(262145 + 30351, 1)
    script.set_global_i(262145 + 30352, 1)
    script.set_global_i(262145 + 30353, 1)
    script.set_global_i(262145 + 30354, 1)
    script.set_global_i(262145 + 30355, 1)
    script.set_global_i(262145 + 30356, 1)
    script.set_global_i(262145 + 30357, 1)
    script.set_global_i(262145 + 30358, 1)
    script.set_global_i(262145 + 30359, 1)
    script.set_global_i(262145 + 30360, 1)
    script.set_global_i(262145 + 30361, 1)
    script.set_global_i(262145 + 30362, 1)
    script.set_global_i(262145 + 30363, 1)
    script.set_global_i(262145 + 30364, 1)
    script.set_global_i(262145 + 30365, 1)
    script.set_global_i(262145 + 30366, 1)
    script.set_global_i(262145 + 30367, 1)
    script.set_global_i(262145 + 30368, 1)
    script.set_global_i(262145 + 30369, 1)
    script.set_global_i(262145 + 30370, 1)
    script.set_global_i(262145 + 30371, 1)
    script.set_global_i(262145 + 30372, 1)
    script.set_global_i(262145 + 30373, 1)
    script.set_global_i(262145 + 30374, 1)
    script.set_global_i(262145 + 30375, 1)
    script.set_global_i(262145 + 30376, 1)
    script.set_global_i(262145 + 30377, 1)
    script.set_global_i(262145 + 30378, 1)
    script.set_global_i(262145 + 30379, 1)
    script.set_global_i(262145 + 30380, 1)
            -- DJ's T-shirts
    script.set_global_i(262145 + 30390, 1)
    script.set_global_i(262145 + 30391, 1)
    script.set_global_i(262145 + 30392, 1)
    script.set_global_i(262145 + 30393, 1)
    script.set_global_i(262145 + 30394, 1)
    script.set_global_i(262145 + 30395, 1)
end)

local XMAS_FEATURES = menu.add_feature("» 圣诞节相关", "parent", MASTER_UNLOCKR.id)
do
local ML_UNLK_XMAS = {
    {"MPPLY_XMASLIVERIES0", 2147483647},
    {"MPPLY_XMASLIVERIES1", 2147483647},
    {"MPPLY_XMASLIVERIES2", 2147483647},
    {"MPPLY_XMASLIVERIES3", 2147483647},
    {"MPPLY_XMASLIVERIES4", 2147483647},
    {"MPPLY_XMASLIVERIES5", 2147483647},
    {"MPPLY_XMASLIVERIES6", 2147483647},
    {"MPPLY_XMASLIVERIES7", 2147483647},
    {"MPPLY_XMASLIVERIES8", 2147483647},
    {"MPPLY_XMASLIVERIES9", 2147483647},
    {"MPPLY_XMASLIVERIES10", 2147483647},
    {"MPPLY_XMASLIVERIES11", 2147483647},
    {"MPPLY_XMASLIVERIES12", 2147483647},
    {"MPPLY_XMASLIVERIES13", 2147483647},
    {"MPPLY_XMASLIVERIES14", 2147483647},
    {"MPPLY_XMASLIVERIES15", 2147483647},
    {"MPPLY_XMASLIVERIES16", 2147483647},
    {"MPPLY_XMASLIVERIES17", 2147483647},
    {"MPPLY_XMASLIVERIES18", 2147483647},
    {"MPPLY_XMASLIVERIES19", 2147483647},
    {"MPPLY_XMASLIVERIES20", 2147483647}
}
    menu.add_feature("» 解锁圣诞涂装", "action", XMAS_FEATURES.id, function()
    menu.notify("所有圣诞涂装已解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #ML_UNLK_XMAS do
            stat_set_int(ML_UNLK_XMAS[i][1], false, ML_UNLK_XMAS[i][2])
        end
    end)

    menu.add_feature("» 解锁圣诞节内容", "action", XMAS_FEATURES.id, function()
        script.set_global_i(262145+12414,1)
        script.set_global_i(262145+12416,1)
        script.set_global_i(262145+25334,1)
        script.set_global_i(262145+25335,1)
        script.set_global_i(262145 + 9154,1)
        script.set_global_i(262145 + 9155,1)
        script.set_global_i(262145 + 9156,1)
        script.set_global_i(262145 + 12413,1)
        script.set_global_i(262145 + 23092,1)
        script.set_global_i(262145 + 23093,1)
        script.set_global_i(262145 + 23094,1)
        script.set_global_i(262145 + 23095,1)
        script.set_global_i(262145 + 4735,1)
        script.set_global_i(262145 + 8891,1)
        script.set_global_i(262145 + 9098,0)
        script.set_global_i(262145 + 9099,0)
        script.set_global_i(262145 + 9100,0)
        script.set_global_i(262145 + 9101,0)
        script.set_global_i(262145 + 9102,0)
        script.set_global_i(262145 + 9103,0)
        script.set_global_i(262145 + 9104,0) 
        script.set_global_i(262145 + 9106,1)
        script.set_global_i(262145 + 9107,1)
        script.set_global_i(262145 + 9108,1)
        script.set_global_i(262145 + 9109,1)
        script.set_global_i(262145 + 9110,1)
        script.set_global_i(262145 + 9111,1)
        script.set_global_i(262145 + 9112,1)
        script.set_global_i(262145 + 9113,1)
        script.set_global_i(262145 + 9114,1)
        script.set_global_i(262145 + 9115,1)
        script.set_global_i(262145 + 9116,1)
        script.set_global_i(262145 + 9117,1)
        script.set_global_i(262145 + 9118,1)
        script.set_global_i(262145 + 9119,1)
        script.set_global_i(262145 + 9120,1)
        script.set_global_i(262145 + 9121,1)
        script.set_global_i(262145 + 9122,1)
        script.set_global_i(262145 + 9123,1)
        script.set_global_i(262145 + 9124,1)
        script.set_global_i(262145 + 9125,1)
        script.set_global_i(262145 + 9126,1)
        script.set_global_i(262145 + 9127,1)
        script.set_global_i(262145 + 9128,1)
        script.set_global_i(262145 + 9129,1)
        script.set_global_i(262145 + 9130,1)
        script.set_global_i(262145 + 9131,1)
        script.set_global_i(262145 + 9132,1)
        script.set_global_i(262145 + 9133,1)
        script.set_global_i(262145 + 9134,1)
        script.set_global_i(262145 + 9135,1)
        script.set_global_i(262145 + 9136,1)
        script.set_global_i(262145 + 9137,1)
        script.set_global_i(262145 + 9138,1)
        script.set_global_i(262145 + 9139,1)
        script.set_global_i(262145 + 9140,1)
        script.set_global_i(262145 + 9141,1)
        script.set_global_i(262145 + 9142,1)
        script.set_global_i(262145 + 9143,1)
        script.set_global_i(262145 + 9144,1)
        script.set_global_i(262145 + 9145,1)
        script.set_global_i(262145 + 9146,1)
        script.set_global_i(262145 + 9147,1)
        script.set_global_i(262145 + 9148,1)
        script.set_global_i(262145 + 9149,1)
        script.set_global_i(262145 + 9150,1)
        script.set_global_i(262145 + 9151,1)
        script.set_global_i(262145 + 9152,1)
        script.set_global_i(262145 + 9153,1)
        script.set_global_i(262145 + 12519,1) -- from 2105
        script.set_global_i(262145 + 12520,1) -- from 2105
        script.set_global_i(262145 + 12521,1)
        script.set_global_i(262145 + 12522,1)
        script.set_global_i(262145 + 18822,1) -- from 2016
        script.set_global_i(262145 + 18823,1)
        script.set_global_i(262145 + 18824,1)
        script.set_global_i(262145 + 18825,1)
        script.set_global_i(262145 + 23113,1) -- from 2017
        script.set_global_i(262145 + 23114,1)
        script.set_global_i(262145 + 23115,1)
        script.set_global_i(262145 + 23116,1)
        script.set_global_i(262145 + 25337,1) -- from 2018
        script.set_global_i(262145 + 25338,1)
        script.set_global_i(262145 + 25339,1)
        script.set_global_i(262145 + 25340,1)
        script.set_global_i(262145 + 28188,1) -- from 2019
        script.set_global_i(262145 + 28189,1)
        script.set_global_i(262145 + 28190,1)
        script.set_global_i(262145 + 28191,1)
        script.set_global_i(262145 + 30381,1) -- from 2020
    end)
end

menu.add_feature("» 解锁帽子、T恤和衬衫", "action", MASTER_UNLOCKR.id, function(hats)
    script.set_global_i(262145 + 12294,1)
    script.set_global_i(262145 + 12295,1)
    script.set_global_i(262145 + 12296,1)
    script.set_global_i(262145 + 12297,1)
    script.set_global_i(262145 + 12298,1)
    script.set_global_i(262145 + 12299,1)
    script.set_global_i(262145 + 12300,1)
    script.set_global_i(262145 + 12301,1)
    script.set_global_i(262145 + 12302,1)
    script.set_global_i(262145 + 12303,1)
    --
    script.set_global_i(262145 + 14885,1)
    script.set_global_i(262145 + 14886,1)
    script.set_global_i(262145 + 14887,1)
    script.set_global_i(262145 + 14888,1)
    script.set_global_i(262145 + 14889,1)
    script.set_global_i(262145 + 14890,1)
    script.set_global_i(262145 + 14891,1)
    script.set_global_i(262145 + 14892,1)
    script.set_global_i(262145 + 14893,1)
    script.set_global_i(262145 + 14894,1)
    script.set_global_i(262145 + 14895,1)
    script.set_global_i(262145 + 14896,1)
    script.set_global_i(262145 + 14897,1)
    script.set_global_i(262145 + 14898,1)
    script.set_global_i(262145 + 14899,1)
    script.set_global_i(262145 + 23885,1)
    script.set_global_i(262145 + 23885,1)
    script.set_global_i(262145 + 23886,1)
    script.set_global_i(262145 + 23887,1)
    script.set_global_i(262145 + 23888,1)
    script.set_global_i(262145 + 23889,1)
    script.set_global_i(262145 + 23890,1)
    script.set_global_i(262145 + 23893,1)
    script.set_global_i(262145 + 23895,1)
    script.set_global_i(262145 + 23898,1)
    --
    script.set_global_i(262145 + 23901,1)
    script.set_global_i(262145 + 23902,1)
    script.set_global_i(262145 + 23903,1)
    script.set_global_i(262145 + 23904,1)
    script.set_global_i(262145 + 23905,1)
    script.set_global_i(262145 + 23906,1)
    script.set_global_i(262145 + 23907,1)
    script.set_global_i(262145 + 23908,1)
    script.set_global_i(262145 + 23909,1)
    script.set_global_i(262145 + 23910,1)
    --
    script.set_global_i(262145 + 17244,1)
    script.set_global_i(262145 + 17245,1)
    script.set_global_i(262145 + 17246,1)
    script.set_global_i(262145 + 17247,1)
    script.set_global_i(262145 + 17248,1)
    script.set_global_i(262145 + 17249,1)
    script.set_global_i(262145 + 17250,1)
    script.set_global_i(262145 + 17251,1)
    script.set_global_i(262145 + 17252,1)
    script.set_global_i(262145 + 17253,1)
    script.set_global_i(262145 + 17254,1)
    script.set_global_i(262145 + 17255,1)
    script.set_global_i(262145 + 17256,1)
    script.set_global_i(262145 + 17257,1)
    script.set_global_i(262145 + 17258,1)
    script.set_global_i(262145 + 17259,1)
    script.set_global_i(262145 + 17260,1)
    script.set_global_i(262145 + 17261,1)
    script.set_global_i(262145 + 17262,1)
    script.set_global_i(262145 + 17263,1)
    script.set_global_i(262145 + 17264,1)
    script.set_global_i(262145 + 17265,1)
    --
    script.set_global_i(262145 + 11658,1)
    script.set_global_i(262145 + 11659,1)
    script.set_global_i(262145 + 11660,1)
    script.set_global_i(262145 + 11661,1)
    script.set_global_i(262145 + 11662,1)
    script.set_global_i(262145 + 11663,1)
    script.set_global_i(262145 + 11664,1)
    script.set_global_i(262145 + 11665,1)
    script.set_global_i(262145 + 11666,1)
    script.set_global_i(262145 + 11667,1)
    script.set_global_i(262145 + 12304,1)
    script.set_global_i(262145 + 12305,1)
    script.set_global_i(262145 + 12306,1)
    script.set_global_i(262145 + 12307,1)
    script.set_global_i(262145 + 12308,1)
    script.set_global_i(262145 + 12309,1)
    script.set_global_i(262145 + 12310,1)
    script.set_global_i(262145 + 12311,1)
    script.set_global_i(262145 + 12312,1)
    script.set_global_i(262145 + 12313,1)
    script.set_global_i(262145 + 12314,1)
    script.set_global_i(262145 + 12315,1)
    script.set_global_i(262145 + 12316,1)
    --
    script.set_global_i(262145 + 23884,1)
    script.set_global_i(262145 + 23889,1)
    script.set_global_i(262145 + 23891,1)
    script.set_global_i(262145 + 23892,1)
    script.set_global_i(262145 + 23893,1)
    script.set_global_i(262145 + 23894,1)
    script.set_global_i(262145 + 23895,1)
    script.set_global_i(262145 + 23896,1)
    script.set_global_i(262145 + 23897,1)
    script.set_global_i(262145 + 24409,1)
    script.set_global_i(262145 + 24410,1)
    script.set_global_i(262145 + 24411,1)
    script.set_global_i(262145 + 24412,1)
    script.set_global_i(262145 + 24413,1)
    script.set_global_i(262145 + 24414,1)
    script.set_global_i(262145 + 24415,1)
    script.set_global_i(262145 + 24416,1)
    script.set_global_i(262145 + 24417,1)
    script.set_global_i(262145 + 24418,1) 
    script.set_global_i(262145 + 24419,1)
    script.set_global_i(262145 + 24420,1)
    script.set_global_i(262145 + 24421,1)
    script.set_global_i(262145 + 24422,1)
    script.set_global_i(262145 + 24423,1)
    script.set_global_i(262145 + 24424,1)
    script.set_global_i(262145 + 24425,1)
    script.set_global_i(262145 + 24426,1)
    script.set_global_i(262145 + 24427,1)
    script.set_global_i(262145 + 24428,1)
    --
    script.set_global_i(262145 + 24585,1)
    script.set_global_i(262145 + 24586,1)
    script.set_global_i(262145 + 24587,1)
    script.set_global_i(262145 + 24588,1)
    script.set_global_i(262145 + 24589,1)
    script.set_global_i(262145 + 24590,1)
    script.set_global_i(262145 + 24591,1)
    script.set_global_i(262145 + 24592,1)
    script.set_global_i(262145 + 24593,1)
    script.set_global_i(262145 + 24594,1)
    script.set_global_i(262145 + 24595,1)
    script.set_global_i(262145 + 24596,1)
    script.set_global_i(262145 + 24597,1)
    script.set_global_i(262145 + 24598,1)
    script.set_global_i(262145 + 24599,1)
    script.set_global_i(262145 + 24600,1)
    script.set_global_i(262145 + 24601,1)
    script.set_global_i(262145 + 24602,1)
    script.set_global_i(262145 + 24603,1)
    script.set_global_i(262145 + 24604,1)
    script.set_global_i(262145 + 24605,1)
    script.set_global_i(262145 + 24606,1)
    script.set_global_i(262145 + 24607,1)
    --
    script.set_global_i(262145 + 20816,1)
    script.set_global_i(262145 + 20820,1)
    script.set_global_i(262145 + 20823,1)
    script.set_global_i(262145 + 20825,1)
    script.set_global_i(262145 + 20830,1)
    script.set_global_i(262145 + 20832,1)
    script.set_global_i(262145 + 20836,1)
    script.set_global_i(262145 + 20839,1)
    --
    script.set_global_i(262145 + 20817,1)
    script.set_global_i(262145 + 20819,1)
    script.set_global_i(262145 + 20821,1)
    script.set_global_i(262145 + 20822,1)
    script.set_global_i(262145 + 20826,1)
    script.set_global_i(262145 + 20829,1)
    script.set_global_i(262145 + 20831,1)
    script.set_global_i(262145 + 20833,1)
    script.set_global_i(262145 + 20834,1)
    script.set_global_i(262145 + 20837,1)
    script.set_global_i(262145 + 20841,1)
    script.set_global_i(262145 + 20842,1)
    script.set_global_i(262145 + 20843,1)
    script.set_global_i(262145 + 20844,1)
    script.set_global_i(262145 + 20845,1)
    script.set_global_i(262145 + 20846,1)
    script.set_global_i(262145 + 20847,1)
    script.set_global_i(262145 + 20848,1)
    script.set_global_i(262145 + 20849,1)
    script.set_global_i(262145 + 20850,1)
    script.set_global_i(262145 + 20851,1)
    script.set_global_i(262145 + 20852,1)
    script.set_global_i(262145 + 20853,1)
    script.set_global_i(262145 + 20290,1)
    --
    script.set_global_i(262145 + 23087,1)
    script.set_global_i(262145 + 23088,1)
    script.set_global_i(262145 + 23089,1)
    script.set_global_i(262145 + 23090,1)
    script.set_global_i(262145 + 23091,1)
    --
    script.set_global_i(262145 + 16503,1)
    script.set_global_i(262145 + 16504,1)
    script.set_global_i(262145 + 16505,1)
    script.set_global_i(262145 + 16506,1)
    script.set_global_i(262145 + 16507,1)
    script.set_global_i(262145 + 16508,1)
    script.set_global_i(262145 + 16509,1)
    --
    script.set_global_i(262145 + 25409,1)
    script.set_global_i(262145 + 25410,1)
    script.set_global_i(262145 + 25411,1)
    script.set_global_i(262145 + 25412,1)
    script.set_global_i(262145 + 25413,1)
    script.set_global_i(262145 + 25414,1)
    script.set_global_i(262145 + 25415,1)
    script.set_global_i(262145 + 25416,1)
    script.set_global_i(262145 + 25417,1)
    script.set_global_i(262145 + 25418,1)
    -- CASINO SHIRT
    script.set_global_i(262145 + 26525,1)
    script.set_global_i(262145 + 26526,1)
    script.set_global_i(262145 + 26527,1)
    script.set_global_i(262145 + 26528,1)
    script.set_global_i(262145 + 26529,1)
    script.set_global_i(262145 + 26530,1)
    script.set_global_i(262145 + 26531,1)
end)

do
local INVTRY_FLL = {
    {"NO_BOUGHT_YUM_SNACKS", 30},
    {"NO_BOUGHT_HEALTH_SNACKS", 15},
    {"NO_BOUGHT_EPIC_SNACKS", 5},
    {"NUMBER_OF_ORANGE_BOUGHT", 10},
    {"NUMBER_OF_BOURGE_BOUGHT", 10},
    {"NUMBER_OF_CHAMP_BOUGHT", 5},
    {"CIGARETTES_BOUGHT", 20},
    {"MP_CHAR_ARMOUR_1_COUNT", 10},
    {"MP_CHAR_ARMOUR_2_COUNT", 10},
    {"MP_CHAR_ARMOUR_3_COUNT", 10},
    {"MP_CHAR_ARMOUR_4_COUNT", 10},
    {"MP_CHAR_ARMOUR_5_COUNT", 10},
    {"BREATHING_APPAR_BOUGHT,", 20}
}
    menu.add_feature("» 一键补充零食、护甲", "action", MASTER_UNLOCKR.id, function()
    menu.notify("补充完成", "解锁大师", 3, 0x64F06414)
        for i = 1, #INVTRY_FLL do
        stat_set_int(INVTRY_FLL[i][1], true, INVTRY_FLL[i][2])
        end
    end)
end

local ARENA_TOOL = menu.add_feature("» 竞技场战争 DLC", "parent", MASTER_UNLOCKR.id)

do
local ARENA_W_UNLK = {
    {"ARN_BS_TRINKET_TICKERS", -1},
    {"ARN_BS_TRINKET_SAVED", -1},
    {"AWD_WATCH_YOUR_STEP", 50},
    {"AWD_TOWER_OFFENSE", 50},
    {"AWD_READY_FOR_WAR", 50},
    {"AWD_THROUGH_A_LENS", 50},
    {"AWD_SPINNER", 50},
    {"AWD_YOUMEANBOOBYTRAPS", 50},
    {"AWD_MASTER_BANDITO", 50},
    {"AWD_SITTING_DUCK", 50},
    {"AWD_CROWDPARTICIPATION", 50},
    {"AWD_KILL_OR_BE_KILLED", 50},
    {"AWD_MASSIVE_SHUNT", 50},
    {"AWD_YOURE_OUTTA_HERE", 200},
    {"AWD_WEVE_GOT_ONE", 50},
    {"AWD_ARENA_WAGEWORKER", 1000000},
    {"AWD_TIME_SERVED", 1000},
    {"AWD_TOP_SCORE", 55000},
    {"AWD_CAREER_WINNER", 1000},
    {"ARENAWARS_SP", 209},
    {"ARENAWARS_SKILL_LEVEL", 20},
    {"ARENAWARS_SP_LIFETIME", 209},
    {"ARENAWARS_AP_TIER", 1000},
    {"ARENAWARS_AP_LIFETIME", 47551850},
    {"ARENAWARS_CARRER_UNLK", 44},
    {"ARN_W_THEME_SCIFI", 1000},
    {"ARN_W_THEME_APOC", 1000},
    {"ARN_W_THEME_CONS", 1000},
    {"ARN_W_PASS_THE_BOMB", 1000},
    {"ARN_W_DETONATION", 1000},
    {"ARN_W_ARCADE_RACE", 1000},
    {"ARN_W_CTF", 1000},
    {"ARN_W_TAG_TEAM", 1000},
    {"ARN_W_DESTR_DERBY", 1000},
    {"ARN_W_CARNAGE", 1000},
    {"ARN_W_MONSTER_JAM", 1000},
    {"ARN_W_GAMES_MASTERS", 1000},
    {"ARN_L_PASS_THE_BOMB", 500},
    {"ARN_L_DETONATION", 500},
    {"ARN_L_ARCADE_RACE", 500},
    {"ARN_L_CTF", 500},
    {"ARN_L_TAG_TEAM", 500},
    {"ARN_L_DESTR_DERBY", 500},
    {"ARN_L_CARNAGE", 500},
    {"ARN_L_MONSTER_JAM", 500},
    {"ARN_L_GAMES_MASTERS", 500},
    {"NUMBER_OF_CHAMP_BOUGHT", 1000},
    {"ARN_SPECTATOR_KILLS", 1000},
    {"ARN_LIFETIME_KILLS", 1000},
    {"ARN_LIFETIME_DEATHS", 500},
    {"ARENAWARS_CARRER_WINS", 1000},
    {"ARENAWARS_CARRER_WINT", 1000},
    {"ARENAWARS_MATCHES_PLYD", 1000},
    {"ARENAWARS_MATCHES_PLYDT", 1000},
    {"ARN_SPEC_BOX_TIME_MS", 86400000},
    {"ARN_SPECTATOR_DRONE", 1000},
    {"ARN_SPECTATOR_CAMS", 1000},
    {"ARN_SMOKE", 1000},
    {"ARN_DRINK", 1000},
    {"ARN_VEH_MONSTER", 31000},
    {"ARN_VEH_MONSTER", 41000},
    {"ARN_VEH_MONSTER", 51000},
    {"ARN_VEH_CERBERUS", 1000},
    {"ARN_VEH_CERBERUS2", 1000},
    {"ARN_VEH_CERBERUS3", 1000},
    {"ARN_VEH_BRUISER", 1000},
    {"ARN_VEH_BRUISER2", 1000},
    {"ARN_VEH_BRUISER3", 1000},
    {"ARN_VEH_SLAMVAN4", 1000},
    {"ARN_VEH_SLAMVAN5", 1000},
    {"ARN_VEH_SLAMVAN6", 1000},
    {"ARN_VEH_BRUTUS", 1000},
    {"ARN_VEH_BRUTUS2", 1000},
    {"ARN_VEH_BRUTUS3", 1000},
    {"ARN_VEH_SCARAB", 1000},
    {"ARN_VEH_SCARAB2", 1000},
    {"ARN_VEH_SCARAB3", 1000},
    {"ARN_VEH_DOMINATOR4", 1000},
    {"ARN_VEH_DOMINATOR5", 1000},
    {"ARN_VEH_DOMINATOR6", 1000},
    {"ARN_VEH_IMPALER2", 1000},
    {"ARN_VEH_IMPALER3", 1000},
    {"ARN_VEH_IMPALER4", 1000},
    {"ARN_VEH_ISSI4", 1000},
    {"ARN_VEH_ISSI5", 1000},
    {"ARN_VEH_ISSI", 61000},
    {"ARN_VEH_IMPERATOR", 1000},
    {"ARN_VEH_IMPERATOR2", 1000},
    {"ARN_VEH_IMPERATOR3", 1000},
    {"ARN_VEH_ZR380", 1000},
    {"ARN_VEH_ZR3802", 1000},
    {"ARN_VEH_ZR3803", 1000},
    {"ARN_VEH_DEATHBIKE", 1000},
    {"ARN_VEH_DEATHBIKE2", 1000},
    {"ARN_VEH_DEATHBIKE3", 1000}
}
local ARENA_W_UNLK_BL = {
    {"AWD_BEGINNER", true},
    {"AWD_FIELD_FILLER", true},
    {"AWD_ARMCHAIR_RACER", true},
    {"AWD_LEARNER", true},
    {"AWD_SUNDAY_DRIVER", true},
    {"AWD_THE_ROOKIE", true},
    {"AWD_BUMP_AND_RUN", true},
    {"AWD_GEAR_HEAD", true},
    {"AWD_DOOR_SLAMMER", true},
    {"AWD_HOT_LAP", true},
    {"AWD_ARENA_AMATEUR", true},
    {"AWD_PAINT_TRADER", true},
    {"AWD_SHUNTER", true},
    {"AWD_JOCK", true},
    {"AWD_WARRIOR", true},
    {"AWD_T_BONE", true},
    {"AWD_MAYHEM", true},
    {"AWD_WRECKER", true},
    {"AWD_CRASH_COURSE", true},
    {"AWD_ARENA_LEGEND", true},
    {"AWD_PEGASUS", true},
    {"AWD_UNSTOPPABLE", true},
    {"AWD_CONTACT_SPORT", true}
}
    menu.add_feature("» 解锁所有竞技场战争奖杯和手办", "action", ARENA_TOOL.id, function()
    menu.notify("解锁成功", "解锁大师", 3, 0x6400FA14)
        for i = 1, #ARENA_W_UNLK do
        stat_set_int(ARENA_W_UNLK[i][1], true, ARENA_W_UNLK[i][2])
        for i = 2, #ARENA_W_UNLK_BL do
        stat_set_bool(ARENA_W_UNLK_BL[i][1], true, ARENA_W_UNLK_BL[i][2])
        stat_set_bool(ARENA_W_UNLK_BL[i][1], false, ARENA_W_UNLK_BL[i][2])
        end
        end
    end)

    menu.add_feature("» 竞技场战争套装", "action", ARENA_TOOL.id, function()
        script.set_global_i(262145 + 25341,1)
        script.set_global_i(262145 + 25342,1)
        script.set_global_i(262145 + 25341,1)
        script.set_global_i(262145 + 25342,1)
        script.set_global_i(262145 + 25343,1)
        script.set_global_i(262145 + 25344,1)
        script.set_global_i(262145 + 25345,1)
        script.set_global_i(262145 + 25346,1)
        script.set_global_i(262145 + 25347,1)
        script.set_global_i(262145 + 25348,1)
        script.set_global_i(262145 + 25349,1)
        script.set_global_i(262145 + 25350,1)
        script.set_global_i(262145 + 25351,1)
        script.set_global_i(262145 + 25352,1)
        script.set_global_i(262145 + 25353,1)
        script.set_global_i(262145 + 25354,1)
        script.set_global_i(262145 + 25355,1)
        script.set_global_i(262145 + 25356,1)
        script.set_global_i(262145 + 25357,1)
        script.set_global_i(262145 + 25358,1)
        script.set_global_i(262145 + 25359,1)
        script.set_global_i(262145 + 25360,1)
        script.set_global_i(262145 + 25361,1)
        script.set_global_i(262145 + 25362,1)
        script.set_global_i(262145 + 25363,1)
        script.set_global_i(262145 + 25364,1)
        script.set_global_i(262145 + 25365,1)
        script.set_global_i(262145 + 25366,1)
        script.set_global_i(262145 + 25367,1)
        script.set_global_i(262145 + 25368,1)
        script.set_global_i(262145 + 25369,1)
        script.set_global_i(262145 + 25370,1)       
        script.set_global_i(262145 + 25371,1)
        script.set_global_i(262145 + 25372,1)
        script.set_global_i(262145 + 25373,1)
        script.set_global_i(262145 + 25374,1)
        script.set_global_i(262145 + 25375,1)
        script.set_global_i(262145 + 25376,1)
        script.set_global_i(262145 + 25377,1)
        script.set_global_i(262145 + 25378,1)
        script.set_global_i(262145 + 25379,1)
        script.set_global_i(262145 + 25380,1)
        script.set_global_i(262145 + 25381,1)
        script.set_global_i(262145 + 25382,1)
        script.set_global_i(262145 + 25383,1)
        script.set_global_i(262145 + 25384,1)
        script.set_global_i(262145 + 25385,1)
        script.set_global_i(262145 + 25386,1)
        script.set_global_i(262145 + 25387,1)
        script.set_global_i(262145 + 25388,1)
        script.set_global_i(262145 + 25389,1)
        script.set_global_i(262145 + 25390,1)
        script.set_global_i(262145 + 25391,1)
        script.set_global_i(262145 + 25392,1)
        script.set_global_i(262145 + 25393,1)
        script.set_global_i(262145 + 25394,1)
        script.set_global_i(262145 + 25395,1)
        script.set_global_i(262145 + 25396,1)
        script.set_global_i(262145 + 25397,1)
        script.set_global_i(262145 + 25398,1)
        script.set_global_i(262145 + 25399,1)
        script.set_global_i(262145 + 25400,1)
        script.set_global_i(262145 + 25401,1)
        script.set_global_i(262145 + 25402,1)
        script.set_global_i(262145 + 25403,1)
        script.set_global_i(262145 + 25404,1)
        script.set_global_i(262145 + 25405,1)
        script.set_global_i(262145 + 25406,1)
        script.set_global_i(262145 + 25407,1)
        script.set_global_i(262145 + 25408,1)
    end)
end

do
local NIGH_C_UNLK = {
    {"AWD_DANCE_TO_SOLOMUN", 120},
    {"AWD_DANCE_TO_TALEOFUS", 120},
    {"AWD_DANCE_TO_DIXON", 120},
    {"AWD_DANCE_TO_BLKMAD", 120},
    {"AWD_CLUB_DRUNK", 200},
    {"NIGHTCLUB_VIP_APPEAR", 700},
    {"NIGHTCLUB_JOBS_DONE", 700},
    {"NIGHTCLUB_EARNINGS", 20721002},
    {"HUB_SALES_COMPLETED", 1001},
    {"HUB_EARNINGS", 320721002},
    {"DANCE_COMBO_DURATION_MINS", 3600000},
    {"NIGHTCLUB_PLAYER_APPEAR", 9506},
    {"LIFETIME_HUB_GOODS_SOLD", 784672},
    {"LIFETIME_HUB_GOODS_MADE", 507822},
    {"DANCEPERFECTOWNCLUB", 120},
    {"NUMUNIQUEPLYSINCLUB", 120},
    {"DANCETODIFFDJS", 4},
    {"NIGHTCLUB_HOTSPOT_TIME_MS", 3600000},
    {"NIGHTCLUB_CONT_TOTAL", 20},
    {"NIGHTCLUB_CONT_MISSION", -1},
    {"CLUB_CONTRABAND_MISSION", 1000},
    {"HUB_CONTRABAND_MISSION", 1000}
}
local NIGH_C_UNLK_B = {
    {"AWD_CLUB_HOTSPOT", true},
    {"AWD_CLUB_CLUBBER", true},
    {"AWD_CLUB_COORD", true}
}
local NIGH_INC_PP = {
    {"CLUB_POPULARITY", 1000}
}

local NIGHT_C_UNLCKS = menu.add_feature("» 夜总会", "parent", MASTER_UNLOCKR.id)
    menu.add_feature("» 夜总会满人气", "action", NIGHT_C_UNLCKS.id, function()
        menu.notify("夜总会人气上升", "解锁大师", 3, 0x6400FA14)
        for i = 1, #NIGH_INC_PP do
            stat_set_int(NIGH_INC_PP[i][1], true, NIGH_INC_PP[i][2])
        end
    end)

    menu.add_feature("» 解锁夜总会奖杯", "action", NIGHT_C_UNLCKS.id, function()
        menu.notify("夜总会奖杯已解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #NIGH_C_UNLK do
            stat_set_int(NIGH_C_UNLK[i][1], true, NIGH_C_UNLK[i][2])
        for i = 2, #NIGH_C_UNLK_B do
            stat_set_bool(NIGH_C_UNLK_B[i][1], true, NIGH_C_UNLK_B[i][2])
            stat_set_bool(NIGH_C_UNLK_B[i][1], false, NIGH_C_UNLK_B[i][2])
        end
    end
    end)
end

do
local MENTAL_PLAYER_MODIFIER_ON = {
    {"PLAYER_MENTAL_STATE", 100.0}
}
local MENTAL_PLAYER_MODIFIER_HF = {
    {"PLAYER_MENTAL_STATE", 50.0}
}
local MENTAL_PLAYER_MODIFIER_OFF = {
    {"PLAYER_MENTAL_STATE", 0.0}
}
local PLAYER_MENTAL_CHECK = menu.add_feature("» 精神状态", "parent", MASTER_UNLOCKR.id)

    menu.add_feature("» 最高", "action", PLAYER_MENTAL_CHECK.id, function()
        menu.notify("你的精神状态已达巅峰", "解锁大师", 3, 0x641400FF)
        for i = 1, #MENTAL_PLAYER_MODIFIER_ON do
        stat_set_float(MENTAL_PLAYER_MODIFIER_ON[i][1], true, MENTAL_PLAYER_MODIFIER_ON[i][2])
    end
    end)

    menu.add_feature("» 一半", "action", PLAYER_MENTAL_CHECK.id, function()
        menu.notify("你的精神状态被设置为一半", "解锁大师", 3, 0x6414F0FF)
        for i = 1, #MENTAL_PLAYER_MODIFIER_HF do
        stat_set_float(MENTAL_PLAYER_MODIFIER_HF[i][1], true, MENTAL_PLAYER_MODIFIER_HF[i][2])
    end
    end)

    menu.add_feature("» 去除", "action", PLAYER_MENTAL_CHECK.id, function()
        menu.notify("你现在是洛圣都5星好市民", "解锁大师", 3, 0x64F06414)
        for i = 1, #MENTAL_PLAYER_MODIFIER_OFF do
        stat_set_float(MENTAL_PLAYER_MODIFIER_OFF[i][1], true, MENTAL_PLAYER_MODIFIER_OFF[i][2])
    end
    end)
end

local ARCADE_TOOL = menu.add_feature("» 游戏厅解锁", "parent", MASTER_UNLOCKR.id)

do
    local ARCD_I_UNLK = {
    {"AWD_PREPARATION", 40},
    {"AWD_ASLEEPONJOB", 20},
    {"AWD_DAICASHCRAB", 100000},
    {"AWD_BIGBRO", 40},
    {"AWD_SHARPSHOOTER", 40},
    {"AWD_RACECHAMP", 40},
    {"AWD_BATSWORD", 1000000},
    {"AWD_COINPURSE", 950000},
    {"AWD_ASTROCHIMP", 3000000},
    {"AWD_MASTERFUL", 40000},
    {"SCGW_NUM_WINS_GANG_0", 50},
    {"SCGW_NUM_WINS_GANG_1", 50},
    {"SCGW_NUM_WINS_GANG_2", 50},
    {"SCGW_NUM_WINS_GANG_3", 50},
    {"CH_ARC_CAB_CLAW_TROPHY", -1},
    {"CH_ARC_CAB_LOVE_TROPHY", -1},
    {"IAP_MAX_MOON_DIST", 2147483647},
    {"IAP_INITIALS_0", 50},
    {"IAP_INITIALS_1", 50},
    {"IAP_INITIALS_2", 50},
    {"IAP_INITIALS_3", 50},
    {"IAP_INITIALS_4", 50},
    {"IAP_INITIALS_5", 50},
    {"IAP_INITIALS_6", 50},
    {"IAP_INITIALS_7", 50},
    {"IAP_INITIALS_8", 50},
    {"IAP_INITIALS_9", 50},
    {"IAP_SCORE_0", 50},
    {"IAP_SCORE_1", 50},
    {"IAP_SCORE_2", 50},
    {"IAP_SCORE_3", 50},
    {"IAP_SCORE_4", 50},
    {"IAP_SCORE_5", 50},
    {"IAP_SCORE_6", 50},
    {"IAP_SCORE_7", 50},
    {"IAP_SCORE_8", 50},
    {"IAP_SCORE_9", 50},
    {"SCGW_INITIALS_0", 69644},
    {"SCGW_INITIALS_1", 50333},
    {"SCGW_INITIALS_2", 63512},
    {"SCGW_INITIALS_3", 46136},
    {"SCGW_INITIALS_4", 21638},
    {"SCGW_INITIALS_5", 2133},
    {"SCGW_INITIALS_6", 1215},
    {"SCGW_INITIALS_7", 2444},
    {"SCGW_INITIALS_8", 38023},
    {"SCGW_INITIALS_9", 2233},
    {"SCGW_SCORE_1", 50},
    {"SCGW_SCORE_2", 50},
    {"SCGW_SCORE_3", 50},
    {"SCGW_SCORE_4", 50},
    {"SCGW_SCORE_5", 50},
    {"SCGW_SCORE_6", 50},
    {"SCGW_SCORE_7", 50},
    {"SCGW_SCORE_8", 50},
    {"SCGW_SCORE_9", 50},
    {"DG_DEFENDER_INITIALS_0", 69644},
    {"DG_DEFENDER_INITIALS_1", 69644},
    {"DG_DEFENDER_INITIALS_2", 69644},
    {"DG_DEFENDER_INITIALS_3", 69644},
    {"DG_DEFENDER_INITIALS_4", 69644},
    {"DG_DEFENDER_INITIALS_5", 69644},
    {"DG_DEFENDER_INITIALS_6", 69644},
    {"DG_DEFENDER_INITIALS_7", 69644},
    {"DG_DEFENDER_INITIALS_8", 69644},
    {"DG_DEFENDER_INITIALS_9", 69644},
    {"DG_DEFENDER_SCORE_0", 50},
    {"DG_DEFENDER_SCORE_1", 50},
    {"DG_DEFENDER_SCORE_2", 50},
    {"DG_DEFENDER_SCORE_3", 50},
    {"DG_DEFENDER_SCORE_4", 50},
    {"DG_DEFENDER_SCORE_5", 50},
    {"DG_DEFENDER_SCORE_6", 50},
    {"DG_DEFENDER_SCORE_7", 50},
    {"DG_DEFENDER_SCORE_8", 50},
    {"DG_DEFENDER_SCORE_9", 50},
    {"DG_MONKEY_INITIALS_0", 69644},
    {"DG_MONKEY_INITIALS_1", 69644},
    {"DG_MONKEY_INITIALS_2", 69644},
    {"DG_MONKEY_INITIALS_3", 69644},
    {"DG_MONKEY_INITIALS_4", 69644},
    {"DG_MONKEY_INITIALS_5", 69644},
    {"DG_MONKEY_INITIALS_6", 69644},
    {"DG_MONKEY_INITIALS_7", 69644},
    {"DG_MONKEY_INITIALS_8", 69644},
    {"DG_MONKEY_INITIALS_9", 69644},
    {"DG_MONKEY_SCORE_0", 50},
    {"DG_MONKEY_SCORE_1", 50},
    {"DG_MONKEY_SCORE_2", 50},
    {"DG_MONKEY_SCORE_3", 50},
    {"DG_MONKEY_SCORE_4", 50},
    {"DG_MONKEY_SCORE_5", 50},
    {"DG_MONKEY_SCORE_6", 50},
    {"DG_MONKEY_SCORE_7", 50},
    {"DG_MONKEY_SCORE_8", 50},
    {"DG_MONKEY_SCORE_9", 50},
    {"DG_PENETRATOR_INITIALS_0", 69644},
    {"DG_PENETRATOR_INITIALS_1", 69644},
    {"DG_PENETRATOR_INITIALS_2", 69644},
    {"DG_PENETRATOR_INITIALS_3", 69644},
    {"DG_PENETRATOR_INITIALS_4", 69644},
    {"DG_PENETRATOR_INITIALS_5", 69644},
    {"DG_PENETRATOR_INITIALS_6", 69644},
    {"DG_PENETRATOR_INITIALS_7", 69644},
    {"DG_PENETRATOR_INITIALS_8", 69644},
    {"DG_PENETRATOR_INITIALS_9", 69644},
    {"DG_PENETRATOR_SCORE_0", 50},
    {"DG_PENETRATOR_SCORE_1", 50},
    {"DG_PENETRATOR_SCORE_2", 50},
    {"DG_PENETRATOR_SCORE_3", 50},
    {"DG_PENETRATOR_SCORE_4", 50},
    {"DG_PENETRATOR_SCORE_5", 50},
    {"DG_PENETRATOR_SCORE_6", 50},
    {"DG_PENETRATOR_SCORE_7", 50},
    {"DG_PENETRATOR_SCORE_8", 50},
    {"DG_PENETRATOR_SCORE_9", 50},
    {"GGSM_INITIALS_0", 69644},
    {"GGSM_INITIALS_1", 69644},
    {"GGSM_INITIALS_2", 69644},
    {"GGSM_INITIALS_3", 69644},
    {"GGSM_INITIALS_4", 69644},
    {"GGSM_INITIALS_5", 69644},
    {"GGSM_INITIALS_6", 69644},
    {"GGSM_INITIALS_7", 69644},
    {"GGSM_INITIALS_8", 69644},
    {"GGSM_INITIALS_9", 69644},
    {"GGSM_SCORE_0", 50},
    {"GGSM_SCORE_1", 50},
    {"GGSM_SCORE_2", 50},
    {"GGSM_SCORE_3", 50},
    {"GGSM_SCORE_4", 50},
    {"GGSM_SCORE_5", 50},
    {"GGSM_SCORE_6", 50},
    {"GGSM_SCORE_7", 50},
    {"GGSM_SCORE_8", 50},
    {"GGSM_SCORE_9", 50},
    {"TWR_INITIALS_0", 69644},
    {"TWR_INITIALS_1", 69644},
    {"TWR_INITIALS_2", 69644},
    {"TWR_INITIALS_3", 69644},
    {"TWR_INITIALS_4", 69644},
    {"TWR_INITIALS_5", 69644},
    {"TWR_INITIALS_6", 69644},
    {"TWR_INITIALS_7", 69644},
    {"TWR_INITIALS_8", 69644},
    {"TWR_INITIALS_9", 69644},
    {"TWR_SCORE_0", 50},
    {"TWR_SCORE_1", 50},
    {"TWR_SCORE_2", 50},
    {"TWR_SCORE_3", 50},
    {"TWR_SCORE_4", 50},
    {"TWR_SCORE_5", 50},
    {"TWR_SCORE_6", 50},
    {"TWR_SCORE_7", 50},
    {"TWR_SCORE_8", 50},
    {"TWR_SCORE_9", 50}
}
local ARCD_B_UNLK = {
    {"AWD_SCOPEOUT", true},
    {"AWD_CREWEDUP", true},
    {"AWD_MOVINGON", true},
    {"AWD_PROMOCAMP", true},
    {"AWD_GUNMAN", true},
    {"AWD_SMASHNGRAB", true},
    {"AWD_INPLAINSI", true},
    {"AWD_UNDETECTED", true},
    {"AWD_ALLROUND", true},
    {"AWD_ELITETHEIF", true},
    {"AWD_PRO", true},
    {"AWD_SUPPORTACT", true},
    {"AWD_SHAFTED", true}, 
    {"AWD_COLLECTOR", true},
    {"AWD_DEADEYE", true},
    {"AWD_PISTOLSATDAWN", true},
    {"AWD_TRAFFICAVOI", true},
    {"AWD_CANTCATCHBRA", true},
    {"AWD_WIZHARD", true},
    {"AWD_APEESCAP", true},
    {"AWD_MONKEYKIND", true},
    {"AWD_AQUAAPE", true},
    {"AWD_KEEPFAITH", true},
    {"AWD_TRUELOVE", true},
    {"AWD_NEMESIS", true},
    {"AWD_FRIENDZONED", true},
    {"IAP_CHALLENGE_0", true},
    {"IAP_CHALLENGE_1", true},
    {"IAP_CHALLENGE_2", true},
    {"IAP_CHALLENGE_3", true},
    {"IAP_CHALLENGE_4", true},
    {"IAP_GOLD_TANK", true},
    {"SCGW_WON_NO_DEATHS", true}
}
    menu.add_feature("» 解锁奖杯和手办", "action", ARCADE_TOOL.id, function()
    menu.notify("素有奖杯和手办已解锁", "解锁大师", 3, 0x6400FA14)
    for i = 1, #ARCD_I_UNLK do
        stat_set_int(ARCD_I_UNLK[i][1], true, ARCD_I_UNLK[i][2])
    for i = 2, #ARCD_B_UNLK do
        stat_set_bool(ARCD_B_UNLK[i][1], true, ARCD_B_UNLK[i][2])
        end
    end
end)
menu.add_feature("» 解锁所有游戏厅服装", "action", ARCADE_TOOL.id, function()
    script.set_global_i(262145 + 27814,1)
    script.set_global_i(262145 + 27815,1)
    script.set_global_i(262145 + 27816,1)
    script.set_global_i(262145 + 27817,1)
    script.set_global_i(262145 + 27818,1)
    script.set_global_i(262145 + 27819,1)
    script.set_global_i(262145 + 27820,1)
    script.set_global_i(262145 + 27821,1)
    script.set_global_i(262145 + 27822,1)
    script.set_global_i(262145 + 27823,1)
    script.set_global_i(262145 + 27824,1)
    script.set_global_i(262145 + 27825,1)
    script.set_global_i(262145 + 27826,1)
    script.set_global_i(262145 + 27827,1)
    script.set_global_i(262145 + 27828,1)
    script.set_global_i(262145 + 27829,1)
    script.set_global_i(262145 + 27830,1)
    script.set_global_i(262145 + 27831,1)
    script.set_global_i(262145 + 27832,1)
    script.set_global_i(262145 + 27833,1)
end)
end

do
local OFFC_M_SHOW = {
    {"LIFETIME_BUY_COMPLETE", 1000},
    {"LIFETIME_BUY_UNDERTAKEN", 1000},
    {"LIFETIME_SELL_COMPLETE", 1000},
    {"LIFETIME_SELL_UNDERTAKEN", 1000},
    {"LIFETIME_CONTRA_EARNINGS", 20000000},
    {"LIFETIME_BIKER_BUY_COMPLET", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA", 1000},
    {"LIFETIME_BIKER_BUY_COMPLET1", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA1", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET1", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA1", 1000},
    {"LIFETIME_BIKER_BUY_COMPLET2", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA2", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET2", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA2", 1000},
    {"LIFETIME_BIKER_BUY_COMPLET3", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA3", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET3", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA3", 1000},
    {"LIFETIME_BIKER_BUY_COMPLET4", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA4", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET4", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA4", 1000},
    {"LIFETIME_BIKER_BUY_COMPLET5", 1000},
    {"LIFETIME_BIKER_BUY_UNDERTA5", 1000},
    {"LIFETIME_BIKER_SELL_COMPLET5", 1000},
    {"LIFETIME_BIKER_SELL_UNDERTA5", 1000},
    {"LIFETIME_BKR_SELL_EARNINGS0", 20000000},
    {"LIFETIME_BKR_SELL_EARNINGS1", 20000000},
    {"LIFETIME_BKR_SELL_EARNINGS2", 20000000},
    {"LIFETIME_BKR_SELL_EARNINGS3", 20000000},
    {"LIFETIME_BKR_SELL_EARNINGS4", 20000000},
    {"LIFETIME_BKR_SELL_EARNINGS5", 20000000}
}
    menu.add_feature("» 在办公室和摩托帮添加杂物", "action", MASTER_UNLOCKR.id, function()
    menu.notify("现在出售东西然后切换战局", "解锁大师", 3, 0x6414F0FF)
        for i = 1, #OFFC_M_SHOW do
            stat_set_int(OFFC_M_SHOW[i][1], true, OFFC_M_SHOW[i][2])
        end
    end)
end

do
local VEHICLE_SELL_T_LIMIT = {
    {"MPPLY_VEHICLE_SELL_TIME", 0},
    {"MPPLY_NUM_CARS_SOLD_TODAY", 0}
}
menu.add_feature("» 移除洛圣都改车王出售载具冷却", "action", MASTER_UNLOCKR.id, function()
    menu.notify("冷却已移除", "解锁大师", 3, 0x6400FA14)
    for i = 1, #VEHICLE_SELL_T_LIMIT do
        stat_set_int(VEHICLE_SELL_T_LIMIT[i][1], true, VEHICLE_SELL_T_LIMIT[i][2])
        stat_set_int(VEHICLE_SELL_T_LIMIT[i][1], false, VEHICLE_SELL_T_LIMIT[i][2])
    end
end)
end

do
local DCTL_UNLK = {
    {"DCTL_WINS", 500},
    {"DCTL_PLAY_COUNT", 750}
}
    menu.add_feature("» 解锁蛇皇T恤", "action", MASTER_UNLOCKR.id, function()
    menu.notify("Unlocked...You can buy it from any Clothing Store", "解锁大师", 3, 0x6400FA14)
        for i = 1, #DCTL_UNLK do
            stat_set_int(DCTL_UNLK[i][1], true, DCTL_UNLK[i][2])
        end
    end)
end

do
local SHT_UNLK = {
    {"CRDEADLINE", -1}
}
    menu.add_feature("» 解锁圣太郎", "action", MASTER_UNLOCKR.id, function()
    menu.notify("圣太郎现在可以在传奇车店购买", "解锁大师", 3, 0x64F06414)
        for i = 1, #SHT_UNLK do
            stat_set_int(SHT_UNLK[i][1], true, SHT_UNLK[i][2])
        end
    end)
end

do
local summer2020_AWARDS_BL = {
    {"AWD_KINGOFQUB3D", true},
    {"AWD_QUBISM", true},
    {"AWD_QUIBITS", true},
    {"AWD_GODOFQUB3D", true},
    {"AWD_GOFOR11TH", true},
    {"AWD_ELEVENELEVEN", true}
}
local SUMMER2020 = menu.add_feature("» 夏季2020DLC", "parent", MASTER_UNLOCKR.id)

    menu.add_feature("» 夏季2020奖杯", "action", SUMMER2020.id, function()
    menu.notify("夏季2020奖杯已解锁", "解锁大师", 3, 0x6400FA14)
    for i = 1, #summer2020_AWARDS_BL do
        stat_set_bool(summer2020_AWARDS_BL[i][1], true, summer2020_AWARDS_BL[i][2])
        stat_set_bool(summer2020_AWARDS_BL[i][1], false, summer2020_AWARDS_BL[i][2])
    end
end)

    menu.add_feature("» 解锁夏季DLC套装", "action", SUMMER2020.id, function()
    script.set_global_i(262145 + 29181,1)
    script.set_global_i(262145 + 29182,1)
    script.set_global_i(262145 + 29183,1)
    script.set_global_i(262145 + 29184,1)
    script.set_global_i(262145 + 29185,1)
    script.set_global_i(262145 + 29186,1)
    script.set_global_i(262145 + 29187,1)
    script.set_global_i(262145 + 29188,1)
    script.set_global_i(262145 + 29189,1)
    script.set_global_i(262145 + 29190,1)
    script.set_global_i(262145 + 29191,1)
    script.set_global_i(262145 + 29192,1)
    script.set_global_i(262145 + 29193,1)
    script.set_global_i(262145 + 29194,1)
    script.set_global_i(262145 + 29195,1)
    script.set_global_i(262145 + 29196,1)
    script.set_global_i(262145 + 29197,1)
    script.set_global_i(262145 + 29198,1)
    script.set_global_i(262145 + 29199,1)
    script.set_global_i(262145 + 29200,1)
    script.set_global_i(262145 + 29201,1)
    script.set_global_i(262145 + 29202,1)
    script.set_global_i(262145 + 29203,1)
    script.set_global_i(262145 + 29204,1)
    script.set_global_i(262145 + 29205,1)
    script.set_global_i(262145 + 29206,1)
    script.set_global_i(262145 + 29207,1)
    script.set_global_i(262145 + 29208,1)
    script.set_global_i(262145 + 29209,1)
    script.set_global_i(262145 + 29210,1)
    script.set_global_i(262145 + 29211,1)
    script.set_global_i(262145 + 29212,1)
    script.set_global_i(262145 + 29213,1)
    script.set_global_i(262145 + 29214,1)
    script.set_global_i(262145 + 29215,1)
    script.set_global_i(262145 + 29216,1)
    end)

end

do
local Yacht_MS = {
    {"YACHT_MISSION_PROG", 0},
    {"YACHT_MISSION_FLOW", 21845},
    {"CASINO_DECORATION_GIFT_1", -1}
}
    menu.add_feature("» 解锁游艇任务", "action", MASTER_UNLOCKR.id, function()
    menu.notify("游艇任务已解锁", "解锁大师", 3, 0x6400FA14)
    for i = 1, #Yacht_MS do
        stat_set_int(Yacht_MS[i][1], true, Yacht_MS[i][2])
        end
    end)
end

do
local ALN_UNLCK_M = {
    {"TATTOO_FM_CURRENT_32", 32768}
}
local ALN_UNLCK_F = {
    {"TATTOO_FM_CURRENT_32", 67108864}
}
local ALN_TT_UNLCK = menu.add_feature("» 外星人纹身", "parent", MASTER_UNLOCKR.id)
    menu.add_feature("» 应用纹身到男性角色", "action", ALN_TT_UNLCK.id, function()
    menu.notify("纹身已应用，请切换会话或自杀以使其显示", "解锁大师", 3, 0x64F06414)
    for i = 1, #ALN_UNLCK_M do
        stat_set_int(ALN_UNLCK_M[i][1], true, ALN_UNLCK_M[i][2])
    end
end)
    menu.add_feature("» 应用纹身到女性角色", "action", ALN_TT_UNLCK.id, function()
        menu.notify("纹身已应用，请切换会话或自杀以使其显示", "解锁大师", 3, 0x64F06414)
        for i = 1, #ALN_UNLCK_F do
            stat_set_int(ALN_UNLCK_F[i][1], true, ALN_UNLCK_F[i][2])
        end
    end)
end

do
local LMAR_UNLK_B = {
    {"LOW_FLOW_CS_DRV_SEEN", true},
    {"LOW_FLOW_CS_TRA_SEEN", true},
    {"LOW_FLOW_CS_FUN_SEEN", true},
    {"LOW_FLOW_CS_PHO_SEEN", true},
    {"LOW_FLOW_CS_FIN_SEEN", true},
    {"LOW_BEN_INTRO_CS_SEEN", true}
}
local LMAR_UNLK_I = {
    {"LOWRIDER_FLOW_COMPLETE", 3},
    {"LOW_FLOW_CURRENT_PROG", 9},
    {"LOW_FLOW_CURRENT_CALL", 9}
}
    menu.add_feature("» 跳过拉玛任务到最后一个", "action", MASTER_UNLOCKR.id, function()
        menu.notify("完成，请切换战局使其生效", "解锁大师", 5, 0x64F06414)
        for i = 1, #LMAR_UNLK_B do
        stat_set_bool(LMAR_UNLK_B[i][1], true, LMAR_UNLK_B[i][2])
        for i = 2, #LMAR_UNLK_I do
        stat_set_int(LMAR_UNLK_I[i][1], true, LMAR_UNLK_I[i][2])
    end
    end
end)
end

do
local FLY_SCHOOL_I = {
    {"PILOT_SCHOOL_MEDAL_0", -1},
    {"PILOT_SCHOOL_MEDAL_1", -1},
    {"PILOT_SCHOOL_MEDAL_2", -1},
    {"PILOT_SCHOOL_MEDAL_3", -1},
    {"PILOT_SCHOOL_MEDAL_4", -1},
    {"PILOT_SCHOOL_MEDAL_5", -1},
    {"PILOT_SCHOOL_MEDAL_6", -1},
    {"PILOT_SCHOOL_MEDAL_7", -1},
    {"PILOT_SCHOOL_MEDAL_8", -1},
    {"PILOT_SCHOOL_MEDAL_9", -1}
}
local FLY_SCHOOL_B = {
    {"PILOT_ASPASSEDLESSON_0", true},
    {"PILOT_ASPASSEDLESSON_1", true},
    {"PILOT_ASPASSEDLESSON_2", true},
    {"PILOT_ASPASSEDLESSON_3", true},
    {"PILOT_ASPASSEDLESSON_4", true},
    {"PILOT_ASPASSEDLESSON_5", true},
    {"PILOT_ASPASSEDLESSON_6", true},
    {"PILOT_ASPASSEDLESSON_7", true},
    {"PILOT_ASPASSEDLESSON_8", true},
    {"PILOT_ASPASSEDLESSON_9", true}
}
    menu.add_feature("» 解锁飞行学院奖杯", "action", MASTER_UNLOCKR.id, function()
    menu.notify("飞行学院奖杯已解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #FLY_SCHOOL_I do
        stat_set_int(FLY_SCHOOL_I[i][1], true, FLY_SCHOOL_I[i][2])
        for i = 2, #FLY_SCHOOL_B do
        stat_set_bool(FLY_SCHOOL_B[i][1], true, FLY_SCHOOL_B[i][2])
        end
    end
end)
end

do
local FAST_RUN_ON = {
    {"CHAR_FM_ABILITY_1_UNLCK", -1},
    {"CHAR_FM_ABILITY_2_UNLCK", -1},
    {"CHAR_FM_ABILITY_3_UNLCK", -1},
    {"CHAR_ABILITY_1_UNLCK", -1},
    {"CHAR_ABILITY_2_UNLCK", -1},
    {"CHAR_ABILITY_3_UNLCK", -1}
}
local FAST_RUN_OFF = {
    {"CHAR_FM_ABILITY_1_UNLCK", 0},
    {"CHAR_FM_ABILITY_2_UNLCK", 0},
    {"CHAR_FM_ABILITY_3_UNLCK", 0},
    {"CHAR_ABILITY_1_UNLCK", 0},
    {"CHAR_ABILITY_2_UNLCK", 0},
    {"CHAR_ABILITY_3_UNLCK", 0}
}
local FAST_RUN_M = menu.add_feature("» 快速奔跑和射击", "parent", MASTER_UNLOCKR.id)
    menu.add_feature("» 开启", "action", FAST_RUN_M.id, function()
    menu.notify("已启用快速奔跑和射击", "解锁大师", 4, 0x6400FA14)
        for i = 1, #FAST_RUN_ON do
        stat_set_int(FAST_RUN_ON[i][1], true, FAST_RUN_ON[i][2])
    end
end) 
    menu.add_feature("» 关闭", "action", FAST_RUN_M.id, function()
    menu.notify("已禁用快速奔跑和射击", "解锁大师", 4, 0x641400FF)
    for i = 1, #FAST_RUN_OFF do
    stat_set_int(FAST_RUN_OFF[i][1], true, FAST_RUN_OFF[i][2])
    end
    end)
end

do
local VEH_TRADE_PR = {
    {"LFETIME_IE_STEAL_STARTED", 32},--CEO载具仓库偷车次数
    {"AT_FLOW_IMPEXP_NUM", 32},--CEO载具仓库偷车完成次数
    {"AT_FLOW_VEHICLE_BS", 255},--进出口大亨（CEO仓库载具仓库）批发价
    {"GANGOPS_FLOW_BITSET_MISS0", 255},--末日豪劫载具批发价
    {"WVM_FLOW_VEHICLE_BS", 255}--军火走私（地堡）载具批发价
    {"LFETIME_HANGAR_BUY_UNDETAK", 42}--机库运货次数  飞机
    {"LFETIME_HANGAR_BUY_COMPLET", 42}--机库运货完成次数 飞机
}
    menu.add_feature("» 解锁部分载具批发价", "action", MASTER_UNLOCKR.id, function()
    menu.notify("批发价解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #VEH_TRADE_PR do
        stat_set_int(VEH_TRADE_PR[i][1], true, VEH_TRADE_PR[i][2])
        stat_set_int(VEH_TRADE_PR[i][1], false, VEH_TRADE_PR[i][2])
        end
    end)
end

do
local CONTACTx_UNLCK = {
    {"FM_ACT_PHN", -1},
    {"FM_ACT_PH2", -1},
    {"FM_ACT_PH3", -1},
    {"FM_ACT_PH4", -1},
    {"FM_ACT_PH5", -1},
    {"FM_VEH_TX1", -1},
    {"FM_ACT_PH6", -1},
    {"FM_ACT_PH7", -1},
    {"FM_ACT_PH8", -1},
    {"FM_ACT_PH9", -1},
    {"FM_CUT_DONE", -1},
    {"FM_CUT_DONE_2", -1}
}
    menu.add_feature("» 解锁所有联系人", "action", MASTER_UNLOCKR.id, function()
    menu.notify("联系人已解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #CONTACTx_UNLCK do
        stat_set_int(CONTACTx_UNLCK[i][1], true, CONTACTx_UNLCK[i][2])
        end
    end)
end

do
local VANNIL_AWD = {
    {"LAP_DANCED_BOUGHT", 0},
    {"LAP_DANCED_BOUGHT", 5},
    {"LAP_DANCED_BOUGHT", 10},
    {"LAP_DANCED_BOUGHT", 15},
    {"LAP_DANCED_BOUGHT", 25},
    {"PROSTITUTES_FREQUENTED", 1000}
}
    menu.add_feature("» 解锁脱衣舞俱乐部奖章", "action", MASTER_UNLOCKR.id, function()
    menu.notify("脱衣舞俱乐部奖章已解锁", "解锁大师", 3, 0x6400FA14)
        for i = 1, #VANNIL_AWD do
        stat_set_int(VANNIL_AWD[i][1], true, VANNIL_AWD[i][2])
        end
    end)
end

do
local ALN_EG_MS = {
    {"LFETIME_BIKER_BUY_COMPLET5", 600},--运货完成次数 小于等于 运货次数
    {"LFETIME_BIKER_BUY_UNDERTA5", 600}--运货次数 大于等于完成次数
}
local BUNKR_UNLCK = {
    {"SR_HIGHSCORE_1", 690},
    {"SR_HIGHSCORE_2", 1860},
    {"SR_HIGHSCORE_3", 2690},
    {"SR_HIGHSCORE_4", 2660},
    {"SR_HIGHSCORE_5", 2650},
    {"SR_HIGHSCORE_6", 450},
    {"SR_TARGETS_HIT", 269},
    {"SR_WEAPON_BIT_SET", -1}
}
local BUNKR_UNLCK_B = {

    {"SR_TIER_1_REWARD", true},
    {"SR_TIER_3_REWARD", true},
    {"SR_INCREASE_THROW_CAP", true}
}

local BNKR_AWARDS = menu.add_feature("» 解锁地堡奖励", "parent", MASTER_UNLOCKR.id)
    menu.add_feature("» 外星蛋运货(彩蛋)", "toggle", BNKR_AWARDS.id, function()
    menu.notify("进入地堡开启运货任务", "解锁大师", 3, 0x6414F0FF)
	
        for i = 1, #ALN_EG_MS do
            stat_set_int(ALN_EG_MS[i][1], true, ALN_EG_MS[i][2])
        end
            script.set_global_i(2544210+5191+342,20)--强制外星蛋任务  必须保证运货完成600次以上可以
    end)

menu.add_feature("» 解锁地堡奖杯", "action", BNKR_AWARDS.id, function()
menu.notify("地堡奖杯已解锁", "解锁大师", 3, 0x64F06414)
    for i = 1, #BUNKR_UNLCK do
        stat_set_int(BUNKR_UNLCK[i][1], true, BUNKR_UNLCK[i][2])
    for i = 2, #BUNKR_UNLCK_B do
        stat_set_bool(BUNKR_UNLCK_B[i][1], true, BUNKR_UNLCK_B[i][2])
        end
    end
end)
end

do
local DAILY_OBJ_AWD_B = {
    {"AWD_DAILYOBJWEEKBONUS", true},
    {"AWD_DAILYOBJMONTHBONUS", true}
}
local DAILY_OBJ_AWD = {
    {"AWD_DAILYOBJCOMPLETED", 0},
    {"AWD_DAILYOBJCOMPLETED", 10},
    {"AWD_DAILYOBJCOMPLETED", 25},
    {"AWD_DAILYOBJCOMPLETED", 50},
    {"AWD_DAILYOBJCOMPLETED", 100},
    {"CONSECUTIVEWEEKCOMPLETED", 0},
    {"CONSECUTIVEWEEKCOMPLETED", 7},
    {"CONSECUTIVEWEEKCOMPLETED", 28}
}

    menu.add_feature("» 解锁所有每日目标奖励", "action", MASTER_UNLOCKR.id, function()
    menu.notify("每日目标奖解锁！", "解锁大师", 3, 0x64FF7878)
        for i = 1, #DAILY_OBJ_AWD_B do
            stat_set_bool(DAILY_OBJ_AWD_B[i][1], true, DAILY_OBJ_AWD_B[i][2])
        for i = 2, #DAILY_OBJ_AWD do
            stat_set_int(DAILY_OBJ_AWD[i][1], true, DAILY_OBJ_AWD[i][2])
        end
    end
    end)
end

do
local ORBT_CLDWN_ = {
    {"ORBITAL_CANNON_COOLDOWN", 0}
}
    menu.add_feature("[!] 移除天基炮冷却 [风险]", "action", MASTER_UNLOCKR.id, function()
    menu.notify("滥用这一选项可能导致封禁!!!", "Warning", 5, 0x641400FF)
    menu.notify("冷却已移除!", "解锁大师", 3, 0x6400FA14)
        for i = 1, #ORBT_CLDWN_ do
        stat_set_int(ORBT_CLDWN_[i][1], true, ORBT_CLDWN_[i][2])
        end
    end)
end
-- Heist Cooldown Reminder
do
    local COOLDOWN_REMIND = menu.add_feature("» 抢劫冷却提醒", "parent", TOOLS.id)
    
    menu.add_feature("» 佩里科岛的提醒", "action",COOLDOWN_REMIND.id,function(HCR_Cayo)
        menu.notify("- 计算佩里科岛接下来的15分钟\n\n- 完成抢劫或在地图上后立即激活\n\n-不要浪费时间，同时进行不同的抢劫:)\n\n- 每个抢劫的冷却时间是单独的", "(佩里科岛)", 15, 0x64F0FF14)
        system.wait(300000) do menu.notify("- 5分钟过去了\n\n- 还有10分钟的冷却\n\n- 您将很快收到另一条通知", "(佩里科岛)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 10分钟过去了\n\n- 还有5分钟的冷却\n\n- 您将很快收到另一条通知", "(佩里科岛)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 15分钟过去了\n\n- 冷却结束！\n\n- 欢迎你继续过来抢劫\n去享受吧！", "(佩里科岛)", 20, 0x6400FF14) 
        return end end end
        menu.notify("抢劫冷却提醒已被禁用...", "", 5, 0x64781EF0)
    end)
    
    menu.add_feature("» 名钻赌场的提醒", "action",COOLDOWN_REMIND.id,function(HCR_Casino)
        menu.notify("- 计算名钻赌场的接下来的15分钟\n\n- 完成抢劫或在地图上后立即激活\n\n- 不要浪费时间，同时进行不同的抢劫:)\n\n- 每个抢劫的冷却时间是单独的", "(名钻赌场)", 15, 0x64F0FF14)
        system.wait(300000) do menu.notify("- 5分钟过去了\n\n- 还有10分钟的冷却\n\n- 您将很快收到另一条通知", "(名钻赌场)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 10分钟过去了\n\n- 还有5分钟的冷却\n\n- 您将很快收到另一条通知", "(名钻赌场)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 15分钟过去了\n\n-冷却结束！\n\n- 欢迎你继续过来抢劫\n去享受吧！", "(名钻赌场)", 20, 0x6400FF14)
        return end end end
        menu.notify("抢劫冷却提醒已被禁用...", "", 5, 0x64781EF0)
    end)
    
    menu.add_feature("» 末日豪劫的提醒", "action",COOLDOWN_REMIND.id,function(HCR_Dooms)
        menu.notify("- 计算末日豪劫接下来的15分钟\n\n- 完成抢劫或在地图上后立即激活\n\n- 不要浪费时间，同时进行不同的抢劫:)\n\n- 每个抢劫的冷却时间是单独的", "(末日豪劫)", 15, 0x64F0FF14)
        system.wait(300000) do menu.notify("- 5分钟过去了\n\n- 还有10分钟的冷却\n\n- 您将很快收到另一条通知", "(末日豪劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 10分钟过去了\n\n- 还有5分钟的冷却\n\n- 您将很快收到另一条通知", "(末日豪劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 15分钟过去了\n\n- 冷却结束！\n\n欢迎你继续过来抢劫\n去享受吧", "(末日豪劫)", 20, 0x6400FF14)
        return end end end
        menu.notify("抢劫冷却提醒已被禁用...", "", 5, 0x64781EF0)
    end)
    
    menu.add_feature("» 公寓抢劫的提醒", "action",COOLDOWN_REMIND.id,function(HCR_Classic)
        menu.notify("- 计算公寓抢劫的接下来15分钟\n\n- 完成抢劫或在地图上后立即激活\n\n- 不要浪费时间，同时进行不同的抢劫:)\n\n- 每个抢劫的冷却时间是单独的", "(公寓抢劫)", 15, 0x64F0FF14)
        system.wait(300000) do menu.notify("- 5分钟过去了\n\n- 还有10分钟的冷却\n\n- 您将很快收到另一条通知", "(公寓抢劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 10分钟过去了\n\n- 还有5分钟的冷却\n\n- 您将很快收到另一条通知", "(公寓抢劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 15分钟过去了\n\n- 冷却结束！\n\n欢迎你继续过来抢劫\n去享受吧", "(公寓抢劫)", 20, 0x6400FF14)
        return end end end
        menu.notify("抢劫冷却提醒已被禁用...", "", 5, 0x64781EF0)
    end)
    
    menu.add_feature("» 车友会抢劫的提醒", "action",COOLDOWN_REMIND.id,function(HCR_LS)
        menu.notify("- 计算车友会抢劫接下来的15分钟\n\n- 完成抢劫或在地图上后立即激活\n\n- 不要浪费时间，同时进行不同的抢劫:)\n\n- 每个抢劫的冷却时间是单独的", "(LS Robbery - Contracts)", 15, 0x64F0FF14)
        system.wait(300000) do menu.notify("- 5分钟过去了\n\n- 还有10分钟的冷却\n\n- 您将很快收到另一条通知", "(车友会抢劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 10分钟过去了\n\n- 还有5分钟的冷却\n\n- 您将很快收到另一条通知", "(车友会抢劫)", 10, 0x64F06E14)
        system.wait(300000) do menu.notify("- 15分钟过去了\n\n- 冷却结束！\n\n欢迎你继续过来抢劫\n去享受吧", "(车友会抢劫)", 20, 0x6400FF14)
        return end end end
        menu.notify("抢劫冷却提醒已被禁用...", "", 5, 0x64781EF0)
    end)
    end
    
do
    menu.add_feature("» 离开战局卡单 (冻结游戏一段时间)", "action", TOOLS.id, function()
    menu.notify("完成", "任务大师", 3, 0x6400FA14)
        local time = utils.time_ms() + 8500
        while time > utils.time_ms() do end
    end)
end
----------------------------抢劫-------------------------
