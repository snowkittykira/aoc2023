import { readFileSync } from 'fs';

const input = readFileSync ('../data/01.txt', 'utf-8')

let total = 0;

input.split('\n').forEach(line => {
    let first = null;
    let last = null;

    for (const char of line) {
        if (char >= '0' && char <= '9') {
            first = first || char
            last = char
        }
    }

    if (first !== null) {
        const lineNum = parseInt (first + last, 10);
        total += lineNum;
    }
})

console.log(total)
