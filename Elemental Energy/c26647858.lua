--ヒーロー・ヘイロー
--HERO Halo
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetValue(s.atval)
	c:RegisterEffect(e2)
end
function s.atval(e,c)
	return c:IsAttackAbove(1900) and not c:IsImmuneToEffect(e)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end