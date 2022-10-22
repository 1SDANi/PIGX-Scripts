--オアシスの使者
--Emissary of the Oasis
local s,id=GetID()
function s.initial_effect(c)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.tg)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.desreptg)
	e2:SetOperation(s.desrepop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function s.tg(e,c)
	return c:IsFaceup() and (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK)))
end
function s.repfilter(c,e)
	return c:IsFaceup() and (c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_DECK))) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_MZONE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_MZONE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end