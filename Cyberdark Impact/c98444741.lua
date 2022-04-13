--積み上げる幸福
--Accumulated Treasure
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	e:SetLabel(Duel.GetCurrentChain())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local chain=e:GetLabel()
	if chain<=1 then
		local g=Duel.GetDecktopGroup(tp,1)
		Duel.ConfirmCards(p,g)
	elseif chain<=2 then
		Duel.DiscardDeck(p,1,REASON_EFFECT)
	elseif chain<=3 then
		Duel.Draw(p,1,REASON_EFFECT)
	else
		Duel.Draw(p,2,REASON_EFFECT)
	end
end