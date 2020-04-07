curl -XPOST 'localhost:9200/movies/_search?pretty=true' \
-H 'Content-Type: application/json' \
-d '{
	"query": {
		"bool": {
			"filter": {
				"term": {
					"cast.raw": {
						"value": "TOM hanks"
					}
				}
			}
		}

	}
}'