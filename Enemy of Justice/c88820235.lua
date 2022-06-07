--E・HERO シャイニング・フレア・ウィングマン
--Elemental HERO Shining Enforcer
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixWithDescription(c,aux.Stringid(id,2),true,true,21844576,58932615,20721928)
	Fusion.AddProcMixWithDescription(c,aux.Stringid(id,1),true,true,41436536,20721928)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.atkup)
	c:RegisterEffect(e3)
end
s.listed_series={0x8}
s.material_setcode={0x8,0x3008}
function s.filter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER)
end
function s.atkup(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
