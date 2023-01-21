--オーバーレイ・キャプチャー
--Xyz Capture
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.counter_place_list={COUNTER_XYZ}
function s.filter1(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_XYZ,1)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil)
	if #g1==0 or #g2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=g2:Select(tp,1,1,nil):GetFirst()
	if tc and tc:RemoveCounter(tp,COUNTER_XYZ,1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local mg=g1:Select(tp,1,1,nil)
		if mg then
			mc:AddCounter(COUNTER_XYZ,1)
		end
	end
end
