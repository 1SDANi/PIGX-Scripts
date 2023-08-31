--マシンナーズ・メガフォーム
--Machina Tank
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,false,true,true,s.fusionfilter,1,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
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
	return c:IsLevelAbove(1) and c:IsRace(RACE_MACHINE) and (not rg or not sg or (st==tg and #sg>=1) or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.Destroy(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end