--The Millennium Key
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
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
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
	--battle indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_EXTRA+LOCATION_REMOVED)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.tg)
	e4:SetValue(s.valcon)
	c:RegisterEffect(e4)
end
s.listed_names={id,2926176,51644030,1000007}
s.listed_series={0x302}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():IsLocation(LOCATION_REMOVED) and e:GetHandler():GetFlagEffect(id+(1-tp))==0) or
		(e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():GetFlagEffect(id+tp)==0) end
	if e:GetHandler():IsLocation(LOCATION_REMOVED) then
		e:GetHandler():RegisterFlagEffect(id+(1-tp),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	elseif e:GetHandler():IsLocation(LOCATION_EXTRA) then
		e:GetHandler():RegisterFlagEffect(id+tp,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.tg(e,c)
	if e:GetHandler():GetFlagEffect(id+c:GetControler())~=0 then
		return false
	end
	if (c:GetControler()==1-e:GetHandler():GetControler() and e:GetHandler():IsLocation(LOCATION_REMOVED)) or
		(c:GetControler()==e:GetHandler():GetControler() and e:GetHandler():IsLocation(LOCATION_EXTRA)) then
		e:GetHandler():RegisterFlagEffect(id+c:GetControler(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	end
end
function s.valcon(e,re,r,rp)
	if (e:GetHandler():IsLocation(LOCATION_EXTRA) or e:GetHandler():IsFaceup()) and ((r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0) then
		if not Duel.IsExistingMatchingCard(s.millenniumfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,e:GetHandler()) then
			Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
		end
		return true
	else
		return false
	end
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
	elseif Duel.IsExistingMatchingCard(s.millenniumfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,e:GetHandler()) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
function s.hidefilter(c,tp)
	return c:IsCode(2926176) and c:IsControler(tp)
end
function s.hidecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.hidefilter,1,nil,tp) and re and re:GetHandler() and re:GetHandler():IsCode(51644030)
end
function s.hideop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end