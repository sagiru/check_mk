PYTHON_VERSION = 2.7.13
BUILD_DIR =  $(shell realpath ./../../winbuild)
PLUGINS_DIR = $(shell realpath ./../../plugins)
# This package list originates from resolving the dependencies of the packages
# pyinstaller, pypiwin32, pyopenssl, pyopenssl. The required packages are explicitly listed
# in favor of providing a working setup for a pyinstaller build with python 2.7
PYTHON_PACKAGES = src/pip/appdirs-1.4.3-py2.py3-none-any.whl \
	src/pip/idna-2.5-py2.py3-none-any.whl \
	src/pip/pyparsing-2.2.0-py2.py3-none-any.whl \
	src/pip/asn1crypto-0.22.0-py2.py3-none-any.whl \
	src/pip/ipaddress-1.0.18-py2-none-any.whl \
	src/pip/pypiwin32-219-cp27-none-win32.whl \
	src/pip/cffi-1.10.0-cp27-cp27m-win32.whl \
	src/pip/packaging-16.8-py2.py3-none-any.whl \
	src/pip/requests-2.13.0-py2.py3-none-any.whl \
	src/pip/cryptography-1.8.1-cp27-cp27m-win32.whl \
	src/pip/pycparser-2.17.tar.gz \
	src/pip/setuptools-34.3.3-py2.py3-none-any.whl \
	src/pip/enum34-1.1.6-py2-none-any.whl \
	src/pip/PyInstaller-3.2.1.tar.bz2 \
	src/pip/six-1.10.0-py2.py3-none-any.whl \
	src/pip/future-0.16.0.tar.gz \
	src/pip/pyOpenSSL-16.2.0-py2.py3-none-any.whl

src/python-$(PYTHON_VERSION).msi:
	cd src && wget https://www.python.org/ftp/python/$(PYTHON_VERSION)/python-$(PYTHON_VERSION).msi

$(PYTHON_PACKAGES): src/python-$(PYTHON_VERSION).msi
	# Download needed python packages including depencencies. This has to be done
	# from within wine to obtain the correct win32 packages.
	# Note: We built this list to make the agent compilation reproducable. From time
	# to time we should update the packages here, but we don't want to fetch new versions
	# automatically.
	mkdir $(BUILD_DIR) && \
	export WINEPREFIX=$(BUILD_DIR) && \
	cd $(BUILD_DIR) && \
	cp $(CURDIR)/src/python-$(PYTHON_VERSION).msi . && \
	wine msiexec /qn /i python-$(PYTHON_VERSION).msi && \
	mkdir pip && \
	cd pip && \
	wine c:\\Python27\\python.exe -m pip download --no-deps appdirs==1.4.3 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps idna==2.5 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps pyparsing==2.2.0 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps asn1crypto==0.22.0 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps ipaddress==1.0.18 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps pypiwin32==219 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps cffi==1.10.0 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps packaging==16.8 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps requests==2.13.0 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps cryptography==1.8.1 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps pycparser==2.17 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps setuptools==34.3.3 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps enum34==1.1.6 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps pyinstaller==3.2.1 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps six==1.10.0 && \
	wine c:\\Python27\\python.exe -m pip download --no-deps future==0.16.0. && \
	wine c:\\Python27\\python.exe -m pip download --no-deps pyOpenSSL==16.2.0 && \
	mkdir -p $(CURDIR)/src/pip && \
	cp -r * $(CURDIR)/src/pip
	rm -rf $(BUILD_DIR)

src/vcredist_x86.exe:
	cd src && \
		wget https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe

setup:
	sudo apt-get install scons upx-ucl wine
