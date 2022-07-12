--A・O・J ブラインド・サッカー
--Ally of Justice Ammit
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetTarget(s.targ)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if t==e:GetHandler() then t=Duel.GetAttacker() end
	if chk ==0 then	return t and not t:IsAttribute(ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,t,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t==e:GetHandler() then t=Duel.GetAttacker() end
	if t and t:IsRelateToBattle() and t:IsAttribute(ATTRIBUTE_DARK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_OVERLAY)&~(RESET_LEAVE|RESET_TOGRAVE))
		t:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_OVERLAY)&~(RESET_LEAVE|RESET_TOGRAVE))
		t:RegisterEffect(e2)
	end
end
