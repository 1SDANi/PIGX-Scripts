--真実の名
--The True Name
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsCode,10000040),s.filter1,s.filter2,nil,nil,nil,nil,SUMMON_TYPE_FUSION,nil,nil,nil,nil,nil,nil,nil,nil,nil,10000040)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetProperty(EFFECT_FLAG_DELAY)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge3:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetProperty(EFFECT_FLAG_DELAY)
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge4,0)
	end)
end
s.listed_names={14731897,10000040}
function s.filter1(c,e,tp)
	return c:IsAbleToRemove() and Duel.GetFlagEffect(tp,c:GetCode())~=0
end
function s.filter2(e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	end
	return nil
end
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(14731897) then
		Duel.RegisterFlagEffect(rp,id,0,0,1)
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=tc:GetCode()
	for tc in aux.Next(eg) do
		code=tc:GetCode()
		if Duel.GetFlagEffect(rp,code)==0 then
			Duel.RegisterFlagEffect(rp,code,0,0,1)
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)~=0
end