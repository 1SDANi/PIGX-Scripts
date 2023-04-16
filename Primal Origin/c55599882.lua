--武神決戦
--Bujintervention
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.rmcn)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
s.listed_names={0x88}
function s.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and rc:IsSetCard(0x88) and rc:IsControler(tp) and rc:IsRelateToBattle()
end
function s.rmcn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.filter(c,code)
	return c:IsAbleToRemove() and c:IsOriginalCodeRule(code)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,1,nil,eg:GetFirst():GetOriginalCodeRule()) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,nil,eg:GetFirst():GetOriginalCodeRule())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,eg:GetFirst():GetOriginalCodeRule())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
