package main

import (
	"fmt"
	"github.com/Nightgunner5/vpk"
	"io"
	"os"
	"path"
)

func main() {
	if len(os.Args) != 3 {
		fmt.Println("Usage:", os.Args[0], "filename.vpk", "target_directory")
		return
	}
	MAIN_FILE := os.Args[1]
	TARGET := os.Args[2]

	f, err := os.Open(MAIN_FILE)
	eh(err)
	defer f.Close()

	vpkFile, err := vpk.ReadVPKFile(f)
	eh(err)

	for _, filename := range vpkFile.ListFiles() {
		fmt.Println(filename)
		dir := path.Dir(TARGET + "/" + filename)
		eh(os.MkdirAll(dir, 0777))
		data, err := vpkFile.GetReader(vpkFile.GetFileInfo(filename), MAIN_FILE)
		fd, err := os.Create(path.Join(dir, path.Base(filename)))
		eh(err)
		io.Copy(fd, data)
		eh(fd.Close())
		eh(data.Close())
	}
}

func eh(err error) {
	if err != nil {
		panic(err)
	}
}
