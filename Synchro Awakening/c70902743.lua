--レッド・デーモンズ・ドラゴン
--Red Dragon Archfiend
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.atcon)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetTarget(s.tg)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():CanChainAttack(0)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
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
	return not rg or not sg or (st==tg and #sg>1) or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end