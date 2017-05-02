#!/bin/bash -e

ZOOKEEPER=zookeeper:2181
KAFKA_HOME=/app/kafka

create_cache_topic ()
{
  $KAFKA_HOME/bin/kafka-topics.sh --delete --if-exists --zookeeper $ZOOKEEPER --topic $1
  $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER --replication-factor 1 --partitions $2 --topic $1

  $KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZOOKEEPER --entity-type topics --entity-name $1 --alter --add-config min.cleanable.dirty.ratio=0.01
  $KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZOOKEEPER --entity-type topics --entity-name $1 --alter --add-config cleanup.policy=compact
  $KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZOOKEEPER --entity-type topics --entity-name $1 --alter --add-config segment.ms=100
  $KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZOOKEEPER --entity-type topics --entity-name $1 --alter --add-config delete.retention.ms=100
}

create_data_topic ()
{
  $KAFKA_HOME/bin/kafka-topics.sh --delete --if-exists --zookeeper $ZOOKEEPER --topic $1
  $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $ZOOKEEPER --replication-factor 1 --partitions $2 --topic $1
  $KAFKA_HOME/bin/kafka-configs.sh --zookeeper $ZOOKEEPER --entity-type topics --entity-name $1 --alter --add-config retention.ms=1800000
}

echo "----------------------------"
echo "- Creating cache topics"
echo "----------------------------"
echo
create_cache_topic ___v1___cache___thingtype 4
create_cache_topic ___v1___cache___things 4
create_cache_topic ___v1___cache___zone 4
create_cache_topic ___v1___cache___zonetype 4
#create_cache_topic ___v1___cache___localmap 10
#create_cache_topic ___v1___cache___zoneproperty 10
create_cache_topic ___v1___cache___group 4
create_cache_topic ___v1___cache___grouptype 4
create_cache_topic ___v1___cache___shift 4
create_cache_topic ___v1___cache___shiftzone 4
create_cache_topic ___v1___cache___logicalreader 4
create_cache_topic ___v1___cache___edgebox 4
create_cache_topic ___v1___cache___edgeboxconfiguration 4
create_cache_topic ___v1___cache___edgeboxrule 4
create_cache_topic ___v1___cache___connection 4

echo "----------------------------"
echo "- Creating data topics"
echo "----------------------------"
echo
create_data_topic ___v1___data1 32 # Edge Boxes(output) and Joiner(input).
create_data_topic ___v1___data2___mojix 32 # Joiner(output) and Kafka Core Bridge(input).
create_data_topic ___v1___data3 32 # Kafka Core Bridge(output) Mongo Dao(input).

# List all topics.
$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper $ZOOKEEPER
