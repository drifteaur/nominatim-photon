#!/bin/bash

# Create search index (supports both Elasticsearch and OpenSearch)
if [ ! -d "/photon/photon_data/elasticsearch" ] && [ ! -d "/photon/photon_data/opensearch" ] && [ ! -d "/photon/photon_data/node_1" ]; then
	echo "Creating search index with OpenSearch"
	java -jar photon.jar -nominatim-import -host nominatim -port 5432 -database nominatim -user nominatim -password terkepeszet -languages hu
fi

# Start photon if search index exists (Elasticsearch, OpenSearch, or node_1)
if [ -d "/photon/photon_data/elasticsearch" ] || [ -d "/photon/photon_data/opensearch" ] || [ -d "/photon/photon_data/node_1" ]; then
	echo "Starting photon"
	java -jar photon.jar -host nominatim -port 5432 -database nominatim -user nominatim -password terkepeszet

	### Start continuous update ###

	# while true; do
	# 	starttime=$(date +%s)
	#
	# 	curl http://localhost:2322/nominatim-update
	#
	# 	# sleep a bit if updates take less than 5 minutes
	# 	endtime=$(date +%s)
	# 	elapsed=$((endtime - starttime))
	# 	if [[ $elapsed -lt 300 ]]; then
	# 		sleepy=$((300 - $elapsed))
	# 		echo "Sleeping for ${sleepy}s..."
	# 		sleep $sleepy
	# 	fi
	# done

else
	echo "Could not start photon, the search index could not be found"
fi
