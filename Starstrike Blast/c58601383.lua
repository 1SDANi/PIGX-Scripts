--地天の騎士ガイアドレイク
--Gaia the Fierce Knight of Earth and Wind
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,s.fusfilter,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FUSION))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter1)
	c:RegisterEffect(e2)
	--cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter2)
	c:RegisterEffect(e3)
end
function s.fusfilter(c)
	return c:IsSetCard(0xbd) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.efilter1(e,re,rp)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function s.efilter2(e,re)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end