#!/bin/bash
# Usefull to run a list of .sql files into containerized postgres database with specific DB_USER/DB_NAME

source ./utils.sh

# Parameters
pod=$(kubectl get pods -n $namespace --no-headers -o custom-columns=":metadata.name" | grep NAME_OF_YOUR_TARGET_POD)
namespace="default"
dbuser="postgres"
dbname="postgres"

# Execution
execute_sql_into_pod "./sql_path_1.sql" "$pod" "$namespace" "$dbuser" "$dbname"
execute_sql_into_pod "./sql_path_2.sql" "$pod" "$namespace" "$dbuser" "$dbname"
execute_sql_into_pod "./sql_path_3.sql" "$pod" "$namespace" "$dbuser" "$dbname"

# End
echo " ~ Completed."
