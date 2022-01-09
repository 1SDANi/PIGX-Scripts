--セカンド・チャンス
--Second Coin Toss
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Redo the coin toss
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetOperation(s.coinop)
	c:RegisterEffect(e2)
end
s.toss_coin=true
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.TossCoin(tp,ev)
	end
end
