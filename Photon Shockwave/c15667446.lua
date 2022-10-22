--暗黒界の闘神 ラチナ
--Latinumm, War God of Dark World
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0x6}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and (r&0x4040)==0x4040
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0
		and rp~=tp and tp==e:GetLabel() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) then
		Duel.BreakEffect()
		g2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		tc2=g2:GetFirst()
		if tc2 then
			local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
			local op=0
			Duel.Hint(HINT_SELECTMSG,tp,0)
			if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
			elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(id,1))
			elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
			else return end
			if op==0 then Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
			else Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEUP) end
		end
	end
end