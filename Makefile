CC ?= gcc
TARGET = libcustomlabels.so
SRCS = src/customlabels.c

ARCH := $(shell uname -m)

ifeq ($(ARCH),aarch64)
    TLS_DIALECT = desc
else ifeq ($(ARCH),x86_64)
    TLS_DIALECT = gnu2
else
    $(error only aarch64 and x86-64 are supported)
endif

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) -ftls-model=global-dynamic -mtls-dialect=$(TLS_DIALECT) -fPIC -shared -o $(TARGET) $(SRCS)

clean:
	rm -f $(TARGET)

PREFIX ?= /usr/local

install: $(TARGET)
	install -d $(PREFIX)/lib
	install -m 0755 $(TARGET) $(PREFIX)/lib/
	mkdir -p $(PREFIX)/include/customlabels
	cp src/*.h $(PREFIX)/include/customlabels
