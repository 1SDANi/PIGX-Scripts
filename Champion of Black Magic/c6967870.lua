--黒蠍－罠はずしのクリフ
--Dark Scorpion - Cliff the Trap Remover
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.filter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,2)
		or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	local op=0
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsPlayerCanDiscardDeck(1-tp,2) then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif Duel.IsPlayerCanDiscardDeck(1-tp,2) then
		Duel.SelectOption(tp,aux.Stringid(id,2))
		op=1
	else
		Duel.SelectOption(tp,aux.Stringid(id,1))
		op=0
	end
	e:SetLabel(op)
	if op==0 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
		e:SetProperty(0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	else
		Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
	end
end
