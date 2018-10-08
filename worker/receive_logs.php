<?php

require_once __DIR__ . '/vendor/autoload.php';
use PhpAmqpLib\Connection\AMQPStreamConnection;

$connection = new AMQPStreamConnection('rabbitmq-cluster-lb-155322444.us-west-2.elb.amazonaws.com', 5672, 'admin', '6yhn7ujm8ik,');
$channel = $connection->channel();

$channel->exchange_declare('logs', 'fanout', false, false, false);

list($queue_name, ,) = $channel->queue_declare("", false, false, true, false);

$channel->queue_bind($queue_name, 'logs');

echo " [*] Waiting for logs. To exit press CTRL+C\n";

$callback = function ($msg) {
    echo ' [x] ', $msg->body, "\n";
};

$channel->basic_consume($queue_name, '', false, true, false, false, $callback);

while (count($channel->callbacks)) {
    $channel->wait();
}

$channel->close();
$connection->close();
