--ファラオの審判
--Judgment of the Pharaoh
local s,id=GetID()
function s.initial_effect(c)
	--"Yu-Jo Friendship" (Monster lock)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
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
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge2,0)
	end)
end
s.listed_names={81332143,14731897}
function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(81332143) then
		Duel.RegisterFlagEffect(rp,id,0,0,1)
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	 if rp==e:GetHandlerPlayer() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsCode(14731897) then
		Duel.RegisterFlagEffect(rp,id+1,0,0,1)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id)~=0
	local b2=Duel.GetFlagEffect(tp,id+1)~=0
	if chk==0 then return b1 or b2 end
	local opt=0
	if b1 and b2 then
		opt=2
	elseif b1 then
		opt=1
	else
		opt=0
	end
	Duel.SetTargetParam(opt)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if opt==2 or opt==1 then
		--Cannot Normal Summon/Set, Flip Summon, Special Summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(0,1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e4,tp)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_TURN_SET)
		Duel.RegisterEffect(e5,tp)
		--Cannot activate monster effects
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_ACTIVATE)
		e6:SetValue(s.aclimit1)
		Duel.RegisterEffect(e6,tp)
		aux.RegisterClientHint(c,nil,tp,0,1,aux.Stringid(id,2),nil)
	end
	if opt==2 or opt==0 then
		--Cannot activate/Set Spells/Traps
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SSET)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetValue(s.aclimit2)
		Duel.RegisterEffect(e2,tp)
		--Effects of Spells/Traps the opponent controls are negated
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetTargetRange(0,LOCATION_SZONE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		aux.RegisterClientHint(c,nil,tp,0,1,aux.Stringid(id,3),nil)
	end
end
function s.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
