--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=53
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
		79979666,20721928,21844576,84327329,86188410,80908502,89252153,59793705,58932615,4611269,7623640,10040267,10163855,511000290,511000482,511000143,511000140,
		12015000,12292422,15981690,22587018,19186123,21143940,3629090,3642509,18094166,16114248,16304628,22865492,23147658,24103628,54185227,45945685,50720316,
		24449083,27780618,34479658,39618799,39984786,39996157,41077745,42502956,44297127,63362460,69572169,76103404,77235086,81782101,59419719,61320914,100000032,
		71218746,7602840,98049038,99861526,24311595,57425061,58932616,96693371,84778110,86520461,91392974,93169863,96693371,99357565,100000033,100000101,79335209,
		42941100,12482652,100000160,100000161,100000162,100000196,100000651,100000652,100000653,100000654,100000655,100000656,100000657,100000658,100000659,100000660,
		100000661,100000662,511000080,511000081,511000082,511000085,511000139,511000142,511001205,511001206,511001207,511001210,511001209,511001349,511310106,511310109,
		511310107,513000115,513000132,89621922,80344569,54959865,43237273,17955766,17732278
	}
	pack[2]={
		1000016,12644061,45170821,54283059,59531356,82697428,83656563,84536654,20721929,21844577,5285665,29095552,33574806,22061412,40854197,50608164,85808813,
		58147549,58481572,62624486,93600443,89870349,100000163,100000164,100000246,511000141,511000492,511000578,97362768,27191436,19394153,53586134,22479888,511001013,
		511001208,511310108,1000017,1000018,1000019,1000020
	}
	pack[3]={
		269012,3912064,15033525,16255173,18631392,21225115,24413299,26964762,32588805,33776734,33900648,46759931,48130397,51402908,54702678,57157964,60417395,511310102,
		80831721,88071625,95486586,95658967,96897184,97811903,98777036,20193924,6186304,83965310,1000012,1000013,1000014,1000015,1945387,22093873,59642500,74711057,
		10920352,23204029,28348537,59509952,100000083,100000474,511000137,511001101,511001111,511001114,511001115,511001134,511001135,511001148,511310100,511310101,
		74875003,511310104,511310105,511310110,100000557,1000021,1000022,1000023,1000024,1000025
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
				for i=1,15 do
					local packnum=1
					for i=1,6 do
						local rarity
						if i==4 or i==5 then
							rarity=2
						elseif i<6 then
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
				local exclude=fg:Select(p,#fg-60-#extra,#fg-60-#extra,nil)
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
