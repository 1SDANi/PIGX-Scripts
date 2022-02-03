--エレメント・ドラゴン
--Element Dragon
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
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(s.atcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.filter,ctlcon,LOCATION_MZONE,0,1,e:GetHandler(),ATTRIBUTE_FIRE)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():CanChainAttack()
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),ATTRIBUTE_WIND)
end
