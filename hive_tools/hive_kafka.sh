export localhost=`ifconfig en0 | grep inet -w | awk '{print $2}'`
export KAFKA_DIR="/Users/vgarg/Downloads/kafka_2.11-2.0.0"

alias startKafkaBroker='docker run -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=$localhost --env ADVERTISED_PORT=9092 spotify/kafka'

create_kafka_topic() {
  $KAFKA_DIR/bin/kafka-topics.sh --create --zookeeper $localhost:2181 --replication-factor 1 --partitions 1 --topic $1
}

consume_kafka_topic() {
  $KAFKA_DIR/bin/kafka-console-consumer.sh --bootstrap-server $localhost:9092 --topic $1 --from-beginning
}

sendMessages() {
  $KAFKA_DIR/bin/kafka-console-producer.sh --broker-list $localhost:9092 --topic $1 
}
