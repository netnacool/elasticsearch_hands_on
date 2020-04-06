# Setup elasticsearch ([refer](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-install.html#run-elasticsearch-local))
1. **Download and Extract Elasticsearch**
	1. Linux
	```
	cd <installation_path>
	curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-linux-x86_64.tar.gz
	tar -xvf elasticsearch-7.6.2-linux-x86_64.tar.gz
	```
	2. macOS
	```
	cd <installation_path>
	curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-darwin-x86_64.tar.gz
	tar -xvf elasticsearch-7.6.2-darwin-x86_64.tar.gz
	```
2. **Run elasticsearch**
```
	cd <installation_path>
	./bin/elasticsearch 
```
3. **Verify if working**
`curl GET "http://localhost:9200"`
Check if *version.number* in response is *7.6.2*

4. **Start one more data node**
```
cd <installation_path>
./bin/elasticsearch -Epath.data=data2 -Epath.logs=log2
```
