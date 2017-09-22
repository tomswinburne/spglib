#!/bin/bash
set -e -x

# Install a system package required by our library
yum install -y numpy

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" install -U urllib3
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    "${PYBIN}/pip" install python-manylinux-demo --no-index -f /io/wheelhouse
done
