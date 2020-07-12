clean ::
	docker image rm git-p4

lint ::
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile

build ::
	docker build -t git-p4 .

run ::
	docker run --rm -it --entrypoint=busybox git-p4 sh

tag ::
	docker tag git-p4 prantlf/git-p4:latest

login ::
	docker login --username=prantlf

push ::
	docker push prantlf/git-p4:latest
