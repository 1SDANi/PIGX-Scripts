--極星將テュール
--Tyr of the Nordic Champions
local s,id=GetID()
function s.initial_effect(c)
	--at limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(s.atlimit)
	c:RegisterEffect(e3)
end
s.listed_series={0x42}
function s.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x42) and c~=e:GetHandler()
end
