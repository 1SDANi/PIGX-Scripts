--奇跡の発掘
--Miracle Dig
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return not c:IsAbleToGraveAsCost()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	if not (#Duel.GetFieldGroup(tp,LOCATION_DECK,0)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	if (res==0 and tc:IsType(TYPE_MONSTER))
		or (res==1 and tc:IsType(TYPE_SPELL))
		or (res==2 and tc:IsType(TYPE_TRAP)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
	end
end