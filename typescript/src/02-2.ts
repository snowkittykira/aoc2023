import { readFileSync } from 'fs';

const input = readFileSync ('../data/02.txt', 'utf-8')
    .trimEnd(); // remove trailing newline

let total = 0
input.split('\n').forEach(line => {
    const maxes: { [key: string]: number } = { red: 0, green: 0, blue: 0 };

    for (let itemMatch of line.matchAll(/(\d+) (\w+)/g)) {
        const count = parseInt(itemMatch[1]);
        const color = itemMatch[2];
        maxes [color] = Math.max(count, maxes[color]);
    }

    total += maxes.red * maxes.green * maxes.blue;
});
console.log (total)
