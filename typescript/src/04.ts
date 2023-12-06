import { readFileSync } from 'fs'

const input = readFileSync ('../data/04.txt', 'utf-8')

function part1 () {
    let total = 0
    for (let match of input.matchAll(/:([^|]+) \| ([^|]+)\n/g)) {
        let winning = match[1]
        let actual = match[2]
        let nums = new Map<string, boolean>()
        let score = 0.5
        for (let num of winning.matchAll (/\d+/g)) {
            nums.set(num[0], true)
        }
        for (let num of actual.matchAll (/\d+/g)) {
            if (nums.get(num[0])) {
                score *= 2
            }
        }
        total += Math.floor (score)
    }
    return total
}

console.log ("part 1: " + part1())
