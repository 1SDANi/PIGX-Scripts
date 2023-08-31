--インヴェルズの門番
--Steelswarm Gatekeeper
local s,id=GetID()
function s.initial_effect(c)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,archetype=0xa})
	e2:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,archetype=0xa})
	c:RegisterEffect(e2)
end
s.listed_series={0xa}