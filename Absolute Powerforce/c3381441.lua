--墓守の巫女
--Gravekeeper's Priestess
local s,id=GetID()
function s.initial_effect(c)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ENVIRONMENT)
	e1:SetValue(CARD_NECROVALLEY)
	c:RegisterEffect(e1)
end