--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=56
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
		59965151,97021916,97904474,16589042,91932350,7093411,30399511,67483216,93882364,30276969,29054481,92933195,54326448,23115241,96099959,23093604,85876417,
		58760121,85754829,11159464,56830749,34016756,5318639,65169794,97687912,37580756,58621589,62325062,96331676,50323155,31281980,30069398,66457407,93542102,
		29947751,66331855,28124263,91607976,28002611,54497620,27870033,53152590,80769747,26157485,89547299,52430902,19505896,82116191,82994509,84824601,43642620,
		18960169,83602069,72767833,18752938,7030340,70423794,7817703,33302407,6795211,69584564,31467372,67630339,30123142,92890308,28284902,28062325,54451023,27340877,
		53334471,80723580
	}
	pack[2]={
		96182448,25247218,68505803,92065772,65549080,28332833,50604950,59482302,22371016,84932271,67270095,92720564,55119278,80885324,53274132,15935204,10097168,
		19974580,45379225,44424095,79707116,44887817,5973663,66518841,91078716,80955168,74440055,54591086,8483333
	}
	pack[3]={
		4904812,66661678,91711547,57543573,18013090,7391448,10026986,47421985,83810690,19204398,1834753,612115,63101919,99590524,80987696,96938777,5126490,31111109,
		18489208,79814787,44364207,4857085,20450925,45500495,71645242,68462976,31245780,94634433,55673611,37829468,63223467,36107810,41442341,23116808,68722455,
		20546916,1557341,11819616,33420078,46195773,6021033,5309481,45247637,32180819,38041940,73580472,27416701,75162696,62379337,35984222,28859794,52512994,
		54343893
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
