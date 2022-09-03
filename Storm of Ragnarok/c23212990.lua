--六武式風雷斬
--Six Strike - Twin Thunder
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
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) or
		Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
	end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then t[p]=aux.Stringid(id,0) p=p+1 end
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) then t[p]=aux.Stringid(id,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(id,0)
	local sg=nil
	if opt==0 then sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	else sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	e:SetLabel(opt)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		local sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.Destroy(sg,REASON_EFFECT)
end
