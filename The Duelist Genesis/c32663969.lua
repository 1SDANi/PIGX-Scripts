--ドミノ
--Domino
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1+g2,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lg=e:GetLabelObject()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>1 then
		local tc1 = tg:GetFirst()
		local tc2 = tg:GetNext()
		if tc2==lg then
			tc2=tc1
			tc1=lg
		end
		if Duel.Destroy(tc1,REASON_EFFECT) then
			Duel.Destroy(tc2,REASON_EFFECT)
		end
	end
end