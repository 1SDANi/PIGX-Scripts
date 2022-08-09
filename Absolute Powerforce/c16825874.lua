--エキセントリック・ボーイ
--Eccentric Boy
local s,id=GetID()
function s.initial_effect(c)
	--perform a fusion summon
	local params = {aux.FilterBoolFunction(Card.IsType,TYPE_FUSION)}
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e2:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e2)
end