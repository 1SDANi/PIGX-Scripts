--アース・グラビティ
--Terra Firma Gravity
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetCondition(s.cn)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(s.atklimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e4)
end
function s.atklimit(e,c)
	return s.filter(c)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLevel(8) and not c:IsType(TYPE_RITUAL+TYPE_SPIRIT)
end
function s.cn(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(s.filter),e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end