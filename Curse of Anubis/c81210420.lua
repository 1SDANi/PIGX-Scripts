--マジカルシルクハット
--Magical Hats
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_EFFECT,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	local fid=e:GetHandler():GetFieldID()
	local i=0
	for tg in aux.Next(sg) do
		--destroy
		local e6=Effect.CreateEffect(tg)
		e6:SetDescription(aux.Stringid(id,1))
		e6:SetCategory(CATEGORY_DESTROY)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetTarget(s.destg)
		e6:SetOperation(s.desop)
		tg:RegisterEffect(e6)
		tg:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_DARK,RACE_SPELLCASTER,1,0,0)
		if Duel.SpecialSummonStep(tg,0,tp,tp,true,false,POS_FACEUP_DEFENSE) then
			i = i + 1
		end
		tg:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
	if i==2 then
		local fg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		if #fg>0 then
			Duel.ChangePosition(fg,POS_FACEDOWN_DEFENSE)
		end
		Duel.BreakEffect()
		Duel.ShuffleSetCard(fg)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
