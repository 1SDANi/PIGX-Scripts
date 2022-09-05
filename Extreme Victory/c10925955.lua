--儀水鏡との交信
--Water Mirror Contact
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c,rit)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and (not rit or c:IsType(TYPE_RITUAL))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	local sel=0
	local ac=0
	if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
	if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
	if sel==1 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif sel==2 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	elseif Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,true) then
		ac=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	else
		ac=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	end
	e:SetLabel(ac)
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.atchk1,1,nil,sg)
end
function s.atchk1(c,sg)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL+TYPE_TRAP) and sg:FilterCount(Card.IsType,c,TYPE_MONSTER)==1
end
function s.spfilter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	if ac==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif ac==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
