--闇のデッキ破壊ウイルス
--Eradicator Epidemic Virus
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,sp)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function s.hgfilter(c)
	return not c:IsPublic() or s.filter(c)
end
function s.fgfilter(c)
	return c:IsFacedown() or s.filter(c)
end
function s.tgfilter(c)
	return ((c:IsLocation(LOCATION_HAND) and c:IsPublic()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup())) and s.filter(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,0,1,nil) and
		(Duel.IsExistingMatchingCard(s.hgfilter,tp,0,LOCATION_HAND,1,nil) or Duel.IsExistingMatchingCard(s.fgfilter,tp,0,LOCATION_ONFIELD,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) then
		local conf=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
		if #conf>0 then
			Duel.ConfirmCards(tp,conf)
			local dg=conf:Filter(s.dfilter,nil)
			Duel.Destroy(dg,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end