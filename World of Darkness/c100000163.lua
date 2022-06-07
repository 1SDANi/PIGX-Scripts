--クリアー・ヴィシャス・ナイト
--Clear Knight
local s,id=GetID()
function s.initial_effect(c)
	--clear
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.indtg)
	e3:SetValue(s.indval)
	c:RegisterEffect(e3)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_ATTACK)
	e7:SetValue(s.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_DEFENSE)
	e8:SetValue(s.atkval)
	c:RegisterEffect(e8)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if not g or #g<=1 then return 0 end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:GetFirst():GetAttack()
end
function s.indtg(e,c)
	e:SetLabel(c:GetAttack())
	return true
end
function s.indval(e,c)
	return c:GetAttack()==e:GetLabel()
end