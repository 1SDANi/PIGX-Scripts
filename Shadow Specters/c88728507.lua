--ヴァンパイア・ソーサラー
--Vampire Sorcerer
local s,id=GetID()
function s.initial_effect(c)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,race=RACE_ZOMBIE})
	e2:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,race=RACE_ZOMBIE})
	c:RegisterEffect(e2)
end