--エクシーズ・ダブル・バック
--Xyz Double Back
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp) and
		c:IsType(TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(c,e,tp,atk)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttackBelow(atk) and c:IsType(TYPE_FUSION)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg and #eg==1 and eg:IsExists(s.cfilter,1,nil,tp) and (not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,eg)) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,eg:GetFirst(),e,tp,eg:GetFirst():GetAttack()) end
	Duel.SetTargetCard(eg:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,eg:GetFirst(),e,tp,eg:GetFirst():GetAttack())
	g:AddCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #fg>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #fg>1 and ft==1 then fg=fg:Select(tp,1,1,nil) end
	for tc in aux.Next(fg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		--Cannot be tributed for a tribute summon
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(3304)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetOperation(s.desop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		tc:RegisterEffect(e4,true)
		--Cannot be used as fusion material
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetDescription(3309)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5,true)
	end
	Duel.SpecialSummonComplete()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
