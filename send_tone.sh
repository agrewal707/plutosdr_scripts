#!/bin/sh

ip=$1
echo $ip
ip2=$2
echo $ip2

gain=$(iio_attr -u ip:$ip -q -c -o ad9361-phy voltage0 hardwaregain | awk '{print $1}')
tx_lo=$(iio_attr -u ip:$ip -q -c ad9361-phy TX_LO frequency)
tx_sps=$(iio_attr -u ip:$ip -q -c -o ad9361-phy voltage0 sampling_frequency)

echo TX_LO: $tx_lo
echo TX SPS: $tx_sps
tone=$(expr $tx_sps / 8 + $tx_lo)
echo TX TONE: $tone

# Turn the attenuation down
iio_attr -u ip:$ip -q -c -o ad9361-phy voltage0 hardwaregain -5

# https://wiki.analog.com/resources/tools-software/linux-drivers/iio-transceiver/ad9361#bist_tone
# <Injection Point> <Tone Frequency> <Tone Level> <Channel Mask>
# Inject 0dBFS tone at Fsample/32 into TX (all channels enabled)
iio_attr -u ip:$ip -q -D ad9361-phy bist_tone "1 3 6 0"
# 3	FSample / 8

./cal_ad9361 -u ip:$ip2 -e ${tone}

iio_attr -u ip:$ip -q -D ad9361-phy bist_tone "0 0 0 0"
iio_attr -u ip:$ip -q -c -o ad9361-phy voltage0 hardwaregain ${gain}
