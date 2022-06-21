--化石融合－フォッシル・フュージョン
--Fossil Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff{handler=c,matfilter=aux.FALSE,extrafil=s.fextra,exactcount=2,extraop=Fusion.BanishMaterial,extrafil2=s.fextra2}
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function s.check(tp,sg,fc)
	return sg:IsExists(Card.IsControler,1,nil,tp)
end
function s.check2(tp,sg,fc)
	return sg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil),s.check
end
function s.fextra2(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil),s.check2
end