create keyspace ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': {{ycsb_replication_factor}} };
create table ycsb.usertable (
    y_id varchar primary key,
    field0 varchar,
    field1 varchar,
    field2 varchar,
    field3 varchar,
    field4 varchar,
    field5 varchar,
    field6 varchar,
    field7 varchar,
    field8 varchar,
    field9 varchar);