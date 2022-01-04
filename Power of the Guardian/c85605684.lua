--バーサーク・デッド・ドラゴン
--Berserk Dragon
local s,id=GetID()
function s.initial_effect(c)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end