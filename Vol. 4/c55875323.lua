--でんきトカゲ
--Electric Lizard
local s,id=GetID()
function s.initial_effect(c)
	--cannot attack or change battle position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsRelateToBattle() end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(3206)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		--Cannot change its battle position
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3313)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
	end
end