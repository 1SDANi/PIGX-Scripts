--ビーストアイズ・ペンデュラム・ドラゴン
-- Beast-Eyes Union Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMix(c,false,true,true,s.fusfilter,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--union place
	local eUnionPlace=Effect.CreateEffect(c)
	eUnionPlace:SetDescription(aux.Stringid(id,0))
	eUnionPlace:SetType(EFFECT_TYPE_IGNITION)
	eUnionPlace:SetRange(LOCATION_EXTRA)
	eUnionPlace:SetCountLimit(1)
	eUnionPlace:SetTarget(s.settg)
	eUnionPlace:SetOperation(s.setop)
	c:RegisterEffect(eUnionPlace)
	--union summon
	local eUnionSummon=Effect.CreateEffect(c)
	eUnionSummon:SetDescription(aux.Stringid(id,1))
	eUnionSummon:SetCategory(CATEGORY_SUMMON)
	eUnionSummon:SetType(EFFECT_TYPE_IGNITION)
	eUnionSummon:SetRange(LOCATION_SZONE)
	eUnionSummon:SetCountLimit(1)
	eUnionSummon:SetTarget(Auxiliary.ExtraNormalTarget{summon=true,typing=TYPE_UNION})
	eUnionSummon:SetOperation(Auxiliary.ExtraNormalOperation{summon=true,typing=TYPE_UNION})
	c:RegisterEffect(eUnionSummon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_FLIPSUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.material_race={RACE_BEAST}
s.material_setcode={0x10f2}
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=c:GetMaterial()
	local atk=0
	if g and #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			if tc:IsRace(RACE_BEAST) then
				local catk=tc:GetBaseAttack()
				if catk<0 then catk=0 end
				atk=atk+catk
			end
		end
	end
	if chk==0 then return atk>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.target(e,c)
	return c:IsType(TYPE_UNION)
end
function s.counterfilter(c)
	return not c:IsType(TYPE_FUSION)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_FUSION)
end
function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsType(TYPE_FUSION))
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_FUSION)
end
function s.setcs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_FLIPSUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return
	else 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS+TYPE_UNION)
		e:GetHandler():RegisterEffect(e1)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end
function s.fusfilter(c)
	return c:IsSetCard(0x10f2) and c:IsType(TYPE_MONSTER+TYPE_UNION)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end