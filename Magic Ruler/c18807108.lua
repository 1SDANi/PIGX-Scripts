--六芒星の呪縛
--Cursed Hexagram
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--Pos limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
end