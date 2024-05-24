local game_start_runref = Game.start_run
function Game:start_run(args)
    game_start_runref(self, args)
    local saveTable = args.savetext or nil
    if not saveTable then
        if args.challenge then
            local _ch = args.challenge
            if _ch.rules then
                if _ch.rules.custom then
                    for k, v in ipairs(_ch.rules.custom) do
                        if v.id == 'no_shop_planets' then
                            self.GAME.planet_rate = 0
                        end
                    end
                end
            end
        end
    end
end

local calculate_dollar_bonusref = Card.calculate_dollar_bonus
function Card.calculate_dollar_bonus(self)
    if self.debuff then return end
    if self.ability.set == "Joker" then
        if self.config.center_key == 'j_sdm_tip_jar' then
            local highest = 0
            for digit in tostring(math.abs(G.GAME.dollars)):gmatch("%d") do
                highest = math.max(highest, tonumber(digit))
            end
            if highest > 0 then
                return highest
            end
        elseif self.config.center_key == 'j_sdm_shareholder_joker' then
            rand_dollar = pseudorandom(pseudoseed('shareholder'), self.ability.extra.min, self.ability.extra.max)
            return rand_dollar
        elseif self.config.center_key == 'j_sdm_furnace' or self.config.center_key == 'j_sdm_denaturalisation' then
            if self.ability.extra.dollars > 0 then
                return self.ability.extra.dollars
            end
        elseif self.config.center_key == 'j_sdm_gold_dealer_joker' then
            rand_dollar = pseudorandom(pseudoseed('golddealer'), self.ability.extra.min, self.ability.extra.max)
            return rand_dollar
        end
    end
    return calculate_dollar_bonusref(self)
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if G.jokers and #G.jokers.cards > 0 then
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({sdm_adding_card = true, card = self})
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

return