package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/fatih/color"
	"github.com/manifoldco/promptui"
)

func showBanner() {
	cyan := color.New(color.FgCyan).SprintFunc()
	green := color.New(color.FgGreen).SprintFunc()
	yellow := color.New(color.FgYellow).SprintFunc()
	magenta := color.New(color.FgMagenta).SprintFunc()
	bold := color.New(color.Bold).SprintFunc()

	fmt.Println()
	fmt.Println(cyan("╔══════════════════════════════════════════════════════╗"))
	fmt.Println(cyan("║"), bold("         🚀 Terraform Automation CLI v1.0           "), cyan("║"))
	fmt.Println(cyan("║"), yellow("     CSP 환경을 손쉽게 선택하고 작업하세요!     "), cyan("║"))
	fmt.Println(cyan("║"), green("    Made with ☕️ & 💻 by DevOps JSON     "), cyan("║"))
	fmt.Println(cyan("╚══════════════════════════════════════════════════════╝"))
	fmt.Println(magenta("\n✨ 시작해볼까요?\n"))
}

func main() {
	showBanner()

	// CSP 선택
	cspPrompt := promptui.Select{
		Label: "☁️ CSP를 선택하세요",
		Items: []string{"aws", "ncp", "gcp"},
	}
	_, selectedCSP, err := cspPrompt.Run()
	if err != nil {
		fmt.Println("❌ CSP 선택 실패:", err)
		return
	}

	// 환경 선택
	envPrompt := promptui.Select{
		Label: "🌎 환경을 선택하세요",
		Items: []string{"dev", "stage", "prod"},
	}
	_, selectedEnv, err := envPrompt.Run()
	if err != nil {
		fmt.Println("❌ 환경 선택 실패:", err)
		return
	}

	// 작업 선택
	taskPrompt := promptui.Select{
		Label: "⚙️ 실행할 Terraform 작업을 선택하세요",
		Items: []string{"init", "fmt -recursive", "plan", "apply", "destroy"},
	}
	_, selectedTask, err := taskPrompt.Run()
	if err != nil {
		fmt.Println("❌ 작업 선택 실패:", err)
		return
	}

	projectRoot := filepath.Join("..", selectedCSP)

	// task가 fmt면 CSP 루트에서 실행 (environment + modules 모두 포함됨)
	if selectedTask == "fmt -recursive" {
		if err := os.Chdir(projectRoot); err != nil {
			fmt.Println("❌ 프로젝트 루트 이동 실패:", err)
			return
		}
		fmt.Println("📁 위치 이동 (fmt 전체 대상):", projectRoot)
	} else {
		envPath := filepath.Join(projectRoot, "environment", selectedEnv)
		if err := os.Chdir(envPath); err != nil {
			fmt.Println("❌ 환경 디렉토리 이동 실패:", err)
			return
		}
		fmt.Println("📁 위치 이동:", envPath)
	}

	// terraform 명령어 실행
	args := parseTerraformArgs(selectedTask)
	cmd := exec.Command("terraform", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	fmt.Printf("\n🚀 실행 중: terraform %s\n\n", selectedTask)
	if err := cmd.Run(); err != nil {
		fmt.Println("❌ 실행 중 오류:", err)
		return
	}
	fmt.Println("✅ 완료:", selectedTask)
}

func parseTerraformArgs(task string) []string {
	switch task {
	case "init":
		return []string{"init"}
	case "fmt -recursive":
		return []string{"fmt", "-recursive"}
	case "plan":
		return []string{"plan", "-var-file=terraform.tfvars"}
	case "apply":
		return []string{"apply", "-auto-approve"}
	case "destroy":
		return []string{"destroy", "-auto-approve"}
	default:
		return []string{}
	}
}
