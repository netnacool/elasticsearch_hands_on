# Elasticsearch Hands On

This guide is made up of 3 parts :
1.	An elasticsearch setup guide (`setup_es.md`) which is a pre-requesite to be followed before starting the actual handson. You can skip the download and extract steps if they are already completed.
2.	A hands on guide (`hands_on.md`) which should be followed in the order that it is given. Each step is identified by a number, and contains a description to explain what's going on. It also contains a curl command which is the REST call that corresponds to that step. You can import this curl command to a tool of your choice to execute it, or you can directly execute the curl script in the `curl_commands` folder.
3.	`curl_commands` folder which contains the curl scripts you can directly execute on your terminal. Each file starts with the identifying number of it's corresponding step. The REST calls return a pretty json so understanding the json output in the terminal won't be an issue. You can execute in this way - 
	1.	Linux/macOS
		```
		./file.sh
		```
		or
		```
		sh file.sh
		```
	2.	Windows
		```
		bash file.sh
		```