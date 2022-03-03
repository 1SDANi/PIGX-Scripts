--錬金生物 ホムンクルス
--Homunculus the Alchemic Being
local s,id=GetID()
function s.initial_effect(c)
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
end
