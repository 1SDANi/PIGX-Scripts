--マスター・ピース
--Masterpiece
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,aux.TRUE,nil,s.fextra,Fusion.BanishMaterial)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c,tid)
	return c:IsAbleToRemove() and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,Duel.GetTurnCount())
	end
	return nil
end