--七皇転生
--Reincarnation of the Seven Emperors
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x1048}
s.listed_names={67926903}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	local no=a.xyz_number
	if chk==0 then return d and a:IsControler(tp) and d:IsControler(1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 and
		(a:IsCode(67926903) or (a:IsSetCard(0x1048) and no and no>=101 and no<=107)) and a:IsCanRemoveAsCost() end
	Duel.Remove(a,POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsSetCard(0x48)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if chk==0 then return g and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Damage(1-tp,g:GetBaseAttack(),REASON_EFFECT)
	end
end