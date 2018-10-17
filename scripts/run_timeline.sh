#!/usr/bin/env bash

# Build timeline package (only need to do this first time)
mvn -f preprocessing/pom.xml clean package

# Clear last run's spark data (in case of interruption) and run timelime on pre-timeline data
function finish {
  rm -Rf spark-warehouse derby.log metastore_db preprocessing/spark-warehouse preprocessing/metastore_db preprocessing/derby.log
}
trap finish EXIT

# Remove the output data
rm -Rf cartpole_discrete_timeline

# Run timelime on pre-timeline data
/usr/local/spark/bin/spark-submit \
  --class com.facebook.spark.rl.Preprocessor preprocessing/target/rl-preprocessing-1.1.jar \
  "`cat ml/rl/workflow/sample_configs/discrete_action/timeline.json`"
