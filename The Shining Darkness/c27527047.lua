--氷結界の御庭番
--Secret Guards of the Ice Barrier
local s,id=GetID()
function s.initial_effect(c)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.tg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
end
s.listed_series={0x2f}
function s.tg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
