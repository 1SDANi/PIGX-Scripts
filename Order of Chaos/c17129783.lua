--セイクリッド・レオニス
--Constellar Leonis
local s,id=GetID()
function s.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,archetype=0x53})
	e1:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,archetype=0x53})
	c:RegisterEffect(e1)
end
s.listed_series={0x53}
