--カース・オブ・ヴァンパイア
--Vampire Baron
local s,id=GetID()
function s.initial_effect(c)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r&REASON_BATTLE)~=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c or not c:IsRelateToEffect(e) then return end
	local res=(Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp) and 2 or 1
	local turn_asc=(Duel.GetCurrentPhase()<PHASE_STANDBY and Duel.GetTurnPlayer()==tp) and 0 or (Duel.GetTurnPlayer()==tp) and 2 or 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,res)
	e1:SetLabel(turn_asc+Duel.GetTurnCount())
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	Duel.RegisterEffect(e1,tp)
	c:CreateEffectRelation(e1)
end
function s.spcon(e,tp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
	local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function s.tgfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	if e:GetLabel()==0 then g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	elseif e:GetLabel()==1 then g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	else g=Duel.SelectMatchingCard(1-tp,s.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP) end
	if Duel.SendtoGrave(g,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		g:GetFirst():RegisterEffect(e2)
	end
end
