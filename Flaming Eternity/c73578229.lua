--ポールポジション
--Pole Position
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	--Adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.adjustop)
	e2:SetLabelObject(g)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTarget(s.etarget)
	e3:SetValue(s.efilter)
	e3:SetLabelObject(g)
	c:RegisterEffect(e3)
end
function s.etarget(e,c)
	return e:GetLabelObject():IsContains(c)
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local preg=e:GetLabelObject()
	if #g>0 then
		local ag=g:GetMaxGroup(Card.GetBaseAttack)
		if ag:Equal(preg) then return end
		preg:Clear()
		preg:Merge(ag)
	else
		if #preg==0 then return end
		preg:Clear()
	end
	Duel.AdjustInstantly(e:GetHandler())
	Duel.Readjust()
end