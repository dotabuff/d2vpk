default: d2vpk sync convert commit push

build:
	sudo apt-get install libxml2-dev
	go get -t

d2vpk: extract.go
	go build -o d2vpk extract.go

sync:
	ruby sync.rb

convert:
	ruby convert.rb

commit:
	git commit -m "`./d2vpk -v`"

push:
	git push
