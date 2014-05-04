default: d2vpk sync convert commit

d2vpk:
	go build -o d2vpk extract.go

sync:
	ruby sync.rb

convert:
	ruby convert.rb

commit:
	git commit -v
