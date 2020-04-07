# Hands-On Steps

**Pre-requesite : Complete setup.md**

1.	**Check health of cluster.**
_`number_of_nodes` should be 2 and `status` green
See [Cluster health](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html)_
```
curl -XGET 'http://localhost:9200/_cluster/health'
```

2.	**Create a new index.**
_We provide the mappings and some settings for the index. The `mappings` define the schema of the index. See [Create index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html), [Mapping Types](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html). In `settings`, the shard and replica count has been overriden (Default value is 1 for both in v7.6.2 - See [Index Settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html#index-modules-settings)). 
`keyword` fields are not analyzed by default and have to match exactly, whereas `text` fields are analyzed by the standard analyzer. See 
[Built in analyzers](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html),
[Analyzers Anatomy](https://www.elastic.co/guide/en/elasticsearch/reference/current/analyzer-anatomy.html)
For `name` and `cast` properties we have defined two data types. One is a `text` field for in-exact matches. The second one is `keyword` field for exact matches. But we have also added a custom lowercase analyzer to the `keyword` fields so that our queries are case insensitive. The normalizer is applied prior to indexing the keyword, as well as at search-time when the keyword field is searched. See
[Normalizers](https://www.elastic.co/guide/en/elasticsearch/reference/current/normalizer.html), 
[Multi fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)_
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

3.	<a name="get_index"></a>**Get the information about the index you just created**
_This basically returns the information about the index
See [Get index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html)_
```
curl -XGET 'http://localhost:9200/movies-v1'
```

4.	**Index a document**
_Note that a field can also store an array of the data type. So `cast` field can have a single string or an array of strings. Also we are passing the id for the doc. If id is not passed, an id is auto generated.
See [Index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html)_
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

5.	**Fetch the document we just created**
_We pass the id of the document to fetch it. See [Get API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html)_
```
curl -XGET 'http://localhost:9200/movies-v1/_doc/1'
```

6.	**Add alias to an index**
_An alias can be mapped to multiple indices. We can query multiple indices by using a single alias. This can also help in migrating an old index to a new one, as we can just map the alias to a new index instead of changing references in our application code. Here we are mapping the `movies` alias to `movies-v1` index
See [Add alias](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-add-alias.html)_
```
curl -XPUT 'http://localhost:9200/movies-v1/_alias/movies'
```

7.	<a name="create_template"></a>**Create an index template**
_Indices can be auto configured on creation using templates. 
If the index name matches the patterns defined in `index_patterns` , it will follow the defined template.
We just copied the configuration of the index we created previously and used it to create a template. The only difference is that we have also configured the `movies` alias to be mapped by default in the`aliases`field
See [Create template](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html)_
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

8.	**Create new indices that follow the template**
_Now if we create new indices that follow the movies-* pattern, we do not need to pass any configurations. They are created automatically. Once created, you can check the index details using [step 3](#get_index)_
```
curl -XPUT 'http://localhost:9200/movies-v2'
curl -XPUT 'http://localhost:9200/movies-v3'
```

9.	**Bulk index documents**
_The actions are specified in the request body using a newline delimited JSON `application/x-ndjson`. The operations which have data associated with them like index, create, update would expect data in the next line. Operations like delete only need a single line.
See [Bulk Index](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)_
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

10.	**Get all docs from an index**
_This is just a normal search request with no query defined, which means all documents are fetched. The size parameter defines the maximum number of documents that should be fetched. When the document count is large, [Scroll API](https://www.elastic.co/guide/en/elasticsearch/reference/7.6/search-request-body.html#request-body-search-scroll) is prefered instead of fetching everything in one request.
See -
[Search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html)_
```
curl -XGET 'localhost:9200/movies/_search?size=10'
```

11.	**A simple match query**
_This type of query is used for full text searches and fuzzy matching. This one would fetch all documents which have the word batman in description. 
The `description` field is `text` , so it is processed by the [standard analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html) by default if not overriden. In this case the standard anaylzer treats all words as seperate tokens and then converts them to lowercase.
The standard analyzer is also applied on the input text when doing a match query. The doc is a match if any of the query tokens match the indexed tokens. The higher the number of matching tokens, the better the score. Also note that we are using the `movies` alias to search on all three indices.
See -
[Match query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-match-query.html), 
[Text datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/text.html), 
[Built in analyzers](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-analyzers.html), 
[How scoring works](https://www.compose.com/articles/how-scoring-works-in-elasticsearch/)_
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

12.	**A filter term query**
_Filter queries do not contribute to the score of a document. We use this when scoring does not matter to us. This saves unnecessary processing. 
See [Query and filter context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html). 
A term query is kind of the opposite of a match query. The provided text should match the source exactly for there to be a match. And the query text is not analyzed like in match query. Recall that we had configured a custom lowercase `analyzer` for `cast` field, so this search is case insensitive. Without it we would had to pass the exact text (i.e Tom Hanks) to get a match.
Also, `term` queries are normally only used with keyword fields and not with text fields. If term queries are used with text fields, there would hardly ever be a match, as the indexed field would be analyzed before indexing, but the input text would not be analyzed.
See [Term query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-term-query.html)_
```
curl -XPOST 'localhost:9200/movies/_search' \
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
```

13.	**A filter match query**
_Here we are using a match query but the score returned would be zero, as it is inside a filter context. This is useful if the score does not matter to us but we do not want to do an exact match._
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

14.	**Boolean query**
_This query is made up of multiple parts. 
Everything inside the `must` clause contributes to the score. It has a `term` query, so there should be an exact match of `language=English` for the doc to be returned.
Everything inside the `filter` clause will not contribute to the score but other than that, it is same as a `must` clause. We are doing a search for the word `batman` inside the `description` field, and an exact match for `genre=Action`. 
The `must_not` clause is just the opposite of `must` clause. We are using a range query inside it. See [Range Query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html)
The `should` clause only affects the score but does not decide whether a doc is returned or not.
Notice that the movie with batman in it's name gets a better score and the second batman movie get's filtered out because of release date.
See 
[Bool query](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)_
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
15.	**Simple nested aggregatinon query**
_This query first buckets the docs on the basis of `genre` using a `term` aggregation and then calculates the average `rating` of each bucket. See -
[Nested aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-nested-aggregation.html), 
[Terms aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html), 
[Avg aggregation](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-metrics-avg-aggregation.html)_
```
curl -XPOST 'http://localhost:9200/movies/_search' \
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

16.	<a name="get_all_indices"></a>**See a list of all indices**
_You would notice that the indices are yellow. An index is yellow if some of it's replica shards are not allocated. Check next step for more details.
See [Get indices](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-indices.html)_
```
curl -XGET 'http://localhost:9200/_cat/indices?v'
```

17.	<a name="shard_allocation"></a>**Fetch shard allocation**
_Here we fetch the shard allocation details to see why the node is yellow. You can see that the shards are distributed equally across the two nodes, and 3 of the replicas are unassigned.
This is because we defined 2 replicas per shard in our index settings, which will require 3 nodes minimum. This is because
 a) A replica shard cannot exist in the same node which has the primary shard.
 b) ES distribution shards evenly among the nodes. So one node cannot have all the leftover replicas.
 But we have only 2 nodes, so the indices are yellow as some replicas are unassigned.
See [Shard info](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-shards.html)_
```
curl -XGET 'http://localhost:9200/_cat/shards?v&h=index,shard,prirep,id'
```

18.	**Update index settings**
_If we reduce the number of replicas to 1, the status of indices would become green. We use the pattern movies-v* to update all indices at once Note that we have not updated the index template, so any new index will still have the old setting. Templates cannot be partially updated, we use the same API we used for creation i.e [step 7](#create_template)
Once executed check the shard allocation using [step 17](#shard_allocation) and indices status using [step 16](#get_all_indices).
Also See [Update index](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-update-settings.html)_
```
curl -XPUT 'localhost:9200/movies-v*/_settings' \
-H 'Content-Type: application/json' \
-d '{
    "index" : {
        "number_of_replicas" : 1
    }
}'
``` 