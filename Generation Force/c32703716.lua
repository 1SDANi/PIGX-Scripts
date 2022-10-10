--フィッシュアンドキックス
--Fish and Kicks
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUATIC)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
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
		if Duel.SendtoGrave(tc1,REASON_EFFECT)>0 then
			Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		end
	end
end