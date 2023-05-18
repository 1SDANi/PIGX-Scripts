--The Millennium Necklace
local s,id=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--sum limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	e0:SetCondition(aux.TRUE)
	c:RegisterEffect(e0)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(s.publicop)
	c:RegisterEffect(e1)
	--to fusion deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(s.hidecost)
	e2:SetOperation(s.hideop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--reveal
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_REMOVED+LOCATION_EXTRA)
	e4:SetCountLimit(1)
	e4:SetCondition(s.con)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
s.listed_names={id,1000007}
s.listed_series={0x302}
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) or e:GetHandler():IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and
		((Duel.GetTurnPlayer()==1-e:GetHandler():GetControler() and e:GetHandler():IsLocation(LOCATION_REMOVED)) or
		(Duel.GetTurnPlayer()==e:GetHandler():GetControler() and e:GetHandler():IsLocation(LOCATION_EXTRA))) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,1)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	g1:Merge(g2)
	Duel.ConfirmCards(tp,g1)
end
function s.publicfilter(c)
	return c:IsCode(id) and (c:IsFaceup() or c:IsLocation(LOCATION_EXTRA))
end
function s.millenniumfilter(c)
	return (c:IsSetCard(0x302) or c:IsCode(1000007)) and (c:IsFaceup() or c:IsLocation(LOCATION_EXTRA))
end
function s.publicop(e,tp,eg,ev,ep,re,r,rp)
	if Duel.IsExistingMatchingCard(s.publicfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,e:GetHandler()) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	else if Duel.IsExistingMatchingCard(s.millenniumfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,e:GetHandler()) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function s.hidecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,6,nil,0x302) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_EXTRA,0,6,6,nil,0x302)
	Duel.ConfirmCards(1-tp,g)
end
function s.hideop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end