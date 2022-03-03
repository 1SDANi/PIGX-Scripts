--クリビー
--Kuribih
local s,id=GetID()
function s.initial_effect(c)
	--at limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(s.condition)
	e3:SetValue(s.atlimit)
	c:RegisterEffect(e3)
end
s.listed_series={0xa4}
function s.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa4)
end
function s.condition(e)
	return Duel.IsExistingMatchingCard(s.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0xa4)
end