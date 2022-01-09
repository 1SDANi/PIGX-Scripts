--リバースダイス
--Re-Roll
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Redo the roll
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetOperation(s.coinop)
	c:RegisterEffect(e2)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		local ct1=(ev&0xff)
		local ct2=(ev>>16)
		Duel.TossDice(ep,ct1,ct2)
	end
end
