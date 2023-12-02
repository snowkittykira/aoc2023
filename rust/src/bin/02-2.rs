//#![allow(dead_code)]
//#![allow(unused_variables)]
//#![allow(unused_mut)]
//#![allow(unused_assignments)]

use std::fs;
use std::collections::HashMap;
use std::path::Path;
use regex::Regex;

fn main() {
    let input = fs::read_to_string(Path::new("../data/02.txt")).unwrap();

    let mut total = 0;

    let item_regex = Regex::new(r"(\d+) (\w+)").unwrap();

    for line in input.lines() {
        let mut maxes = HashMap::new();
        maxes.insert("red", 0);
        maxes.insert("green", 0);
        maxes.insert("blue", 0);
        for captures in item_regex.captures_iter(line) {
            let count = captures.get(1).unwrap().as_str().parse::<i32>().unwrap();
            let color = captures.get(2).unwrap().as_str();
            *maxes.get_mut(color).unwrap() = i32::max(maxes[color], count);
        }
        total += maxes["red"] * maxes["green"] * maxes["blue"];
    }
    println!("{}", total);
}
