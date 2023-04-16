--狂戦士の魂
--Berserker Soul
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetAttackTarget()==nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and eg:GetFirst():IsControler(tp) and Duel.GetFieldGroup(tp,LOCATION_DECK,0)>0 and eg:GetFirst():IsAttackBelow(1500) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		Duel.ChainAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetCondition(s.condition)
		e1:SetOperation(s.op)
		eg:GetFirst():RegisterEffect(e1)
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		Duel.ChainAttack()
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end