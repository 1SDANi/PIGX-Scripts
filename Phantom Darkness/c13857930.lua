--N・ティンクル・モス
--Neo-Spacian Twinkle Moss
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,false,true,true,17732278,1)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_METAMORPHOSIS}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget() and e:GetHandler():IsRelateToEffect(e) and Duel.IsPlayerCanDraw(tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(id,1)
	opval[off-1]=1
	off=off+1
	if not a:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=2
		off=off+1
	end
	if d and d:IsAttackPos() and d:IsCanChangePosition() then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		if Duel.NegateAttack() then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	elseif opval[op]==2 then
		Duel.ChangeAttackTarget(nil)
	elseif opval[op]==3 then
		Duel.ChangePosition(a,POS_FACEUP_DEFENSE)
	end
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end