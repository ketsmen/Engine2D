/**
 ******************************************************************************
 * @file    base.go
 * @author  MakerYang
 ******************************************************************************
 */

package Base

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"os"
	"time"
)

const (
	Error   = "\033[31m"
	Success = "\033[32m"
	Warning = "\033[33m"
	Info    = "\033[34m"
)

func Print(content string, color string) {
	fmt.Printf("%s%s%s\n", color, content, "\033[0m")
}

func PathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
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
