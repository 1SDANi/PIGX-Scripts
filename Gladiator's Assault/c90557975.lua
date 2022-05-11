--上昇気流
--Updraft
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_list={COUNTER_FOG}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.filter(c)
	return c:IsFaceup() and c:GetCounter(COUNTER_FOG)~=0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do 
		local cc=tc:GetCounter(COUNTER_FOG)
		ct=ct+cc
		tc:RemoveCounter(tp,COUNTER_FOG,cc,REASON_EFFECT)
	end
	if ct>0 then
		Duel.Damage(p,500*ct,REASON_EFFECT)
	end
end