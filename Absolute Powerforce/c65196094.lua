--バラエティ・アウト
--The Spice of Life
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3) and c:IsCanBeEffectTarget(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g:GetClassCount(Card.GetRace)>=3 end
	local tg=aux.SelectUnselectGroup(g,e,tp,3,3,aux.dpcheck(Card.GetRace),1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg and #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		for tc in aux.Next(sg) do
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
			--Banish it if it leaves the field
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetDescription(3300)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e4:SetValue(LOCATION_REMOVED)
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
	end
end