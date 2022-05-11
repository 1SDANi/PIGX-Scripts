--アステカの石像
--Stone Statue of the Aztecs
local s,id=GetID()
function s.initial_effect(c)
	--reflect battle dam
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
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
	return Duel.GetAttackTarget()==e:GetHandler() or Duel.GetAttacker()==e:GetHandler()
end

