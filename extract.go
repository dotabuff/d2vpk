package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"path"
	"strconv"
	"strings"

	"github.com/Nightgunner5/vpk"
	"github.com/davecgh/go-spew/spew"
	"github.com/moovweb/gokogiri"
)

var versionFlag = flag.Bool("v", false, "get version from steamdb")

func main() {
	flag.Parse()
	if *versionFlag {
		getVersion()
		return
	}

	if len(os.Args) < 3 {
		fmt.Println("Usage:", os.Args[0], "filename.vpk", "target_directory")
		return
	}

	MAIN_FILE := os.Args[1]
	TARGET := os.Args[2]
	ignoreExt := map[string]bool{}
	ignorePath := []string{}

	if len(os.Args) > 3 {
		for _, arg := range os.Args[3:] {
			if strings.HasPrefix(arg, ".") {
				ignoreExt[arg] = true
			} else {
				ignorePath = append(ignorePath, arg)
			}
		}
	}

	f, err := os.Open(MAIN_FILE)
	eh(err)
	defer f.Close()

	vpkFile, err := vpk.ReadVPKFile(f)
	eh(err)

	for _, filename := range vpkFile.ListFiles() {
		if ignoreExt[path.Ext(filename)] {
			continue
		}
		ignore := false
		for _, path := range ignorePath {
			if strings.HasPrefix(filename, path) {
				ignore = true
				break
			}
		}
		if ignore {
			continue
		}
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

func getVersion() {
	response, err := http.Get("http://steamdb.info/app/570/history/")
	eh(err)

	body, err := ioutil.ReadAll(response.Body)
	eh(err)

	doc, err := gokogiri.ParseHtml(body)
	eh(err)

	node, err := doc.Root().Search(`//div[@class="wrapper-info"]//a[contains(@href,"/changelist/")]`)
	eh(err)
	change, err := strconv.Atoi(node[0].Content())
	eh(err)

	node, err = doc.Root().Search(`//i[contains(.,"branches/public/buildid")]//following-sibling::ins`)
	eh(err)
	build, err := strconv.Atoi(node[0].Content())
	eh(err)

	spew.Printf("Change #%d Build #%d\n", change, build)
}
