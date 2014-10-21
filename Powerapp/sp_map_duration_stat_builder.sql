DROP TABLE powerapp_mapping_usage;
CREATE TABLE powerapp_mapping_usage (
  tx_id bigint(20) unsigned NOT NULL,
  phone varchar(12) NOT NULL,
  datein date NOT NULL,
  map_ipadd varchar(20) NOT NULL,
  map_datein varchar(29) DEFAULT NULL,
  map_ts bigint(20) NOT NULL,
  unmap_ipadd varchar(20) DEFAULT NULL,
  unmap_datein varchar(29) DEFAULT NULL,
  unmap_ts bigint(20) DEFAULT NULL,
  unmap_tx_id bigint(20) DEFAULT NULL,
  brand varchar(10) DEFAULT NULL,
  PRIMARY KEY (tx_id)
) ;

DROP PROCEDURE IF EXISTS sp_map_duration_stat_builder;
delimiter //
CREATE PROCEDURE sp_map_duration_stat_builder()
BEGIN

   DECLARE done, done_s int default 0;
   DECLARE vMinTxId bigint(20);
   DECLARE vPhone varchar(12);
   DECLARE vIpAdd varchar(20);
   DECLARE c cursor FOR SELECT tx_id, phone, map_ipadd FROM powerapp_mapping_usage WHERE unmap_tx_id is null limit 100000;

   SET net_write_timeout=12000;
   SET global connect_timeout=12000;
   SET net_read_timeout=12000;

   -- TRUNCATE TABLE powerapp_mapping_usage;
   -- INSERT IGNORE INTO powerapp_mapping_usage (tx_id, phone, datein, map_ipadd, map_datein, map_ts, unmap_datein)
   -- SELECT tx_id, phone, left(date_add('1970-01-01', interval (ts/1000) second),10) datein, ipadd, 
   --        date_add('1970-01-01', interval (ts/1000) second) map_datein, ts, null
   -- FROM   powerapp_mapping_hist where map_type ='MAP';

   BEGIN
      declare continue handler for sqlstate '02000' set done = 1;
      OPEN c;
      REPEAT
         FETCH c INTO vMinTxId, vPhone, vIpAdd;
         if not done then
            begin
               declare continue handler for sqlstate '02000' set done_s = 1;

               set @unmap_datein = null;
               set @unmap_ts     = null;
               set @unmap_ipadd  = null;
               set @unmap_tx_id  = null;
               set @vSimType     = null;

               SELECT date_add('1970-01-01', interval (ts/1000) second), ts, ipadd, tx_id
               INTO @unmap_datein, @unmap_ts, @unmap_ipadd, @unmap_tx_id
               FROM powerapp_mapping_hist
               WHERE tx_id = (select min(tx_id)
                              from powerapp_mapping_hist
                              where map_type = 'UNMAP'
                              and  phone = vPhone
                              and  ipadd = vIpAdd
                              and  tx_id > vMinTxId );

               if (vPhone REGEXP '^(63|0)908[1-7,9][0-9]{6,6}$|^(63|0)918[2,4-6][0-9]{6,6}$|^(63|0)9183[0-2][0-9]{5,5}$|^(63|0)91833[0-6][0-9]{4,4}$|^(63|0)918338[0-9]{4}$|^(63|0)918339[0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9183[4-7][0-9]{5,5}$|^(63|0)91838[0-9]{5,5}$|^(63|0)91839[0-9]{5,5}$|^(63|0)919[3,4,6,8][0-9]{6,6}$|^(63|0)9192[0-1][0-9]{5,5}$|^(63|0)91922[1-9][0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9192[3-7,9][0-9]{5,5}$|^(63|0)91928[0-8][0-9]{4,4}$|^(63|0)9195[0-3,5-9][0-9]{5,5}$|^(63|0)9199[0,2-8][0-9]{5,5}$|^(63|0)920[1,4,6][0-9]{6,6}$' OR
                   vPhone REGEXP '^(63|0)9202[0-6][0-9]{5,5}$|^(63|0)9205[0-8][0-9]{5,5}$|^(63|0)92059[0-7][0-9]{4,4}$|^(63|0)920599[0-9]{4,4}$|^(63|0)9208[0-7,9][0-9]{5,5}$|^(63|0)920880[0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9202(7(0(0[5-9][0-9]{2}|[1-9][0-9]{3})|[1-9][0-9]{4})|[89][0-9]{5})$|^(63|0)921[2,4-7][0-9]{6,6}$|^(63|0)9213[0-2,4-9][0-9]{5,5}$|^(63|0)92133[0-8][0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)921339[0-8][0-9]{3,3}$|^(63|0)9219[5-9][0-9]{5,5}$|^(63|0)928[2-4,7][0-9]{6,6}$|^(63|0)92859[0-9]{5,5}$|^(63|0)9286[0-3,5-9][0-9]{5,5}$|^(63|0)9289[0,3-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)929[1-8][0-9]{6,6}$|^(63|0)9299[5-7][0-9]{5,5}$|^(63|0)9391[0-9]{6,6}$|^(63|0)939([2-5][0-9]{6}|6[0-5][0-9]{5})$|^(63|0)939(7[6-9][0-9]{5}|80[0-9]{5})$' OR
                   vPhone REGEXP '^(63|0)9399[4-6][0-9]{5}$|^(63|0)947([2-5][0-9]{6}|6[0-4][0-9]{5})$|^(63|0)947(69[0-9]{5}|7[0-9]{6}|8[0-8][0-9]{5})$|^(63|0)9479[2-8][0-9]{5}$|^(63|0)9491[1-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)9493[0-7,9][0-9]{5,5}$|^(63|0)94950[0-9]{5,5}$|^(63|0)949[4,6,7][0-9]{6,6}$|^(63|0)9499[0-8][0-9]{5,5}$|^(63|0)94939[0-9]{5}$|^(63|0)999[3-5,7][0-9]{6,6}$|^(63|0)9996[5-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)9998[0-7,9][0-9]{5,5}$|^(63|0)9999[0-8][0-9]{5,5}$|^(63|0)9991[5-9][0-9]{5,5}$|^(63|0)9985[0-2][0-9]{5}$|^(63|0)998[2-4][0-9]{6}$|^(63|0)9981[5-9][0-9]{5}$' OR
                   vPhone REGEXP '^(63|0)9989[0-4][0-9]{5}$|^(63|0)947(1[4-9][0-9]{5}|[2-5][0-9]{6}|6[0-4][0-9]{5})$|^(63|0)9281[0-9]{6,6}$|^(63|0)9476[5-8][0-9]{5}$|^(63|0)90800[0-9]{5}$')
               then
                  set @vSimType = 'BUDDY';
               elseif (vPhone REGEXP '^(63|0)907[1-9][0-9]{6,6}$|^(63|0)909[1-9][0-9]{6,6}$|^(63|0)910[1-6,8-9][0-9]{6,6}$|^(63|0)9107[0-8][0-9]{5,5}$|^(63|0)91079([0-8][0-9]{4}|9[0-8][0-9]{3})$|^(63|0)912[1-9][0-9]{6,6}$' OR
                      vPhone REGEXP '^(63|0)9187[0-8][0-9]{5,5}$|^(63|0)91879([0-8][0-9]{4}|9[0-8][0-9]{3})$|^(63|0)9197[0-9]{6,6}$|^(63|0)920(3|7)[0-9]{6,6}$|^(63|0)92088[1-9][0-9]{4,4}$|^(63|0)9285[3,4,6-8][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)930[1-9][0-9]{6,6}$|^(63|0)946(1[1-9][0-9]{5}|[2-6][0-9]{6}|7[0-5][0-9]{5})$|^(63|0)946[89][0-9]{6}$|^(63|0)9481[2-5][0-9]{5}$|^(63|0)9482[0-9]{6}$' OR
                      vPhone REGEXP '^(63|0)9483[0-9][1-9][5-9][0-9]{3}$|^(63|0)948[4-8][0-9]{6}$|^(63|0)9489[0-4][0-9]{5}$|^(63|0)9489[6-9][0-9]{5}$')
               then
                  set @vSimType = 'TNT';
               elseif (vPhone REGEXP '^(63|0)90885[0-9]{5,5}$|^(63|0)90880[0-2][0-1][0-1][0-9]{2,2}$|^(63|0)9188[0-9]{6,6}$|^(63|0)92888[0-9]{5,5}$|^(63|0)93999[0-9]{5,5}$|^(63|0)94988[0-9]{5,5}$|^(63|0)94999[0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)908880[0-1][0-9]{3,3}$|^(63|0)90888020[0-9]{2,2}$|^(63|0)908880210[0-9]{1,1}$|^(63|0)908880211[0-9]{1,1}$|^(63|0)91893[0,3-9][0-9]{4,4}$|^(63|0)91894[0-8][0-9]{4,4}$' OR
                      vPhone REGEXP '^(63|0)9189[5-6][0-9]{5,5}$|^(63|0)9189(0(0[1-9][0-9]{3}|[1-9][0-9]{4})|[12][0-9]{5})$|^6391897([0-3][0-9]{4}|4[0-8][0-9]{3})$|^(63|0)91897[5-9][0-9]{4,4}$|^(63|0)9189[8-9][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)9209[0,1,5-7,9][0-9]{5,5}$|^(63|0)920932[6-9][0-9]{3,3}$|^(63|0)920938[0-9]{4,4}$|^(63|0)92094[5-9][0-9]{4,4}$|^(63|0)92855[0-9]{5,5}$|^(63|0)9399[0-378][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)999(88|99)[0-9]{5,5}$|^(63|0)91999[0-9]{5,5}$|^(63|0)9088[1-4,6,9][0-9]{5,5}$|^(63|0)90887[2-9][0-9]{4,4}$|^(63|0)90888021[2-9][0-9]{1,1}$|^(63|0)9088802[2-9][0-9]{2,2}$' OR
                      vPhone REGEXP '^(63|0)908880[3-9][0-9]{3,3}$|^(63|0)90888[1-9][0-9]{4,4}$|^(63|0)947(89|99)[0-9]{5,5}$|^(63|0)9479171[0-9]{3}$|^(63|0)947917[2-6][0-9]{3}$|^(63|0)92092[0-8][0-9]{4,4}$' OR
                      vPhone REGEXP '^(63|0)920929[0-8][0-9]{3,3}$|^(63|0)92094[0-4][0-9]{4,4}$|^(63|0)94790[0-9]{5}$|^(63|0)92098[0-9]{5,5}$|^(63|0)9285[0-2][0-9]{5,5}$|^(63|0)94938[0-9]{5}$|^(63|0)94791[0-6][0-9]{4}$')
               then
                  set @vSimType = 'POSTPD';
               end if;

               if @unmap_datein is not null then
                  UPDATE  powerapp_mapping_usage
                  SET     unmap_datein=@unmap_datein,
                          unmap_ts=@unmap_ts,
                          unmap_ipadd=@unmap_ipadd,
                          brand=ifnull(@vSimType, 'BUDDY'),
                          unmap_tx_id=@unmap_tx_id
                  WHERE   tx_id=vMinTxId;
               end if;
            end;
         end if;
      UNTIL done
      END REPEAT;
      CLOSE c;
   END;

END;
//
delimiter ;



call sp_map_duration_stat_builder();
select tx_id, unmap_tx_id, phone, (unmap_ts-map_ts)/1000/60 Duration_M, map_datein, unmap_datein, map_ipadd, map_ts, unmap_ts, brand
from powerapp_mapping_usage
where (unmap_ts-map_ts) < 0
and  unmap_ts is not null;

select * from powerapp_mapping_hist where tx_id = 47639360 union
select * from powerapp_mapping_hist where tx_id = 47639361;

select * from powerapp_mapping_hist where tx_id = (
select min(tx_id)
from powerapp_mapping_hist
where map_type = 'UNMAP'
and  phone = '639072601929'
and  ts > 1394583896689 
and  ipadd = '110.162.67.77/32')


+----------+-------------+--------------+-------------+---------------------+---------------------+------------------+---------------+---------------+-------+
| tx_id    | unmap_tx_id | phone        | Duration_M  | map_datein          | unmap_datein        | map_ipadd        | map_ts        | unmap_ts      | brand |
+----------+-------------+--------------+-------------+---------------------+---------------------+------------------+---------------+---------------+-------+
| 47639360 |    47639361 | 639072601929 | -0.00833333 | 2014-03-12 00:24:57 | 2014-03-12 00:24:56 | 10.162.67.77/32  | 1394583896689 | 1394583896189 | TNT   |
| 47639589 |    47639594 | 639072601929 | -0.00835000 | 2014-03-12 00:25:00 | 2014-03-12 00:25:00 | 10.162.69.190/32 | 1394583900193 | 1394583899692 | TNT   |
| 56391151 |    56391153 | 639073546690 | -0.00833333 | 2014-03-13 17:43:32 | 2014-03-13 17:43:31 | 10.162.196.17/32 | 1394732611924 | 1394732611424 | TNT   |
+----------+-------------+--------------+-------------+---------------------+---------------------+------------------+---------------+---------------+-------+
3 rows in set (2.12 sec)

select * from powerapp_mapping_hist where tx_id = 55197583 union
select * from powerapp_mapping_hist where tx_id = 55197588;
+----------+--------------+-----------------+----------+----------+---------------+
| tx_id    | phone        | ipadd           | map_type | status   | ts            |
+----------+--------------+-----------------+----------+----------+---------------+
| 47639360 | 639072601929 | 10.162.67.77/32 | MAP      | COMPLETE | 1394583896689 |
| 47639361 | 639072601929 | 10.162.67.77/32 | UNMAP    | COMPLETE | 1394583896189 |
+----------+--------------+-----------------+----------+----------+---------------+
2 rows in set (0.00 sec)
