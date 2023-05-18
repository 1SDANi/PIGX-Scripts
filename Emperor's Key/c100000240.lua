--フォトン・デルタ・ウィング
--Photon Delta Wing
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
s.listed_series={0x55,0x7b}
function s.atlimit(e,c)
	return c:IsFaceup() and (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c~=e:GetHandler()
end
