package  main

import(
	"fmt"
_	"log"
"bufio"
"os"
)

func main() {
	fmt.Println("insert y value here: ")
	input := bufio.NewScanner(os.Stdin)
	fmt.Println(input.Text)
}
