import os

c = get_config()
c.JupyterHub.load_roles = [  # noqa: F821
    {
        "name": "test-admin",
        "scopes": ["admin:users", "admin:servers", "access:servers"],
        "services": ["test"],
    }
]

c.JupyterHub.services = [  # noqa: F821
    {
        "name": "test",
        "api_token": "test-token-123",
    }
]
# We rely on environment variables to configure JupyterHub so that we
# avoid having to rebuild the JupyterHub container every time we change a
# configuration paramete
# Spawn single-user servers as Docker containers
#c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
c.JupyterHub.spawner_class = 'sudospawner.SudoSpawner'
#c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
c.SudoSpawner.mem_limit = '2G'
c.Spawner.cpu_limit = 1.0

c.Spawner.environment.update(
    {
        "SPARK_HOME": "/opt/spark",
        "SPARK_CONF_DIR": "/etc/spark/conf",
        "LD_LIBRARY_PATH": "/opt/hadoop/lib/native:/opt/oracle/instantclient_21_12",
        "HADOOP_HOME": "/opt/hadoop",
        "HADOOP_CONF_DIR": "/etc/hadoop/conf",
        "HADOOP_LOG_DIR": "/mnt/log",
        "HADOOP_OPTIONAL_TOOLS": "hadoop-aws",
        "HIVE_HOME": "/opt/hive",
        "HIVE_CONF_DIR": "/etc/hive/conf",
        "HADOOP_OPTS": "-Dderby.system.home=/tmp/derby",
        "HBASE_HOME": "/opt/hbase",
        "HBASE_CONF_DIR": "/etc/hbase/conf",
        "HBASE_SECURITY_LOGGER": "INFO,console",
        "HBASE_ZNODE_FILE": "/mnt/hbase.znode",
        "TEZ_JARS": "/opt/tez",
        "TEZ_CONF_DIR": "/etc/tez/conf",
        "HTTPFS_TEMP": "/mnt/tmp",
        "HADOOP_LOG_DIR": "/mnt/log",
        "HTTPFS_LOG": "/mnt/log",
        "HTTPFS_SILENT": "false",
        "HTTPFS_CONFIG": "/etc/hadoop/conf",
        "CATALINA_BASE": "/mnt/catalina",
        "ZOOCFGDIR":"/etc/zookeeper/conf",
        "ZOO_LOG_DIR":"/mnt/log",
        "HADOOP_USER_NAME":"hdfs",
        "SPARK_DIST_CLASSPATH":"/etc/hadoop/conf:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.563.jar:/opt/hadoop/share/hadoop/tools/lib/hadoop-aws-3.2.2.jar:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*:/etc/tez/conf:/opt/tez/LICENSE:/opt/tez/LICENSE-BSD-3clause:/opt/tez/LICENSE-CDDLv1.0:/opt/tez/LICENSE-CDDLv1.1-GPLv2_withCPE:/opt/tez/LICENSE-MIT:/opt/tez/LICENSE-SIL_OpenFontLicense-v1.1:/opt/tez/NOTICE:/opt/tez/hadoop-shim-0.10.2.jar:/opt/tez/hadoop-shim-2.8-0.10.2.jar:/opt/tez/lib:/opt/tez/share:/opt/tez/tez-api-0.10.2.jar:/opt/tez/tez-build-tools-0.10.2.jar:/opt/tez/tez-common-0.10.2.jar:/opt/tez/tez-dag-0.10.2.jar:/opt/tez/tez-examples-0.10.2.jar:/opt/tez/tez-history-parser-0.10.2.jar:/opt/tez/tez-javadoc-tools-0.10.2.jar:/opt/tez/tez-job-analyzer-0.10.2.jar:/opt/tez/tez-mapreduce-0.10.2.jar:/opt/tez/tez-protobuf-history-plugin-0.10.2.jar:/opt/tez/tez-runtime-internals-0.10.2.jar:/opt/tez/tez-runtime-library-0.10.2.jar:/opt/tez/tez-tests-0.10.2.jar:/opt/tez/tez-tfile-parser-0.10.2.jar:/opt/tez/tez-yarn-timeline-cache-plugin-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-with-acls-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-with-fs-0.10.2.jar:/opt/tez/lib/RoaringBitmap-0.7.45.jar:/opt/tez/lib/async-http-client-2.12.3.jar:/opt/tez/lib/commons-cli-1.2.jar:/opt/tez/lib/commons-codec-1.11.jar:/opt/tez/lib/commons-collections4-4.1.jar:/opt/tez/lib/commons-io-2.8.0.jar:/opt/tez/lib/commons-lang-2.6.jar:/opt/tez/lib/guava-31.1-jre.jar:/opt/tez/lib/hadoop-hdfs-client-3.3.1.jar:/opt/tez/lib/hadoop-yarn-server-timeline-pluginstorage-3.3.1.jar:/opt/tez/lib/javax.servlet-api-3.1.0.jar:/opt/tez/lib/jersey-client-1.19.jar:/opt/tez/lib/jersey-json-1.19.jar:/opt/tez/lib/jettison-1.3.4.jar:/opt/tez/lib/jsr305-3.0.0.jar:/opt/tez/lib/metrics-core-3.1.0.jar:/opt/tez/lib/netty-all-4.1.72.Final.jar:/opt/tez/lib/pig-0.13.0.jar:/opt/tez/lib/protobuf-java-2.5.0.jar",
        "JAVA_HOME":"/usr/local/openjdk-8/",
        "PATH":"/opt/oracle/instantclient_21_12:/opt/mssql-tools/bin:/opt/mssql-tools18/bin:trino-cli/bin:/opt/hbase/bin:/opt/hive/bin:/bin:/opt/spark/bin:/opt/hadoop/bin:/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "SAMPLE_ENV": "TEST"
    }
)

# c.Spawner.env_keep = ["PATH"]
c.Spawner.environment =     {
        "SPARK_HOME": "/opt/spark",
        "SPARK_CONF_DIR": "/etc/spark/conf",
        "LD_LIBRARY_PATH": "/opt/hadoop/lib/native:/opt/oracle/instantclient_21_12",
        "HADOOP_HOME": "/opt/hadoop",
        "HADOOP_CONF_DIR": "/etc/hadoop/conf",
        "HADOOP_LOG_DIR": "/mnt/log",
        "HADOOP_OPTIONAL_TOOLS": "hadoop-aws",
        "HIVE_HOME": "/opt/hive",
        "HIVE_CONF_DIR": "/etc/hive/conf",
        "HADOOP_OPTS": "-Dderby.system.home=/tmp/derby",
        "HBASE_HOME": "/opt/hbase",
        "HBASE_CONF_DIR": "/etc/hbase/conf",
        "HBASE_SECURITY_LOGGER": "INFO,console",
        "HBASE_ZNODE_FILE": "/mnt/hbase.znode",
        "TEZ_JARS": "/opt/tez",
        "TEZ_CONF_DIR": "/etc/tez/conf",
        "HTTPFS_TEMP": "/mnt/tmp",
        "HADOOP_LOG_DIR": "/mnt/log",
        "HTTPFS_LOG": "/mnt/log",
        "HTTPFS_SILENT": "false",
        "HTTPFS_CONFIG": "/etc/hadoop/conf",
        "CATALINA_BASE": "/mnt/catalina",
        "ZOOCFGDIR":"/etc/zookeeper/conf",
        "ZOO_LOG_DIR":"/mnt/log",
        "HADOOP_USER_NAME":"hdfs",
        "SPARK_DIST_CLASSPATH":"/etc/hadoop/conf:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.563.jar:/opt/hadoop/share/hadoop/tools/lib/hadoop-aws-3.2.2.jar:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*:/etc/tez/conf:/opt/tez/LICENSE:/opt/tez/LICENSE-BSD-3clause:/opt/tez/LICENSE-CDDLv1.0:/opt/tez/LICENSE-CDDLv1.1-GPLv2_withCPE:/opt/tez/LICENSE-MIT:/opt/tez/LICENSE-SIL_OpenFontLicense-v1.1:/opt/tez/NOTICE:/opt/tez/hadoop-shim-0.10.2.jar:/opt/tez/hadoop-shim-2.8-0.10.2.jar:/opt/tez/lib:/opt/tez/share:/opt/tez/tez-api-0.10.2.jar:/opt/tez/tez-build-tools-0.10.2.jar:/opt/tez/tez-common-0.10.2.jar:/opt/tez/tez-dag-0.10.2.jar:/opt/tez/tez-examples-0.10.2.jar:/opt/tez/tez-history-parser-0.10.2.jar:/opt/tez/tez-javadoc-tools-0.10.2.jar:/opt/tez/tez-job-analyzer-0.10.2.jar:/opt/tez/tez-mapreduce-0.10.2.jar:/opt/tez/tez-protobuf-history-plugin-0.10.2.jar:/opt/tez/tez-runtime-internals-0.10.2.jar:/opt/tez/tez-runtime-library-0.10.2.jar:/opt/tez/tez-tests-0.10.2.jar:/opt/tez/tez-tfile-parser-0.10.2.jar:/opt/tez/tez-yarn-timeline-cache-plugin-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-with-acls-0.10.2.jar:/opt/tez/tez-yarn-timeline-history-with-fs-0.10.2.jar:/opt/tez/lib/RoaringBitmap-0.7.45.jar:/opt/tez/lib/async-http-client-2.12.3.jar:/opt/tez/lib/commons-cli-1.2.jar:/opt/tez/lib/commons-codec-1.11.jar:/opt/tez/lib/commons-collections4-4.1.jar:/opt/tez/lib/commons-io-2.8.0.jar:/opt/tez/lib/commons-lang-2.6.jar:/opt/tez/lib/guava-31.1-jre.jar:/opt/tez/lib/hadoop-hdfs-client-3.3.1.jar:/opt/tez/lib/hadoop-yarn-server-timeline-pluginstorage-3.3.1.jar:/opt/tez/lib/javax.servlet-api-3.1.0.jar:/opt/tez/lib/jersey-client-1.19.jar:/opt/tez/lib/jersey-json-1.19.jar:/opt/tez/lib/jettison-1.3.4.jar:/opt/tez/lib/jsr305-3.0.0.jar:/opt/tez/lib/metrics-core-3.1.0.jar:/opt/tez/lib/netty-all-4.1.72.Final.jar:/opt/tez/lib/pig-0.13.0.jar:/opt/tez/lib/protobuf-java-2.5.0.jar",
        "JAVA_HOME":"/usr/local/openjdk-8/",
        "PATH":"/opt/oracle/instantclient_21_12:/opt/mssql-tools/bin:/opt/mssql-tools18/bin:trino-cli/bin:/opt/hbase/bin:/opt/hive/bin:/bin:/opt/spark/bin:/opt/hadoop/bin:/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "SAMPLE_ENV": "TEST"
}


# User containers will access hub by container name on the Docker network
c.JupyterHub.hub_ip = "127.0.0.1"
c.JupyterHub.hub_port = 8080

# Persist hub data on volume mounted inside container
c.JupyterHub.cookie_secret_file = "/data/jupyterhub_cookie_secret"
c.JupyterHub.db_url = "sqlite:////data/jupyterhub.sqlite"
c.LocalAuthenticator.add_user_cmd = [
    'adduser',
    '-q',
    '--gecos',
    '""',
    '--home',
    '/customhome/USERNAME',
    '--disabled-password'
]
#c.SystemdSpawner.default_shell = '/bin/bash'
c.LocalProcessSpawner.shell_cmd = ['bash', '-l', '-c']
#c.LocalAuthenticator.create_system_users = True
# Authenticate users with Native Authenticator
c.JupyterHub.authenticator_class = "nativeauthenticator.NativeAuthenticator"
# shutdown the server after no activity for an hour
c.ServerApp.shutdown_no_activity_timeout = 60 * 60
# shutdown kernels after no activity for 20 minutes
c.MappingKernelManager.cull_idle_timeout = 20 * 60
# check for idle kernels every two minutes
c.MappingKernelManager.cull_interval = 2 * 60

# Allow anyone to sign-up without approval
c.NativeAuthenticator.open_signup = True
# Allowed admins
admin = os.environ.get("JUPYTERHUB_ADMIN")
if admin:
    c.Authenticator.admin_users = [admin]