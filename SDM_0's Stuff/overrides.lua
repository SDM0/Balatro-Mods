local config = SDM_0s_Stuff_Config.config

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

local back_trigger_effectref = Back.trigger_effect
function Back:trigger_effect(args)
    back_trigger_effectref(self, args)
    if not args then return end
    if self.name == "DNA Deck" or (self.name == "Deck Of Stuff" and config.b_dna) then
        if G.GAME.chips + hand_chips * mult > G.GAME.blind.chips then
            local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
            G.E_MANAGER:add_event(Event({func = function()
                local new_cards = {}
                for _, v in ipairs(scoring_hand) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local _card = copy_card(v, nil, nil, G.playing_card)
                    table.insert(new_cards, _card)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.hand:emplace(_card)
                    _card.states.visible = nil
                    _card:start_materialize()
                end
                playing_card_joker_effects(new_cards)
                return true
            end}))
        end
    end
end

local calculate_dollar_bonusref = Card.calculate_dollar_bonus
function Card.calculate_dollar_bonus(self)
    if self.debuff then return end
    if self.ability.set == "Joker" then
        local obj = self.config.center
        if obj and obj.sdm_calc_dollar_bonus and type(obj.sdm_calc_dollar_bonus) == 'function' then
            return obj:sdm_calc_dollar_bonus(self)
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