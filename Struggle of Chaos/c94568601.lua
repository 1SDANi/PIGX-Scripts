--タイラント・ドラゴン
--Tyrant Dragon
local s,id=GetID()
function s.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(s.atcon)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_TRAP) and aux.tgoval(e,re,rp)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.bdcon(e,tp,eg,ep,ev,re,r,rp) and c:CanChainAttack()
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end