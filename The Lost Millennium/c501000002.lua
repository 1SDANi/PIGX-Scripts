--破壊王ゼクゼクス
--King of Destruction - Xexex
local s,id=GetID()
function s.initial_effect(c)
	--summon with 3 tribute
	local e2=aux.AddNormalSetProcedure(c)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,WIN_REASON_DUEL_WINNER)
end