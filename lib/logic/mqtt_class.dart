import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  static final MQTTService _instance = MQTTService._internal();
  late MqttServerClient client;
  bool isConnected = false;
  final StreamController<Map<String, dynamic>> _messageStreamController =
  StreamController<Map<String, dynamic>>.broadcast();
  // Singleton accessor
  static MQTTService get instance => _instance;

  MQTTService._internal();

  // Initialize and connect to the MQTT server
  Future<void> initialize({
    required String server,
    required int port,
    required String clientId,
    required String username,
    required String password,
  }) async {
    client = MqttServerClient.withPort(server, clientId, port)
      ..secure = true
      ..setProtocolV311()
      ..logging(on: true)
      ..keepAlivePeriod = 30
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected;

    // Load and set the security context
    final clientAuthorities = await rootBundle.load('assets/images/mosquitto.pem.crt');
    final context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(clientAuthorities.buffer.asUint8List());

    client.securityContext = context;

    client.connectionMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean()
        .withWillTopic('test/test')
        .withWillMessage('lamhx message test')
        .withWillQos(mqtt.MqttQos.exactlyOnce);

    print('MQTT client connecting...');
    try {
      await client.connect(username, password);
      if (client.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
        print('MQTT client connected');
        isConnected = true;
      } else {
        print('ERROR: MQTT client connection failed - disconnecting, state is ${client.connectionStatus?.state}');
        disconnect();
      }
    } on Exception catch (e) {
      print('Connection exception: $e');
      disconnect();
    }
    client.updates?.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>? messages) {
      if (messages != null) {
        final message = messages.first.payload as mqtt.MqttPublishMessage;
        final payload = mqtt.MqttPublishPayload.bytesToStringAsString(message.payload.message);

        // Parse the payload and forward it to the stream
        final parsedData = jsonDecode(payload); // Assuming payload is JSON
        _messageStreamController.add(parsedData);
      }
    });
  }

  // Disconnect the client
  void disconnect() {
    client.disconnect();
    isConnected = false;
    print('Disconnected from MQTT server');
  }

  // Subscription to a topic
  void subscribe(String topic) {
    if (isConnected) {
      client.subscribe(topic, mqtt.MqttQos.atMostOnce);
      print('Subscribed to $topic');
    }
  }

  // Publishing a message to a topic
  void publish(String topic, String message) {
    if (isConnected) {
      final builder = mqtt.MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, mqtt.MqttQos.atLeastOnce, builder.payload!);
      print('Message published to $topic');
    }
  }

  // Handling disconnection event
  void _onDisconnected() {
    isConnected = false;
    print('MQTT client disconnected');
  }

  // Handling successful connection event
  void _onConnected() {
    isConnected = true;
    print('MQTT client connected');
  }

  // Listen for incoming messages
  // Stream<List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>>? get messages => client.updates;

  Stream<Map<String, dynamic>> get messageStream => _messageStreamController.stream;


  // Dispose resources (optional for cleanup)
  void dispose() {
    disconnect();
    _messageStreamController.close(); // Close the stream controller when done
  }
}
