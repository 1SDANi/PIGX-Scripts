--星態龍
--Stareater Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,3,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--disable
	local e000=Effect.CreateEffect(c)
	e000:SetType(EFFECT_TYPE_FIELD)
	e000:SetCode(EFFECT_DISABLE)
	e000:SetRange(LOCATION_MZONE)
	e000:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e000:SetTarget(s.disable)
	c:RegisterEffect(e000)
end
function s.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) and e:GetHandler()~=c
end
function s.fusionfilter(c,fc,sumtype,sp,sub,mg,sg)
	local tg=fc:GetLevel()
	local rg
	local st
	if mg then
		rg=mg-sg
	end
	if sg then
		st=sg:GetSum(Card.GetLevel)
	end
	return c:IsLevelAbove(1) and (not rg or not sg or (st==tg and #sg>1) or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end