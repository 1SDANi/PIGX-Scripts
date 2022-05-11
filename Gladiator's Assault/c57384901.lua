--亜空間ジャンプ装置
--Swap Swamp "A"
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_list={COUNTER_A}
s.listed_series={0xc}
function s.filter1(c)
	return c:IsAbleToChangeControler() and c:IsSetCard(0xc)
end
function s.filter2(c)
	return c:GetCounter(COUNTER_A)>0 and c:IsAbleToChangeControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(1-tp,s.filter2,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	if Duel.SwapControl(c1,c2,0,0) and c1:AddCounter(COUNTER_A,1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		c1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c1:RegisterEffect(e2)
	end
end