--エーリアン・ブレイン
--Alien Brain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.counter_place_list={COUNTER_A}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return #eg==1 and ec:IsPreviousControler(tp) and ec:IsRace(RACE_REPTILE)
		and (ec:GetPreviousRaceOnField()&RACE_REPTILE)~=0
		and ec==Duel.GetAttackTarget() and ec:IsLocation(LOCATION_GRAVE) and ec:IsReason(REASON_BATTLE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst():GetReasonCard()
	if chk==0 then return tc:IsControler(1-tp) and tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst():GetReasonCard()
	if tc:IsControler(1-tp) and tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControlerCanBeChanged() and tc:AddCounter(COUNTER_A,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		Duel.GetControl(tc,tp)
	end
end
