--妖刀竹光
--Cursed Bamboo Sword
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.eqfilter)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end
s.listed_series={0x60}
function s.eqfilter(c)
	return c:GetEquipCount()~=0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x60)
end