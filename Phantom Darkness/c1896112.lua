--次元誘爆
--Dimension Explosion
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost() and (ft>0 or c:GetSequence()<5)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsExistingTarget(s.filter,1-tp,LOCATION_REMOVED,0,1,nil,e,1-tp) end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft1=1 end
	if ft1>5 then ft1=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.filter,tp,LOCATION_REMOVED,0,1,ft1,nil,e,tp)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2>5 then ft2=5 end
	if Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT) then ft2=1 end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(1-tp,s.filter,1-tp,LOCATION_REMOVED,0,1,ft2,nil,e,1-tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,#g1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct1=#g1
	if ft1>=ct1 and (ct1==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then
		local tc=g1:GetFirst()
		for tc in aux.Next(g1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct2=#g2
	if ft2>=ct2 and (ct2==1 or not Duel.IsPlayerAffectedByEffect(1-tp,CARD_BLUEEYES_SPIRIT)) then
		local tc=g2:GetFirst()
		for tc in aux.Next(g2) do
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			--damage
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(s.op)
			tc:RegisterEffect(e1)
			--Cannot be tributed
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(3303)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_UNRELEASABLE_SUM)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e4,true)
			--Cannot be used as fusion material
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetDescription(3309)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e5:SetValue(1)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e2)
end