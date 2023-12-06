import { readFileSync } from 'fs'

const input = readFileSync ('../data/03.txt', 'utf-8')

// length including newline
let lineLength = input.split('\n')[0].length + 1

interface Coord {
    x: number,
    y: number
}

interface Token {
    from: Coord,
    to: Coord,
    body: string
}

function index_to_coords (index: number) {
    return {
        x: index % lineLength,
        y: Math.floor(index / lineLength),
    };
}

function find_all_with_locations (pattern: RegExp): Token[] {
    return [...input.matchAll(pattern)].map((match) => {
        let str = match[0];
        let from = match.index!;
        let to = from + str.length;
        return {
            from: index_to_coords (from),
            // convert `to` to one-past-the-end vertically
            to: index_to_coords (to + lineLength),
            body: str
        };
    });
}

function are_adjacent (a: Token, b: Token) {
  return a.from.x <= b.to.x && b.from.x <= a.to.x &&
         a.from.y <= b.to.y && b.from.y <= a.to.y
}


function part1 (numbers: Token[], symbols: Token[]) {
    let total = 0
    for (let num of numbers) {
        let isCounted = false
        for (let sym of symbols) {
            if (are_adjacent(num, sym)) {
                isCounted = true
            }
        }
        if (isCounted) {
            total += parseInt(num.body)
        }
    }
    return total
}

function part2 (numbers: Token[], symbols: Token[]) {
    let total = 0

    for (let sym of symbols) {
        if (sym.body == "*") {
            let numCount = 0
            let product = 1
            for (let num of numbers) {
                if (are_adjacent(num, sym)) {
                    numCount += 1
                    product *= parseInt(num.body)
                }
            }
            if (numCount == 2) {
                total += product
            }
        }
    }

    return total
}

let numbers = find_all_with_locations(/\d+/g)
let symbols = find_all_with_locations(/[^\d\.\n]+/g)

console.log (numbers)
console.log (symbols)

console.log(part1(numbers, symbols))
console.log(part2(numbers, symbols))
