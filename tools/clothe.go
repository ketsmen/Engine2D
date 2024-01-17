/**
 ******************************************************************************
 * @file    clothe.go
 * @author  ARMCNC site:www.armcnc.net github:armcnc.github.io
 ******************************************************************************
 */

package main

import (
	"bufio"
	"crypto/md5"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

type FileInfo struct {
	Name   string
	Prefix string
	Suffix string
	Path   string
	Uid    string
	Id     string
}

type Data struct {
	Animations []Animation `json:"animations"`
}

type Animation struct {
	Frames []Frame `json:"frames"`
	Loop   bool    `json:"loop"`
	Name   string  `json:"name"`
	Speed  float64 `json:"speed"`
}

type Frame struct {
	Duration float64 `json:"duration"`
	Texture  string  `json:"texture"`
}

func main() {
	var filesInfo []FileInfo

	strContentUid, strContentId := GenerateUniqueIDs("418")

	strContent := `[gd_scene load_steps=418 format=3 uid="uid://` + strContentUid + `"]` + "\n\n"

	targetDir := "framework/statics/scenes/world/player/clothe/000/women"
	err := filepath.Walk("../"+targetDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && !strings.HasSuffix(info.Name(), ".import") {
			file, err := os.Open("../" + targetDir + "/" + info.Name() + ".import")
			if err != nil {
				fmt.Println("Error opening file:", err)
			}
			defer file.Close()
			uid, id := GenerateUniqueIDs(info.Name())
			scanner := bufio.NewScanner(file)
			for scanner.Scan() {
				line := scanner.Text()
				if strings.HasPrefix(line, "uid=") {
					uid = strings.TrimPrefix(line, "uid=")
				}
			}
			ext := filepath.Ext(info.Name())
			prefix := strings.TrimSuffix(info.Name(), ext)
			fileInfo := FileInfo{
				Name:   info.Name(),
				Prefix: prefix,
				Suffix: ext,
				Path:   "res://" + targetDir + "/" + info.Name(),
				Uid:    uid,
				Id:     id,
			}
			strContent += `[ext_resource type="Texture2D" uid="` + fileInfo.Uid + `" path="` + fileInfo.Path + `" id="` + fileInfo.Id + `"]` + "\n"
			filesInfo = append(filesInfo, fileInfo)
		}
		return nil
	})
	if err != nil {
		fmt.Printf("Error walking through directory: %v\n", err)
	}

	strContent += "\n"
	strContent += `[sub_resource type="SpriteFrames" id="SpriteFrames_` + strContentId + `"]` + "\n"

	fmt.Printf("共找到 %d 个文件，开始预处理...\n", len(filesInfo))

	data := Data{}
	data.Animations = make([]Animation, 0)

	fps := 8.0
	direction := 8 // 八个方向
	standNames := []string{"6_stand", "7_stand", "0_stand", "1_stand", "2_stand", "3_stand", "4_stand", "5_stand"}
	for i := 0; i < direction; i++ {
		// 站立资源
		stand := filesInfo[0:32]                                       // 共32张图片
		standSize := 4                                                 // 每个方向4张图片
		standI := stand[(i * standSize):((i * standSize) + standSize)] // 当前方向中的4张
		fmt.Printf("第 %d 组站立资源为 %s到%s \n", i, standI[0].Name, standI[len(standI)-1].Name)
		standItem := Animation{
			Frames: make([]Frame, 0),
			Loop:   false,
			Speed:  fps,
			Name:   standNames[i],
		}
		for x := 0; x < len(standI); x++ {
			item := Frame{}
			item.Texture = `ExtResource(` + standI[x].Id + `)`
			item.Duration = 1.0
			standItem.Frames = append(standItem.Frames, item)
		}
		data.Animations = append(data.Animations, standItem)
	}

	jsonBytes, err := json.MarshalIndent(data.Animations, "", "	")
	if err != nil {
		log.Fatalf("Error occurred during marshaling. Error: %s", err.Error())
	}

	filePath := "./output.tscn"
	strContent += "animations = " + string(jsonBytes)
	strContent = strings.ReplaceAll(strContent, `"ExtResource(`, `ExtResource("`)
	strContent = strings.ReplaceAll(strContent, `)"`, `")`)
	strContent = strings.ReplaceAll(strContent, `"name": "`, `"name": &"`)

	strContent += "\n\n"
	strContent += `[node name="Animate" type="AnimatedSprite2D"]` + "\n"
	strContent += `sprite_frames = SubResource("SpriteFrames_` + strContentId + `")` + "\n"
	strContent += `animation = &"0_stand"` + "\n"
	strContent += `autoplay = "0_stand"` + "\n"
	strContent += `offset = Vector2(18.5, -28)` + "\n"

	err = ioutil.WriteFile(filePath, []byte(strContent), 0644)
	if err != nil {
		log.Fatalf("Error occurred while writing to file. Error: %s", err.Error())
	}
}

func GenerateUniqueIDs(fileName string) (string, string) {
	timestamp := time.Now().UnixNano()
	input := fmt.Sprintf("%s%d", fileName, timestamp)
	hash := md5.Sum([]byte(input))
	hashStr := hex.EncodeToString(hash[:])
	uniqueID12 := hashStr[:12]
	uniqueID5 := hashStr[:5]
	return uniqueID12, uniqueID5
}
