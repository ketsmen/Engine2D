/**
 ******************************************************************************
 * @file    main.go
 * @author  MakerYang
 ******************************************************************************
 */

package main

import (
	"Tools/base"
	"Tools/clothe"
	"Tools/weapon"
	"Tools/wing"
	"fmt"
	"os"
)

func main() {

	args := os.Args
	if len(args) == 0 {
		Base.Print(fmt.Sprintf("请指定资源类型，可选值为：clothe|weapon|wing"), Base.Warning)
		return
	}

	if args[1] == "clothe" {
		Clothe.Start(args)
	}

	if args[1] == "weapon" {
		Weapon.Start(args)
	}

	if args[1] == "wing" {
		Wing.Start(args)
	}
}