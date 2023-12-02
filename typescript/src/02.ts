import { readFileSync } from 'fs';

const input = readFileSync ('../data/02.txt', 'utf-8')
    .trimEnd(); // remove trailing newline

const limits: { [key: string]: number } = { red: 12, green: 13, blue: 14 };

let total = 0
input.split('\n').forEach(line => {
    const match = line.match(/Game (\d+): (.*)/);
    if (!match) { throw new Error(); }
    const num = parseInt(match[1]);
    const batches = match[2];
    let possible = true;

    batches.split('; ').forEach(batch => {
        batch.split(', ').forEach(item => {
            let itemMatch = item.match(/(\d+) (\w+)/)
            if (!itemMatch) { throw new Error(); }
            const count = parseInt(itemMatch[1]);
            const color = itemMatch[2];
            if (count > limits[color]) {
                possible = false;
            }
        });
    });

    if (possible) {
        total += num;
    }
});
console.log (total)
