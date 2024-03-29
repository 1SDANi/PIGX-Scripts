--チェーン・マテリアル
--Chain Material
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.chain_condition)
	e1:SetTarget(s.chain_target)
	e1:SetOperation(s.chain_operation)
	e1:SetValue(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabel(0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.operation(e)
	e:GetLabelObject():SetLabel(1)
end
function s.chain_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==0
end
function s.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.chain_target(e,te,tp,value)
	if not value or value&SUMMON_TYPE_FUSION==0 then return Group.CreateGroup() end
	if Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,nil,te)
	else
		return Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,nil,te)
	end
end
function s.chain_operation(e,te,tp,tc,mat,sumtype,sg,sumpos)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	if sg then
		sg:AddCard(tc)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-(RESET_TOFIELD+RESET_TURN_SET),0,1)
	else
		Duel.SpecialSummonStep(tc,sumtype,tp,tp,false,false,sumpos)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	end
end