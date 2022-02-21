view: uv_pdt {
  derived_table: {
    sql:
      select
      event_name,PARSE_DATE("%Y%m%d", event_date) as event_date, count (distinct user_pseudo_id)  as uv
      from `allen-first.bingoblast.events_*`
      where check_single_condition(event_params,{% parameter key1_filter %},{% parameter value1_filter %},{% parameter key2_filter %},{% parameter value2_filter %}) > 1
      and {% condition event_name_filter1 %} event_name {% endcondition %}
      and _TABLE_SUFFIX BETWEEN replace(safe_cast(date({%date_start date_filter %}) as string),'-','') AND replace(safe_cast(date({%date_end date_filter %}) as string),'-','')
      group by 1,2
 ;;
# increment_key: "event_date_date"
# increment_offset: 3
  }

  filter: date_filter {
    type: date
  }

  filter: event_name_filter1 {
    type: string
    suggest_explore: uv_pdt
    suggest_dimension: uv_pdt.event_name
  }

  parameter: key1_filter {
    # suggest_dimension: event
    default_value: "item_id"
    allowed_value: {
      label: "item_id"
      value: "item_id"
    }
  }

  parameter: key2_filter {
    # suggest_dimension: event
    default_value: "content_type"
    allowed_value: {
      label: "content_type"
      value: "content_type"
    }
  }

  parameter: value1_filter {
    # suggest_dimension: event
    default_value: "declined"
    allowed_value: {
      label: "declined"
      value: "declined"
    }
  }

  parameter: value2_filter {
    # suggest_dimension: event
    default_value: "time_extender"
    allowed_value: {
      label: "time_extender"
      value: "time_extender"
    }
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: event_date {
    type: date
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: uv {
    type: number
    sql: ${TABLE}.uv ;;
  }

  set: detail {
    fields: [event_name, event_date, uv]
  }
}
