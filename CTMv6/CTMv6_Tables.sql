CREATE TABLE ctm_accnt_list (
  id int(11) NOT NULL AUTO_INCREMENT,
  ctm_accnt int(9) unsigned zerofill NOT NULL,
  status tinyint(4) DEFAULT '0',
  PRIMARY KEY (id,ctm_accnt),
  KEY status (status)
) ENGINE=MyISAM;

CREATE TABLE ctm_accounts (
  ctm_accnt int(9) unsigned zerofill NOT NULL,
  ctm_token varchar(255) DEFAULT NULL,
  display_name varchar(25) DEFAULT NULL,
  photo_path varchar(255) DEFAULT NULL,
  msisdn varchar(19) DEFAULT NULL,
  msisdn_passwd varchar(100) DEFAULT NULL,
  msisdn_type varchar(15) DEFAULT NULL,
  reg_src varchar(15) NOT NULL,
  reg_app varchar(15) NOT NULL,
  country smallint(6) DEFAULT NULL,
  msisdn_carrier varchar(12) DEFAULT NULL,
  reg_date datetime DEFAULT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ctm_accnt),
  UNIQUE KEY msisdn (msisdn),  
  KEY reg_date (reg_date),  --  keys will only appear in slave
  KEY msisdn_carrier (msisdn_carrier),  --  keys will only appear in slave
  KEY msisdn_type (msisdn_type),  -- keys will only appear in slave
  KEY reg_src (reg_src), -- keys will only appear in slave
  KEY reg_app (reg_app)  --  keys will only appear in slave
) ENGINE=MyISAM;

CREATE TABLE ctm_sns_link (
  ctm_accnt int(9) unsigned zerofill NOT NULL,
  sn_provider_id tinyint(4) NOT NULL,
  token varchar(255) NOT NULL,
  sn_display_name varchar(80) NOT NULL,
  email_add varchar(255) DEFAULT NULL,
  linked_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ctm_accnt,sn_provider_id),
  KEY sn_id (sn_display_name)
) ENGINE=MyISAM;


CREATE TABLE sns_id_lookup (
  id tinyint(4) NOT NULL AUTO_INCREMENT,
  sn_provider varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=MyISAM;


CREATE TABLE country_lookup (
  id smallint(6) NOT NULL AUTO_INCREMENT,
  country_code varchar(8) NOT NULL DEFAULT '',
  country_name varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=MyISAM;


CREATE TABLE mobile_pattern (
  operator varchar(15) DEFAULT NULL,
  sim_type varchar(20) DEFAULT NULL,
  pattern varchar(150) DEFAULT NULL,
  notes varchar(100) DEFAULT NULL
) ENGINE=MyISAM;






