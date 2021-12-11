--大神官デ・ザード
--High Priest Dezard
local s,id=GetID()
function s.initial_effect(c)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--fusion
	local params = {nil,Fusion.CheckWithHandler(Fusion.OnFieldMat(aux.FilterBoolFunction(Card.IsCode,39711336))),nil,nil,Fusion.ForcedHandler}
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e3:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e3)
end
function s.efilter(e,re,rp)
	return (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP))
		and re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end