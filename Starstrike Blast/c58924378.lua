--エレキャッスル
--Wattcastle
local s,id=GetID()
function s.initial_effect(c)
	--Atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_BATTLE_CONFIRM)
	e0:SetRange(LOCATION_FZONE)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end
s.listed_series={0xe}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	if chk==0 then return bc and tc:IsFaceup() and tc:IsSetCard(0xe) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	if bc and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end