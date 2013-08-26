SerialPort Server
=================
SerialPort Server makes your Device (Arduino, mbed...) WebServer. You can access SerialPort via HTTP, WebSocket and TCP Socket.

- http://shokai.github.io/serialport-server


Requirements
------------
- USB Device (Arduino, mbed ...)


Install
-------

    % gem install serialport-server


Usage
-----

    % serialport-server --help
    % serialport-server /dev/tty.usb-device -http_port 8783 -websocket_prot 8784 -socket_port 8785
