all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  Add your jekyll site right here in the base of the gitrepo
	@echo ""  An example site is given to be replaced
	@echo ""   1. make render       - your site will be in /tmp/

build: cprenderin builddocker cpoctoin beep

render: cprenderin builddocker rundocker cpoctoin rm beep

octo: cpoctoin octopush

octopush:
	git push octo master

cprenderin:
	cp render/Dockerfile ./Dockerfile

cpoctoin:
	cp octohost/Dockerfile ./Dockerfile

rundocker:
	@docker run --name=sawww \
	--cidfile="cid" \
	-v /tmp:/tmp \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t joshuacox/sawwwrender

builddocker:
	/usr/bin/time -v docker build -t joshuacox/sawwwrender .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	@docker kill `cat cid`

rm-name:
	rm  name

rm-image:
	@docker rm `cat cid`
	@rm cid

cleanfiles:
	rm name
	rm repo
	rm proxy
	rm proxyport

rm: kill rm-image

clean: cleanfiles rm

enter:
	docker exec -i -t `cat cid` /bin/bash
