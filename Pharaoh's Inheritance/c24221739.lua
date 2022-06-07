--神殿を守る者
--Protector of the Sanctuary
local s,id=GetID()
function s.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(s.sumcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e2)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e3:SetCondition(s.con)
	c:RegisterEffect(e3)
	--cannot draw
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_DRAW)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.con)
	c:RegisterEffect(e4)
end
function s.sumcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.con(e)
	return not Duel.GetCurrentPhase()==PHASE_DRAW
end
