--マジック・スライム
--Magic Reflect Slime
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableGeminiAttribute(c)
	--battle indestructable
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetCondition(aux.IsGeminiState)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetCondition(aux.IsGeminiState)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Double damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(s.dcon)
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e2)
end
function s.dcon(e)
	return Duel.GetAttackTarget()==e:GetHandler() or Duel.GetAttacker()==e:GetHandler() and aux.IsGeminiState(e)
end
