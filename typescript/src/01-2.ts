import { readFileSync } from 'fs';

const input = readFileSync ('../data/01.txt', 'utf-8')

let total = 0;

let numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9',
               'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

input.split('\n').forEach(line => {
    let first: number | null = null;
    let last: number | null = null;

    for (let i = 0; i < line.length; i++) {
        const str = line.substring(i);
        numbers.forEach ((n, j) => {
            if (str.startsWith(n)) {
                let num = j%9 + 1
                first = first || num;
                last = num;
            }
        })
    }

    if (first !== null && last !== null) {
        const lineNum = first * 10 + last;
        total += lineNum;
    }
})

console.log(total)
