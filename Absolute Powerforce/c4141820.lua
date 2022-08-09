--儀式魔人プレコグスター
--Ritual Djinn - Diviner
local s,id=GetID()
function s.initial_effect(c)
	--ritual material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetCondition(s.con)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.con(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	for rc in aux.Next(eg) do
		if rc:GetFlagEffect(id)==0 then
			--Draw
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetCategory(CATEGORY_HANDES)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_BATTLE_DAMAGE)
			e1:SetCondition(s.discardcn)
			e1:SetTarget(s.discardtg)
			e1:SetOperation(s.discardop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function s.discardcn(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.discardtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.discardop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if #g==0 then return end
	local sg=g:RandomSelect(p,1)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end