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
	"strconv"
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

type Action struct {
	Names []string `json:"names"`
	Size  int      `json:"size"`
	Start int      `json:"start"`
	End   int      `json:"end"`
}

func main() {
	var filesInfo []FileInfo

	strContentUid, strContentId := GenerateUniqueIDs("418")

	strContent := `[gd_scene load_steps=418 format=3 uid="uid://` + strContentUid + `"]` + "\n\n"

	targetI := 0
	targetDir := "framework/statics/scenes/world/player/clothe/000/men"
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
				Id:     strconv.Itoa(targetI) + "_" + id,
			}
			strContent += `[ext_resource type="Texture2D" uid=` + fileInfo.Uid + ` path="` + fileInfo.Path + `" id="` + fileInfo.Id + `"]` + "\n"
			filesInfo = append(filesInfo, fileInfo)
			targetI++
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

	fps := 8.0     //
	direction := 8 // 八个方向
	action := make([]Action, 0)
	action = append(
		action,
		Action{Start: 0, End: 32, Size: 4, Names: []string{"6_stand", "7_stand", "0_stand", "1_stand", "2_stand", "3_stand", "4_stand", "5_stand"}},
		Action{Start: 32, End: 80, Size: 6, Names: []string{"6_walking", "7_walking", "0_walking", "1_walking", "2_walking", "3_walking", "4_walking", "5_walking"}},
		Action{Start: 80, End: 128, Size: 6, Names: []string{"6_running", "7_running", "0_running", "1_running", "2_running", "3_running", "4_running", "5_running"}},
		Action{Start: 128, End: 136, Size: 1, Names: []string{"6_attack_stand", "7_attack_stand", "0_attack_stand", "1_attack_stand", "2_attack_stand", "3_attack_stand", "4_attack_stand", "5_attack_stand"}},
		Action{Start: 136, End: 184, Size: 6, Names: []string{"6_attack", "7_attack", "0_attack", "1_attack", "2_attack", "3_attack", "4_attack", "5_attack"}},
		Action{Start: 184, End: 232, Size: 6, Names: []string{"6_digging", "7_digging", "0_digging", "1_digging", "2_digging", "3_digging", "4_digging", "5_digging"}},
		Action{Start: 232, End: 296, Size: 8, Names: []string{"6_jump", "7_jump", "0_jump", "1_jump", "2_jump", "3_jump", "4_jump", "5_jump"}},
		Action{Start: 296, End: 344, Size: 6, Names: []string{"6_launch", "7_launch", "0_launch", "1_launch", "2_launch", "3_launch", "4_launch", "5_launch"}},
		Action{Start: 344, End: 360, Size: 2, Names: []string{"6_pickup", "7_pickup", "0_pickup", "1_pickup", "2_pickup", "3_pickup", "4_pickup", "5_pickup"}},
		Action{Start: 360, End: 384, Size: 3, Names: []string{"6_damage", "7_damage", "0_damage", "1_damage", "2_damage", "3_damage", "4_damage", "5_damage"}},
		Action{Start: 384, End: 416, Size: 4, Names: []string{"6_death", "7_death", "0_death", "1_death", "2_death", "3_death", "4_death", "5_death"}},
	)
	for i := 0; i < direction; i++ {
		for x := 0; x < len(action); x++ {
			itemRange := filesInfo[action[x].Start:action[x].End]
			itemSize := action[x].Size
			itemI := itemRange[(i * itemSize):((i * itemSize) + itemSize)]
			fmt.Printf("%d 方向 %s 资源文件为 %s到%s \n", i, action[x].Names[i], itemI[0].Name, itemI[len(itemI)-1].Name)
			item := Animation{
				Frames: make([]Frame, 0),
				Loop:   true,
				Speed:  fps,
				Name:   action[x].Names[i],
			}
			for y := 0; y < len(itemI); y++ {
				frame := Frame{}
				frame.Texture = `ExtResource(` + itemI[y].Id + `)`
				frame.Duration = 1.0
				item.Frames = append(item.Frames, frame)
			}
			data.Animations = append(data.Animations, item)
		}
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
