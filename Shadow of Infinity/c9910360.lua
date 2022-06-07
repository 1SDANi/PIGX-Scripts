--ガエル・サンデス
--Dea3 Frog
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,true,true,s.fusfilter,3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
s.material_setcode={0x12}
function s.fusfilter(c)
	return c:IsSetCard(0x12) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x12)
end
function s.val(e,c)
	local g=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,nil)
	return #g*2000
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end