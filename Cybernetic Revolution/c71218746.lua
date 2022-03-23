--ドリルロイド
--Drillroid
local s,id=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetTarget(s.targ)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--change battle position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then	return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() then
		Duel.Destroy(t,REASON_EFFECT)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
