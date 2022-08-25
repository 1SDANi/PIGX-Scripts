--ユニバード
--Unibird
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function s.cfilter(c,ft)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if chkc then return sg:IsContains(chkc) and chkc:IsLevelBelow(e:GetLabel()) end
	if #sg==0 then return false end
	local mg,mlv=sg:GetMinGroup(Card.GetLevel)
	local elv=e:GetHandler():GetLevel()
	local lv=(elv>=mlv) and 1 or (mlv-elv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	local minc=-ft+1
	if minc<=0 then minc=1 end
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,e:GetHandler(),ft)
	local t=g:CheckWithSumGreater(Card.GetLevel,lv,minc,99)
	Debug.Message(t)
	if chk==0 then return ft>-1 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=g:SelectWithSumGreater(tp,Card.GetLevel,lv,minc,99)
	local slv=elv+mg:GetSum(Card.GetLevel)
	mg:AddCard(e:GetHandler())
	Duel.Remove(mg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	e:SetLabel(slv)
	local tc=sg:FilterSelect(tp,Card.IsLevelBelow,1,1,nil,slv)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
