# Define the database connection to be used for this model.
connection: "xiaomi_v2"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: xiaomi_v2_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: xiaomi_v2_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Xiaomi V2"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: ping {}
explore: uv_pdt {
  extends: [udf_lib]
}

explore: udf_lib {
  extension: required
  sql_preamble:
    ${EXTENDED}
     -- math functions
      create temp function check_single_condition(arr ANY type,key1 string,value1 string,key2 string, value2 string)
      as (
        (select count(*) from unnest(arr) as arr
         where (arr.key=key1 and arr.value.string_value = value1)
            or (arr.key=key2 and arr.value.string_value = value2))
      );
  ;;
}
