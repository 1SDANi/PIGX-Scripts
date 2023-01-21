--ドラゴン・ウィッチ－ドラゴンの守護者－
--Lady of Dragons
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(17985575)
	c:RegisterEffect(e0)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.ccon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
s.listed_names={17985575}
function s.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function s.ccon(e)
	return Duel.IsExistingMatchingCard(FilterFaceupFunction(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,0,1,nil)
end