--宝玉の双璧
--Gem-Pair
local s,id=GetID()
function s.initial_effect(c)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.tfcon)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
end
s.listed_series={0x1034}
function s.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tffilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_UNION) and not c:IsForbidden()
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.damval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e4=Effect.CreateEffect(c)
		e4:SetCode(EFFECT_CHANGE_TYPE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e4:SetValue(TYPE_SPELL+TYPE_CONTINUOUS+TYPE_UNION)
		tc:RegisterEffect(e4)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end
function s.damval(e,re,val,r,rp,rc)
	if (r&REASON_EFFECT)~=0 then return 0
	else return val end
end
