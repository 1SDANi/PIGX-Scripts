--バウンサー・ガード
--Bounzer Guard
local s,id=GetID()
function s.initial_effect(c)
	--Targeted "Bounzer" monster cannot be targeted by card effect, also cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e3:SetValue(s.atlimit)
		c:RegisterEffect(e3)
	end
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end