APP := gcloud-kubectl

include devops/make/common.mk
include devops/make/common-docker.mk

# when pushing from circle and branch is 'master', add a 'master' and 'latest' tag to the docker image
push-master-tag::
	@docker tag $(IMAGE) quay.io/getpantheon/gcloud-kubectl:master
	@docker push quay.io/getpantheon/gcloud-kubectl:master
	@docker tag $(IMAGE) quay.io/getpantheon/gcloud-kubectl:latest
	@docker push quay.io/getpantheon/gcloud-kubectl:latest

# extend the update-makefiles task to remove files we don't need
update-makefiles::
	make prune-common-make

# strip out everything from common-makefiles that we don't want.
prune-common-make:
	@find devops/make -type f \
		-not -name common.mk \
		-not -name common-docker.mk -delete
	@find devops/make -empty -delete
	@git add devops/make
	@git commit -C HEAD --amend
