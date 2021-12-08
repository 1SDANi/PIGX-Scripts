--ラストバトル！
--Last Turn
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsControler(1-tp) then
		a,d=d,a
	end
	return d and a:IsControler(tp) and d:IsControler(1-tp) and 
		Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and
		Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local bc=a
	if bc==c then bc=d end
	if chk==0 then return bc and bc:IsOnField() and bc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(bc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_BATTLE_DESTROYED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_BATTLED+RESET_PHASE+PHASE_MAIN2)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(s.op1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_BATTLED)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_BATTLED+RESET_PHASE+PHASE_MAIN2)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(s.op2)
		tc:RegisterEffect(e2)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(0,WIN_REASON_LAST_TURN)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(WIN_REASON_LAST_TURN,0)
end