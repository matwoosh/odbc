-module(erlodbc).
-export([init/0,start/1,stop/1]).

init()->
	odbc:start(),
	{ok, Ref} = odbc:connect("DSN=DevartODBCPostgreSQL;UID=erl;PWD=erl", []),
	
	Ref.
	
start(Ref)-> 
	odbc:sql_query(Ref, "CREATE TABLE EMPLOYEE 
						(NR integer, FIRSTNAME char varying(20), 
						LASTNAME char varying(20), GENDER char(1),
						PRIMARY KEY(NR))"),
	
	odbc:sql_query(Ref, "INSERT INTO EMPLOYEE VALUES(1, 'Jane', 'Doe', 'F')"),
	{ok,R1}=odbc:describe_table(Ref, "EMPLOYEE"),
	io:format("Table description ~p~n",[R1]),
	
	odbc:param_query(Ref,"INSERT INTO EMPLOYEE (NR, FIRSTNAME, "
						"LASTNAME, GENDER) VALUES(?, ?, ?, ?)",
						[{sql_integer,[2,3,4,5,6,7,8]},
						{{sql_varchar, 20},
						["John", "Monica", "Ross", "Rachel","Piper", "Prue", "Louise"]},
						{{sql_varchar, 20},
						["Doe","Geller","Geller", "Green","Halliwell", "Halliwell", "Lane"]},
						{{sql_char, 1}, 
						["M","F","M","F","F","F","F"]}]),
	{selected, C2, R2}=odbc:sql_query(Ref, "SELECT * FROM EMPLOYEE"),
	io:format("SELECT on Employee ~p~n",[{selected, C2, R2}]),
	
	{selected, C3, R3}=odbc:param_query(Ref, "SELECT * FROM EMPLOYEE WHERE GENDER=?",
							[{{sql_char, 1}, ["M"]}]),
	io:format("SELECT on Employee ~p~n",[{selected, C3, R3}]),
		
	odbc:sql_query(Ref, "DROP TABLE EMPLOYEE").

	
stop(Ref)->

	odbc:disconnect(Ref),
	odbc:stop().
	
