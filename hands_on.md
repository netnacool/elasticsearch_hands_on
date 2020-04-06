# Elasticsearch Hands-On

1. **Check node health**
```
curl -XGET 'http://localhost:9200/_cat/health?v'
```

2. **Create an index**
```
curl -XPUT 'http://localhost:9200/movies-v1' \
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
```

3. **-XGET index information**
```
curl -XGET 'http://localhost:9200/movies-v1'
```

4. **Index a document**
```
curl -XPUT 'http://localhost:9200/movies-v1/_doc/1?pretty=true' \
-H 'Content-Type: application/json' \
-d\ '{
	"name": "The Lord of the Rings: The Fellowship of the Ring",
	"description": "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.",
	"cast": ["Alan Howard", "Noel Appleby", "Sean Astin", "Sala Baker", "Sean Bean", "Cate Blanchett", "Orlando Bloom", "Billy Boyd"],
	"duration_minutes": 179,
	"genre": ["Action", "Adventure", "Drama"],
	"language": ["English"],
	"rating": 8.8,
	"release_data": "19-12-2001",
	"created_at": "04-04-2020 11:31:03",
	"updated_at": "04-04-2020 11:31:03"
}'
```

5. **Fetch a document**
```
curl -XGET 'http://localhost:9200/movies-v1/_doc/1'
```

6. **Create index template**
```
curl -XPUT 'http://localhost:9200/_template/movies_template_v1' \
-H 'Content-Type: application/json' \
-d '{
	"index_patterns" : ["movies-v*"],
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
	},
	"aliases": {
		"movies": {}
	}
}'
```

7. **Create new indices using template**
```
curl -XPUT 'http://localhost:9200/movies-v2'
curl -XPUT 'http://localhost:9200/movies-v3'
```

8. **Add alias to an index**
```
curl -XPUT 'http://localhost:9200/movies-v1/_alias/movies'
```

9. **Bulk index documents**
```
curl -XPOST 'http://localhost:9200/_bulk' \
-H 'Content-type: application/x-ndjson' \
-d '{ "delete" : { "_index" : "movies-v1", "_id" : "1" } }
{ "index" : { "_index" : "movies-v1", "_id" : "1" } }
{"name": "The Lord of the Rings: The Fellowship of the Ring", "description": "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.", "cast": ["Alan Howard", "Noel Appleby", "Sean Astin", "Sala Baker", "Sean Bean", "Cate Blanchett", "Orlando Bloom", "Billy Boyd"], "duration_minutes": 179, "genre": ["Action", "Adventure", "Drama"], "language": ["English"], "rating": 8.8, "release_data": "19-12-2001", "created_at": "04-04-2020 11:31:03", "updated_at": "04-04-2020 11:31:03"}
{ "index" : { "_index" : "movies-v1", "_id" : "2" } }
{"name": "The Shawshank Redemption", "description": "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", "cast": ["Tim Robbins", "Morgan Freeman", "Bob Gunton"], "duration_minutes": 142, "genre": ["Drama"], "language": ["English"], "rating": 9.3, "release_data": "17-02-1995", "created_at": "05-04-2020 13:31:03", "updated_at": "05-04-2020 13:31:03"}
{ "index" : { "_index" : "movies-v1", "_id" : "3" } }
{"name": "The Terminal", "description": "An Eastern European tourist unexpectedly finds himself stranded in JFK airport, and must take up temporary residence there.", "cast": ["Tom Hanks", "Catherine Zeta-Jones", "Chi McBride"], "duration_minutes": 128, "genre": ["Comedy", "Drama", "Romance"], "language": ["English"], "rating": 7.4, "release_data": "03-09-2004", "created_at": "05-04-2020 13:35:01", "updated_at": "05-04-2020 13:35:01"}
{ "index" : { "_index" : "movies-v1", "_id" : "4" } }
{"name": "The Dark Knight", "description": "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.", "cast": ["Christian Bale", "Heath Ledger", "Aaron Eckhart"], "duration_minutes": 152, "genre": ["Action", "Drama", "Crime"], "language": ["English"], "rating": 9.0, "release_data": "24-07-2008", "created_at": "05-04-2020 13:41:12", "updated_at": "05-04-2020 13:41:12"}
{ "index" : { "_index" : "movies-v3", "_id" : "5" } }
{"name": "Batman Begins", "description": "After training with his mentor, Batman begins his fight to free crime-ridden Gotham City from corruption.", "cast": ["Christian Bale", "Michael Caine", "Ken Watanabe"], "duration_minutes": 140, "genre": ["Action", "Adventure"], "language": ["English"], "rating": 8.2, "release_data": "16-06-2005", "created_at": "05-04-2020 13:43:02", "updated_at": "05-04-2020 13:43:02"}
{ "index" : { "_index" : "movies-v3", "_id" : "6" } }
{"name": "The Matrix", "description": "A com-XPUTer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", "cast": ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"], "duration_minutes": 136, "genre": ["Action", "Sci-Fi"], "language": ["English"], "rating": 8.7, "release_data": "11-06-1999", "created_at": "05-04-2020 13:48:02", "updated_at": "05-04-2020 13:48:02"}
{ "index" : { "_index" : "movies-v3", "_id" : "7" } }
{"name": "Batman v Superman: Dawn of Justice", "description": "Fearing that the actions of Superman are left unchecked, Batman takes on the Man of Steel, while the world wrestles with what kind of a hero it really needs.", "cast": [ "Ben Affleck", "Henry Cavill", "Amy Adams"], "duration_minutes": 151, "genre": ["Action", "Adventure", "Sci-Fi"], "language": ["English"], "rating": 6.5, "release_data": "25-03-2006", "created_at": "05-04-2020 17:42:03", "updated_at": "05-04-2020 17:42:03"}'
```

10. **Get all docs**
```
curl -XGET 'localhost:9200/movies/_search?size=10'
```

11. **Execute simple match query**
```
curl -XPOST 'localhost:9200/movies/_search' \
-H 'Content-Type: application/json' \
-d '{
    "query": {
        "match": {
            "description": {
                "query": "batman"
            }
        }
    }
}'
```

12. **Execute filter term query**
```
curl -XPOST 'localhost:9200/movies/_search' \
-H 'Content-Type: application/json' \
-d '{
	"query": {
		"bool": {
			"filter": {
				"term": {
					"cast.raw": {
						"value": "Tom hanks"
					}
				}
			}
		}

	}
}'
```

13. **Execute filter match query**
```
curl -XPOST 'localhost:9200/movies/_search' \
-H 'Content-Type: application/json' \
-d '{
	"query": {
		"bool": {
			"filter": {
				"match": {
					"description": {
						"query": "batman"
					}
				}
			}
		}

	}
}'
```

14. **Execute bool query**
```
curl -XPOST 'localhost:9200/movies/_search' \
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
```
15. **Simple nested aggregatinon query**
```
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
```

16. **Fetch all indices**
```
curl -XGET 'http://localhost:9200/_cat/indices'
```

17. **Fetch shard allocation**
```
curl -XGET 'http://localhost:9200/_cat/allocation?v'
```

18. **Update index settings**
```
curl -XPUT 'localhost:9200/movies-v*/_settings' \
-H 'Content-Type: application/json' \
-d '{
    "index" : {
        "number_of_replicas" : 1
    }
}'
``` 