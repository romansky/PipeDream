var serialport = require("serialport");
var SerialPort = serialport.SerialPort; // localize object constructor

var serialPort = new SerialPort("/dev/ttyACM0", {
	parser: serialport.parsers.readline("\n"),
	baudrate: 9600,
	dataBits: 8,
	parity: 'none',
	stopBits: 1,
	flowControl: false
});

serialPort.on("data", function (data) {
	console.log(data.toString());

});

// setTimeout(function() { 
// 	serialPort.write("S");

// 	for (var i = 0; i < 60; ++i) {
// 		serialPort.write("0");
// 	}

// }, 3000);


setTimeout(function() { 
	serialPort.write("L");
	for (var i = 0; i < 36; ++i) {
		serialPort.write((i%5).toString());
	}

}, 3000);

// setTimeout(function() { 
// 	serialPort.write("S");

// 	for (var i = 0; i < 60; ++i) {
// 		serialPort.write("1");
// 	}

// }, 20000);
