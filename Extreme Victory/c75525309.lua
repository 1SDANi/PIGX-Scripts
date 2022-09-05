--六武派二刀流
--Six Strike - Dual Wield
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={0x3d}
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x3d),tp,LOCATION_MZONE,0,3,nil)
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	local sg=nil
	if sel==0 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	else Duel.SetOperationInfo(0,CATEGORY_NEGATE,g,#g,0,0) end
	e:SetLabel(sel)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local g=Duel.GetTargetCards(e)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg and #sg>0 then
		if opt==0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else
			local tc=sg:GetFirst()
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
