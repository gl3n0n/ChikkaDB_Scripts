delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mo//

create procedure sp_generate_ctm_stats_mo (p_database varchar(20))
begin
   DECLARE vSchemaOwner, vTableName Varchar(80);
   declare done int default 0;
   declare c_tab cursor for select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_out_20%'
                            and   table_schema = p_database
                            union
                            select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_out_20%'
                            and   table_schema = p_database
                            order by table_schema, table_name;

   declare continue handler for sqlstate '23000' set done = 0;
   declare continue handler for sqlstate '02000' set done = 1;
   
   open c_tab;
   repeat
   fetch c_tab into vSchemaOwner, vTableName;
      if not done then

         select count(1)
         into   @nCnt
         from   information_schema.columns
         where  concat(table_schema, '.', table_name) = vTableName
         and    COLUMN_NAME='post_flag';

         if @nCnt = 0 then
            SET @vSql = concat('alter table ', vTableName, ' add post_flag smallint');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;

         if vSchemaOwner = 'mui_ph_globe_1' then
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9175[0-9]{6,6}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)90599[0-9]{5,5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('update ', vTableName, ' set post_flag = 0 where post_flag is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''globe'' carrier, ''mo'' type,   ',
                               '       sum(CASE WHEN (post_flag=1) THEN 1 ELSE 0 END) PostCtr,    ',
                               '       sum(CASE WHEN (post_flag=1) THEN 0 ELSE 1 END) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ' );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, time_hh, carrier, type, sum(PostCtr), sum(PreCtr) from ( ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''globe'' carrier, ''ukmo'' type,   ',
                               '       count(distinct tx_from) PostCtr,    ',
                               '       0 PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 1 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ',
                               'union ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''globe'' carrier, ''ukmo'' type,   ',
                               '       0 PostCtr,    ',
                               '       count(distinct tx_from) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 0 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type '
                               ') tab_1 group by datein, time_hh, carrier, type');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         elseif vSchemaOwner = 'mui_ph_smart_1' then
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94789[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94799[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9479171[0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)947917[2-6][0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)90887[2-9][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)908880212[0-9]$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9088802[2-9]{2}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)908880[3-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)918930[0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)91893[3-9][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)91894[0-8][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9189(5|6)[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)91999[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9209(0|1)[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)920932[6-9][0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)920938[0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)92094[5-9][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)92855[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)999(88|99)[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            -- GOLD 3G pattern
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9285[0-2][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            -- ADDICT patterns
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)92092[0-8][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)920929[0-8][0-9]{3}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)92094[0-4][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            -- INFINITY patterns
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)90885[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9188[0-9]{6}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)92888[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)93999[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)949(88|99)[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            -- BRO Postpaid pattern
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94790[5-9][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94791[3-6][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94938[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94951[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)90887[0-1][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            -- BRO Micro Postpaid pattern
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9299[8-9][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9396[6-9][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)93970[0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9471[2-3][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9476[7-8][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9281[0-3][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9495[2|4][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)94955[1-4][0-9]{4}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9991[1-4][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 0 where post_flag is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''smart'' carrier, ''mo'' type,   ',
                               '       sum(CASE WHEN (post_flag=1) THEN 1 ELSE 0 END) PostCtr,    ',
                               '       sum(CASE WHEN (post_flag=1) THEN 0 ELSE 1 END) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ' );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, time_hh, carrier, type, sum(PostCtr), sum(PreCtr) from ( ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''smart'' carrier, ''ukmo'' type,   ',
                               '       count(distinct tx_from) PostCtr,    ',
                               '       0 PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 1 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ',
                               'union ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''smart'' carrier, ''ukmo'' type,   ',
                               '       0 PostCtr,    ',
                               '       count(distinct tx_from) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 0 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type '
                               ') tab_1 group by datein, time_hh, carrier, type');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;


         elseif vSchemaOwner = 'mui_ph_sun_1' then

            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''(([+| ]?63)|0)9228[0-9]{6}'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''(([+| ]?63)|0)922922[0-9]{4}'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 1 where tx_from REGEXP ''(([+| ]?63)|0)9328[0-9]{6}'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('update ', vTableName, ' set post_flag = 0 where post_flag is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''sun'' carrier, ''mo'' type,   ',
                               '       sum(CASE WHEN (post_flag=1) THEN 1 ELSE 0 END) PostCtr,    ',
                               '       sum(CASE WHEN (post_flag=1) THEN 0 ELSE 1 END) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ' );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET @vSql = concat('insert into test.ctm_stats_dtl ',
                               'select datein, time_hh, carrier, type, sum(PostCtr), sum(PreCtr) from ( ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''sun'' carrier, ''ukmo'' type,   ',
                               '       count(distinct tx_from) PostCtr,    ',
                               '       0 PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 1 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type ',
                               'union ',
                               'select datein, concat(left(timein, 2), '':00'') time_hh,  ',
                               '       ''sun'' carrier, ''ukmo'' type,   ',
                               '       0 PostCtr,    ',
                               '       count(distinct tx_from) PreCtr    ',
                               'from ', vTableName, ' ',
                               'where post_flag = 0 ',
                               'and   status = 2 ',
                               'and   tx_type = ''messaging'' ',
                               'group by datein, time_hh, carrier, type '
                               ') tab_1 group by datein, time_hh, carrier, type');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      end if;
   until done
   end repeat;
end;
//

delimiter ;


set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

mui_ph_globe_1
mui_ph_smart_1
mui_ph_sun_1

call sp_generate_ctm_stats_mo('mui_ph_globe_1');
call sp_generate_ctm_stats_mo('mui_ph_smart_1');
call sp_generate_ctm_stats_mo('mui_ph_sun_1');



select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_out_20%'
                            and   table_schema = 'mui_ph_globe_1'
                            union
                            select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_out_20%'
                            and   table_schema = 'mui_ph_globe_1'
                            order by table_schema, table_name;




select datein, concat(left(timein, 2), ':00') time_h, 'smart', 'mo', count(1) hits
from mui_ph_smart_1.bridge_out
where status = 2 
and   tx_type = 'messaging'
group by datein , concat(left(timein, 2), ':00');

select datein, concat(left(timein, 2), ':00') time_h, 'smart', 'ukmo', count(distinct tx_from) hits
from mui_ph_smart_1.bridge_out
where status = 2 
and   tx_type = 'messaging'
group by datein , concat(left(timein, 2), ':00');

select datein, concat(left(timein, 2), ':00') time_h, 'smart', 'ukmt', count(distinct tx_to) hits
from mui_ph_smart_1.bridge_in
where status = 2 
and   tx_type = 'chat'
group by datein , concat(left(timein, 2), ':00');

select datein, concat(left(timein, 2), ':00') time_h, 'sun', 'mo', count(1) hits
from mui_ph_sun_1.bridge_out
where status = 2 
and   tx_type = 'messaging'
group by datein , concat(left(timein, 2), ':00');

select datein, concat(left(timein, 2), ':00') time_h, 'sun', 'ukmo', count(distinct tx_from) hits
from mui_ph_sun_1.bridge_out
where status = 2 
and   tx_type = 'messaging'
group by datein , concat(left(timein, 2), ':00');

select datein, concat(left(timein, 2), ':00') time_h, 'sun', 'ukmt', count(distinct tx_to) hits
from mui_ph_sun_1.bridge_in
where status = 2 
and   tx_type = 'chat'
group by datein , concat(left(timein, 2), ':00');
