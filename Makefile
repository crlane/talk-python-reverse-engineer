HOST_PORT=8888
SLIDES_PORT=8000
BASENOTEBOOK=jupyter/scipy-notebook
NOTEBOOKS=`pwd`:/home/jovyan/work

ORG ?= crlane
IMAGE ?= $(ORG)/reverse-engineer
PRESENTATION ?= Reverse\ Engineering\ A\ Toy\ Robot

.PHONY: pull image slides present run
.IGNORE: clean

clean:
	rm *.html

pull:
	docker pull ${BASENOTEBOOK}

image:
	docker build -t $(IMAGE) .

present: clean
	@docker run --rm -it -p $(SLIDES_PORT):$(SLIDES_PORT) -v $(NOTEBOOKS) $(IMAGE) jupyter nbconvert $(PRESENTATION).ipynb --to slides --post serve --log-level DEBUG --ServePostProcessor.ip='0.0.0.0'

run:
	@docker run --rm -it -p $(HOST_PORT):$(HOST_PORT) -v $(NOTEBOOKS) $(IMAGE)
