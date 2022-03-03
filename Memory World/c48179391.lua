--オレイカルコスの結界
--The Seal of Orichalcos
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.con)
	e4:SetValue(s.tg)
	c:RegisterEffect(e4)
	--prevent activation of the Legendary Dragons
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.limit)
	c:RegisterEffect(e5)
	--cannot activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetValue(s.efilter)
	c:RegisterEffect(e6)
end
s.listed_names={1784686,11082056,46232525}
function s.efilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.limit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(1784686,11082056,46232525)
end
function s.group(c,tp)
	local seq=c:GetSequence()
	local g=Group.CreateGroup()
	local function optadd(loc,seq,player)
		if not player then player=tp end
		local c=Duel.GetFieldCard(player,loc,seq)
		if c then g:AddCard(c) end
	end
	if seq+1<=4 then optadd(LOCATION_MZONE,seq+1) end
	if seq-1>=0 then optadd(LOCATION_MZONE,seq-1) end
	if seq<5 then
		if seq==1 then
			optadd(LOCATION_MZONE,5)
		end
		if seq==3 then
			optadd(LOCATION_MZONE,6)
		end
	elseif seq==5 then
		optadd(LOCATION_MZONE,1)
	elseif seq==6 then
		optadd(LOCATION_MZONE,3)
	end
	return g
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.group,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,tp)
end
function s.tg(e,c)
	if not c:IsInMainMZone() then return false end
	return #(s.group(c:GetSequence(),tp))>0
end