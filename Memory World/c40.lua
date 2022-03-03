--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=40
if self_code then id=self_code end
if not SealedDuel then
	SealedDuel={}
	local function finish_setup()
		--Pre-draw
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetCountLimit(1)
		e1:SetOperation(SealedDuel.op)
		Duel.RegisterEffect(e1,0)
	end
	--define pack
	--pack[1]=BP01, [2]=BP02, [3]=BPW2, [4]=BP03
	--[1]=common, [2]=rare, [3]=foil
	pack={}
	pack[1]={
		35191415,46986414,74677422,18803791,76812113,87639778,80280944,55569674,81954378,511001898,511000265,511000672,140000082,75380687,
		43892408,19747827,83743222,83743222,46354113,10960419,170000196,57470761,58293343,84687358,44095762,44373896,83555666,22804644,57728570,
		44632120,34419588,71036835,40640057,7021574,511000690,110000103,110000104,110000105,110000106,110000107,110000108,110000109,110000110,
		110000111,110000112,110000113,110000114,110000115,110000117,110000120,78527720,14512825,9677699,511001411,511000437,511001412,511001413,
		511001418,41916534,73405179,511000438,899287,511000266,511000268,43528009,79922118,45072394,511001420,7133305,3026686,72083436,38576155,
		64961254,92182447,45584727,43341600,58641905
	}
	pack[2]={
		71408082,100000535,100000295,511000895,18175965,34022290,140000083,48179391,110000100,110000101,1784686,46232525,11082056,89397517,16404809,
		70914287,6309986,170000173,170000174,42776960,46294982,72283691,30411385,66809920,39299733,17956906,511000188,100000528,18478530
	}
	pack[3]={
		1000000,1000001,1000002,1000003,1000004,1000005,1000006,1000007,1000008,1000009,10000040,10000080,10000090,39913299,51644030,80019195,
		84565800,85800949,53315891,170000166,7634581,170000168,170000169,82103466,2204038,92182447,65687442,511000274,511000273
	}
	for _,v in ipairs(pack[1]) do table.insert(pack[3],v) end
	for _,v in ipairs(pack[2]) do table.insert(pack[3],v) end
	function SealedDuel.op(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE)
		end
		local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_CARD,0,id)
		--tag variable defining
		local z,o=tp,1-tp
		if not aux.AskEveryone(aux.Stringid(id,1)) then
			return
		end
		
		local groups={}
		groups[0]={}
		groups[1]={}
		for i=1,counts[0] do
			groups[0][i]={}
		end
		for i=1,counts[1] do
			groups[1][i]={}
		end
		for p=z,o do
			for team=1,counts[p] do
				for i=1,12 do
					local packnum=1
					for i=1,5 do
						local rarity
						if i==4 then
							rarity=2
						elseif i<5 then
							rarity=1
						else
							rarity=Duel.GetRandomNumber(1,3)
						end
						local code
						code=pack[rarity][Duel.GetRandomNumber(1,#pack[rarity])]
						table.insert(groups[p][team],code)
					end
				end
			end
		end
		
		for p=z,o do
			for team=1,counts[p] do
				Duel.SendtoDeck(Duel.GetFieldGroup(p,0xff,0),nil,-2,REASON_RULE)
				for idx,code in ipairs(groups[p][team]) do
					Debug.AddCard(code,p,p,LOCATION_DECK,1,POS_FACEDOWN_DEFENSE)
				end
				Debug.ReloadFieldEnd()
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,2))
				local fg=Duel.GetFieldGroup(p,0xff,0)
				local extra=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
				local exclude=fg:Select(p,0,#fg-30-#extra,nil)
				if exclude then
					Duel.SendtoDeck(exclude,nil,-2,REASON_RULE)
				end
				Duel.ShuffleDeck(p)
				Duel.ShuffleExtra(p)
				if counts[p]~=1 then
					Duel.TagSwap(p)
				end
			end
		end
	end
	finish_setup()
end
if not Duel.GetStartingHand then
	Duel.GetStartingHand=function() return 5 end
end
