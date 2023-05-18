--魔轟神獣ユニコール
--The Fabled Unicorn
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,true,s.fusionfilter,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
end
s.material_race={RACE_FIEND,RACE_BEAST}
function s.disable(e,c)
	return c:IsType(TYPE_EFFECT) and c~=e:GetHandler() and Duel.GetFieldGroupCount(e:GetHandler(),LOCATION_HAND,0)==0
end
function s.chaosfilter(c,rac,rg,st,mg)
	local sg=rg-c
	if (not c:IsRace(rac)) or sg:CheckWithSumEqual(s.chaosfilter,st-c:GetLevel(),1,99,c:GetRace(),sg,st-c:GetLevel(),mg) or mg:IsExists(aux.NOT(Card.IsRace),1,nil,rac) then
		return c:GetLevel()
	else
		return 0
	end
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
	return c:IsLevelAbove(1) and (not rg or not sg or (st==tg and #sg>1) or (st<tg and rg:CheckWithSumEqual(s.chaosfilter,tg-st,1,99,c:GetAttribute(),rg,tg-st,mg))) and
		c:IsRace(RACE_BEAST+RACE_FIEND) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:FilterCount(aux.TRUE,c)>1 or (not sg:IsExists(Card.IsRace,1,c,c:GetRace())))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end