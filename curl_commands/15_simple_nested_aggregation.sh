curl -XPOST 'http://localhost:9200/movies/_search?pretty=true' \
-H 'Content-Type: application/json' \
-d '{
    "aggs" : {
        "genres" : {
            "terms" : { "field" : "genre" },
            "aggs" : {
                "avg_rating" : { "avg" : { "field" : "rating" } }
            }
        }
    },
    "size":0
}'