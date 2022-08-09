--サボウ・クローザー
--Cactus Bouncer
local s,id=GetID()
function s.initial_effect(c)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.splimit)
	e2:SetCondition(s.dscon)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return (sumtp&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.dscon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsRace,RACE_PLANT),0,LOCATION_MZONE,0,1,e:GetHandler())
end