--デステニー・デストロイ
--D - Destruction
local s,id=GetID()
function s.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0xc008}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,1)
end
function s.bfilter(c,e,tp)
	return not s.sfilter(c,e,tp)
end
function s.sfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local bg=Duel.GetDecktopGroup(tp,5):Filter(s.bfilter,nil,e,tp)
	local sg=Duel.GetDecktopGroup(tp,5):Filter(s.sfilter,nil,e,tp)
	Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end