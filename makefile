CFLAGS += -I $(HOME)/local/include
LDFLAGS += -L $(HOME)/local/lib

all:
	gcc -std=gnu99 -g $(CFLAGS) -o power power.c $(LDFLAGS) -liio -lm -Wall -Wextra
	gcc -std=gnu99 -g $(CFLAGS) -o cal_ad9361 cal_ad9361.c $(LDFLAGS) -lfftw3 -lpthread -liio -lm -Wall -Wextra
arm:
	# source /opt/Xilinx/SDK/2017.2/settings64.sh
	arm-xilinx-linux-gnueabi-gcc -mfloat-abi=soft --sysroot=sysroot -I./include -Lsysroot/lib -std=gnu99 -g -o power_check power_check.c -lfftw3 -lpthread -liio -lm -Wall -Wextra
