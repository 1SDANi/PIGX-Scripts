--The Millennium Eye
local s,id=GetID()
function s.initial_effect(c)
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
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(s.hidecon)
	e2:SetOperation(s.hideop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	--show hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCondition(s.con)
	e5:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e5)
	
end
s.listed_names={id,51644030}
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.publicfilter(c)
	return c:IsCode(id) and (c:IsFaceup() or c:IsLocation(LOCATION_EXTRA))
end
function s.publicop(e,tp,eg,ev,ep,re,r,rp)
	if Duel.IsExistingMatchingCard(s.publicfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,e:GetHandler()) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function s.hidefilter(c,tp)
	return c:IsCode(51644030) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
end
function s.hidecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.hidefilter,nil,tp)>0
end
function s.hideop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end