--オーロラ・ドロー
--Aurora Draw
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.ntcon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x13}
function s.cfilter(c)
	return c:GetCode()==id
end
function s.ntcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x13),tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
