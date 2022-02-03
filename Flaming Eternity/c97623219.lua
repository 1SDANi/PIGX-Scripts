--エレメント・ヴァルキリー
--Element Valkyrie
local s,id=GetID()
function s.initial_effect(c)
	--Attribute Fire
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e0)
	--Attribute Water
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e02:SetCode(EFFECT_ADD_ATTRIBUTE)
	e02:SetRange(LOCATION_ALL)
	e02:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e02)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.ctlcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function s.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.filter,ctlcon,LOCATION_MZONE,0,1,e:GetHandler(),ATTRIBUTE_FIRE)
end
function s.ctlcon(e)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler(),ATTRIBUTE_WATER)
end
