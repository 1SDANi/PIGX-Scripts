--ディスカバード・アタック
--Discovered Attack
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x45}
s.listed_names={35975813}
function s.filter1(c)
	return c:IsFaceup() and c:IsCode(35975813)
end
function s.filter2(c)
	return c:IsFaceup() and not c:IsCode(35975813) and c:IsSetCard(0x45) and c:IsAbleToHandAsCost()
end
function s.filter3(c)
	return c:IsFaceup() and not c:IsCode(35975813) and c:IsSetCard(0x45) and c:IsCanAttack()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(filter3,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(og) do
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
