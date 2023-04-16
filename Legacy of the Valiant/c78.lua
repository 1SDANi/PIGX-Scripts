--Sealed Duel
--credits to andre and AlphaKretin, tag functionality by senpaizuri, rescripted by MLD
--re-rescripted by edo9300
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=78
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
		76436988,75214390,39229392,2618045,38007744,65591858,1586457,37168514,90764875,64379261,37984162,99429730,61318483,97584500,51196805,24101897,97317530,51912531,22134079,86868952,50896944,
		50074392,86062400,12467005,84401683,8339504,34834619,7617062,32999573,38777931,64161630,91650245,63049052,26822796,84472026,59048135,87255382,24861088,71415349,34898052,10282757,80208323,
		15458892,57996334,53981499,77797992,75673220,23087070,85255550,72520073
	}
	pack[2]={
		40941889,63257623,99641328,50474354,23857661,43378076,24701235,85346853,11522979,47017574,46895036,8561192,71345905,33611061,70000776,6595475,37055344,99311109,47077318,46955770,84124261,
		86686671,12670770,23649496,50260683,45010690,8809344
	}
	pack[3]={
		23689697,8522996,19748583,90434657,1372887,72167543,46772449,2830693,3557275,25700114,65384188,59951714,11682713,62434031,98707192,59251766,58139128,87294988,19684740,70222318,63227401,
		73359475,46132282,72537897,36046926,25824484,23979249,85646474,25524823,10406322,48739166,12744567,73289035,45950291,47687766,77558536,40164421,4779823,45286019,72370114,19891310,
		24919805,51126152,24731453,97520701,93108839,73176465,72959823,45742626,9348522,10560119,46565218,85310252,11705261,59911557,12927849,86532744,7194917,200000002,23893227,59281922,58069384,
		72837335,34620088,8226374,71015787,7409792,6387204,33776843,69170557,6165656,32559361,95442074,69058960,95442074,31437713,68836428,94220427,67113830,21715135,20292186
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
