--ルーレット・スパイダー
--Roulette Spider
local s,id=GetID()
function s.initial_effect(c)
	--Change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==1-tp and not Duel.GetAttacker():IsImmuneToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	if (not e:GetHandler():IsRelateToEffect(e)) or Duel.GetAttacker():IsImmuneToEffect(e) then return end
	local zone=Duel.TossDice(tp,1)
	if zone>=6 then
		zone=SelectFieldZone(tp,1,0,LOCATION_MZONE)
	end
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,zone-1)
	if tc then
		Duel.CalculateDamage(Duel.GetAttacker(),tc)
	else
		Duel.NegateAttack()
	end
end
