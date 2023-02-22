--双頭の雷龍
--Twin-Headed Thunder Dragon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	Fusion.AddProcMixN(c,false,true,true,31786629,2)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)
end
s.material_setcode={0x11c}
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE+REASON_EFFECT)~=0
end
