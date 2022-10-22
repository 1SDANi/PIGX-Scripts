--燃える闘志
--Fiery Fervor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function s.value(e,c)
	if Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) then
		return c:GetBaseAttack()*2
	else
		c:GetBaseAttack()
	end
end
