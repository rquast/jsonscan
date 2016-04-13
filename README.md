# JSONScan

A command line scanning client for Mac OS X 10.10 and higher.

The purpose of JSONScan is to make it easy for languages, other than objective-c or swift, to use ImageKit, without a cocoa bridge or native bindings. It allows you to communicate with a scanner using JSON through stdin/stdout.

## Acknowledgements

JSONScan is a fork of [scanline](https://github.com/klep/scanline).

[OrderedDictionary](https://github.com/nicklockwood/OrderedDictionary) is used for the JSON output, to get around the abscence of ordered key-value list classes in Cocoa/ObjC.

## Usage

Listing Scanners & Settings:

```
./jsonscan
```

An example output from listing the scanners:

```
{"repsonse": "found", "name": "EPSON GT-S50"}
{"repsonse": "status", "message": "All devices have been listed."}
{"repsonse": "status", "message": "Scanner Ready: EPSON GT-S50"}
{
  "response" : "settings",
  "read-only-settings" : {
    "can-use-black-white-threshold" : "true",
    "use-back-white-threshold" : "false",
    "default-black-and-white-threshold" : "128",
    "can-perform-overview-scan" : "false",
    "native-x-resolution" : "600",
    "native-y-resolution" : "600",
    "supported-bit-depths" : {
      "1" : "1 Bit",
      "8" : "8 Bits"
    },
    "preferred-resolutions" : {
      "50" : "50 DPI",
      "72" : "72 DPI",
      "96" : "96 DPI",
      "150" : "150 DPI",
      "200" : "200 DPI",
      "240" : "240 DPI",
      "266" : "266 DPI",
      "300" : "300 DPI",
      "350" : "350 DPI",
      "360" : "360 DPI",
      "400" : "400 DPI",
      "600" : "600 DPI",
      "720" : "720 DPI",
      "800" : "800 DPI",
      "1200" : "1200 DPI",
      "1600" : "1600 DPI",
      "2400" : "2400 DPI",
      "3200" : "3200 DPI",
      "4800" : "4800 DPI",
      "6400" : "6400 DPI"
    },
    "preferred-scale-factors" : {
      "100" : "100%"
    },
    "supported-measurement-units" : {
      "0" : "Inches",
      "1" : "Centimeters",
      "5" : "Pixels"
    },
    "is-document-loaded" : "true",
    "document-size" : {
      "width" : "21",
      "height" : "29.7"
    },
    "physical-size" : {
      "width" : "21.59",
      "height" : "35.56"
    },
    "is-reverse-feeder-page-order" : "false",
    "supports-duplex-scanning" : "true",
    "supported-document-types" : {
      "1" : "A4",
      "2" : "B5",
      "3" : "US Letter",
      "4" : "US Legal",
      "5" : "A5",
      "13" : "A6",
      "62" : "4R"
    }
  },
  "read-write-settings" : {
    "threshold-for-black-and-white-scanning" : "128",
    "bit-depth" : {
      "1" : "1 Bit"
    },
    "measurement-unit" : {
      "1" : "Centimeters"
    },
    "overview-resolution" : "300",
    "pixel-data-type" : {
      "0" : "Black and White"
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

Performing a scan with the default scanner:

```
./jsonscan -s
```

Performing a scan with custom settings:

```
./jsonscan -c < settings.json
```

settings.json example:

```
TODO
```

## It is a work in progress.
