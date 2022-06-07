--ダークネス ２
--NULL
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKDEFCHANGE+CATEGORY_ATKDEFCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.flagfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:GetFlagEffect(id)==0 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.flagfilter,tp,LOCATION_SZONE,0,e:GetHandler())
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_CONTROL|RESET_CHAIN,0,1)
		end
		return true
	end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_SZONE,0,nil)
	if ct>3 then ct=3 end
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_FZONE)<=0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_ATKDEFCHANGE,g,#g,0,0)
		Duel.SetOperationInfo(0,CATEGORY_ATKDEFCHANGE,g,#g,0,0)
		e:SetLabel(ct)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000*ct)
		tc:RegisterEffect(e1)
	end
end