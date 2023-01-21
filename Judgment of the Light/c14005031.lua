--ムーンダンスの儀式
--Moon Dance Ritual
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.disable)
	c:RegisterEffect(e4)
end
function s.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) and e:GetHandler():GetEquipTarget()~=c
end