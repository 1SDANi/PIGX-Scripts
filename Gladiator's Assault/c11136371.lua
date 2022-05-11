--カウンター・ジェム
--Gem-Counter
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
end
s.listed_series={0x1034}
function s.plfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_UNION) and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_GRAVE,0,ft,ft,nil)
	if #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS+TYPE_UNION)
			tc:RegisterEffect(e1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetOperation(s.desop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			tc:RegisterEffect(e3,true)
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end