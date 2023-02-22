--Red-Eyes Archfiend Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.fusfilter1,s.fusfilter2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
end
s.material_setcode={0x3b,0x45}
function s.fusfilter1(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.fusfilter2(c)
	return c:IsSetCard(0x45) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end