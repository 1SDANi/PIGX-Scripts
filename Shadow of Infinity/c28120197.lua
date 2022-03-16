--断層地帯
--Canyon
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.tg)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttackTarget()
	Debug.Message(a:IsAttribute(ATTRIBUTE_EARTH))
	Debug.Message(a:IsPosition(POS_FACEDOWN_DEFENSE))
	return a and a:IsAttribute(ATTRIBUTE_EARTH) and a:IsPosition(POS_FACEDOWN_DEFENSE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttackTarget()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(a:GetBaseDefense()*2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
	a:RegisterEffect(e2,true)
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0
end
function s.tg(e,c)
	if e:GetHandler():GetFlagEffect(id+c:GetControler())~=0 then
		return false
	end
	if c:IsPosition(POS_FACEDOWN_DEFENSE) then
		e:GetHandler():RegisterFlagEffect(id+c:GetControler(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return true
	end
end