--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=82
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
		79636594,16021142,79514956,42029847,41307269,4786063,31181711,77679716,3064425,38124994,2729285,3841833,66457138,99668578,26057276,52551211,52339733,24096499,86889202,59368956,78574395,5972394,
		18752707,70245411,43034264,70422863,43912676,79306385,5795980,78184733,5672432,31077447,4450854,30845999,30845999,67249508,74335036,35884610,12822541,74605254,11609969,8643186,72648577,73360025,
		9765723,46259438,35037880,71422989,65247798,92246806,27918963,90307777,27796375,53180020,99185129,89463537,52846880,14735698,87118301,14513016,40907115,86396750,13890468,75457624
	}
	pack[2]={
		43241495,17857780,65331686,39246582,78391364,5908650,24218047,63274863,90885155,27279764,11039171,41367003,3734202,39122311,11705261,47728740,73213494,72491806,9485511,85545073
	}
	pack[3]={
		48546368,64496451,48424886,92512625,51543904,601193,74822425,43202238,16195942,86767655,12152769,42199039,39900763,30068120,91907707,37991342,99946920,51617185,50485594,10817524,79606837,
		44256816,6417578,36006208,25935625,88724332,87602890,13974207,17639150,66127916,734741,42589641,48210156,81571633,39153655,44186624,92536468,47198668,74583607,987311,3758046,46372010,44364077,
		70458081,24326617,72378329,93368494,52068432,48063985,39853199,65025250,91420254,54903668,26674724,25857246,88240999,51124303,49885567,86274272,12678870,11556339,30575681,66970385,73779005
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
