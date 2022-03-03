--孤高の格闘家
--Lone Wolf
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TRUE)
	e2:SetCondition(s.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end
s.listed_series={0x300}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x300)
end
function s.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function s.condition(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==1 and s.filter(g:GetFirst())
end