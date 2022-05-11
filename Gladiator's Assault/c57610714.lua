--雲魔物－アイ・オブ・ザ・タイフーン
--Cloudian - Typhoonman
local s,id=GetID()
function s.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(COUNTER_FOG,1)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if tc and tc:IsCanAddCounter(COUNTER_FOG,1) and tc:AddCounter(COUNTER_FOG,1) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			e1:SetValue(1000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end