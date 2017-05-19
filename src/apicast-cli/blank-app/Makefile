test: build
	docker run --rm {{ path }}-app /usr/libexec/s2i/run --daemon

build: rock
	s2i build . {{s2i.builder_image }} {{ path }}-app

rock:
	luarocks make {{ path }}-scm-1.rockspec
