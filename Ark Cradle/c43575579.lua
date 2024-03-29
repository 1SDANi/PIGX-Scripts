--アフター・グロー
--Afterglow
--Scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.cfilter(c)
	return c:IsCode(id) and c:IsAbleToRemove() and ((not c:IsLocation(LOCATION_REMOVED)) or c:IsFaceup())
end
function s.tdfilter(c)
	return c:IsCode(id) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT) then
		Duel.SendtoDeck(td,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_DRAW)
		e1:SetCountLimit(1)
		e1:SetCondition(s.cn)
		e1:SetOperation(s.op)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function s.cn(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (r&REASON_RULE)~=0 and Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()  and Duel.GetCurrentPhase()==PHASE_DRAW and #eg>0
end
function s.draw(c,e)
	return c==e:GetHandler()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if #eg<1 then return end
	Duel.ConfirmCards(1-tp,eg)
	local g=eg:Filter(s.draw,nil,e)
	if #g>0 and #eg==1 then
		Duel.Win(tp,WIN_REASON_AFTERGLOW)
	else
		Duel.Win(1-tp,WIN_REASON_AFTERGLOW)
	end
	Duel.ShuffleHand(tp)
end
