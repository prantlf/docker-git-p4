clean ::
	docker image rm git-p4 prantlf/git-p4 registry.gitlab.com/prantlf/docker-git-p4

lint ::
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile

build ::
	docker build -t git-p4 .
	docker tag git-p4 prantlf/git-p4
	docker tag git-p4 registry.gitlab.com/prantlf/docker-git-p4

run ::
	docker run --rm -it --entrypoint=busybox git-p4 sh

login ::
	docker login --username=prantlf
	docker login registry.gitlab.com --username=prantlf

pull ::
	docker pull prantlf/git-p4
	docker pull registry.gitlab.com/prantlf/docker-git-p4

push ::
	docker push prantlf/git-p4
	docker push registry.gitlab.com/prantlf/docker-git-p4
	docker tag prantlf/git-p4 prantlf/git-p4:2.38.1-22.1
	docker push prantlf/git-p4:2.38.1-22.1
	docker tag registry.gitlab.com/prantlf/docker-git-p4 registry.gitlab.com/prantlf/docker-git-p4:2.38.1-22.1
	docker push registry.gitlab.com/prantlf/docker-git-p4:2.38.1-22.1
