--岩投げエリア
--Catapult Zone
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(s.destg)
	e2:SetValue(s.value)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.dfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE)
end
function s.repfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=eg:IsExists(s.dfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_DECK,0,1,nil)
	local c2=eg:IsExists(s.dfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(s.repfilter,1-tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return e:GetHandler():GetFlagEffect(id+e:GetHandler():GetControler())~=0 and (c1 or c2 and not (c1 and c2)) end
	e:GetHandler():RegisterFlagEffect(id+e:GetHandler():GetControler(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if c1 then
		e:SetLabel(tp)
		return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
	else
		e:SetLabel(1-tp)
		return Duel.SelectEffectYesNo(1-tp,e:GetHandler(),96)
	end
end
function s.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,p,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
