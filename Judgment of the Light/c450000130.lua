--遺言の札
--Card of Last Will
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsControler(1-tp) then a,d=d,a end
	return d and a:IsControler(tp) and d:IsControler(1-tp) and Duel.GetTurnPlayer()~=tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=5-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht<5 then 
		Duel.Draw(tp,5-ht,REASON_EFFECT)
	end
	ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht<5 then 
		Duel.Draw(1-tp,5-ht,REASON_EFFECT)
	end
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end