curl -XPUT 'localhost:9200/movies-v*/_settings?pretty=true' \
-H 'Content-Type: application/json' \
-d '{
    "index" : {
        "number_of_replicas" : 1
    }
}'