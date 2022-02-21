view: incremental_pdt {
  derived_table: {
    datagroup_trigger:xiaomi_v2_default_datagroup
    increment_key: "event_date_date"
    increment_offset: 3
    sql:
      select
      event_name,PARSE_DATE("%Y%m%d", event_date) as event_date, count (distinct user_pseudo_id)  as uv
      from `allen-first.bingoblast.events_*`
      where {% incrementcondition %} PARSE_DATE("%Y%m%d", event_date) {%  endincrementcondition %}
      and _TABLE_SUFFIX BETWEEN replace(safe_cast(date_sub(current_date(),interval 720 day) as string),'-','') AND replace(safe_cast(current_date() as string),'-','')
      group by 1,2
 ;;
# increment_key: "event_date_date"
# increment_offset: 3
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: event_name {
      type: string
      sql: ${TABLE}.event_name ;;
    }

    dimension_group: event_date {
      type: time
      # datatype: date
      timeframes: [raw,date]
      sql: ${TABLE}.event_date ;;
    }

    dimension: uv {
      type: number
      sql: ${TABLE}.uv ;;
    }

    set: detail {
      fields: [event_name, uv]
    }
  }
