# Makefile for gkrellm cpupower plugin

PKGCONFIG ?= pkg-config

GTK_INCLUDE = $(shell $(PKGCONFIG) gtk+-2.0 --cflags)
GTK_LIB = $(shell $(PKGCONFIG) gtk+-2.0 --libs)

FLAGS = -Wall -fPIC $(GTK_INCLUDE)
LIBS = $(GTK_LIB)

LFLAGS = -shared -lcpupower

CC ?= gcc

OBJS = cpupower.o

cpupower.so: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(FLAGS) $(OBJS) -o cpupower.so $(LFLAGS) $(LIBS)

install: cpupower.so
	install -D -m 755 -s cpupower.so $(DESTDIR)/usr/lib/gkrellm2/plugins/cpupower.so

install-sudo:
	mkdir -p $(DESTDIR)/etc/sudoers.d
	echo "%trusted ALL = (root) NOPASSWD: /usr/bin/cpupower -c [0-9]* frequency-set -g [[\:lower\:]]*" >> $(DESTDIR)/etc/sudoers.d/gkrellm2-cpupower
	echo "%trusted ALL = (root) NOPASSWD: /usr/bin/cpupower -c [0-9]* frequency-set -f [0-9]*" >> $(DESTDIR)/etc/sudoers.d/gkrellm2-cpupower

clean:
	rm -f *.o core *.so* *.bak *~

cpupower.o: cpupower.c

