--M・HERO カミカゼ
--Masked HERO Khamsin
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.earthfilter,s.windfilter)
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(s.sumlimit)
	c:RegisterEffect(e4)
end
s.listed_names={CARD_METAMORPHOSIS}
s.material_setcode={0x8,0xa008}
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and c:IsControler(1-e:GetHandler():GetControler())
end
function s.earthfilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.windfilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end