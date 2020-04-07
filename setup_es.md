# Setup elasticsearch (Reference - [Run Elasticsearch locally](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-install.html#run-elasticsearch-local))
1.	**Download and Extract Elasticsearch**
	1.	Linux
	```
	cd <installation_path>
	curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-linux-x86_64.tar.gz
	tar -xvf elasticsearch-7.6.2-linux-x86_64.tar.gz
	```
	2.	macOS
	```
	cd <installation_path>
	curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-darwin-x86_64.tar.gz
	tar -xvf elasticsearch-7.6.2-darwin-x86_64.tar.gz
	```
	3.	Windows: 
	Download - [elasticsearch-7.6.2-windows-x86_64.zip](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.2-windows-x86_64.zip) then
	go to download path and
	```
	Expand-Archive elasticsearch-7.6.2-windows-x86_64.zip
	```
2. **Run elasticsearch**
	1.	Linux/macOs
	```
	cd elasticsearch-7.6.2/bin
	./elasticsearch
	```
	2.	Windows
	```
	cd elasticsearch-7.6.2\bin
	.\elasticsearch.bat
	```
3.	**Verify if working**
```
curl "http://localhost:9200"
```
Check if *version.number* in response is *7.6.2*

4. **Start another data node**

_By default, Elasticsearch is configured to prevent more than one node from sharing the same data path. Hence we have explicitely given a new path._
**Please make sure you have exactly two instances running in the end, this is essential for some hands-on steps**
	1.	Linux/macOS
	```
	cd elasticsearch-7.6.2
	./bin/elasticsearch -Epath.data=data2 -Epath.logs=log2
	```
	2.	Windows
	```
	cd elasticsearch-7.6.2
	.\elasticsearch.bat -E path.data=data2 -E path.logs=log2
	```