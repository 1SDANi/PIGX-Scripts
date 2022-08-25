--スクラップ・カウンター
--Scrap Rage
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.destg)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
end
function s.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsDestructable() and not c:IsReason(REASON_REPLACE)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.dfilter,1,nil,tp) end
	local g=eg:Filter(s.dfilter,nil,tp)
	if g and #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Destroy(tp,g)
		return true
	else return false end
end
function s.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(e:GetHandler():GetControler()) and c:IsReason(REASON_BATTLE) and c:IsDestructable() and not c:IsReason(REASON_REPLACE)
end
