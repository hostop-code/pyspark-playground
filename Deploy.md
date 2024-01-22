For docker swarm :

docker stack deploy -c docker-compose-hadoop.yml big_data
docker stack deploy -c docker-compose-hive.yml big_data
docker stack deploy -c docker-compose-spark.yml big_data
docker stack deploy -c docker-compose-trino.yml big_data
docker stack deploy -c docker-compose-jupyterhub.yml big_data