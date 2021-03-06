CREATE TABLE IF NOT EXISTS `user` (`id`	INTEGER NOT NULL AUTO_INCREMENT,`username`	VARCHAR ( 64 ) UNIQUE,`email` VARCHAR ( 120 ) UNIQUE, `password` VARCHAR ( 128 ),`role`	VARCHAR ( 128 ),`groups` VARCHAR ( 120 ), ldap_user INTEGER NOT NULL DEFAULT 0, activeuser INTEGER NOT NULL DEFAULT 1, PRIMARY KEY(`id`) );
INSERT INTO `user` (username, email, password, role, `groups`) VALUES ('admin','admin@localhost','21232f297a57a5a743894a0e4a801fc3','admin','1');
INSERT INTO `user` (username, email, password, role, `groups`) VALUES ('editor','editor@localhost','5aee9dbd2a188839105073571bee1b1f','editor','1');
INSERT INTO `user` (username, email, password, role, `groups`) VALUES ('guest','guest@localhost','084e0343a0486ff05530df6c705c8bb4','guest','1');
CREATE TABLE IF NOT EXISTS `servers` (`id`	INTEGER NOT NULL AUTO_INCREMENT,`hostname` VARCHAR ( 64 ),`ip` VARCHAR ( 64 ) UNIQUE,`groups` VARCHAR ( 64 ), type_ip INTEGER NOT NULL DEFAULT 0, enable INTEGER NOT NULL DEFAULT 1, master INTEGER NOT NULL DEFAULT 0, cred INTEGER NOT NULL DEFAULT 1, alert INTEGER NOT NULL DEFAULT 0, metrics INTEGER NOT NULL DEFAULT 0, port INTEGER NOT NULL DEFAULT 22, `desc` varchar(64), active INTEGER NOT NULL DEFAULT 0, keepalived INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(`id`) );
CREATE TABLE IF NOT EXISTS `role` (`id`	INTEGER NOT NULL AUTO_INCREMENT,`name`	VARCHAR ( 80 ) UNIQUE,`description`	VARCHAR ( 255 ),PRIMARY KEY(`id`) );
INSERT INTO `role` (name, description) VALUES ('admin','Can do everything');
INSERT INTO `role` (name, description) VALUES ('editor','Can edit configs');
INSERT INTO `role` (name, description) VALUES ('guest','Read only access');
CREATE TABLE IF NOT EXISTS `groups` (`id`	INTEGER NOT NULL AUTO_INCREMENT,`name` VARCHAR ( 80 ) UNIQUE,`description` VARCHAR ( 255 ),PRIMARY KEY(`id`));
INSERT INTO `groups` (name, description) VALUES ('All','All servers enter in this group');	
CREATE TABLE IF NOT EXISTS `uuid` (`user_id` INTEGER NOT NULL, `uuid` varchar ( 64 ),`exp` DATETIME default CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS `token` (`user_id` INTEGER, `token` varchar(64), `exp` timestamp default CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS `cred` (`id` integer primary key AUTO_INCREMENT, `name` VARCHAR ( 64 ), `enable` INTEGER NOT NULL DEFAULT 1, `username` VARCHAR ( 64 ) NOT NULL, `password` VARCHAR ( 64 ) NOT NULL, `groups` INTEGER NOT NULL DEFAULT 1, UNIQUE(name,`groups`));
CREATE TABLE IF NOT EXISTS `telegram` (`id` integer primary key auto_increment, `token` VARCHAR ( 64 ), `chanel_name` INTEGER NOT NULL DEFAULT 1, `groups` INTEGER NOT NULL DEFAULT 1);
CREATE TABLE IF NOT EXISTS `metrics_http_status` (`serv` varchar(64), `2xx` INTEGER, `3xx` INTEGER, `4xx` INTEGER, `5xx` INTEGER,`date` DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS `metrics` (`serv` varchar(64), curr_con INTEGER, cur_ssl_con INTEGER, sess_rate INTEGER, max_sess_rate INTEGER,`date`  DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS `settings` (`param` varchar(64), value varchar(64), section varchar(64), `desc` varchar(100), `group` INTEGER NOT NULL DEFAULT 1, UNIQUE(param, `group`));
CREATE TABLE IF NOT EXISTS `version` (`version` varchar(64));
CREATE TABLE IF NOT EXISTS `options` (`id` INTEGER NOT NULL, `options` VARCHAR ( 64 ), `groups` VARCHAR ( 120 ), PRIMARY KEY(`id`));
CREATE TABLE IF NOT EXISTS `saved_servers` (`id` INTEGER NOT NULL, `server` VARCHAR ( 64 ), `description` VARCHAR ( 120 ), `groups` VARCHAR ( 120 ), PRIMARY KEY(`id`));
CREATE TABLE IF NOT EXISTS `backups` (`id` INTEGER NOT NULL, `server` VARCHAR ( 64 ), `rhost` VARCHAR ( 120 ), `rpath` VARCHAR ( 120 ), `time` VARCHAR ( 120 ),  cred INTEGER, `description` VARCHAR ( 120 ), PRIMARY KEY(`id`));
CREATE TABLE IF NOT EXISTS `waf` (`server_id` INTEGER UNIQUE, metrics INTEGER);
CREATE TABLE IF NOT EXISTS `waf_metrics` (`serv` varchar(64), conn INTEGER, `date` DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS user_groups(user_id INTEGER NOT NULL, user_group_id INTEGER NOT NULL, UNIQUE(user_id,user_group_id));
CREATE TABLE IF NOT EXISTS port_scanner_settings (server_id INTEGER NOT NULL, user_group_id INTEGER NOT NULL, enabled INTEGER NOT NULL, notify INTEGER NOT NULL, history INTEGER NOT NULL, UNIQUE(server_id));
CREATE TABLE IF NOT EXISTS port_scanner_ports (`serv` varchar(64), user_group_id INTEGER NOT NULL, port INTEGER NOT NULL, service_name varchar(64), `date`  DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS port_scanner_history (`serv` varchar(64), port INTEGER NOT NULL, status varchar(64), service_name varchar(64), `date`  DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS providers_creds (`id` INTEGER NOT NULL, `name` VARCHAR ( 64 ), `type` VARCHAR ( 64 ), `group` VARCHAR ( 64 ), `key` VARCHAR ( 64 ),  `secret` VARCHAR ( 64 ), `create_date`  DATETIME default '0000-00-00 00:00:00', `edit_date`  DATETIME default '0000-00-00 00:00:00', PRIMARY KEY(`id`)); 
CREATE TABLE IF NOT EXISTS provisioned_servers (`id` INTEGER NOT NULL, `region` VARCHAR ( 64 ), `instance_type` VARCHAR ( 64 ), `public_ip` INTEGER, `floating_ip` INTEGER, `volume_size` INTEGER, `backup` INTEGER, `monitoring` INTEGER, `private_networking` INTEGER, `ssh_key_name` VARCHAR ( 64 ), `ssh_ids` VARCHAR ( 64 ), `name` VARCHAR ( 64 ), `os` VARCHAR ( 64 ), `firewall` INTEGER, `provider_id` INTEGER, `type` VARCHAR ( 64 ), `status` VARCHAR ( 64 ), `group_id` INTEGER NOT NULL, `date`  DATETIME default '0000-00-00 00:00:00', `IP` VARCHAR ( 64 ), `last_error` VARCHAR ( 256 ), `delete_on_termination` INTEGER, PRIMARY KEY(`id`));
CREATE TABLE IF NOT EXISTS api_tokens (`token` varchar(64), `user_name` varchar(64), `user_group_id` INTEGER NOT NULL, `user_role` INTEGER NOT NULL, `create_date`  DATETIME default '0000-00-00 00:00:00', `expire_date`  DATETIME default '0000-00-00 00:00:00');
CREATE TABLE IF NOT EXISTS `slack` (`id` INTEGER NOT NULL, `token` VARCHAR (64), `chanel_name` INTEGER NOT NULL DEFAULT 1, `groups` INTEGER NOT NULL DEFAULT 1, PRIMARY KEY(`id`));
CREATE TABLE IF NOT EXISTS `settings` (`param` varchar(64), value varchar(64), section varchar(64), `desc` varchar(100), `group` INTEGER NOT NULL DEFAULT 1, UNIQUE(param, `group`));
INSERT  INTO settings (param, value, section, `desc`) values('time_zone', 'UTC', 'main', 'Time Zone');
INSERT  INTO settings (param, value, section, `desc`) values('proxy', '', 'main', 'Proxy server. Use proto://ip:port');
INSERT  INTO settings (param, value, section, `desc`) values('session_ttl', '5', 'main', 'Time to live users sessions. In days');
INSERT  INTO settings (param, value, section, `desc`) values('token_ttl', '5', 'main', 'Time to live users tokens. In days');
INSERT  INTO settings (param, value, section, `desc`) values('tmp_config_path', '/tmp/', 'main', 'A temp folder of configs, for checking. The path must exist');
INSERT  INTO settings (param, value, section, `desc`) values('cert_path', '/etc/ssl/certs/', 'main', 'A path to SSL dir. The folder owner must be an user who set in the SSH settings. The path must exist');
INSERT  INTO settings (param, value, section, `desc`) values('ssl_local_path', 'certs', 'main', 'Path to dir for local save SSL certs. This is a relative path, begins with $HOME_HAPROXY-WI/app/');
INSERT  INTO settings (param, value, section, `desc`) values('lists_path', 'lists', 'main', 'Path to black/white lists. This is a relative path, begins with $HOME_HAPROXY-WI');
INSERT  INTO settings (param, value, section, `desc`) values('local_path_logs', '/var/log/haproxy.log', 'logs', 'Logs save locally, enabled by default');
INSERT  INTO settings (param, value, section, `desc`) values('syslog_server_enable', '0', 'logs', 'If exist syslog server for HAProxy logs, enable this option');
INSERT  INTO settings (param, value, section, `desc`) values('syslog_server', '0', 'logs', 'IP address of syslog server');
INSERT  INTO settings (param, value, section, `desc`) values('log_time_storage', '14', 'logs', 'Storage time for user activity logs, in days');
INSERT  INTO settings (param, value, section, `desc`) values('stats_user', 'admin', 'haproxy', 'Username for the HAProxy Stats web page');
INSERT  INTO settings (param, value, section, `desc`) values('stats_password', 'password', 'haproxy', 'Password for the HAProxy Stats web page');
INSERT  INTO settings (param, value, section, `desc`) values('stats_port', '8085', 'haproxy', 'Port for the HAProxy Stats web page');
INSERT  INTO settings (param, value, section, `desc`) values('stats_page', 'stats', 'haproxy', 'URI for the HAProxy Stats web page');
INSERT  INTO settings (param, value, section, `desc`) values('haproxy_dir', '/etc/haproxy/', 'haproxy', 'Path to HAProxy dir');
INSERT  INTO settings (param, value, section, `desc`) values('haproxy_config_path', '/etc/haproxy/haproxy.cfg', 'haproxy', 'Path to HAProxy config');
INSERT  INTO settings (param, value, section, `desc`) values('server_state_file', '/etc/haproxy/haproxy.state', 'haproxy', 'Path to HAProxy state file');
INSERT  INTO settings (param, value, section, `desc`) values('haproxy_sock', '/var/run/haproxy.sock', 'haproxy', 'Path to HAProxy sock file');
INSERT  INTO settings (param, value, section, `desc`) values('haproxy_sock_port', '1999', 'haproxy', 'HAProxy sock port');
INSERT  INTO settings (param, value, section, `desc`) values('apache_log_path', '/var/log/httpd/', 'logs', 'Path to Apache logs folder');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_enable', '0', 'ldap', 'If 1 LDAP is enabled');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_server', '', 'ldap', 'LDAP server IP address');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_port', '389', 'ldap', 'Default port is 389 or 636');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_user', '', 'ldap', 'Username to connect to the LDAP server. Enter: user@domain.com');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_password', '', 'ldap', 'Password for connect to LDAP server');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_base', '', 'ldap', 'Base domain. Example: dc=domain, dc=com');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_domain', '', 'ldap', 'Domain for login, that after @, like user@domain.com, without user@');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_class_search', 'user', 'ldap', 'Class to search user');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_user_attribute', 'sAMAccountName', 'ldap', 'User attribute for searching');
INSERT  INTO settings (param, value, section, `desc`) values('ldap_search_field', 'mail', 'ldap', 'Field where user e-mails are saved');
CREATE TABLE IF NOT EXISTS `version` (`version` varchar(64));