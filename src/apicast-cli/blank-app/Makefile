test: build
	docker run --rm cors-proxy-app

build: rock
	s2i build . quay.io/3scale/s2i-openresty-centos7:1.11.2.3-4 cors-proxy-app

rock:
	luarocks make cors-proxy-scm-1.rockspec
