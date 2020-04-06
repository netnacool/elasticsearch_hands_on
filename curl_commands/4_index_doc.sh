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