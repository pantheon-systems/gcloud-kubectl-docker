APP := gcloud-kubectl

include devops/make/common.mk
include devops/make/common-docker.mk

# when pushing from circle and branch is 'master', add a 'master' tag to the docker image
push-master-tag::
	@docker tag $(IMAGE) quay.io/getpantheon/gcloud-kubectl:master
	@docker push quay.io/getpantheon/gcloud-kubectl:master

# extend the update-makefiles task to remove files we don't need
update-makefiles::
	make prune-common-make

prune-common-make:
	@find devops/make -type f \
		-not -name common.mk \
		-not -name common-docker.mk -delete
	@find devops/make -empty -delete
	@git add devops/make
	@git commit -C HEAD --amend


# initial pull of common-make
	# rm -rf .git devops
	# git init
	# git add .
	# git commit -a -m'initial commit'
	# git remote add common_makefiles git@github.com:pantheon-systems/common_makefiles.git --no-tags
	# git subtree add --prefix devops/make common_makefiles master --squash
	# make strip-common-make

# updates
# make update-makefiles
# 	make -C strip-make
