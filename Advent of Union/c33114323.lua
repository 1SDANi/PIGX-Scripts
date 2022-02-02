--メタルシルバー・アーマー
--Metalsilver Armor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,nil,s.eqlimit)
	--Untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end