--罰則金
--Fine
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg and #eg==1 and eg:IsExists(s.filter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,1-eg:GetHandler():GetOwner(),LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetTargetPlayer(1-eg:GetHandler():GetOwner())
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.DiscardHand(p,aux.TRUE,p,p,REASON_EFFECT+REASON_DISCARD)
end