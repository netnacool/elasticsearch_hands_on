curl -XPOST 'localhost:9200/movies/_search?pretty=true' \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "bool" : {
      "must" : {
        "term" : { "language" : "English" }
      },
      "filter": [
        {"match" : { "description" : "batman" }},
        {"term" : { "genre" : "Action" }}
      ],
      "must_not" : {
        "range" : {
          "release_data" : { "lte" : "10-06-2007"}
        }
      },
      "should" : [
        { "match" : { "name" : "batman" } }
      ]
    }
  }
}'