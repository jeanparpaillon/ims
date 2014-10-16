# Icare Media Server

[Travis-CI](http://travis-ci.org/jeanparpaillon/ims) :: ![Travis-CI](https://secure.travis-ci.org/jeanparpaillon/ims.png)

## Dependancies

IMS is written in erlang. It uses the very good rebar tool for
compiling, getting dependancies, etc.  It is mainly based on top of
erocci framework.  The following dependancies are not handled by rebar
and must be installed before typing 'make':

* erlang/OTP, version 16B01 or greater
* openssl and headers
* libxml2 and headers
* libexpat and headers

Debian and Ubuntu: apt-get install erlang libssl-dev libexpat1-dev libxml2-dev

## Compiling

$ make

The Makefile is wrapper around rebar. Learn quickly how to use rebar
for advanced options. The tool is particularly suited for erlang
applications.

## Running

$ ./start.sh
