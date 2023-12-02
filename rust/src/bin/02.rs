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

    let mut limits = HashMap::new();
    limits.insert("red", 12);
    limits.insert("green", 13);
    limits.insert("blue", 14);
    let limits = limits;

    let line_regex = Regex::new(r"Game (\d+)").unwrap();
    let item_regex = Regex::new(r"(\d+) (\w+)").unwrap();

    for line in input.lines() {
        let captures = line_regex.captures(line).unwrap();
        let num = captures.get(1).unwrap().as_str().parse::<i32>().unwrap();
        let mut possible = true;
        for captures in item_regex.captures_iter(line){
            let count = captures.get(1).unwrap().as_str().parse::<i32>().unwrap();
            let color = captures.get(2).unwrap().as_str();
            if count > limits[color] {
                possible = false;
            }
        }
        if possible {
            total += num;
        }
    }
    println!("{}", total);
}
