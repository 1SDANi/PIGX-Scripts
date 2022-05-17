--ユベル－Das Abscheulich Ritter
--Yubel - Das Abscheulich Ritter
local s,id=GetID()
function s.initial_effect(c)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
s.listed_names={id,31764700}
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function s.costfilter(c)
	return ((not c:IsLocation(LOCATION_REMOVED)) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x40)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil) end
	local sg=Duel.GetMatchingGroup(s.costfilter,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_REMOVED,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function s.filter(c,e,tp)
	return c:IsCode(31764700) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end