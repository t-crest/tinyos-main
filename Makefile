COM_PORT?=/dev/ttyUSB0

TOSAPP?=PatmosApp
BOOTAPP?=bootable-bootloader

BOARD?=altde2-115
VENDOR?=Altera
BLASTER_TYPE?=USB-Blaster

BUILDDIR?=$(CURDIR)

all:

comp:
	gcc -c ./tos/platforms/patmos/libs/nesc_dummy/libTinyosPatmos.c -o ./tos/platforms/patmos/libs/nesc_dummy/libTinyosPatmos.o
	ar rcs ./tos/platforms/patmos/libs/nesc_dummy/libTinyosPatmos.a ./tos/platforms/patmos/libs/nesc_dummy/libTinyosPatmos.o
	make -C apps/$(TOSAPP) patmos

	patmos-clang -c ./tos/platforms/patmos/libs/patmos/libTinyosPatmos.c -o ./tos/platforms/patmos/libs/patmos/libTinyosPatmos.o
	patmos-ar rcs ./tos/platforms/patmos/libs/patmos/libTinyosPatmos.a ./tos/platforms/patmos/libs/patmos/libTinyosPatmos.o

	patmos-clang -O2 apps/$(TOSAPP)/build/patmos/app.c -o tinyos.elf -L tos/platforms/patmos/libs/patmos -lTinyosPatmos

tools:
	make -C ../patmos tools

config:
	make -C ../patmos config BOARD=$(BOARD) VENDOR=$(VENDOR) BLASTER_TYPE=$(BLASTER_TYPE)

gen:
	make -C ../patmos gen BOOTAPP=$(BOOTAPP) BOARD=$(BOARD)

synth:
	make -C ../patmos synth BOOTAPP=$(BOOTAPP) BOARD=$(BOARD)

download:
	make -C ../patmos download BUILDDIR=$(CURDIR) APP=tinyos

clean:
	rm -f tos/platforms/patmos/libs/patmos/*.a tos/platforms/patmos/libs/patmos/*.o tos/platforms/patmos/libs/nesc_dummy/*.a  tos/platforms/patmos/libs/nesc_dummy/*.o 
	rm -rf apps/$(TOSAPP)/build/patmos
	rm -f tinyos.elf