import { readFileSync } from 'fs';

const input = readFileSync ('../data/01.txt', 'utf-8')

let total = 0;

let numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
let wordNumbers = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

input.split('\n').forEach(line => {
    let first: number | null = null;
    let last: number | null = null;
    console.log(line);

    for (let i = 0; i < line.length; i++) {
        const str = line.substring(i);
        numbers.forEach ((n, j) => {
            if (str.startsWith(n)) {
                first = first || (j+1)
                last = j+1
            }
        })
        wordNumbers.forEach ((n, j) => {
            if (str.startsWith(n)) {
                first = first || j+1
                last = j+1
            }
        })

    }

    if (first !== null && last !== null) {
        const lineNum = first * 10 + last;
        console.log(lineNum);

        total += lineNum;
    }
})

console.log(total)
