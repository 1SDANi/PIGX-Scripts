--ライフ・ストリーム・ドラゴン
--Life Stream Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixRep(c,true,true,s.fusionfilter,2,99)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--change lp
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.lpcon)
	e0:SetOperation(s.lpop)
	c:RegisterEffect(e0)
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(s.desreptg)
	c:RegisterEffect(e5)
end
s.material={2403771}
s.listed_names={2403771}
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if sel==0 then
		Duel.SetLP(tp,4000)
	else
		Duel.SetLP(1-tp,4000)
	end
end
function s.damval(e,re,val,r,rp,rc)
	if (r&REASON_EFFECT)~=0 or (r&REASON_BATTLE)~=0 then return 0
	else return val end
end
function s.repfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) 
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		return true
	else return false end
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
	return c:HasLevel() and (c:IsType(TYPE_FUSION) or c:IsCode(CARD_STARDUST_DRAGON)) and (not rg or not sg or (st==tg and #sg>1) or (st<tg and rg:CheckWithSumEqual(Card.GetLevel,tg-st,1,99))) and
		(c:IsCode(CARD_STARDUST_DRAGON) or (not sg or sg:IsExists(Card.IsCode,1,c,CARD_STARDUST_DRAGON)))
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end