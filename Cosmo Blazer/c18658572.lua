--見世物ゴブリン
--Egotistical Goblin
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.cfcn)
	e3:SetOperation(s.cfop)
	c:RegisterEffect(e3)
end
function s.cfcn(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.DisableShuffleCheck()
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.MoveSequence(tc,1)
	end
end
