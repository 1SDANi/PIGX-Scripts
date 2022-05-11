--古代の機械騎士
--Antique Gear Knight
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetValue(c:GetBaseAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetCondition(aux.IsGeminiState)
	e2:SetValue(c:GetBaseDefense()*2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(s.actlimit)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(aux.IsGeminiState)
	c:RegisterEffect(e4)
end
function s.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() and aux.IsGeminiState(e)
end