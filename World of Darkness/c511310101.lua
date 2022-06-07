--ダークネス １
--NaN
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
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
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
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
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_FZONE)<=0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		if #tg>0 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end