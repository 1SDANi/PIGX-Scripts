--七皇再生
--Rebirth of the Seven Emperors
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x1048}
s.listed_names={67926903}
s.counter_place_list={COUNTER_XYZ}
function s.cfilter(c,tp)
	return c:GetSequence()<5 and c:IsControler(tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,exg=Duel.GetReleaseGroup(tp):Split(aux.ReleaseCostFilter,nil,tp)
	if chk==0 then return #g>0 and g:FilterCount(s.cfilter,nil,tp)+Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local sg=Duel.SelectReleaseGroupCost(tp,nil,2,2,false,nil,nil)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end
function s.spfilter(c,e,tp)
	local no=c.xyz_number
	return (c:IsCode(67926903) or (c:IsSetCard(0x1048) and no and no>=101 and no<=107)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=e:GetLabel()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and ct>0 then
		tc:AddCounter(COUNTER_XYZ,1)
	end
end