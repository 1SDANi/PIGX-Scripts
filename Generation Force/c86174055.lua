--スピッド・バード
--Speed Bird
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter(chkc) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if chk==0 then return ft>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local c=ft
	if c>2 then c=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then c=1 end
	if #g==0 then return end
	local sg=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then c=1 end
	if #g==0 or ft<#g then return end
	local t1=g:GetFirst()
	local t2=g:GetNext()
	Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP)
	--Cannot be used as synchro material
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	t1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	t1:RegisterEffect(e2)
	if t2 then
		Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		t2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		t2:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
