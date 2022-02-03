--ポイズン・ファング
--Poison Fangs
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--Double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetCondition(s.dcon)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler() and c:IsRace(RACE_BEAST)
end
function s.dcon(e)
	return Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget() or Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end