from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("SparkByExamples.com") \
    .config("spark.sql.warehouse.dir", "/warehouse/tablespace/managed/hive") \
    .config("hive.metastore.uris", "thrift://hive-metastore:9083") \
    .enableHiveSupport() \
    .getOrCreate()
    
spark.sql("show databases").show()

# Print Spark configurations
for config_key, config_value in spark.sparkContext.getConf().getAll():
    print(f"{config_key}: {config_value}")

spark.stop()

export HIVE_METASTORE_URIS=thrift://hive-metastore:9083
