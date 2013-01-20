#!/bin/sh

# check if we're on a Raspberry Pi board, exit otherwise
hash vcgencmd 2> /dev/null || {
    echo "Failure: 'vcgencmd' does not exist on this system";
    exit 1;
}

echo -e "\n###############################################"
echo "#       RASPBERRY PI SYSTEM INFORMATIONS      #"
echo "###############################################"

echo -e "\nCPU current Frequency: `vcgencmd measure_clock arm`"
echo "CORE current Frequency: `vcgencmd measure_clock core`"
echo "CORE current Voltage: `vcgencmd measure_volts core`"
echo "CPU current Temperature: `vcgencmd measure_temp`"

echo -e "\nFirmware Version: `vcgencmd version`\n"

echo -e "Codecs Status:"
echo "`vcgencmd codec_enabled H264`"
echo "`vcgencmd codec_enabled MPG2`"
echo "`vcgencmd codec_enabled WVC1`"

echo
