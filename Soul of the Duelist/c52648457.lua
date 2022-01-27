--ゴーゴンの眼
--Gorgon's Eye
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.distg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(op)
	Duel.RegisterEffect(e1,tp)
end
function s.distg(e,c)
	if e:GetLabel()==0 then
		return c:IsAttackPos()
	else
		return c:IsDefensePos()
	end
end
