--ハーピィ・ダンサー
--Harpy Dancer
local s,id=GetID()
function s.initial_effect(c)
	--change name
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_ALL)
	e0:SetValue(CARD_HARPY_LADY)
	c:RegisterEffect(e0)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSummonable(true,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) end
	if chk==0 then return Duel.IsExistingTarget(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_WIND),tp,LOCATION_MZONE,0,1,nil) and
		Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil)
			if s1 then
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end