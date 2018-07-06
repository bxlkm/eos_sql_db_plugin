1. install mysql.
2. put the directory of mysql file in /usr/local/lib 
	file list: libcrypto.1.0.0.dylib, libcrypto.dylib, libmysqlclien.21.dylib, libmysqlclient.a, libmysqlclient.dylib, libmysqlservices.a, libssl.1.0.0.dylib .
3. install soci.
	$ git clone https://github.com/SOCI/soci.git
	$ cd soci && mkdir build && cd build
	$ cmake
	$ make && make install
4. Edit plugins setting, add sql_db_plugin.
5. add --sql_db-uri="mysql://db={database name} user={root} password='{password}'" --sql_db-block-start=0 to config.ini .