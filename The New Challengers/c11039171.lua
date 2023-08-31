--デストーイ・シザー・ウルフ
--Frightfur Wolf
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,39246582,s.fusfilter)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0xa9}
s.material_setcode={0xc3,0xa9}
function s.fusfilter(c)
	return c:IsSetCard(0xc3) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end