<?php

require_once __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPStreamConnection;
use PhpAmqpLib\Message\AMQPMessage;

$connection = new AMQPStreamConnection('rabbitmq-cluster-lb-155322444.us-west-2.elb.amazonaws.com', 5672, 'admin', '6yhn7ujm8ik,');
$channel = $connection->channel();

$channel->queue_declare('task_queue', false, true, false, false);

$data = implode(' ', array_slice($argv, 1));
if (empty($data)) {
    $data = "Hello World!";
}
$msg = new AMQPMessage(
    $data,
    array('delivery_mode' => AMQPMessage::DELIVERY_MODE_PERSISTENT)
);

$channel->basic_publish($msg, '', 'task_queue');

echo ' [x] Sent ', $data, "\n";

$channel->close();
$connection->close();
