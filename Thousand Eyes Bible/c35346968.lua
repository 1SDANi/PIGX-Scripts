--神の恵み
--Bless the Rain
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000*#eg)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000*#eg,REASON_EFFECT)
end
