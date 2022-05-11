--スペシャル・デュアル・サモン
--Super Double Summon
local s,id=GetID()
function s.initial_effect(c)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_NORMAL)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		if s1 then
			Duel.Summon(tp,tc,true,nil)
		end
	end
	Duel.BreakEffect()
	if Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
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