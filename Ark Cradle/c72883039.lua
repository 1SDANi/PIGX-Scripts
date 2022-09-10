--無限光アイン・ソフ・オウル
--Infinite Light
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetTarget(s.etarget)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(1)
	e3:SetTarget(s.reptg)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end
s.listed_names={36894320}
function s.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil,36894320)
end
function s.etarget(e,c)
	return c:GetOriginalType()&TYPE_EXTRA~=0
end
function s.repfilter(c,e)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not tc:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if #eg~=1 then return false end
		local tc=eg:GetFirst()
		return tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsAttribute(ATTRIBUTE_DIVINE) 
			and not tc:IsReason(REASON_REPLACE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_MZONE,0,1,tc)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_MZONE,0,1,1,tc)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end