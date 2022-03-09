--暗黒界の軍神 シルバ
--Sillva, Warlord of Dark World
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and (r&0x4040)==0x4040
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0
			and rp~=tp and tp==e:GetLabel() and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 then
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			local ct=1
			if #g>1 then ct=Duel.AnnounceNumber(tp,1,2) end
			local sg=g:RandomSelect(ep,1)
			if ct>1 then
				g:RemoveCard(sg:GetFirst())
				sg:Merge(g:RandomSelect(ep,1))
			end
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
