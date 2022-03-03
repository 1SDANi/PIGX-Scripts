--稲妻の剣
--Lightning Blade
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR))
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.targ)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	local q=e:GetHandler():GetEquipTarget()
	if chk ==0 then	return (a==q and d~=nil and d:IsAttribute(ATTRIBUTE_WATER)) or 
		(a~=nil and d==q and a:IsAttribute(ATTRIBUTE_WATER)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	local q=e:GetHandler():GetEquipTarget()
	if a==q and d~=nil and d:IsAttribute(ATTRIBUTE_WATER) and d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
	if a~=nil and d==q and a:IsAttribute(ATTRIBUTE_WATER) and a:IsRelateToBattle() then
		Duel.Destroy(a,REASON_EFFECT)
	end
end
