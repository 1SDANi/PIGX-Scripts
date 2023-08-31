--始祖竜ワイアーム
--First of the Dragons
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMixN(c,false,true,true,s.filter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION,nil,nil,nil,nil,nil,true)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end
function s.indval(e,c)
	return not c:IsType(TYPE_NORMAL)
end
function s.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_UNION) and c:IsType(TYPE_NORMAL)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end