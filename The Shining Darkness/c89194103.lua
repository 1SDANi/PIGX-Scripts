--魔轟神獣クダベ
--The Fabled Kudan
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TRUE)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
s.material_race={RACE_FIEND,RACE_BEAST}
function s.valcon(e,re,r,rp)
	return ((r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
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
	return c:IsLevelAbove(1) and (not rg or not sg or (st==tg and #sg>1) or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99))) and
		c:IsRace(RACE_BEAST+RACE_FIEND) and
		(not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:FilterCount(aux.TRUE,c)>1 or
		((not sg:IsExists(Card.IsRace,1,c,c:GetRace()))))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end