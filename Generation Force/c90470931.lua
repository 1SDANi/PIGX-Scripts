--鬼神の連撃
--Divine Rampage
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_list={COUNTER_XYZ}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function s.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK) and c:IsType(TYPE_FUSION) and e:GetHandler():IsCanRemoveCounter(tp,COUNTER_XYZ,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	ct=Duel.AnnounceNumber(tp,1,g:GetFirst():GetCounter(COUNTER_XYZ))
	e:GetHandler():RemoveCounter(tp,COUNTER_XYZ,ct,REASON_COST)
	e:SetLabel(ct)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=e:GetLabeL()
	if tc:IsRelateToEffect(e) then
		--Attack up to the number of monsters you control
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end