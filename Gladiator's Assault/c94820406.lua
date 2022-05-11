--ダーク・フュージョン
--Dark Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Fusion summon 1 fiend fusion monster
	--Using monsters from hand or field as material
	c:RegisterEffect(Fusion.CreateSummonEff({handler=c,fusfilter=aux.TRUE,stage2=s.stage2}))
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		--Cannot be targeted by opponent's card effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3061)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(aux.tgoval)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end