# JSONScan

A command line scanning client for Mac OS X 10.10 and higher.

The purpose of JSONScan is to make it easy for languages, other than objective-c or swift, to use ImageKit, without a cocoa bridge or native bindings. It allows you to communicate with a scanner using JSON through stdin/stdout. It is used in production for the Mac version of [FormReturn OMR Software](https://www.formreturn.com), which was written in Java.

## Compiled Executable

Available here: [https://github.com/rquast/jsonscan/blob/master/jsonscan.zip?raw=true](https://github.com/rquast/jsonscan/blob/master/jsonscan.zip?raw=true)

## Acknowledgements

JSONScan is a rewrite of [scanline](https://github.com/klep/scanline).

[OrderedDictionary](https://github.com/nicklockwood/OrderedDictionary) is used for the JSON output, to get around the abscence of ordered key-value list classes in Cocoa/ObjC.

## Contributing

Contributions are welcome. Please only submit contribution by forking the project and creating a pull request.

## Usage

JSONScan can be used from the command line or an application. It is ideal for use with classes such as Java's ProcessBuilder and Gson.

### Scanning using default settings without JSON

```
./jsonscan -s
```

### Querying Scanners & Settings

```
./jsonscan -l
```

Example output:

```
{"response": "found", "name": "Primera Trio"}
{"response": "status", "message": "All devices have been listed."}
{"response": "status", "message": "Scanner Ready: Primera Trio"}
{
  "response" : "settings",
  "name" : "Primera Trio",
  "read-only-settings" : {
    "can-use-black-white-threshold" : "true",
    "default-black-and-white-threshold" : "127",
    "can-perform-overview-scan" : "false",
    "native-x-resolution" : "300",
    "native-y-resolution" : "300",
    "supported-pixel-data-types" : {
      "0" : "Black and White",
      "1" : "Grayscale",
      "2" : "RGB",
      "3" : "Indexed",
      "4" : "CMY",
      "5" : "CMYK",
      "6" : "YUV",
      "7" : "YUVK",
      "8" : "CIEXYZ"
    },
    "supported-bit-depths" : {
      "1" : "1 Bit",
      "8" : "8 Bits"
    },
    "preferred-resolutions" : {
      "75" : "75 DPI",
      "100" : "100 DPI",
      "150" : "150 DPI",
      "200" : "200 DPI",
      "300" : "300 DPI",
      "600" : "600 DPI"
    },
    "preferred-scale-factors" : {
      "50" : "50%",
      "70" : "70%",
      "78" : "78%",
      "83" : "83%",
      "85" : "85%",
      "91" : "91%",
      "94" : "94%",
      "97" : "97%",
      "100" : "100%"
    },
    "supported-measurement-units" : {
      "0" : "Inches",
      "1" : "Centimeters",
      "5" : "Pixels"
    },
    "is-document-loaded" : "false",
    "document-size" : {
      "width" : "21",
      "height" : "29.7"
    },
    "physical-size" : {
      "width" : "21.59",
      "height" : "35.56"
    },
    "is-reverse-feeder-page-order" : "false",
    "supports-duplex-scanning" : "false",
    "supported-document-types" : {
      "1" : "A4",
      "3" : "US Letter",
      "4" : "US Legal",
      "13" : "A6",
      "62" : "4R"
    }
  },
  "read-write-settings" : {
    "use-back-white-threshold" : "false",
    "threshold-for-black-and-white-scanning" : "127",
    "bit-depth" : {
      "8" : "8 Bits"
    },
    "measurement-unit" : {
      "1" : "Centimeters"
    },
    "overview-resolution" : "300",
    "pixel-data-type" : {
      "2" : "RGB"
    },
    "scale-factor" : "100",
    "scan-area" : {
      "x" : "0",
      "y" : "0",
      "width" : "0",
      "height" : "0"
    },
    "scan-area-orientation" : {
      "1" : "Normal"
    },
    "is-duplex-scanning-enabled" : "false",
    "resolution" : "300",
    "document-type" : {
      "1" : "A4"
    },
    "even-page-orientation" : {
      "1" : "Normal"
    },
    "odd-page-orientation" : {
      "1" : "Normal"
    }
  }
}
```

### Performing a scan with custom settings

```
./jsonscan -c < settings.json
```

settings.json example:

```
{
    "device-name": "Primera Trio",
    "base-directory": "/tmp",
    "output-file-type": "png",
    "resolution": "300",
    "is-duplex-scanning-enabled": "false",
    "use-back-white-threshold": "false",
    "threshold-for-black-and-white-scanning": "128",
    "document-type": "A4",
    "pixel-data-type": "0"
}
```

## Roadmap

- Add support for page-load scan events (wait for the scanner to have a page loaded then perform scan).
- Add support for scan progress indication.

## License

MIT for all files except OrderedDictionary which is Zlib licensed.
