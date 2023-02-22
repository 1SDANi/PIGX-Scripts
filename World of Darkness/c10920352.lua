--M・HERO ヴェイパー
--Masked HERO Leidenfrost
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.waterfilter,s.firefilter)
	--Attributes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_METAMORPHOSIS}
s.material_setcode={0x8,0xa008}
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE+REASON_EFFECT)~=0
end
function s.waterfilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.firefilter(c)
	return c:IsSetCard(0xa008) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end