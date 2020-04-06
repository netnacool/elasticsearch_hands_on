curl -XPUT 'http://localhost:9200/movies-v1?pretty=true' \
-H 'Content-Type: application/json' \
-d '{
	"settings": {
		"number_of_shards": 3,
		"number_of_replicas": 2,
		"analysis": {
			"normalizer": {
				"lowercase_keyword": {
					"type": "custom",
					"filter": ["lowercase"]
				}
			}
		}
	},
	"mappings": {
		"properties": {
			"name": {
				"type": "text",
				"fields": {
					"raw": {
						"type": "keyword",
						"normalizer": "lowercase_keyword"
					}
				}
			},
			"description": {
				"type": "text"
			},
			"genre": {
				"type": "keyword"
			},
			"language": {
				"type": "keyword"
			},
			"cast": {
				"type": "text",
				"fields": {
					"raw": {
						"type": "keyword",
						"normalizer": "lowercase_keyword"
					}
				}
			},
			"release_data": {
				"type": "date",
				"format": "dd-MM-yyyy"
			},
			"duration_minutes": {
				"type": "short"
			},
			"rating": {
				"type": "scaled_float",
				"scaling_factor": 100
			},
			"created_at": {
				"type": "date",
				"format": "dd-MM-yyyy HH:mm:ss"
			},
			"updated_at": {
				"type": "date",
				"format": "dd-MM-yyyy HH:mm:ss"
			}
		}
	}
}'