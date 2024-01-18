/**
 ******************************************************************************
 * @file    wing.go
 * @author  MakerYang
 ******************************************************************************
 */

package Wing

import (
	"Tools/base"
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strconv"
	"strings"
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

func Start(args []string) {

	if len(args) < 4 {
		Base.Print(fmt.Sprintf("请指定服饰ID和玩家性别，示例：wing 000 men"), Base.Warning)
		return
	}

	pngInfo := make([]FileInfo, 0)

	dirPath := "framework/statics/scenes/world/player/wing/" + args[2] + "/" + args[3]
	outputPath := "framework/scenes/world/player/wing/" + args[2] + "/" + args[3] + ".tscn"

	outputUid, outputId := Base.GenerateUniqueIDs("2024")
	outputContent := `[gd_scene load_steps=418 format=3 uid="uid://` + outputUid + `"]` + "\n\n"

	files, _ := os.ReadDir("../" + dirPath)
	for i, file := range files {
		item := FileInfo{}
		item.Name = file.Name()
		item.Path = "res://" + dirPath + "/" + item.Name
		item.Suffix = filepath.Ext(item.Name)
		item.Prefix = strings.TrimSuffix(item.Name, item.Suffix)
		if item.Suffix == ".png" {
			uid, id := Base.GenerateUniqueIDs(item.Name)
			importFile, err := os.Open("../" + dirPath + "/" + item.Name + ".import")
			if err != nil {
				Base.Print(fmt.Sprintf("Error opening file"), Base.Error)
				return
			}
			scanner := bufio.NewScanner(importFile)
			for scanner.Scan() {
				line := scanner.Text()
				if strings.HasPrefix(line, "uid=") {
					uid = strings.TrimPrefix(line, "uid=")
				}
			}
			item.Id = strconv.Itoa(i) + "_" + id
			item.Uid = uid
			outputContent += `[ext_resource type="Texture2D" uid=` + item.Uid + ` path="` + item.Path + `" id="` + item.Id + `"]` + "\n"
			pngInfo = append(pngInfo, item)
		}
	}

	outputContent += "\n"
	outputContent += `[sub_resource type="SpriteFrames" id="SpriteFrames_` + outputId + `"]` + "\n"

	Base.Print(fmt.Sprintf("共找到 %d 个文件，开始预处理...", len(pngInfo)), Base.Success)

	data := Data{}
	data.Animations = make([]Animation, 0)

	fps := 8.0     //
	direction := 8 // 八个方向
	action := make([]Action, 0)
	action = append(
		action,
		Action{Start: 0, End: 64, Size: 8, Names: []string{"6_stand", "7_stand", "0_stand", "1_stand", "2_stand", "3_stand", "4_stand", "5_stand"}},
		Action{Start: 64, End: 112, Size: 6, Names: []string{"6_walking", "7_walking", "0_walking", "1_walking", "2_walking", "3_walking", "4_walking", "5_walking"}},
		Action{Start: 112, End: 160, Size: 6, Names: []string{"6_running", "7_running", "0_running", "1_running", "2_running", "3_running", "4_running", "5_running"}},
		Action{Start: 160, End: 168, Size: 1, Names: []string{"6_attack_stand", "7_attack_stand", "0_attack_stand", "1_attack_stand", "2_attack_stand", "3_attack_stand", "4_attack_stand", "5_attack_stand"}},
		Action{Start: 168, End: 216, Size: 6, Names: []string{"6_attack", "7_attack", "0_attack", "1_attack", "2_attack", "3_attack", "4_attack", "5_attack"}},
		Action{Start: 216, End: 264, Size: 6, Names: []string{"6_digging", "7_digging", "0_digging", "1_digging", "2_digging", "3_digging", "4_digging", "5_digging"}},
		Action{Start: 264, End: 328, Size: 8, Names: []string{"6_jump", "7_jump", "0_jump", "1_jump", "2_jump", "3_jump", "4_jump", "5_jump"}},
		Action{Start: 328, End: 376, Size: 6, Names: []string{"6_launch", "7_launch", "0_launch", "1_launch", "2_launch", "3_launch", "4_launch", "5_launch"}},
		Action{Start: 376, End: 392, Size: 2, Names: []string{"6_pickup", "7_pickup", "0_pickup", "1_pickup", "2_pickup", "3_pickup", "4_pickup", "5_pickup"}},
		Action{Start: 392, End: 416, Size: 3, Names: []string{"6_damage", "7_damage", "0_damage", "1_damage", "2_damage", "3_damage", "4_damage", "5_damage"}},
		Action{Start: 416, End: 448, Size: 4, Names: []string{"6_death", "7_death", "0_death", "1_death", "2_death", "3_death", "4_death", "5_death"}},
	)
	for i := 0; i < direction; i++ {
		for x := 0; x < len(action); x++ {
			itemRange := pngInfo[action[x].Start:action[x].End]
			itemSize := action[x].Size
			itemI := itemRange[(i * itemSize):((i * itemSize) + itemSize)]
			Base.Print(fmt.Sprintf("%d 方向 %s 资源文件为 %s到%s", i, action[x].Names[i], itemI[0].Name, itemI[len(itemI)-1].Name), Base.Success)
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
		Base.Print(fmt.Sprintf("解析JSON出错"), Base.Error)
		return
	}

	outputContent += "animations = " + string(jsonBytes)
	outputContent = strings.ReplaceAll(outputContent, `"ExtResource(`, `ExtResource("`)
	outputContent = strings.ReplaceAll(outputContent, `)"`, `")`)
	outputContent = strings.ReplaceAll(outputContent, `"name": "`, `"name": &"`)

	outputContent += "\n\n"
	outputContent += `[node name="Animate" type="AnimatedSprite2D"]` + "\n"
	outputContent += `sprite_frames = SubResource("SpriteFrames_` + outputId + `")` + "\n"
	outputContent += `animation = &"0_stand"` + "\n"
	outputContent += `autoplay = "0_stand"` + "\n"
	outputContent += `offset = Vector2(0, -28)` + "\n"

	err = ioutil.WriteFile("../"+outputPath, []byte(outputContent), 0644)
	if err != nil {
		Base.Print(fmt.Sprintf("文件生成失败"), Base.Error)
		return
	}
}
