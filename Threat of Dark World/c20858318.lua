--必殺！黒蠍コンビネーション
--Dark Scorpion Combination
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.listed_series={0x1a}
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a) and c:IsCanAttack()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)==5
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(og) do
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
