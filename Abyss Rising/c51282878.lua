--フィッシュボーグ－プランター
--Fishborg Planter
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAbletoRemove() end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)~=0 then
		local oc=Duel.GetOperatedGroup():GetFirst()
		local c=e:GetHandler()
		if oc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
			if oc:IsType(TYPE_MONSTER) and oc:IsAttribute(ATTRIBUTE_WATER) then
				if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
					--Banish it if it leaves the field
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(3300)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e1:SetValue(LOCATION_REMOVED)
					c:RegisterEffect(e1,true)
				end
			else
				Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
