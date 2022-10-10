--重爆撃禽 ボム・フェネクス
--Blaze Fenix, the Burning Bombardment Bird
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE))
	Fusion.AddContactProc(c,s.contactfil,s.contactop,nil,nil,SUMMON_TYPE_FUSION)
	--Inflict damage equal to number of cards on the field x 300
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end
s.material_race={RACE_MACHINE}
s.material_attribute={ATTRIBUTE_FIRE}
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.Damage(p,ct*200,REASON_EFFECT)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end