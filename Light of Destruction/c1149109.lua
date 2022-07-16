--デッキロック
--Deck Lockdown
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.cn)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	--cannot draw
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	Duel.RegisterEffect(e2,tp)
	--disable search
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetCondition(s.con)
	Duel.RegisterEffect(e3,tp)
	--cannot send to grave
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE)
	Duel.RegisterEffect(e4,tp)
	--cannot mill
	local e5=e1:Clone()
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e5:SetTargetRange(1,1)
	Duel.RegisterEffect(e5,tp)
	--Cannot banish
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e6)
end
function s.con(e)
	return not Duel.GetCurrentPhase()==PHASE_DRAW
end