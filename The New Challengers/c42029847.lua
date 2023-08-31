--幻奏の音女セレナ
--Serenade the Melodious Diva
local s,id=GetID()
function s.initial_effect(c)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(s.condition)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,race=RACE_PSYCHIC})
	e2:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,race=RACE_PSYCHIC})
	c:RegisterEffect(e2)
end
function s.condition(e,c)
	return c:IsRace(RACE_PSYCHIC)
end