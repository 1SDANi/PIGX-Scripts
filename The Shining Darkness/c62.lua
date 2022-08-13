--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=62
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
		84290642,56209279,77625948,79109599,39191307,13945283,20586572,88264978,66378485,39761138,65156847,38049541,64034255,27827903,90616316,99594764,25988873,
		88361177,25866285,51254980,87649699,50032342,27527047,3366982,1845204,95286165,74848038,93895605,64697231,63356631,58921041,26775203,25652655,51047350,135598,
		88032368,14430063,13708425,50702124,48868994,11747708,48742406,74130411,73318863,46897277,12296376,49680980,75675029,48568432,1357146,47346845,67779172,
		29228350,65612454,28506708,64990807,91985515,27383110,53778229,90263923,25435080,52833089,15313433,15313433,51717541,40555959,87043568,86821010,13438207,
		49833312,49600724
	}
	pack[2]={
		48343627,75434695,2377034,91438994,26704411,53199020,52977572,74711057,88190790,68505803,4904812,96099959,23093604,52869807,51925772,49080532,85475641,525110,
		12469386,47929865,12079734,74730899,36629203,66835946,92223641,91107093,89040386,88928798,14550855,12216615,176392,38837163,67483216
	}
	pack[3]={
		91554542,63211608,24644634,53921056,89194103,25682811,99916754,26304459,52709508,52687916,36521459,66165755,55343236,14344682,13521194,50732780,86137485,402568,
		31385077,35448319,73787254,63665606,9059700,19182751,98954375,80367387,74952447,73018302,26257572,11593137,5998840,87319876,86197239,75252099,30562585,66957584,
		53656677,87106146,2843014,36560997,47421985,19204398,89258906,44665365,36407615,72896720,4290468,4168871,93946239,39440937,31383545,9012916,72926163,36643046,
		74860293,255998,47766694,73048641,11287364,86915847,75292259,35050257,72549351,24449083,43359262,19012345
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
