GITSHA = $(shell git rev-parse --short HEAD)
TM=$(shell date +'%y-%m-%d-%H-%M-%S')
PROJECT="trip-analyzer"
IMAGE_BASE="cr.yandex/crpbccv0ku23t0tjs8je"

docker-build:
	docker build -t $(PROJECT):$(GITSHA) .

docker-push:
	docker tag $(PROJECT):$(GITSHA) $(IMAGE_BASE)/$(PROJECT):$(GITSHA)
	docker push $(IMAGE_BASE)/$(PROJECT):$(GITSHA)

docker-run:
	docker run -p 8080:8080 -e USER=$(USER) -e PASSWORD=$(PASSWORD) -e GEO_KEY=$(GEO_KEY) $(IMAGE_BASE)/$(PROJECT):$(GITSHA)

test:
	python3 test.py

deploy:
	yc managed-kubernetes cluster get-credentials --name daimler-dev --folder-id b1gvbmq6a2epvcv05qe1 --external
	helm upgrade -i $(PROJECT) --set image=$(IMAGE_BASE)/$(PROJECT):$(GITSHA) --set username=$(USER) --set password=$(PASSWORD) --set geo_key=$(GEO_KEY) ./chart
