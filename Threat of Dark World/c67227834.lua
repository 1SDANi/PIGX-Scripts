--魔術の呪文書
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL))
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(s.atkvalue)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(s.defvalue)
	c:RegisterEffect(e2)
end
function s.atkvalue(e,c)
	return c:GetBaseAttack()*2
end
function s.defvalue(e,c)
	return c:GetBaseDefense()*2
end