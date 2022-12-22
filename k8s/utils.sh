
select_pod_from_namespace () {
    local namespace="$1"
    # Select pod
    podsOfNamespace=($(kubectl get pods -n $namespace --no-headers -o custom-columns=":metadata.name"));
    echo "==> Select your pod, or 0 to exit";
    select pod in "${podsOfNamespace[@]}"; do
        if [[ $REPLY == "0" ]]; then
            exit 0;
        elif [[ -z $pod ]]; then
            echo 'Invalid choice, try again' >&2
        else
            break;
        fi
    done
}

# Execute SQL_FILE into postgres POD with provided DBUSER and DBNAME
execute_sql_into_pod () {
    local sql="$1"
    local pod="$2"
    local namespace="$3"
    local dbuser="$4"
    local dbname="$5"
    echo "==================================="
    echo "File:      $sql"
    echo "Pod:       $pod"
    echo "DB_USER:   $dbuser"
    echo "DB_NAME:   $dbname"
    echo "==================================="
    if [ -z "$sql" ] || [ -z "$pod" ] || [ -z "$dbuser" ] || [ -z "$dbname" ]; then
        echo "=> One or more empty parameters (sql=$sql, pod=$pod, user=$dbuser, dbname=$dbname)"
        exit 1;
    fi
    echo "=================================== [ $sql ]"
    log=$(kubectl exec -i $pod -n $namespace -- psql -U $dbuser -d $dbname < $sql 2>&1)
    echo -e "\e[32m$log \e[0m"
    echo "=================================== [ END ]"
}