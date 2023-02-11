--グリザイユの牢獄
--Grisaille Prison
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_DELAY)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(s.checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge3:SetOperation(s.checkop)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetProperty(EFFECT_FLAG_DELAY)
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetOperation(s.checkop)
		Duel.RegisterEffect(ge4,0)
	end)
end
function s.checkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		if s.checkfilter(tc) and rp==e:GetHandler():GetControler() then
			Duel.RegisterFlagEffect(rp,id,0,0,1)
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),id)<=0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return (sumtp&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
