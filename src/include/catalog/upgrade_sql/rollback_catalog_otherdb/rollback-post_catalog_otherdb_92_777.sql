DO $$
DECLARE
ans boolean;
BEGIN

    -- openGauss 3.0.X already have this feature, same as the version we are, do nothing.
    select case when working_version_num() = 92606 then true else false end into ans;
    if ans = false then
        DROP FUNCTION IF EXISTS dbe_perf.standby_statement_history(boolean);
        DROP FUNCTION IF EXISTS dbe_perf.standby_statement_history(boolean, timestamp with time zone[]);
    end if;

    -- openGauss 2.0.X and 3.0.X already have this feature, but low version, we shoule recreate it.
    select case when working_version_num() >= 92301 and working_version_num() < 92420 then true else false end into ans;
    if ans = true then
        SET LOCAL inplace_upgrade_next_system_object_oids = IUO_PROC, 3118;
        CREATE OR REPLACE FUNCTION dbe_perf.standby_statement_history(
            IN  only_slow boolean,
            OUT db_name name,
            OUT schema_name name,
            OUT origin_node integer,
            OUT user_name name,
            OUT application_name text,
            OUT client_addr text,
            OUT client_port integer,
            OUT unique_query_id bigint,
            OUT debug_query_id bigint,
            OUT query text,
            OUT start_time timestamp with time zone,
            OUT finish_time timestamp with time zone,
            OUT slow_sql_threshold bigint,
            OUT transaction_id bigint,
            OUT thread_id bigint,
            OUT session_id bigint,
            OUT n_soft_parse bigint,
            OUT n_hard_parse bigint,
            OUT query_plan text,
            OUT n_returned_rows bigint,
            OUT n_tuples_fetched bigint,
            OUT n_tuples_returned bigint,
            OUT n_tuples_inserted bigint,
            OUT n_tuples_updated bigint,
            OUT n_tuples_deleted bigint,
            OUT n_blocks_fetched bigint,
            OUT n_blocks_hit bigint,
            OUT db_time bigint,
            OUT cpu_time bigint,
            OUT execution_time bigint,
            OUT parse_time bigint,
            OUT plan_time bigint,
            OUT rewrite_time bigint,
            OUT pl_execution_time bigint,
            OUT pl_compilation_time bigint,
            OUT data_io_time bigint,
            OUT net_send_info text,
            OUT net_recv_info text,
            OUT net_stream_send_info text,
            OUT net_stream_recv_info text,
            OUT lock_count bigint,
            OUT lock_time bigint,
            OUT lock_wait_count bigint,
            OUT lock_wait_time bigint,
            OUT lock_max_count bigint,
            OUT lwlock_count bigint,
            OUT lwlock_wait_count bigint,
            OUT lwlock_time bigint,
            OUT lwlock_wait_time bigint,
            OUT details bytea,
            OUT is_slow_sql boolean)
        RETURNS SETOF record NOT FENCED NOT SHIPPABLE ROWS 10000
        LANGUAGE internal AS $function$standby_statement_history_1v$function$;

        DROP FUNCTION IF EXISTS dbe_perf.standby_statement_history(boolean, timestamp with time zone[]);
        SET LOCAL inplace_upgrade_next_system_object_oids = IUO_PROC, 3119;
        CREATE OR REPLACE FUNCTION dbe_perf.standby_statement_history(
            IN  only_slow boolean,
            VARIADIC finish_time timestamp with time zone[], 
            OUT db_name name,
            OUT schema_name name,
            OUT origin_node integer,
            OUT user_name name,
            OUT application_name text,
            OUT client_addr text,
            OUT client_port integer,
            OUT unique_query_id bigint,
            OUT debug_query_id bigint,
            OUT query text,
            OUT start_time timestamp with time zone,
            OUT finish_time timestamp with time zone,
            OUT slow_sql_threshold bigint,
            OUT transaction_id bigint,
            OUT thread_id bigint,
            OUT session_id bigint,
            OUT n_soft_parse bigint,
            OUT n_hard_parse bigint,
            OUT query_plan text,
            OUT n_returned_rows bigint,
            OUT n_tuples_fetched bigint,
            OUT n_tuples_returned bigint,
            OUT n_tuples_inserted bigint,
            OUT n_tuples_updated bigint,
            OUT n_tuples_deleted bigint,
            OUT n_blocks_fetched bigint,
            OUT n_blocks_hit bigint,
            OUT db_time bigint,
            OUT cpu_time bigint,
            OUT execution_time bigint,
            OUT parse_time bigint,
            OUT plan_time bigint,
            OUT rewrite_time bigint,
            OUT pl_execution_time bigint,
            OUT pl_compilation_time bigint,
            OUT data_io_time bigint,
            OUT net_send_info text,
            OUT net_recv_info text,
            OUT net_stream_send_info text,
            OUT net_stream_recv_info text,
            OUT lock_count bigint,
            OUT lock_time bigint,
            OUT lock_wait_count bigint,
            OUT lock_wait_time bigint,
            OUT lock_max_count bigint,
            OUT lwlock_count bigint,
            OUT lwlock_wait_count bigint,
            OUT lwlock_time bigint,
            OUT lwlock_wait_time bigint,
            OUT details bytea,
            OUT is_slow_sql boolean)
        RETURNS SETOF record NOT FENCED NOT SHIPPABLE ROWS 10000
        LANGUAGE internal AS $function$standby_statement_history$function$;
    end if;

END$$;



