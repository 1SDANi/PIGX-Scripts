--ハーピィ・レディ・SB
--Cyber Harpy Lady
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ALL)
	e1:SetValue(CARD_HARPY_LADY)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,code=CARD_HARPY_LADY})
	e2:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,code=CARD_HARPY_LADY})
	c:RegisterEffect(e2)
end
s.listed_names={CARD_HARPY_LADY}