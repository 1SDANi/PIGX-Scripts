--武装再生
--Arms Regeneration
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.eqcfilter(c,tp)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(s.eqtfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function s.eqtfilter(c,ec,tp)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and ec:CheckUniqueOnField(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local phase=Duel.GetCurrentPhase()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return ft>0 and Duel.IsExistingTarget(s.eqcfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and phase~=PHASE_DAMAGE end
	local tc=Duel.SelectTarget(tp,s.eqcfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,tc:GetControler(),0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local eqpc=Duel.GetFirstTarget()
	if not eqpc:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(s.eqtfilter,tp,LOCATION_MZONE,0,1,nil,eqpc,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local eqptg=Duel.SelectMatchingCard(tp,s.eqtfilter,tp,LOCATION_MZONE,0,1,1,nil,eqpc,tp):GetFirst()
		if eqptg then
			Duel.HintSelection(eqptg,true)
			Duel.Equip(tp,eqpc,eqptg)
		end
	end
end