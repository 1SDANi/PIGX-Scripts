--黒蠍－棘のミーネ
--Dark Scorpion - Meanae the Thorn
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x1a}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.filter(c)
	return c:IsSetCard(0x1a) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		or Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	local op=0
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDiscardDeck(1-tp,5) then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	else
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	end
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
		e:SetProperty(0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
		e:SetProperty(0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
