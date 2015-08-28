{% from "roundcube/map.jinja" import server with context %}

{%- if server.enabled %}

roundcube_db_config:
  file.managed:
  - name: /etc/roundcube/debian-db.php
  - source: salt://roundcube/files/debian-db.php
  - mode: 640
  - user: root
  - group: www-data
  - template: jinja
  - require:
    - pkg: roundcube_packages

roundcube_main_config:
  file.managed:
  - name: /etc/roundcube/main.inc.php
  - source: salt://roundcube/files/main.inc.php
  - mode: 640
  - user: root
  - group: www-data
  - template: jinja
  - require:
    - pkg: roundcube_packages

roundcube_packages:
  pkg.installed:
    - names: {{ server.pkgs }}

roundcube_db_install:
  cmd.wait:
    - name: mysql -u{{ server.mysql.user }} -p{{ server.mysql.password }} -h{{ server.mysql.host }} {{ server.mysql.database }} < /usr/share/dbconfig-common/data/roundcube/install/mysql
    - watch:
      - file: roundcube_db_config

php_mcrypt_enable:
  cmd.wait:
    - name: php5enmod mcrypt
    - watch:
      - pkg: roundcube_packages

{%- endif %}