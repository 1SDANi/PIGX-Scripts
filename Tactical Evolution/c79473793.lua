--青氷の白夜龍
--White Night Dragon
local s,id=GetID()
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(s.distg)
	c:RegisterEffect(e1)
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--at limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(s.atlimit)
	c:RegisterEffect(e3)
end
s.counter_list={COUNTER_ICE}
function s.distg(e,c)
	return c:GetCounter(COUNTER_ICE)>0 and c:GetControler ~= e:GetHandler():GetControler()
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end