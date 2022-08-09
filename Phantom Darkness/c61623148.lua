--暗黒界の書物
--Dark World Grimoire
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end