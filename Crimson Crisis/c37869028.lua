--トリプル・ヴァイパー
--Hydra Viper
local s,id=GetID()
function s.initial_effect(c)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.atcn)
	e2:SetCost(s.atcs)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.atcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():CanChainAttack(0)
end
function s.atcs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,nil,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end