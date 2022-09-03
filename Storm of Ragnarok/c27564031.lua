--Malefic World
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.listed_series={0x23}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(Duel.GetTurnPlayer(),LOCATION_DECK,0)>0 and Duel.GetDrawCount(Duel.GetTurnPlayer())>0
end
function s.filter(c)
	return c:IsSetCard(0x23) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,Duel.GetTurnPlayer(),LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(Duel.GetTurnPlayer())
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,Duel.GetTurnPlayer(),LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(id,1)) then return end
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,Duel.GetTurnPlayer(),HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(Duel.GetTurnPlayer(),s.filter,Duel.GetTurnPlayer(),LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-Duel.GetTurnPlayer(),g)
	end
end
