delimiter //
DROP FUNCTION IF EXISTS sf_get_subs_type//
CREATE FUNCTION sf_get_subs_type ( p_carrier varchar(12), p_gsm_num varchar(12) ) returns varchar(8) DETERMINISTIC
BEGIN
    -- GLOBE

    IF p_carrier = 'GLOBE' THEN
       -- 0917 30-32x-xxxx
       IF (p_gsm_num REGEXP '^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$') = 1 THEN
          return 'POST';
       -- 0917 5xx-xxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9175[0-9]{6,6}$') = 1 THEN
          return 'POST';
       -- 0917 62-63,65,67,68x-xxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$') = 1 THEN
          return 'POST';
       -- 0917 70-72,77x-xxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$') = 1 THEN
          return 'POST';
       -- 0917 70-72,77,79x-xxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$') = 1 THEN
          return 'POST';
       -- 0917 80-89x-xxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$') = 1 THEN
          return 'POST';
       -- 905 99 xxxxx
       ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)90599[0-9]{5,5}$') = 1 THEN
          return 'POST';
       ELSE
          return 'PRE';
       END IF;
    END IF;

    -- SMART
    IF p_carrier = 'SMART' THEN
    
      -- GOLD
      IF (p_gsm_num REGEXP '^(([+| ]?63)|0)94789[0-9]{5}$') = 1 THEN -- 90888xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94799[0-9]{5}$') = 1 THEN -- 94799xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9479171[0-9]{3}$') = 1 THEN -- 9479171000 to 9479171999
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)947917[2-6][0-9]{3}$') = 1 THEN -- 9479172xxx to 9479176xxx
         return 'POST';       
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$') = 1 THEN -- 90881xxxxx - 90884xxxxx, 90886xxxxx, 90888xxxxx,90889xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)90887[2-9][0-9]{4}$') = 1 THEN -- 908872xxxx -908879xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)908880212[0-9]$') = 1 THEN --  908880212x
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9088802[2-9]{2}$') = 1 THEN --  90888022xx - 90888029xx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)908880[3-9]{3}$') = 1 THEN --  9088803xxx - 9088809xxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$') = 1 THEN --  9189001xxx to 9189299xxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)918930[0-9]{4}$') = 1 THEN --  918930xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91893[3-9][0-9]{4}$') = 1 THEN --  918933xxxx - 918939xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91894[0-8][0-9]{4}$') = 1 THEN --  918940xxxx - 918948xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9189(5|6)[0-9]{5}$') = 1 THEN --  91895xxxxx - 91896xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$') = 1 THEN --  9189700xxx - 9189748xxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$') = 1 THEN --  9189750xxx - 9189999xxx
         return 'POST';       
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91999[0-9]{5}$') = 1 THEN --  91999xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9209(0|1)[0-9]{5}$') = 1 THEN --  92090xxxxx - 92091xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920932[6-9][0-9]{3}$') = 1 THEN --  9209326xxx - 9209329xxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920938[0-9]{4}$') = 1 THEN --  920938xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92094[5-9][0-9]{4}$') = 1 THEN --  920945xxxx - 920949xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$') = 1 THEN --  92095xxxxx - 92097xxxxx, 92099xxxxx
         return 'POST';       
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92855[0-9]{5}$') = 1 THEN --  92855xxxxx
         return 'POST';       
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$') = 1 THEN --  93990xxxxx to 93993x, 93997x to 93998x
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)999(88|99)[0-9]{5}$') = 1 THEN --  99988xxxxx, 99999xxxxx
         return 'POST';
      -- GOLD 3G pattern
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9285[0-2][0-9]{5}$') = 1 THEN --  92850xxxxx - 92852xxxxx
         return 'POST';
      -- ADDICT patterns
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92092[0-8][0-9]{4}$') = 1 THEN --  920920xxxx - 920928xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920929[0-8][0-9]{3}$') = 1 THEN --  9209290xxx - 9209298xxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92094[0-4][0-9]{4}$') = 1 THEN --  920940xxxx - 920944xxxx
         return 'POST';
      -- INFINITY patterns
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)90885[0-9]{5}$') = 1 THEN --  90885xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$') = 1 THEN --  9088800000 to 9088802119
         return 'POST';       
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9188[0-9]{6}$') = 1 THEN --  9188xxxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92888[0-9]{5}$') = 1 THEN --  92888xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)93999[0-9]{5}$') = 1 THEN --  93999xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)949(88|99)[0-9]{5}$') = 1 THEN --  94988xxxxx, 9499xxxxx
         return 'POST';
      -- BUDDY patterns
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)908[1-7,9][0-9]{6}$') = 1 THEN -- 9081xxxxxx - 9087xxxxxx or 9089xxxxxx       
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)918([2,4-6])[0-9]{6}$') = 1 THEN -- 9182xxxxxx,9184xxxxxx-9186xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9183[0-2,9][0-9]{5}$') = 1 THEN -- 91830xxxxx-91832xxxxx, 91839xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91833[0-6][0-9]{4}$') = 1 THEN -- 918330xxxx - 918336xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)918338[1-9][0-9]{3}$') = 1 THEN -- 9183381xxx - 9183389xxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9183(39|[4-8][0-9])[0-9]{4}$') = 1 THEN -- 918339xxxx - 918389xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)919(3|4|6|8)[0-9]{6}$') = 1 THEN -- 9193xxxxxx,9194xxxxxx,9196xxxxxx,9198xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9192[0-1,3-7,9][0-9]{5}$') = 1 THEN -- 91920xxxxx-91921xxxxx, 91923xxxxx-91927xxxxx, 91929xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91922[1-9][0-9]{4}$') = 1 THEN -- 919221xxxx - 919229xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91928[0-8][0-9]{4}$') = 1 THEN -- 919280xxxx - 919288xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9195[0-3,5-9][0-9]{5}$') = 1 THEN -- 91950xxxxx - 91953xxxxx, 91955xxxxx - 91959xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9199[0,2-8][0-9]{5}$') = 1 THEN -- 91990xxxxx, 91992xxxxx - 91998xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9201[0-9]{6}$') = 1 THEN -- 9201xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9202[0-6][0-9]{5}$') = 1 THEN -- 92020xxxxx - 92026xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920(4|6)[0-9]{6}$') = 1 THEN -- 9204xxxxxx, 9206xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92059[0-9]{5}$') = 1 THEN -- 920590xxxx - 920599xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9205[0-8][0-9]{5}$') = 1 THEN -- 92050xxxxx - 92058xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9208[0-7][0-9]{5}$') = 1 THEN -- 92080xxxxx - 92087xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92089[0-9]{5}$') = 1 THEN -- 92089xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920880[0-9]{4}$') = 1 THEN -- 920880xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9202(7(0(0[5-9]|[1-9][0-9])|[1-9][0-9]{2})|[89][0-9]{3})[0-9]{2}$') = 1 THEN -- 92027005xx - 92029999xx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)921[2,4-7][0-9]{6}$') = 1 THEN -- 9212xxxxxx, 9214xxxxxx - 9217xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9213[0-2][0-9]{5}$') = 1 THEN -- 92130xxxxx,92132xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9213[4-9][0-9]{5}$') = 1 THEN -- 92134xxxxx-92139xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92133[0-8][0-9]{4}$') = 1 THEN -- 921330xxxx-921338xxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)921339[0-8][0-9]{3}$') = 1 THEN -- 9213390xxx - 9213398xxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9219[5-9][0-9]{5}$') = 1 THEN -- 92195xxxxx - 92199xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)928[2-4,7][0-9]{6}$') = 1 THEN -- 9282xxxxxx - 9284xxxxxx, 9287xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9289[0,3-9][0-9]{5}$') = 1 THEN -- 92893xxxxx - 92899xxxxx, 92890xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92859[0-9]{5}$') = 1 THEN -- 92859xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9286[0-3,5-9][0-9]{5}$') = 1 THEN -- 92860xxxxx-92863xxxxx, 92865xxxxx-92869xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)929[1-8][0-9]{6}$') = 1 THEN -- 9291xxxxxx - 9298xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9299[5-7][0-9]{5}$') = 1 THEN -- 92995xxxxx - 92997xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)930[1-9][0-9]{6}$') = 1 THEN -- 9301xxxxxx - 9309xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9391[0-9]{6}$') = 1 THEN -- 93910xxxxx - 93919xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)939([2-5][0-9]|6[0-5])[0-9]{5}$') = 1 THEN -- 9392xxxxxx - 93965xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9397[6-9][0-9]{5}$') = 1 THEN -- 93976xxxxx - 93979xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)93980[0-9]{5}$') = 1 THEN -- 93980xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9399(4|5|6)[0-9]{5}$') = 1 THEN -- 93994xxxxx-93996xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)947[2-5][0-9]{6}$') = 1 THEN -- 947 [2-5]xx xxxx   //added 20110505
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9476[0-4][0-9]{5}$') = 1 THEN -- 947 6[0-4]x xxxx  //added 20110505
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94769[0-9]{5}$') = 1 THEN -- 94769xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9477[0-9]{6}$') = 1 THEN -- 9477xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9478[0-8][0-9]{5}$') = 1 THEN -- 94780xxxxx-94788xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9479[2-8][0-9]{5}$') = 1 THEN -- 94792xxxxx-94798xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9491[1-9][0-9]{5}$') = 1 THEN -- 94911xxxxx - 94919xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9493[0-7,9][0-9]{5}$') = 1 THEN -- 94930xxxxx - 94937xxxxx, 94939xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)949(4[0-9]|50)[0-9]{5}$') = 1 THEN -- 94940xxxxx - 94950xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)949(6|7)[0-9]{6}$') = 1 THEN -- 9496xxxxxx - 9497xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9498[1-6,9][0-9]{5}$') = 1 THEN -- 94981xxxxx - 94986xxxxx, 94989xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9499[0-8][0-9]{5}$') = 1 THEN -- 94990xxxxx - 94998xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)999[3-5,7][0-9]{6}$') = 1 THEN -- 9993xxxxxx, 9995xxxxxx, 9997xxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9996[5-9][0-9]{5}$') = 1 THEN -- 99965xxxxx- 99969xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9998[0-7,9][0-9]{5}$') = 1 THEN -- 99980xxxxx-99987xxxxx, 99989xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9999[0-8][0-9]{5}$') = 1 THEN -- 99990xxxxx-99998xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9991[5-9][0-9]{5}$') = 1 THEN -- 99915xxxxx-99919xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)998[0-9]{7}$') = 1 THEN -- 998xxxxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92892[0-9]{5}$') = 1 THEN -- 92892xxxxx
      --    return 'POST';

      -- TALK N TEXT patterns
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)907[1-9][0-9]{6}$') = 1 THEN -- 9071xxxxxx - 9079xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)909[1-9][0-9]{6}$') = 1 THEN -- 9091xxxxxx - 9099xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)910[1-6,8-9][0-9]{6}$') = 1 THEN -- 9101xxxxxx - 9106xxxxxx, 9108xxxxxx - 9109xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9107[0-8][0-9]{5}$') = 1 THEN -- 91070xxxxx - 91078xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91079([0-8][0-9]|9[0-8])[0-9]{3}$') = 1 THEN -- 9107900xxx - 91077998xxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)912[1-9][0-9]{6}$') = 1 THEN -- 9121xxxxxx - 9129xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9187[0-8][0-9]{5}$') = 1 THEN -- 91870xxxxx - 91878xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)91879([0-8][0-9]|9[0-8])[0-9]{3}$') = 1 THEN -- 9187900xxx - 9187998xxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9197[0-9]{6}$') = 1 THEN -- 9197xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)920(3|7)[0-9]{6}$') = 1 THEN -- 9203xxxxxx, 9207xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92088[1-9][0-9]{4}$') = 1 THEN -- 920881xxxx - 920889xxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9285[3-4,6-8][0-9]{5}$') = 1 THEN -- 92853xxxxx, 92854xxxxx, 92856xxxxx - 92858xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)930[1-9][0-9]{6}$') = 1 THEN -- 9301xxxxxx - 9309xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9461[1-9][0-9]{5}$') = 1 THEN -- 94611xxxxx - 94619xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)946[2-6][0-9]{6}$') = 1 THEN -- 9462xxxxxx - 9466xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9467[0-5][0-9]{5}$') = 1 THEN -- 94670xxxxx - 94675xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)946(8|9)[0-9]{6}$') = 1 THEN -- 9468xxxxxx - 9469xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)948(2|[4-8])[0-9]{6}$') = 1 THEN -- 9482x, 9484x- 9488x
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9481[2-5][0-9]{5}$') = 1 THEN -- 94812xxxxx -94815xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9489[0-4][0-9]{5}$') = 1 THEN -- 94890xxxxx -94894xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9489[6-9][0-9]{5}$') = 1 THEN -- 94896xxxxx -94899xxxxx
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9483(0[1-9][5-9]|0[2-9][0-9]|[1-9][0-9][0-9])[0-9]{3}$') = 1 THEN -- 9483015xxx - 9483999xxxx
      
      -- KID PREPAID patterns
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9219[0-4][0-9]{5}$') = 1 THEN -- 92190xxxxx - 92194xxxxx
      
      -- ADDICT PREPAID patterns
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9218[0-7,9][0-9]{5}$') = 1 THEN -- 92180xxxxx - 92187xxxxx, 92189xxxxx
      
      -- ADDICT PREPAID 3G pattern
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)92188[0-9]{5}$') = 1 THEN -- 92189xxxxx
      
      -- RED MOBILE pattern
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9389[5-9][0-9]{5}$') = 1 THEN -- 93895xxxxx - 93899xxxxx
      --    return 'POST';
      -- ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)99810000[0-5][0-9]$') = 1 THEN -- 998100000x - 998100005x
      --    return 'POST';
             
      -- BRO Postpaid pattern
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94790[5-9][0-9]{4}$') = 1 THEN -- 947905xxxx - 947909xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94791[3-6][0-9]{4}$') = 1 THEN -- 947913xxxx - 947916xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94938[0-9]{5}$') = 1 THEN -- 949 38x xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94951[0-9]{5}$') = 1 THEN -- 949 51x xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)90887[0-1][0-9]{4}$') = 1 THEN -- 908870xxxx - 908871xxxx
         return 'POST';
      
      -- BRO Micro Postpaid pattern
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9299[8-9][0-9]{5}$') = 1 THEN -- 92998xxxxx - 92999xxxxx 
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9396[6-9][0-9]{5}$') = 1 THEN -- 93966xxxxx - 93969xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)93970[0-9]{5}$') = 1 THEN -- 93970xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9471[2-3][0-9]{5}$') = 1 THEN -- 94712xxxxx - 94713xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9476[7-8][0-9]{5}$') = 1 THEN -- 94767xxxxx - 94768xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9281[0-3][0-9]{5}$') = 1 THEN -- 92810xxxxx - 92813xxxxx   
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9495[2|4][0-9]{5}$') = 1 THEN -- 94952xxxxx | 94954xxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)94955[1-4][0-9]{4}$') = 1 THEN -- 949551xxxx | 949554xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9991[1-4][0-9]{5}$') = 1 THEN -- 999911xxxx - 999914xxxx 
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$') = 1 THEN -- 99960xxxxx | 99963xxxxx | 99964xxxxx
         return 'POST';
      ELSE
         return 'PRE';
      END IF;
   END IF;

   -- SUN
   IF p_carrier = 'SUN' THEN

      IF (p_gsm_num REGEXP '(([+| ]?63)|0)9228[0-9]{6}') = 1 THEN -- 9228xxxxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)922922[0-9]{4}') = 1 THEN -- 922922xxxx
         return 'POST';
      ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)9328[0-9]{6}') = 1 THEN -- 9328xxxxxx
         return 'POST';
      ELSE
         return 'PRE';
      END IF;
      -- PREPAID
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)922[2-7,9][0-9]{6}') = 1 THEN -- 9222xxxxxx, 9223xxxxxx, 9224xxxxxx, 9225xxxxxx, 9226xxxxxx, 9227xxxxxx, 9229xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)923[0-9]{7}') = 1 THEN -- 923xxxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)932[0-7,9][0-9]{6}') = 1 THEN --  932<anything but 8>xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)933[0-9]{7}') = 1 THEN -- 9331xxxxxx, 9332xxxxxx, 9333xxxxxx, 9334xxxxxx, 9335xxxxxx, 9336xxxxxx, 9337xxxxxx, 9339xxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)942[0-9]{7}') = 1 THEN -- 942xxxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)943[0-9]{7}') = 1 THEN -- 943xxxxxxx
      -- ELSEIF (p_gsm_num REGEXP '(([+| ]?63)|0)925[0-9]{7}') = 1 THEN -- 925xxxxxxx
   END IF;

   return 'OTHERS';
END;
//
delimiter ;
