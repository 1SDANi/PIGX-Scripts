--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=80
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
		1000038,1000039,1000040,5068132,6442944,7080743,11845050,47840168,21414674,22530212,22657402,31059809,32281491,34475451,42352091,28884172,61692648,34034150,60023855,67120578,68535320,69764158,
		79663524,81028112,91718579,95886782,98881931,72717433,18106132,61245403,32476434,6180710,96163807,95929069,97639441,98154550,100000200,100000206,100000240,511000034,511000702,
		511000703,511000704,511000707,511000908,511000909,511000910,87526784,50319138,23915499,86804246,511001059,511001709,511002147,511002148,511002157,511002158,511002468,511002686,511002687,
		513000133
	}
	pack[2]={
		41418852,20285786,20735371,20936251,20994205,25334372,27062594,33252803,41850466,64283880,56673480,57499304,60879050,62829077,67517351,68441986,77402960,84731222,90812044,91677585,60944809,
		34559295,95664204,67331360,19272658,47128571,83512285,45283341,32175429,96142517,450000000,511000209,511000225,511000510,511000511,511000686,511000706,511001180,511001422,511001423,511001427,
		511001665,511001666,511001708,511001826,511002469,511004123,100299015,511001200
	}
	pack[3]={
		4997565,4019153,8165596,8387138,15232745,15862758,21313376,23085002,23187256,26556950,28400508,29208536,29208536,32453837,35772782,37279508,39030163,39622156,42230449,49032236,51543904,52085072,
		52653092,53701457,54191698,54358015,55470553,56292140,56673480,56832966,57314798,57707471,58820923,59479050,62541668,63504681,63767246,65305468,66011101,66547759,67557908,94942656,90126061,
		69757518,71166481,78625448,79747096,80796456,82697249,84224627,89477759,90162951,90590303,91499077,92015800,93713837,95474755,96864105,100010001,111011803,111011903,111011904,111011905,
		111011906,511000705,84013237,511001338
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
