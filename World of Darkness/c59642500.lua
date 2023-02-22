--M・HERO 闇鬼
--Masked HERO Eclipse
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.darkfilter,s.lightfilter)
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e0)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e3:SetCondition(s.con)
	c:RegisterEffect(e3)
	--cannot draw
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_DRAW)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.con)
	c:RegisterEffect(e4)
end
s.listed_names={CARD_METAMORPHOSIS}
s.material_setcode={0x8,0xa008}
function s.con(e)
	return not Duel.GetCurrentPhase()==PHASE_DRAW
end
function s.darkfilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.lightfilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end